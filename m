Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:51765 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbaESWTw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 May 2014 18:19:52 -0400
Received: by mail-qc0-f175.google.com with SMTP id w7so10028141qcr.6
        for <linux-media@vger.kernel.org>; Mon, 19 May 2014 15:19:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5377B269.3040103@iki.fi>
References: <1398187584-26666-1-git-send-email-knightrider@are.ma>
	<5377B269.3040103@iki.fi>
Date: Tue, 20 May 2014 07:19:51 +0900
Message-ID: <CAKnK8-Qd+uN9v6y7kx25Pd0e1cARFv2Gd0V0WyB6VTNEOLL9ZQ@mail.gmail.com>
Subject: Re: [PATCH] Full DVB driver package for Earthsoft PT3 (ISDB-S/T) cards
From: =?UTF-8?B?44G744Gh?= <knightrider@are.ma>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>, m.chehab@samsung.com,
	Hans De Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Peter Senna Tschudin <peter.senna@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for the review.
Inlined questions before going further.
Best Regards
-Bud

2014-05-18 4:03 GMT+09:00 Antti Palosaari <crope@iki.fi>:
> Overall tc90522 driver looks very complex and there was multiple issues. One
> reason of complexiness is that HW algo used. I cannot see any reason why it
> is used, just change default SW algo and implement things more likely others
> are doing.
>
>> diff --git a/drivers/media/dvb-frontends/tc90522.c
>> b/drivers/media/dvb-frontends/tc90522.c
>> new file mode 100644
>> index 0000000..a767600
>> --- /dev/null
>> +++ b/drivers/media/dvb-frontends/tc90522.c
>> @@ -0,0 +1,539 @@
>> +/*
>> + * Earthsoft PT3 demodulator frontend Toshiba TC90522XBG
>> OFDM(ISDB-T)/8PSK(ISDB-S)
>
> That is, or at least should be, general DTV demod driver. So lets call it
> Toshiba TC90522 or whatever the chipset name is.

FYI, the only document available is SDK from PT3 card maker, Earthsoft.
No guarantee this driver works in other cards.

>> +int tc90522_write(struct dvb_frontend *fe, const u8 *data, int len)
>> +{
>> +       struct tc90522 *demod = fe->demodulator_priv;
>> +       struct i2c_msg msg[3];
>> +       u8 buf[6];
>> +
>> +       if (data) {
>> +               msg[0].addr = demod->addr_demod;
>> +               msg[0].buf = (u8 *)data;
>> +               msg[0].flags = 0;                       /* write */
>> +               msg[0].len = len;
>> +
>> +               return i2c_transfer(demod->i2c, msg, 1) == 1 ? 0 :
>> -EREMOTEIO;
>> +       } else {
>> +               u8 addr_tuner = (len >> 8) & 0xff,
>> +                  addr_data = len & 0xff;
>> +               if (len >> 16) {                        /* read tuner
>> without address */
>> +                       buf[0] = TC90522_PASSTHROUGH;
>> +                       buf[1] = (addr_tuner << 1) | 1;
>> +                       msg[0].buf = buf;
>> +                       msg[0].len = 2;
>> +                       msg[0].addr = demod->addr_demod;
>> +                       msg[0].flags = 0;               /* write */
>> +
>> +                       msg[1].buf = buf + 2;
>> +                       msg[1].len = 1;
>> +                       msg[1].addr = demod->addr_demod;
>> +                       msg[1].flags = I2C_M_RD;        /* read */
>> +
>> +                       return i2c_transfer(demod->i2c, msg, 2) == 2 ?
>> buf[2] : -EREMOTEIO;
>> +               } else {                                /* read tuner */
>> +                       buf[0] = TC90522_PASSTHROUGH;
>> +                       buf[1] = addr_tuner << 1;
>> +                       buf[2] = addr_data;
>> +                       msg[0].buf = buf;
>> +                       msg[0].len = 3;
>> +                       msg[0].addr = demod->addr_demod;
>> +                       msg[0].flags = 0;               /* write */
>> +
>> +                       buf[3] = TC90522_PASSTHROUGH;
>> +                       buf[4] = (addr_tuner << 1) | 1;
>> +                       msg[1].buf = buf + 3;
>> +                       msg[1].len = 2;
>> +                       msg[1].addr = demod->addr_demod;
>> +                       msg[1].flags = 0;               /* write */
>> +
>> +                       msg[2].buf = buf + 5;
>> +                       msg[2].len = 1;
>> +                       msg[2].addr = demod->addr_demod;
>> +                       msg[2].flags = I2C_M_RD;        /* read */
>> +
>> +                       return i2c_transfer(demod->i2c, msg, 3) == 3 ?
>> buf[5] : -EREMOTEIO;
>> +               }
>> +       }
>> +}
>
> That routine is mess. I read it many times without understanding what it
> does, when and why. It is not register write over I2C as expected. For
> example parameter named "len" is abused for tuner I2C even that is demod
> driver...

