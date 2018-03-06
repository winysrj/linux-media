Return-path: <linux-media-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:44135 "EHLO
        hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933153AbeCFOok (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2018 09:44:40 -0500
Received: from homiemail-a117.g.dreamhost.com (sub5.mail.dreamhost.com [208.113.200.129])
        by hapkido.dreamhost.com (Postfix) with ESMTP id C5A5193664
        for <linux-media@vger.kernel.org>; Tue,  6 Mar 2018 06:44:39 -0800 (PST)
Subject: Re: [PATCH 3/7] si2157: Add hybrid tuner support
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Brad Love <brad@nextdimension.cc>,
        Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
References: <1515773982-6411-1-git-send-email-brad@nextdimension.cc>
 <1515773982-6411-4-git-send-email-brad@nextdimension.cc>
 <f2825efa-49ec-882e-7529-38521d99eb53@iki.fi>
 <71536ba9-8a5c-fd8d-a270-a62a725bd304@nextdimension.cc>
 <20180306092401.3463671c@vento.lan>
From: Brad Love <brad@b-rad.cc>
Message-ID: <52dbe5b5-c636-c727-35eb-59d3a8d1f732@b-rad.cc>
Date: Tue, 6 Mar 2018 08:44:36 -0600
MIME-Version: 1.0
In-Reply-To: <20180306092401.3463671c@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,


On 2018-03-06 06:24, Mauro Carvalho Chehab wrote:
> Hi Brad,
>
> As patches 1 and 2 are independent of this one, and should be backward
> compatible, I'm applying them, but I have issues with this one too :-)
>
> Em Tue, 16 Jan 2018 14:48:35 -0600
> Brad Love <brad@nextdimension.cc> escreveu:
>
>> On 2018-01-15 23:05, Antti Palosaari wrote:
>>> Hello
>>> So the use case is to share single tuner with multiple demodulators?
>>> Why don't just register single tuner and pass that info to multiple
>>> demods?
>>>
>>> Antti =20
>> Hello Antti,
>>
>> It was done this way because of lack of knowledge of other ways. The
>> method I used mirrored that done by the three other drivers I found
>> which supported *and* included multiple front ends. We had this _attac=
h
>> function sitting around as part of wip analog support to the si2157, a=
nd
>> it seemed like a nice fit here.
> The thing is that dvb_attach() is a very dirty and ugly hack,
> done when we needed to use I2C low level API calls inside DVB,
> while using high level bus-attach based I2C API for V4L.
>
> The hybrid_tuner_instance is yet-another-ugly dirty hack, with even
> causes lots of troubles for static analyzers.
>
> Nowadays, we should, instead, let the I2C bus bind the device
> at the bus and take care of lifetime issues.
>
> Btw, please take a look on this changeset:
>
> 	8f569c0b4e6b ("media: dvb-core: add helper functions for I2C binding")
>
> and an example about how to simplify the binding code at:
>
> 	ad32495b1513 ("media: em28xx-dvb: simplify DVB module probing logic")
>
> Em28xx is currently the only driver using the newer functions - My
> plan is to cleanup other drivers using the same logic as well,
> eventually improving the implementation of the new functions if needed.

I noticed the cleanup, I'll include it in my revised patch.



>
>> I just perused the tree again and noticed one spot I missed originally=
,
>> which does not use an _attach function. I didn't realize I could just
>> memcpy tuner_ops from fe[0] to fe[1] and call it a done deal, it does
>> appear to work the same though.
> I didn't write any hybrid tuner support using the new I2C binding
> schema, but, if both demods use the same tuner, I guess that's all
> it should be needed (and set adap->mfe_shared to 1).


This patch can be removed from the set, I have just memcpy'd
the tuner_ops to fe[1] now and everything works. I will resubmit a patch
with the mfe_shared property set though.



>
>> Is this really all that is required? If so, I'll modify patch 7/7 and
>> put this patch to the side for now.
>>
>> Cheers,
>>
>> Brad
>>
>>
>>> On 01/12/2018 06:19 PM, Brad Love wrote: =20
>>>> Add ability to share a tuner amongst demodulators. Addtional
>>>> demods are attached using hybrid_tuner_instance_list.
>>>>
>>>> The changes are equivalent to moving all of probe to _attach.
>>>> Results are backwards compatible with current usage.
>>>>
>>>> If the tuner is acquired via attach, then .release cleans state.
>>>> if the tuner is an i2c driver, then .release is set to NULL, and
>>>> .remove cleans remaining state.
>>>>
>>>> The following file contains a static si2157_attach:
>>>> - drivers/media/pci/saa7164/saa7164-dvb.c
>>>> The function name has been appended with _priv to appease
>>>> the compiler.
>>>>
>>>> Signed-off-by: Brad Love <brad@nextdimension.cc>
>>>> ---
>>>> =C2=A0 drivers/media/pci/saa7164/saa7164-dvb.c |=C2=A0 11 +-
>>>> =C2=A0 drivers/media/tuners/si2157.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 232
>>>> +++++++++++++++++++++++---------
>>>> =C2=A0 drivers/media/tuners/si2157.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 14 ++
>>>> =C2=A0 drivers/media/tuners/si2157_priv.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0=C2=A0 5 +
>>>> =C2=A0 4 files changed, 192 insertions(+), 70 deletions(-)
>>>>
>>>> diff --git a/drivers/media/pci/saa7164/saa7164-dvb.c
>>>> b/drivers/media/pci/saa7164/saa7164-dvb.c
>>>> index e76d3ba..9522c6c 100644
>>>> --- a/drivers/media/pci/saa7164/saa7164-dvb.c
>>>> +++ b/drivers/media/pci/saa7164/saa7164-dvb.c
>>>> @@ -110,8 +110,9 @@ static struct si2157_config
>>>> hauppauge_hvr2255_tuner_config =3D {
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .if_port =3D 1,
>>>> =C2=A0 };
>>>> =C2=A0 -static int si2157_attach(struct saa7164_port *port, struct
>>>> i2c_adapter *adapter,
>>>> -=C2=A0=C2=A0=C2=A0 struct dvb_frontend *fe, u8 addr8bit, struct si2=
157_config *cfg)
>>>> +static int si2157_attach_priv(struct saa7164_port *port,
>>>> +=C2=A0=C2=A0=C2=A0 struct i2c_adapter *adapter, struct dvb_frontend=
 *fe,
>>>> +=C2=A0=C2=A0=C2=A0 u8 addr8bit, struct si2157_config *cfg)
>>>> =C2=A0 {
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct i2c_board_info bi;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct i2c_client *tuner;
>>>> @@ -624,11 +625,13 @@ int saa7164_dvb_register(struct saa7164_port
>>>> *port)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (port->dvb=
.frontend !=3D NULL) {
>>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if (port->nr =3D=3D 0) {
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 si2157_attach(port, &dev->i2c_bus[0].i2c_adap,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 si2157_attach_priv(port,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 &dev->i2c_bus[0].i2c_adap,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 port->dvb.frontend, 0xc0,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 &hauppauge_hvr2255_tuner_config);
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 } else {
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 si2157_attach(port, &dev->i2c_bus[1].i2c_adap,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 si2157_attach_priv(port,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 &dev->i2c_bus[1].i2c_adap,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 port->dvb.frontend, 0xc0,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 &hauppauge_hvr2255_tuner_config);
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 }
>>>> diff --git a/drivers/media/tuners/si2157.c
>>>> b/drivers/media/tuners/si2157.c
>>>> index e35b1fa..9121361 100644
>>>> --- a/drivers/media/tuners/si2157.c
>>>> +++ b/drivers/media/tuners/si2157.c
>>>> @@ -18,6 +18,11 @@
>>>> =C2=A0 =C2=A0 static const struct dvb_tuner_ops si2157_ops;
>>>> =C2=A0 +static DEFINE_MUTEX(si2157_list_mutex);
>>>> +static LIST_HEAD(hybrid_tuner_instance_list);
>>>> +
>>>> +/*-----------------------------------------------------------------=
----*/
>>>>
>>>> +
>>>> =C2=A0 /* execute firmware command */
>>>> =C2=A0 static int si2157_cmd_execute(struct i2c_client *client, stru=
ct
>>>> si2157_cmd *cmd)
>>>> =C2=A0 {
>>>> @@ -385,6 +390,31 @@ static int si2157_get_if_frequency(struct
>>>> dvb_frontend *fe, u32 *frequency)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>>>> =C2=A0 }
>>>> =C2=A0 +static void si2157_release(struct dvb_frontend *fe)
>>>> +{
>>>> +=C2=A0=C2=A0=C2=A0 struct i2c_client *client =3D fe->tuner_priv;
>>>> +=C2=A0=C2=A0=C2=A0 struct si2157_dev *dev =3D i2c_get_clientdata(cl=
ient);
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 dev_dbg(&client->dev, "%s()\n", __func__);
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 /* only do full cleanup on final instance */
>>>> +=C2=A0=C2=A0=C2=A0 if (hybrid_tuner_report_instance_count(dev) =3D=3D=
 1) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* stop statistics polli=
ng */
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cancel_delayed_work_sync=
(&dev->stat_work);
>>>> +#ifdef CONFIG_MEDIA_CONTROLLER_DVB
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (dev->mdev)
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
media_device_unregister_entity(&dev->ent);
>>>> +#endif
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 i2c_set_clientdata(clien=
t, NULL);
>>>> +=C2=A0=C2=A0=C2=A0 }
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 mutex_lock(&si2157_list_mutex);
>>>> +=C2=A0=C2=A0=C2=A0 hybrid_tuner_release_state(dev);
>>>> +=C2=A0=C2=A0=C2=A0 mutex_unlock(&si2157_list_mutex);
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 fe->tuner_priv =3D NULL;
>>>> +}
>>>> +
>>>> =C2=A0 static const struct dvb_tuner_ops si2157_ops =3D {
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .info =3D {
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .name=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D "Silicon Labs
>>>> Si2141/Si2146/2147/2148/2157/2158",
>>>> @@ -396,6 +426,7 @@ static const struct dvb_tuner_ops si2157_ops =3D=
 {
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .sleep =3D si2157_sleep,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .set_params =3D si2157_set_params,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .get_if_frequency =3D si2157_get_if_f=
requency,
>>>> +=C2=A0=C2=A0=C2=A0 .release =3D si2157_release,
>>>> =C2=A0 };
>>>> =C2=A0 =C2=A0 static void si2157_stat_work(struct work_struct *work)
>>>> @@ -431,72 +462,30 @@ static int si2157_probe(struct i2c_client *cli=
ent,
>>>> =C2=A0 {
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct si2157_config *cfg =3D client-=
>dev.platform_data;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct dvb_frontend *fe =3D cfg->fe;
>>>> -=C2=A0=C2=A0=C2=A0 struct si2157_dev *dev;
>>>> -=C2=A0=C2=A0=C2=A0 struct si2157_cmd cmd;
>>>> -=C2=A0=C2=A0=C2=A0 int ret;
>>>> -
>>>> -=C2=A0=C2=A0=C2=A0 dev =3D kzalloc(sizeof(*dev), GFP_KERNEL);
>>>> -=C2=A0=C2=A0=C2=A0 if (!dev) {
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -ENOMEM;
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev_err(&client->dev, "k=
zalloc() failed\n");
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err;
>>>> -=C2=A0=C2=A0=C2=A0 }
>>>> -
>>>> -=C2=A0=C2=A0=C2=A0 i2c_set_clientdata(client, dev);
>>>> -=C2=A0=C2=A0=C2=A0 dev->fe =3D cfg->fe;
>>>> -=C2=A0=C2=A0=C2=A0 dev->inversion =3D cfg->inversion;
>>>> -=C2=A0=C2=A0=C2=A0 dev->if_port =3D cfg->if_port;
>>>> -=C2=A0=C2=A0=C2=A0 dev->chiptype =3D (u8)id->driver_data;
>>>> -=C2=A0=C2=A0=C2=A0 dev->if_frequency =3D 5000000; /* default value =
of property 0x0706 */
>>>> -=C2=A0=C2=A0=C2=A0 mutex_init(&dev->i2c_mutex);
>>>> -=C2=A0=C2=A0=C2=A0 INIT_DELAYED_WORK(&dev->stat_work, si2157_stat_w=
ork);
>>>> +=C2=A0=C2=A0=C2=A0 struct si2157_dev *dev =3D NULL;
>>>> +=C2=A0=C2=A0=C2=A0 unsigned short addr =3D client->addr;
>>>> +=C2=A0=C2=A0=C2=A0 int ret =3D 0;
>>>> =C2=A0 -=C2=A0=C2=A0=C2=A0 /* check if the tuner is there */
>>>> -=C2=A0=C2=A0=C2=A0 cmd.wlen =3D 0;
>>>> -=C2=A0=C2=A0=C2=A0 cmd.rlen =3D 1;
>>>> -=C2=A0=C2=A0=C2=A0 ret =3D si2157_cmd_execute(client, &cmd);
>>>> -=C2=A0=C2=A0=C2=A0 if (ret)
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_kfree;
>>>> -
>>>> -=C2=A0=C2=A0=C2=A0 memcpy(&fe->ops.tuner_ops, &si2157_ops, sizeof(s=
truct
>>>> dvb_tuner_ops));
>>>> +=C2=A0=C2=A0=C2=A0 dev_dbg(&client->dev, "Probing tuner\n");
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fe->tuner_priv =3D client;
>>>> =C2=A0 -#ifdef CONFIG_MEDIA_CONTROLLER
>>>> -=C2=A0=C2=A0=C2=A0 if (cfg->mdev) {
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev->mdev =3D cfg->mdev;
>>>> -
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev->ent.name =3D KBUILD=
_MODNAME;
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev->ent.function =3D ME=
DIA_ENT_F_TUNER;
>>>> -
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev->pad[TUNER_PAD_RF_IN=
PUT].flags =3D MEDIA_PAD_FL_SINK;
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev->pad[TUNER_PAD_OUTPU=
T].flags =3D MEDIA_PAD_FL_SOURCE;
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev->pad[TUNER_PAD_AUD_O=
UT].flags =3D MEDIA_PAD_FL_SOURCE;
>>>> -
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D media_entity_pad=
s_init(&dev->ent, TUNER_NUM_PADS,
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 &dev->pad[0]);
>>>> -
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
goto err_kfree;
>>>> -
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D media_device_reg=
ister_entity(cfg->mdev, &dev->ent);
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret) {
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
media_entity_cleanup(&dev->ent);
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
goto err_kfree;
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>> +=C2=A0=C2=A0=C2=A0 if (si2157_attach(fe, (u8)addr, client->adapter,=
 cfg) =3D=3D NULL) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev_err(&client->dev, "%=
s: attaching si2157 tuner failed\n",
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 __func__);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>> -#endif
>>>> +=C2=A0=C2=A0=C2=A0 fe->ops.tuner_ops.release =3D NULL;
>>>> =C2=A0 +=C2=A0=C2=A0=C2=A0 dev =3D i2c_get_clientdata(client);
>>>> +=C2=A0=C2=A0=C2=A0 dev->chiptype =3D (u8)id->driver_data;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev_info(&client->dev, "Silicon Labs =
%s successfully attached\n",
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 dev->chiptype =3D=3D SI2157_CHIPTYPE_SI2141 ?=C2=A0 "Si2141" :
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 dev->chiptype =3D=3D SI2157_CHIPTYPE_SI2146 ?
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 "Si2146" : "Si2147/2148/2157/2158");
>>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>>>> -
>>>> -err_kfree:
>>>> -=C2=A0=C2=A0=C2=A0 kfree(dev);
>>>> =C2=A0 err:
>>>> -=C2=A0=C2=A0=C2=A0 dev_dbg(&client->dev, "failed=3D%d\n", ret);
>>>> +=C2=A0=C2=A0=C2=A0 dev_warn(&client->dev, "probe failed =3D %d\n", =
ret);
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>>>> =C2=A0 }
>>>> =C2=A0 @@ -505,19 +494,10 @@ static int si2157_remove(struct i2c_cli=
ent
>>>> *client)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct si2157_dev *dev =3D i2c_get_cl=
ientdata(client);
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct dvb_frontend *fe =3D dev->fe;
>>>> =C2=A0 -=C2=A0=C2=A0=C2=A0 dev_dbg(&client->dev, "\n");
>>>> -
>>>> -=C2=A0=C2=A0=C2=A0 /* stop statistics polling */
>>>> -=C2=A0=C2=A0=C2=A0 cancel_delayed_work_sync(&dev->stat_work);
>>>> -
>>>> -#ifdef CONFIG_MEDIA_CONTROLLER_DVB
>>>> -=C2=A0=C2=A0=C2=A0 if (dev->mdev)
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 media_device_unregister_=
entity(&dev->ent);
>>>> -#endif
>>>> +=C2=A0=C2=A0=C2=A0 dev_dbg(&client->dev, "%s()\n", __func__);
>>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 memset(&fe->ops.tuner_ops, 0, =
sizeof(struct dvb_tuner_ops));
>>>> -=C2=A0=C2=A0=C2=A0 fe->tuner_priv =3D NULL;
>>>> -=C2=A0=C2=A0=C2=A0 kfree(dev);
>>>> +=C2=A0=C2=A0=C2=A0 si2157_release(fe);
>>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>>>> =C2=A0 }
>>>> @@ -542,7 +522,127 @@ static struct i2c_driver si2157_driver =3D {
>>>> =C2=A0 =C2=A0 module_i2c_driver(si2157_driver);
>>>> =C2=A0 -MODULE_DESCRIPTION("Silicon Labs Si2141/Si2146/2147/2148/215=
7/2158
>>>> silicon tuner driver");
>>>> +struct dvb_frontend *si2157_attach(struct dvb_frontend *fe, u8 addr=
,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct i2c_adapter *i2c,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct si2157_config *cf=
g)
>>>> +{
>>>> +=C2=A0=C2=A0=C2=A0 struct i2c_client *client =3D NULL;
>>>> +=C2=A0=C2=A0=C2=A0 struct si2157_dev *dev =3D NULL;
>>>> +=C2=A0=C2=A0=C2=A0 struct si2157_cmd cmd;
>>>> +=C2=A0=C2=A0=C2=A0 int instance =3D 0, ret;
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 pr_debug("%s (%d-%04x)\n", __func__,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 i2c ? =
i2c_adapter_id(i2c) : 0,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 addr);
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 if (!cfg) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pr_warn("no configuratio=
n submitted\n");
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto fail;
>>>> +=C2=A0=C2=A0=C2=A0 }
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 if (!fe) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pr_warn("fe is NULL\n");
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto fail;
>>>> +=C2=A0=C2=A0=C2=A0 }
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 client =3D fe->tuner_priv;
>>>> +=C2=A0=C2=A0=C2=A0 if (!client) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pr_warn("client is NULL\=
n");
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto fail;
>>>> +=C2=A0=C2=A0=C2=A0 }
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 mutex_lock(&si2157_list_mutex);
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 instance =3D hybrid_tuner_request_state(struct s=
i2157_dev, dev,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
hybrid_tuner_instance_list,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
i2c, addr, "si2157");
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 switch (instance) {
>>>> +=C2=A0=C2=A0=C2=A0 case 0:
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto fail;
>>>> +=C2=A0=C2=A0=C2=A0 case 1:
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* new tuner instance */
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev_dbg(&client->dev, "%=
s(): new instance for tuner @0x%02x\n",
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 __func__, addr);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev->addr =3D addr;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 i2c_set_clientdata(clien=
t, dev);
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev->fe =3D fe;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev->chiptype =3D SI2157=
_CHIPTYPE_SI2157;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev->if_frequency =3D 0;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev->if_port=C2=A0=C2=A0=
 =3D cfg->if_port;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev->inversion =3D cfg->=
inversion;
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_init(&dev->i2c_mut=
ex);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 INIT_DELAYED_WORK(&dev->=
stat_work, si2157_stat_work);
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
>>>> +=C2=A0=C2=A0=C2=A0 default:
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* existing tuner instan=
ce */
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev_dbg(&client->dev,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 "%s(): using existing instance for tuner @0x%02x\n"=
,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 __func__, addr);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
>>>> +=C2=A0=C2=A0=C2=A0 }
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 /* check if the tuner is there */
>>>> +=C2=A0=C2=A0=C2=A0 cmd.wlen =3D 0;
>>>> +=C2=A0=C2=A0=C2=A0 cmd.rlen =3D 1;
>>>> +=C2=A0=C2=A0=C2=A0 ret =3D si2157_cmd_execute(client, &cmd);
>>>> +=C2=A0=C2=A0=C2=A0 /* verify no i2c error and CTS is set */
>>>> +=C2=A0=C2=A0=C2=A0 if (ret) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev_warn(&client->dev, "=
no HW found ret=3D%d\n", ret);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto fail_instance;
>>>> +=C2=A0=C2=A0=C2=A0 }
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 memcpy(&fe->ops.tuner_ops, &si2157_ops, sizeof(s=
truct
>>>> dvb_tuner_ops));
>>>> +
>>>> +#ifdef CONFIG_MEDIA_CONTROLLER
>>>> +=C2=A0=C2=A0=C2=A0 if (instance =3D=3D 1 && cfg->mdev) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev->mdev =3D cfg->mdev;
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev->ent.name =3D KBUILD=
_MODNAME;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev->ent.function =3D ME=
DIA_ENT_F_TUNER;
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev->pad[TUNER_PAD_RF_IN=
PUT].flags =3D MEDIA_PAD_FL_SINK;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev->pad[TUNER_PAD_OUTPU=
T].flags =3D MEDIA_PAD_FL_SOURCE;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev->pad[TUNER_PAD_AUD_O=
UT].flags =3D MEDIA_PAD_FL_SOURCE;
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D media_entity_pad=
s_init(&dev->ent, TUNER_NUM_PADS,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 &dev->pad[0]);
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
goto fail_instance;
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D media_device_reg=
ister_entity(cfg->mdev, &dev->ent);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
dev_warn(&client->dev,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 "media_device_regiser_entity returns %d\n", ret);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
media_entity_cleanup(&dev->ent);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
goto fail_instance;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>> +=C2=A0=C2=A0=C2=A0 }
>>>> +#endif
>>>> +=C2=A0=C2=A0=C2=A0 mutex_unlock(&si2157_list_mutex);
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 if (instance !=3D 1)
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev_info(&client->dev, "=
Silicon Labs %s successfully
>>>> attached\n",
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
dev->chiptype =3D=3D SI2157_CHIPTYPE_SI2141 ?=C2=A0 "Si2141" :
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
dev->chiptype =3D=3D SI2157_CHIPTYPE_SI2146 ?
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
"Si2146" : "Si2147/2148/2157/2158");
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 return fe;
>>>> +fail_instance:
>>>> +=C2=A0=C2=A0=C2=A0 mutex_unlock(&si2157_list_mutex);
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 si2157_release(fe);
>>>> +fail:
>>>> +=C2=A0=C2=A0=C2=A0 dev_warn(&client->dev, "Attach failed\n");
>>>> +=C2=A0=C2=A0=C2=A0 return NULL;
>>>> +}
>>>> +EXPORT_SYMBOL(si2157_attach);
>>>> +
>>>> +MODULE_DESCRIPTION("Silicon Labs Si2141/2146/2147/2148/2157/2158
>>>> silicon tuner driver");
>>>> =C2=A0 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
>>>> =C2=A0 MODULE_LICENSE("GPL");
>>>> =C2=A0 MODULE_FIRMWARE(SI2158_A20_FIRMWARE);
>>>> diff --git a/drivers/media/tuners/si2157.h
>>>> b/drivers/media/tuners/si2157.h
>>>> index de597fa..26b94ca 100644
>>>> --- a/drivers/media/tuners/si2157.h
>>>> +++ b/drivers/media/tuners/si2157.h
>>>> @@ -46,4 +46,18 @@ struct si2157_config {
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u8 if_port;
>>>> =C2=A0 };
>>>> =C2=A0 +#if IS_REACHABLE(CONFIG_MEDIA_TUNER_SI2157)
>>>> +extern struct dvb_frontend *si2157_attach(struct dvb_frontend *fe,
>>>> u8 addr,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 str=
uct i2c_adapter *i2c,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 str=
uct si2157_config *cfg);
>>>> +#else
>>>> +static inline struct dvb_frontend *si2157_attach(struct dvb_fronten=
d
>>>> *fe,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 u8 addr,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 struct i2c_adapter *i2c,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 struct si2157_config *cfg)
>>>> +{
>>>> +=C2=A0=C2=A0=C2=A0 pr_err("%s: driver disabled by Kconfig\n", __fun=
c__);
>>>> +=C2=A0=C2=A0=C2=A0 return NULL;
>>>> +}
>>>> +#endif
>>>> =C2=A0 #endif
>>>> diff --git a/drivers/media/tuners/si2157_priv.h
>>>> b/drivers/media/tuners/si2157_priv.h
>>>> index e6436f7..2801aaa 100644
>>>> --- a/drivers/media/tuners/si2157_priv.h
>>>> +++ b/drivers/media/tuners/si2157_priv.h
>>>> @@ -19,15 +19,20 @@
>>>> =C2=A0 =C2=A0 #include <linux/firmware.h>
>>>> =C2=A0 #include <media/v4l2-mc.h>
>>>> +#include "tuner-i2c.h"
>>>> =C2=A0 #include "si2157.h"
>>>> =C2=A0 =C2=A0 /* state struct */
>>>> =C2=A0 struct si2157_dev {
>>>> +=C2=A0=C2=A0=C2=A0 struct list_head hybrid_tuner_instance_list;
>>>> +=C2=A0=C2=A0=C2=A0 struct tuner_i2c_props=C2=A0 i2c_props;
>>>> +
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct mutex i2c_mutex;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct dvb_frontend *fe;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool active;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool inversion;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u8 chiptype;
>>>> +=C2=A0=C2=A0=C2=A0 u8 addr;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u8 if_port;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 if_frequency;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct delayed_work stat_work;
>>>> =20
>>> =20
>
>
> Thanks,
> Mauro
