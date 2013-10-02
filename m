Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:38875 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab3JBWyS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Oct 2013 18:54:18 -0400
Received: by mail-wi0-f177.google.com with SMTP id cb5so1698005wib.16
        for <linux-media@vger.kernel.org>; Wed, 02 Oct 2013 15:54:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <524CA043.8080205@iki.fi>
References: <1380751751-4842-1-git-send-email-ljalvs@gmail.com>
	<524CA043.8080205@iki.fi>
Date: Wed, 2 Oct 2013 23:54:16 +0100
Message-ID: <CAGj5WxCGaBtJkAzram4LzFbe8pyn2_GKStUCSFisO4LYW5v+Qw@mail.gmail.com>
Subject: Re: [PATCH 1/2] cx24117: Changed the way common data struct was being
 passed to the demod.
From: Luis Alves <ljalvs@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>,
	mchehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I Antti,

I think it's safe to use because the hybrid_tuner_request_state will
make sure that the i2c_adapter_id is the same for both demods.

On the other hand, I think I need to re-send this changes as one single file.

Regards,
Luis


2013/10/2 Antti Palosaari <crope@iki.fi>:
> On 03.10.2013 01:09, Luis Alves wrote:
>>
>> Hi Mike,
>>
>> It's done (also tested and apparently working good)!
>>
>> I didn't know if two separated patches were needed (one for the cx24117
>> and the other for the cx23885) but I've splited it.
>> As you pointed out, this series of patches are to be used against your
>> cx24117 branch.
>>
>> Regards,
>> Luis
>>
>> Signed-off-by: Luis Alves <ljalvs@gmail.com>
>
>
> I am not very familiar how that hybrid tuner request works, but it seems to
> be based of driver global list.
>
> I wonder if that works as it should. What happens when you have two cx24117
> demods equipped, having total of 4 frontends? Does it block access only for
> one demod at the time (as it should block only one per chip)?
>
> regards
> Antti
>
>
>
>> ---
>>   drivers/media/dvb-frontends/cx24117.c |   72
>> +++++++++++++++++++++++----------
>>   drivers/media/dvb-frontends/cx24117.h |    4 +-
>>   2 files changed, 53 insertions(+), 23 deletions(-)
>>
>> diff --git a/drivers/media/dvb-frontends/cx24117.c
>> b/drivers/media/dvb-frontends/cx24117.c
>> index 3b63913..9087309 100644
>> --- a/drivers/media/dvb-frontends/cx24117.c
>> +++ b/drivers/media/dvb-frontends/cx24117.c
>> @@ -31,6 +31,7 @@
>>   #include <linux/init.h>
>>   #include <linux/firmware.h>
>>
>> +#include "tuner-i2c.h"
>>   #include "dvb_frontend.h"
>>   #include "cx24117.h"
>>
>> @@ -145,6 +146,9 @@ enum cmds {
>>         CMD_TUNERSLEEP  = 0x36,
>>   };
>>
>> +static LIST_HEAD(hybrid_tuner_instance_list);
>> +static DEFINE_MUTEX(cx24117_list_mutex);
>> +
>>   /* The Demod/Tuner can't easily provide these, we cache them */
>>   struct cx24117_tuning {
>>         u32 frequency;
>> @@ -176,9 +180,11 @@ struct cx24117_priv {
>>         u8 demod_address;
>>         struct i2c_adapter *i2c;
>>         u8 skip_fw_load;
>> -
>>         struct mutex fe_lock;
>> -       atomic_t fe_nr;
>> +
>> +       /* Used for sharing this struct between demods */
>> +       struct tuner_i2c_props i2c_props;
>> +       struct list_head hybrid_tuner_instance_list;
>>   };
>>
>>   /* one per each fe */
>> @@ -536,7 +542,7 @@ static int cx24117_load_firmware(struct dvb_frontend
>> *fe,
>>         dev_dbg(&state->priv->i2c->dev,
>>                 "%s() demod%d FW is %zu bytes (%02x %02x .. %02x %02x)\n",
>>                 __func__, state->demod, fw->size, fw->data[0],
>> fw->data[1],
>> -               fw->data[fw->size-2], fw->data[fw->size-1]);
>> +               fw->data[fw->size - 2], fw->data[fw->size - 1]);
>>
>>         cx24117_writereg(state, 0xea, 0x00);
>>         cx24117_writereg(state, 0xea, 0x01);
>> @@ -1116,37 +1122,64 @@ static int cx24117_diseqc_send_burst(struct
>> dvb_frontend *fe,
>>         return 0;
>>   }
>>
>> +static int cx24117_get_priv(struct cx24117_priv **priv,
>> +       struct i2c_adapter *i2c, u8 client_address)
>> +{
>> +       int ret;
>> +
>> +       mutex_lock(&cx24117_list_mutex);
>> +       ret = hybrid_tuner_request_state(struct cx24117_priv, (*priv),
>> +               hybrid_tuner_instance_list, i2c, client_address,
>> "cx24117");
>> +       mutex_unlock(&cx24117_list_mutex);
>> +
>> +       return ret;
>> +}
>> +
>> +static void cx24117_release_priv(struct cx24117_priv *priv)
>> +{
>> +       mutex_lock(&cx24117_list_mutex);
>> +       if (priv != NULL)
>> +               hybrid_tuner_release_state(priv);
>> +       mutex_unlock(&cx24117_list_mutex);
>> +}
>> +
>>   static void cx24117_release(struct dvb_frontend *fe)
>>   {
>>         struct cx24117_state *state = fe->demodulator_priv;
>>         dev_dbg(&state->priv->i2c->dev, "%s demod%d\n",
>>                 __func__, state->demod);
>> -       if (!atomic_dec_and_test(&state->priv->fe_nr))
>> -               kfree(state->priv);
>> +       cx24117_release_priv(state->priv);
>>         kfree(state);
>>   }
>>
>>   static struct dvb_frontend_ops cx24117_ops;
>>
>>   struct dvb_frontend *cx24117_attach(const struct cx24117_config *config,
>> -       struct i2c_adapter *i2c, struct dvb_frontend *fe)
>> +       struct i2c_adapter *i2c)
>>   {
>>         struct cx24117_state *state = NULL;
>>         struct cx24117_priv *priv = NULL;
>>         int demod = 0;
>>
>> -       /* first frontend attaching */
>> -       /* allocate shared priv struct */
>> -       if (fe == NULL) {
>> -               priv = kzalloc(sizeof(struct cx24117_priv), GFP_KERNEL);
>> -               if (priv == NULL)
>> -                       goto error1;
>> +       /* get the common data struct for both demods */
>> +       demod = cx24117_get_priv(&priv, i2c, config->demod_address);
>> +
>> +       switch (demod) {
>> +       case 0:
>> +               dev_err(&state->priv->i2c->dev,
>> +                       "%s: Error attaching frontend %d\n",
>> +                       KBUILD_MODNAME, demod);
>> +               goto error1;
>> +               break;
>> +       case 1:
>> +               /* new priv instance */
>>                 priv->i2c = i2c;
>>                 priv->demod_address = config->demod_address;
>>                 mutex_init(&priv->fe_lock);
>> -       } else {
>> -               demod = 1;
>> -               priv = ((struct cx24117_state *)
>> fe->demodulator_priv)->priv;
>> +               break;
>> +       default:
>> +               /* existing priv instance */
>> +               break;
>>         }
>>
>>         /* allocate memory for the internal state */
>> @@ -1154,7 +1187,7 @@ struct dvb_frontend *cx24117_attach(const struct
>> cx24117_config *config,
>>         if (state == NULL)
>>                 goto error2;
>>
>> -       state->demod = demod;
>> +       state->demod = demod - 1;
>>         state->priv = priv;
>>
>>         /* test i2c bus for ack */
>> @@ -1163,12 +1196,9 @@ struct dvb_frontend *cx24117_attach(const struct
>> cx24117_config *config,
>>                         goto error3;
>>         }
>>
>> -       /* nr of frontends using the module */
>> -       atomic_inc(&priv->fe_nr);
>> -
>>         dev_info(&state->priv->i2c->dev,
>>                 "%s: Attaching frontend %d\n",
>> -               KBUILD_MODNAME, demod);
>> +               KBUILD_MODNAME, state->demod);
>>
>>         /* create dvb_frontend */
>>         memcpy(&state->frontend.ops, &cx24117_ops,
>> @@ -1179,7 +1209,7 @@ struct dvb_frontend *cx24117_attach(const struct
>> cx24117_config *config,
>>   error3:
>>         kfree(state);
>>   error2:
>> -       kfree(priv);
>> +       cx24117_release_priv(priv);
>>   error1:
>>         return NULL;
>>   }
>> diff --git a/drivers/media/dvb-frontends/cx24117.h
>> b/drivers/media/dvb-frontends/cx24117.h
>> index 5bc8f11..4e59e95 100644
>> --- a/drivers/media/dvb-frontends/cx24117.h
>> +++ b/drivers/media/dvb-frontends/cx24117.h
>> @@ -33,11 +33,11 @@ struct cx24117_config {
>>   #if IS_ENABLED(CONFIG_DVB_CX24117)
>>   extern struct dvb_frontend *cx24117_attach(
>>         const struct cx24117_config *config,
>> -       struct i2c_adapter *i2c, struct dvb_frontend *fe);
>> +       struct i2c_adapter *i2c);
>>   #else
>>   static inline struct dvb_frontend *cx24117_attach(
>>         const struct cx24117_config *config,
>> -       struct i2c_adapter *i2c, struct dvb_frontend *fe)
>> +       struct i2c_adapter *i2c)
>>   {
>>         dev_warn(&i2c->dev, "%s: driver disabled by Kconfig\n", __func__);
>>         return NULL;
>>
>
>
> --
> http://palosaari.fi/