Tuners need to read data through demod, and there is no read callback available
in dvb_frontend.h (only write is provided).
The above routine provides R/W access.

>> +int tc90522_write_data(struct dvb_frontend *fe, u8 addr_data, u8 *data,
>> u8 len)
>> +{
>> +       u8 buf[len + 1];
>> +       buf[0] = addr_data;
>> +       memcpy(buf + 1, data, len);
>> +       return tc90522_write(fe, buf, len + 1);
>> +}
>> +
>> +int tc90522_read(struct tc90522 *demod, u8 addr, u8 *buf, u8 buflen)
>> +{
>> +       struct i2c_msg msg[2];
>> +       if (!buf || !buflen)
>> +               return -EINVAL;
>> +
>> +       buf[0] = addr;
>
> ....
>>
>> +       msg[0].addr = demod->addr_demod;
>> +       msg[0].flags = 0;                       /* write */
>> +       msg[0].buf = buf;
>
> just give a addr pointer, no need to store it to buf first.
>
>> +       msg[0].len = 1;
>> +
>> +       msg[1].addr = demod->addr_demod;
>> +       msg[1].flags = I2C_M_RD;                /* read */
>> +       msg[1].buf = buf;
>> +       msg[1].len = buflen;
>> +
>> +       return i2c_transfer(demod->i2c, msg, 2) == 2 ? 0 : -EREMOTEIO;
>> +}
>
> All in all, it looks like demod is using just most typical register access
> for both register write and read, where first byte is register address and
> value(s) are after that. Register read is done using repeated START.
>
> I encourage you to use RegMap API as it covers all that boilerplate stuff -
> and forces you implement things correctly (no such hack possible done in
> tc90522_write()).

Good recommendation. I'll take a look.

>> +u32 tc90522_byten(const u8 *data, u32 n)
>> +{
>> +       u32 i, val = 0;
>> +
>> +       for (i = 0; i < n; i++) {
>> +               val <<= 8;
>> +               val |= data[i];
>> +       }
>> +       return val;
>> +}
>
> What is that? Kinda bit reverse? Look from existing bitops if there is such
> a solution already and if not, add comments what that is for.

changed to:
u64 tc90522_ntoint(const u8 *data, u8 n)    /* convert n_bytes data
from stream (network byte order) to integer */
{                        /* can't use <arpa/inet.h>'s ntoh*() as
sometimes n = 3,5,... */
...

>> +               ((data[0] >> 4) & 1)                    ||
>> +               tc90522_read(demod, 0xce, data, 2)      ||
>> +               (tc90522_byten(data, 2) == 0)           ||
>> +               tc90522_read(demod, 0xc3, data, 1)      ||
>> +               tc90522_read(demod, 0xc5, data, SIZE);
>
> Masking return statuses like that does not look good nor clear.

Well, the statuses are not so important here.
We only want to know & stop if there was an error occured.
That is enough.

>> +enum tc90522_pwr {
>> +       TC90522_PWR_OFF         = 0x00,
>> +       TC90522_PWR_AMP_ON      = 0x04,
>> +       TC90522_PWR_TUNER_ON    = 0x40,
>> +};
>> +
>> +static enum tc90522_pwr tc90522_pwr = TC90522_PWR_OFF;
>
> Global static variable for device power management..? That looks very bad.
> Those variables are shared between all driver instances. That will not work
> if you have multiple devices having that demod driver!

OK, removed.
In the next release pt3_pci will instruct when to power on the demod chip.

>> +int tc90522_set_powers(struct tc90522 *demod, enum tc90522_pwr pwr)
>> +{
>> +       u8 data = pwr | 0b10011001;
>> +       pr_debug("#%d tuner %s amp %s\n", demod->idx, pwr &
>> TC90522_PWR_TUNER_ON ? "ON" : "OFF", pwr & TC90522_PWR_AMP_ON ? "ON" :
>> "OFF");
>> +       tc90522_pwr = pwr;
>> +       return tc90522_write_data(&demod->fe, 0x1e, &data, 1);
>> +}
>> +
>> +/* dvb_frontend_ops */
>> +int tc90522_get_frontend_algo(struct dvb_frontend *fe)
>> +{
>> +       return DVBFE_ALGO_HW;
>> +}
>> +
>> +int tc90522_sleep(struct dvb_frontend *fe)
>> +{
>> +       struct tc90522 *demod = fe->demodulator_priv;
>> +       pr_debug("#%d %s %s\n", demod->idx, __func__, demod->type ==
>> SYS_ISDBS ? "S" : "T");
>> +       return fe->ops.tuner_ops.sleep(fe);
>
> :-@ You are simply not allowed to hard code tuner power-management to demod
> driver, it is no, no, no. Demod driver can have only get IF and set
> parameters reference to tuner and nothing more.
>
> You should sleep only demod in that demod sleep().
> It is DVB core who is responsible of runtime power-management.
>
>> +}
>> +
>> +int tc90522_wakeup(struct dvb_frontend *fe)
>> +{
>> +       struct tc90522 *demod = fe->demodulator_priv;
>> +       pr_debug("#%d %s %s 0x%x\n", demod->idx, __func__, demod->type ==
>> SYS_ISDBS ? "S" : "T", tc90522_pwr);
>> +
>> +       if (!tc90522_pwr)
>> +               return  tc90522_set_powers(demod, TC90522_PWR_TUNER_ON) ||
>> +                       i2c_transfer(demod->i2c, NULL, 0)               ||
>> +                       tc90522_set_powers(demod, TC90522_PWR_TUNER_ON |
>> TC90522_PWR_AMP_ON);
>> +       demod->state = TC90522_IDLE;
>> +       return fe->ops.tuner_ops.init(fe);
>> +}
>
> power-management is totally wrong here too
>
>> +void tc90522_release(struct dvb_frontend *fe)
>> +{
>> +       struct tc90522 *demod = fe->demodulator_priv;
>> +       pr_debug("#%d %s\n", demod->idx, __func__);
>> +
>> +       if (tc90522_pwr)
>> +               tc90522_set_powers(demod, TC90522_PWR_OFF);
>
> That belongs to demod driver power-management callback sleep()
>
>> +       tc90522_sleep(fe);
>
> hmm? PM...
>
>> +       fe->ops.tuner_ops.release(fe);
>> +       kfree(demod);
>> +}

Sounds like your perception is TOTALLY WRONG.
Remember this chip has 4 independent demods sharing the same power.
There is only one power available for all 4!
Turning off 1 demod will shutdown the other 3.

Secondly, in PT3, there is no direct access to the tuners.
Every control / data is done via demod, including power.

>> +int tc90522_read_signal_strength(struct dvb_frontend *fe, u16 *cn)     /*
>> raw C/N */
>> +{
>> +       struct tc90522 *demod = fe->demodulator_priv;
>> +       s64 ret = tc90522_get_cn_raw(demod);
>> +       *cn = ret < 0 ? 0 : ret;
>> +       pr_debug("v3 CN %d (%lld dB)\n", (int)*cn, demod->type ==
>> SYS_ISDBS ? (long long int)tc90522_get_cn_s(*cn) : (long long
>> int)tc90522_get_cn_t(*cn));
>> +       return ret < 0 ? ret : 0;
>> +}
>
> We have API who supports both CNR and signal strenght. Do not abuse signal
> strenght for CNR, instead implement as it should.

OK, on DVBv3 stat I changed back .read_signal_strength to .read_snr
for CNR (digitally modulated SNR)
though AFAIK (in a strict mean) SNR != CNR.

>> +int tc90522_read_status(struct dvb_frontend *fe, fe_status_t *status)
>> +{
>> +       struct tc90522 *demod = fe->demodulator_priv;
>> +       struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>> +       s64 ret = tc90522_get_cn_raw(demod),
>> +           raw = ret < 0 ? 0 : ret;
>> +
>> +       switch (demod->state) {
>> +       case TC90522_IDLE:
>> +       case TC90522_SET_FREQUENCY:
>> +               *status = 0;
>> +               break;
>> +
>> +       case TC90522_SET_MODULATION:
>> +       case TC90522_ABORT:
>> +               *status |= FE_HAS_SIGNAL;
>> +               break;
>> +
>> +       case TC90522_TRACK:
>> +               *status |= FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
>> +               break;
>> +       }
>> +
>> +       c->cnr.len = 1;
>> +       c->cnr.stat[0].svalue = demod->type == SYS_ISDBS ?
>> tc90522_get_cn_s(raw) : tc90522_get_cn_t(raw);
>> +       c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
>> +       pr_debug("v5 CN %lld (%lld dB)\n", raw, c->cnr.stat[0].svalue);
>> +       return ret < 0 ? ret : 0;
>> +}
>
> So you have decided to add some statistics logic here too. It is good place
> to update stistics counters, but only on case where SW algo used and DVB
> core is polling. However, you used HW algo which means that is not polled
> automatically. Maybe it does not work as it should.

So sorry but so far this works perfectly.

>> +/**** ISDB-S ****/
>> +int tc90522_write_id_s(struct dvb_frontend *fe, u16 id)
>> +{
>> +       u8 data[2] = { id >> 8, (u8)id };
>> +       return tc90522_write_data(fe, 0x8f, data, sizeof(data));
>> +}
>
> Rather useless oneliner function called only from one place. This makes only
> few lines of code more and bigger binary.

OK, merged to parent function.

>> +int tc90522_tune_s(struct dvb_frontend *fe, bool re_tune, unsigned int
>> mode_flags, unsigned int *delay, fe_status_t *status)
>> +{
>> +       struct tc90522 *demod = fe->demodulator_priv;
>> +       struct tmcc_s tmcc;
>> +       int i, ret,
>> +           freq = fe->dtv_property_cache.frequency,
>> +           tsid = fe->dtv_property_cache.stream_id;
>
> Adding more ints here does not cost anything.

Well, this looks cleaner & smarter on my editor, and checkpatch.pl did
not complain...

>> +
>> +       if (re_tune)
>> +               demod->state = TC90522_SET_FREQUENCY;
>> +
>> +       switch (demod->state) {
>> +       case TC90522_IDLE:
>> +               *delay = msecs_to_jiffies(3000);
>> +               *status = 0;
>> +               return 0;
>> +
>> +       case TC90522_SET_FREQUENCY:
>> +               pr_debug("#%d tsid 0x%x freq %d\n", demod->idx, tsid,
>> freq);
>
> You must use dev_ functions for logging.

Some maintainers (I forgot their names, maybe you also?) asked to use pr_*.
And I agreed with them. dev_* is used only in pt3_pci, the PCI bridge driver.
IMHO pr_* is more suitable. We can change to dev_* if it is a must.

... skip ...

>> +               demod->state = TC90522_TRACK;
>> +               /* fallthrough */
>> +
>> +       case TC90522_TRACK:
>> +               *delay = msecs_to_jiffies(3000);
>> +               *status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
>> +               return 0;
>> +
>> +       case TC90522_ABORT:
>> +               *delay = msecs_to_jiffies(3000);
>> +               *status = FE_HAS_SIGNAL;
>> +               return 0;
>> +       }
>> +       return -ERANGE;
>> +}
>
> That didnt look very correct and I didnt even understand it very well.
> Basically it is callback which dvb core uses to tune device. However, thee
> is complex state machine implemented. State machine state is updated by
> read_status() callback, which is *not* ran by DVB core when that HW aldo is
> used. How that can work? You need to call FE status from userspace in order
> to update state machine? If your app does not call status, that does not
> work at all?

You are WRONG.
It is dvb-core who runs the iteration.

> And those 3 sec timers are here in order to leave some time for app to read
> FE status => updates state machine?

User is recommended to do FE_READ_STATUS and check FE_HAS_LOCK status
to make sure it is tuned correctly.

>> +int tc90522_get_tmcc_t(struct tc90522 *demod)
>> +{
>> +       u8 buf;
>> +       bool b = false, retryov, fulock;
>> +
>> +       while (1) {
>> +               if (tc90522_read(demod, 0x80, &buf, 1))
>> +                       return -EBADMSG;
>> +               retryov = buf & 0b10000000 ? true : false;
>> +               fulock  = buf & 0b00001000 ? true : false;
>> +               if (!fulock) {
>> +                       b = true;
>> +                       break;
>> +               } else {
>> +                       if (retryov)
>> +                               break;
>> +               }
>> +               msleep_interruptible(1);
>
> Weird looking sleep, I have never earlier seen that. Have you looked timers
> howto from kernel documentation?
>
> Also, it looks a bit scary what goes to potential infinity loop. If you need
> some upper limit per time you should use loop implemented by jiffies.
> Otherwise just use for loop which surely ends.

So far never fails. But OK I will set an upper limit.

>> +/**** Common ****/
>> +struct dvb_frontend *tc90522_attach(struct i2c_adapter *i2c, u8 idx,
>> fe_delivery_system_t type, u8 addr_demod)
>> +{
>> +       struct dvb_frontend *fe;
>> +       struct tc90522 *demod = kzalloc(sizeof(struct tc90522),
>> GFP_KERNEL);
>> +       if (!demod)
>> +               return NULL;
>> +
>> +       demod->i2c      = i2c;
>> +       demod->idx      = idx;
>
> Driver should not need index at all. It could be found from the frontend
> pointer after registration, but still not needed.

If you read the source thoroughly, you will find that idx is used only
for debugging.
We can remove if it is prohibited.

>> +       demod->type     = type;
>> +       demod->addr_demod = addr_demod;
>> +       fe = &demod->fe;
>> +       memcpy(&fe->ops, (demod->type == SYS_ISDBS) ? &tc90522_ops_s :
>> &tc90522_ops_t, sizeof(struct dvb_frontend_ops));
>> +       fe->demodulator_priv = demod;
>> +       return fe;
>> +}
>
> There is some issues as T and S mode driver instances registered to same
> chip. What happens if you are wathing T and try tune S at same time?
> (probably T breaks). I am not still sure if it is something that should be
> fixed.

Nothing wrong. The chip can handle all 2ch T + 2ch S simultaneously.
