Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f44.google.com ([209.85.212.44]:55071 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab2LRVkr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Dec 2012 16:40:47 -0500
Received: by mail-vb0-f44.google.com with SMTP id fc26so1545729vbb.3
        for <linux-media@vger.kernel.org>; Tue, 18 Dec 2012 13:40:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <505F38E7.2030809@iki.fi>
References: <7663201.PVTXFeZIJ8@jar7.dominio> <5054BEA2.5090601@iki.fi> <505F38E7.2030809@iki.fi>
From: Eddi De Pieri <eddi@depieri.net>
Date: Tue, 18 Dec 2012 22:32:33 +0100
Message-ID: <CAKdnbx4FYhF+m1PF1qqahFvu8dp=3KD0Kt_L+xr9j++D=2o3AQ@mail.gmail.com>
Subject: Re: [PATCH] v3 Add support to Avermedia Twinstar double tuner in af9035
To: Antti Palosaari <crope@iki.fi>
Cc: Jose Alberto Reguero <jareguero@telefonica.net>,
	linux-media@vger.kernel.org, Michael Krufky <mkrufky@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti and Jose

I'd like to advise you that I tested this path since it solve issue on
other af9035 devices like avermedia a835 and avermedia a867.

I mean:
mxl5007t_soft_reset: 522: failed!
mxl5007t_tuner_init: error -140 on line 535
mxl5007t_set_params: error -140 on line 666
mxl5007t_soft_reset: 522: failed!
mxl5007t_tuner_init: error -140 on line 535
mxl5007t_set_params: error -140 on line 666
mxl5007t_soft_reset: 522: failed!
mxl5007t_tuner_init: error -140 on line 535
mxl5007t_set_params: error -140 on line 666
mxl5007t_soft_reset: 522: failed!
mxl5007t_tuner_init: error -140 on line 535
mxl5007t_set_params: error -140 on line 666

It seems that no_reset and no_probe configuration parameter added by
jose is needed for mxl5007t initialization.

I suppose that the initialization is already done by the af9035 firmware.

Regards

Eddi De Pieri

On Sun, Sep 23, 2012 at 6:29 PM, Antti Palosaari <crope@iki.fi> wrote:
> Hello Jose,
> Could you try to split and resent?
>
> I will get af9035 + fc0012 dual tuner next week and add support for it. I
> wish to use your patch for dual mode, but I as there is that unresolved
> MXL5007t dependency I cannot user it currently.
>
> regards
> Antti
>
> On 09/15/2012 08:45 PM, Antti Palosaari wrote:
>>
>> Hello
>> Could you split that patch to 2?
>> 1) mxl5007t changes
>> 2) af9035/af9033 dual mode
>> 3) af9035/af9033 changes needed for mxl5007t
>>
>> I cannot say much about tuner changes, but I still wonder are those
>> really needed as this device is already supported. Is it broken currently?
>> What happens when no_probe = 0 ?
>> What happens when no_reset = 0 ?
>>
>> Soft reset means usually resetting chip state machine. It is something
>> like "start operating" command. First program registers then issue soft
>> reset in order to restart state machine.
>>
>> regards
>> Antti
>>
>>
>> On 08/30/2012 02:02 AM, Jose Alberto Reguero wrote:
>>>
>>> This patch add support to the Avermedia Twinstar double tuner in the
>>> af9035
>>> driver. Version 3 of the patch.
>>>
>>> Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>
>>>
>>> Jose Alberto
>>>
>>> diff -upr linux/drivers/media/dvb-frontends/af9033.c
>>> linux.new/drivers/media/dvb-frontends/af9033.c
>>> --- linux/drivers/media/dvb-frontends/af9033.c    2012-08-14
>>> 05:45:22.000000000 +0200
>>> +++ linux.new/drivers/media/dvb-frontends/af9033.c    2012-08-29
>>> 16:00:52.020523899 +0200
>>> @@ -326,6 +326,18 @@ static int af9033_init(struct dvb_fronte
>>>               goto err;
>>>       }
>>>
>>> +    if (state->cfg.ts_mode == AF9033_TS_MODE_SERIAL) {
>>> +        ret = af9033_wr_reg_mask(state, 0x00d91c, 0x01, 0x01);
>>> +        if (ret < 0)
>>> +            goto err;
>>> +        ret = af9033_wr_reg_mask(state, 0x00d917, 0x00, 0x01);
>>> +        if (ret < 0)
>>> +            goto err;
>>> +        ret = af9033_wr_reg_mask(state, 0x00d916, 0x00, 0x01);
>>> +        if (ret < 0)
>>> +            goto err;
>>> +    }
>>> +
>>>       state->bandwidth_hz = 0; /* force to program all parameters */
>>>
>>>       return 0;
>>> diff -upr linux/drivers/media/tuners/mxl5007t.c
>>> linux.new/drivers/media/tuners/mxl5007t.c
>>> --- linux/drivers/media/tuners/mxl5007t.c    2012-08-14
>>> 05:45:22.000000000 +0200
>>> +++ linux.new/drivers/media/tuners/mxl5007t.c    2012-08-29
>>> 13:07:57.299884405 +0200
>>> @@ -374,7 +374,6 @@ static struct reg_pair_t *mxl5007t_calc_
>>>       mxl5007t_set_if_freq_bits(state, cfg->if_freq_hz, cfg->invert_if);
>>>       mxl5007t_set_xtal_freq_bits(state, cfg->xtal_freq_hz);
>>>
>>> -    set_reg_bits(state->tab_init, 0x04, 0x01, cfg->loop_thru_enable);
>>>       set_reg_bits(state->tab_init, 0x03, 0x08, cfg->clk_out_enable <<
>>> 3);
>>>       set_reg_bits(state->tab_init, 0x03, 0x07, cfg->clk_out_amp);
>>>
>>> @@ -531,9 +530,11 @@ static int mxl5007t_tuner_init(struct mx
>>>       struct reg_pair_t *init_regs;
>>>       int ret;
>>>
>>> -    ret = mxl5007t_soft_reset(state);
>>> -    if (mxl_fail(ret))
>>> -        goto fail;
>>> +    if (!state->config->no_reset) {
>>> +        ret = mxl5007t_soft_reset(state);
>>> +        if (mxl_fail(ret))
>>> +            goto fail;
>>> +    }
>>>
>>>       /* calculate initialization reg array */
>>>       init_regs = mxl5007t_calc_init_regs(state, mode);
>>> @@ -887,7 +888,11 @@ struct dvb_frontend *mxl5007t_attach(str
>>>           if (fe->ops.i2c_gate_ctrl)
>>>               fe->ops.i2c_gate_ctrl(fe, 1);
>>>
>>> -        ret = mxl5007t_get_chip_id(state);
>>> +        if (!state->config->no_probe)
>>> +            ret = mxl5007t_get_chip_id(state);
>>> +
>>> +        ret = mxl5007t_write_reg(state, 0x04,
>>> +            state->config->loop_thru_enable);
>>>
>>>           if (fe->ops.i2c_gate_ctrl)
>>>               fe->ops.i2c_gate_ctrl(fe, 0);
>>> diff -upr linux/drivers/media/tuners/mxl5007t.h
>>> linux.new/drivers/media/tuners/mxl5007t.h
>>> --- linux/drivers/media/tuners/mxl5007t.h    2012-08-14
>>> 05:45:22.000000000 +0200
>>> +++ linux.new/drivers/media/tuners/mxl5007t.h    2012-08-25
>>> 19:38:19.990920623 +0200
>>> @@ -73,8 +73,10 @@ struct mxl5007t_config {
>>>       enum mxl5007t_xtal_freq xtal_freq_hz;
>>>       enum mxl5007t_if_freq if_freq_hz;
>>>       unsigned int invert_if:1;
>>> -    unsigned int loop_thru_enable:1;
>>> +    unsigned int loop_thru_enable:2;
>>>       unsigned int clk_out_enable:1;
>>> +    unsigned int no_probe:1;
>>> +    unsigned int no_reset:1;
>>>   };
>>>
>>>   #if defined(CONFIG_MEDIA_TUNER_MXL5007T) ||
>>> (defined(CONFIG_MEDIA_TUNER_MXL5007T_MODULE) && defined(MODULE))
>>> diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.c
>>> linux.new/drivers/media/usb/dvb-usb-v2/af9035.c
>>> --- linux/drivers/media/usb/dvb-usb-v2/af9035.c    2012-08-16
>>> 05:45:24.000000000 +0200
>>> +++ linux.new/drivers/media/usb/dvb-usb-v2/af9035.c    2012-08-29
>>> 19:20:00.862523903 +0200
>>> @@ -209,10 +209,14 @@ static int af9035_i2c_master_xfer(struct
>>>           if (msg[0].len > 40 || msg[1].len > 40) {
>>>               /* TODO: correct limits > 40 */
>>>               ret = -EOPNOTSUPP;
>>> -        } else if (msg[0].addr == state->af9033_config[0].i2c_addr) {
>>> +        } else if ((msg[0].addr == state->af9033_config[0].i2c_addr) ||
>>> +               (msg[0].addr == state->af9033_config[1].i2c_addr)) {
>>>               /* integrated demod */
>>>               u32 reg = msg[0].buf[0] << 16 | msg[0].buf[1] << 8 |
>>>                       msg[0].buf[2];
>>> +            if (state->af9033_config[1].i2c_addr &&
>>> +               (msg[0].addr == state->af9033_config[1].i2c_addr))
>>> +                reg |= 0x100000;
>>>               ret = af9035_rd_regs(d, reg, &msg[1].buf[0],
>>>                       msg[1].len);
>>>           } else {
>>> @@ -220,8 +224,9 @@ static int af9035_i2c_master_xfer(struct
>>>               u8 buf[5 + msg[0].len];
>>>               struct usb_req req = { CMD_I2C_RD, 0, sizeof(buf),
>>>                       buf, msg[1].len, msg[1].buf };
>>> +            req.mbox |= ((msg[0].addr & 0x80)  >>  3);
>>>               buf[0] = msg[1].len;
>>> -            buf[1] = msg[0].addr << 1;
>>> +            buf[1] = (u8)(msg[0].addr << 1);
>>>               buf[2] = 0x00; /* reg addr len */
>>>               buf[3] = 0x00; /* reg addr MSB */
>>>               buf[4] = 0x00; /* reg addr LSB */
>>> @@ -232,10 +237,14 @@ static int af9035_i2c_master_xfer(struct
>>>           if (msg[0].len > 40) {
>>>               /* TODO: correct limits > 40 */
>>>               ret = -EOPNOTSUPP;
>>> -        } else if (msg[0].addr == state->af9033_config[0].i2c_addr) {
>>> +        } else if ((msg[0].addr == state->af9033_config[0].i2c_addr) ||
>>> +               (msg[0].addr == state->af9033_config[1].i2c_addr)) {
>>>               /* integrated demod */
>>>               u32 reg = msg[0].buf[0] << 16 | msg[0].buf[1] << 8 |
>>>                       msg[0].buf[2];
>>> +            if (state->af9033_config[1].i2c_addr &&
>>> +               (msg[0].addr == state->af9033_config[1].i2c_addr))
>>> +                reg |= 0x100000;
>>>               ret = af9035_wr_regs(d, reg, &msg[0].buf[3],
>>>                       msg[0].len - 3);
>>>           } else {
>>> @@ -243,8 +252,9 @@ static int af9035_i2c_master_xfer(struct
>>>               u8 buf[5 + msg[0].len];
>>>               struct usb_req req = { CMD_I2C_WR, 0, sizeof(buf), buf,
>>>                       0, NULL };
>>> +            req.mbox |= ((msg[0].addr & 0x80)  >>  3);
>>>               buf[0] = msg[0].len;
>>> -            buf[1] = msg[0].addr << 1;
>>> +            buf[1] = (u8)(msg[0].addr << 1);
>>>               buf[2] = 0x00; /* reg addr len */
>>>               buf[3] = 0x00; /* reg addr MSB */
>>>               buf[4] = 0x00; /* reg addr LSB */
>>> @@ -283,9 +293,30 @@ static int af9035_identify_state(struct
>>>       int ret;
>>>       u8 wbuf[1] = { 1 };
>>>       u8 rbuf[4];
>>> +    u8 tmp;
>>>       struct usb_req req = { CMD_FW_QUERYINFO, 0, sizeof(wbuf), wbuf,
>>>               sizeof(rbuf), rbuf };
>>>
>>> +    /* check if there is dual tuners */
>>> +    ret = af9035_rd_reg(d, EEPROM_DUAL_MODE, &tmp);
>>> +    if (ret < 0)
>>> +        goto err;
>>> +
>>> +    if (tmp) {
>>> +        /* read 2nd demodulator I2C address */
>>> +        ret = af9035_rd_reg(d, EEPROM_2WIREADDR, &tmp);
>>> +        if (ret < 0)
>>> +            goto err;
>>> +
>>> +        ret = af9035_wr_reg(d, 0x00417f, tmp);
>>> +        if (ret < 0)
>>> +            goto err;
>>> +
>>> +        ret = af9035_wr_reg(d, 0x00d81a, 1);
>>> +        if (ret < 0)
>>> +            goto err;
>>> +    }
>>> +
>>>       ret = af9035_ctrl_msg(d, &req);
>>>       if (ret < 0)
>>>           goto err;
>>> @@ -492,7 +523,14 @@ static int af9035_read_config(struct dvb
>>>
>>>       state->dual_mode = tmp;
>>>       pr_debug("%s: dual mode=%d\n", __func__, state->dual_mode);
>>> -
>>> +    if (state->dual_mode) {
>>> +        /* read 2nd demodulator I2C address */
>>> +        ret = af9035_rd_reg(d, EEPROM_2WIREADDR, &tmp);
>>> +        if (ret < 0)
>>> +            goto err;
>>> +        state->af9033_config[1].i2c_addr = tmp;
>>> +        pr_debug("%s: 2nd demod I2C addr:%02x\n", __func__, tmp);
>>> +    }
>>>       for (i = 0; i < state->dual_mode + 1; i++) {
>>>           /* tuner */
>>>           ret = af9035_rd_reg(d, EEPROM_1_TUNER_ID + eeprom_shift, &tmp);
>>> @@ -671,6 +709,12 @@ static int af9035_frontend_callback(void
>>>       return -EINVAL;
>>>   }
>>>
>>> +static int af9035_get_adapter_count(struct dvb_usb_device *d)
>>> +{
>>> +    struct state *state = d_to_priv(d);
>>> +    return state->dual_mode + 1;
>>> +}
>>> +
>>>   static int af9035_frontend_attach(struct dvb_usb_adapter *adap)
>>>   {
>>>       struct state *state = adap_to_priv(adap);
>>> @@ -726,13 +770,26 @@ static const struct fc0011_config af9035
>>>       .i2c_address = 0x60,
>>>   };
>>>
>>> -static struct mxl5007t_config af9035_mxl5007t_config = {
>>> -    .xtal_freq_hz = MxL_XTAL_24_MHZ,
>>> -    .if_freq_hz = MxL_IF_4_57_MHZ,
>>> -    .invert_if = 0,
>>> -    .loop_thru_enable = 0,
>>> -    .clk_out_enable = 0,
>>> -    .clk_out_amp = MxL_CLKOUT_AMP_0_94V,
>>> +static struct mxl5007t_config af9035_mxl5007t_config[] = {
>>> +    {
>>> +        .xtal_freq_hz = MxL_XTAL_24_MHZ,
>>> +        .if_freq_hz = MxL_IF_4_57_MHZ,
>>> +        .invert_if = 0,
>>> +        .loop_thru_enable = 0,
>>> +        .clk_out_enable = 0,
>>> +        .clk_out_amp = MxL_CLKOUT_AMP_0_94V,
>>> +        .no_probe = 1,
>>> +        .no_reset = 1,
>>> +    }, {
>>> +        .xtal_freq_hz = MxL_XTAL_24_MHZ,
>>> +        .if_freq_hz = MxL_IF_4_57_MHZ,
>>> +        .invert_if = 0,
>>> +        .loop_thru_enable = 3,
>>> +        .clk_out_enable = 1,
>>> +        .clk_out_amp = MxL_CLKOUT_AMP_0_94V,
>>> +        .no_probe = 1,
>>> +        .no_reset = 1,
>>> +    }
>>>   };
>>>
>>>   static struct tda18218_config af9035_tda18218_config = {
>>> @@ -795,46 +852,52 @@ static int af9035_tuner_attach(struct dv
>>>                   &d->i2c_adap, &af9035_fc0011_config);
>>>           break;
>>>       case AF9033_TUNER_MXL5007T:
>>> -        ret = af9035_wr_reg(d, 0x00d8e0, 1);
>>> -        if (ret < 0)
>>> -            goto err;
>>> -        ret = af9035_wr_reg(d, 0x00d8e1, 1);
>>> -        if (ret < 0)
>>> -            goto err;
>>> -        ret = af9035_wr_reg(d, 0x00d8df, 0);
>>> -        if (ret < 0)
>>> -            goto err;
>>> +        state->tuner_address[adap->id] = 0x60;
>>> +        /* hack, use b[7] to carry used I2C-bus */
>>> +        state->tuner_address[adap->id] |= (adap->id << 7);
>>> +        if (adap->id == 0) {
>>> +            ret = af9035_wr_reg(d, 0x00d8e0, 1);
>>> +            if (ret < 0)
>>> +                goto err;
>>> +            ret = af9035_wr_reg(d, 0x00d8e1, 1);
>>> +            if (ret < 0)
>>> +                goto err;
>>> +            ret = af9035_wr_reg(d, 0x00d8df, 0);
>>> +            if (ret < 0)
>>> +                goto err;
>>>
>>> -        msleep(30);
>>> +            msleep(30);
>>>
>>> -        ret = af9035_wr_reg(d, 0x00d8df, 1);
>>> -        if (ret < 0)
>>> -            goto err;
>>> +            ret = af9035_wr_reg(d, 0x00d8df, 1);
>>> +            if (ret < 0)
>>> +                goto err;
>>>
>>> -        msleep(300);
>>> +            msleep(300);
>>>
>>> -        ret = af9035_wr_reg(d, 0x00d8c0, 1);
>>> -        if (ret < 0)
>>> -            goto err;
>>> -        ret = af9035_wr_reg(d, 0x00d8c1, 1);
>>> -        if (ret < 0)
>>> -            goto err;
>>> -        ret = af9035_wr_reg(d, 0x00d8bf, 0);
>>> -        if (ret < 0)
>>> -            goto err;
>>> -        ret = af9035_wr_reg(d, 0x00d8b4, 1);
>>> -        if (ret < 0)
>>> -            goto err;
>>> -        ret = af9035_wr_reg(d, 0x00d8b5, 1);
>>> -        if (ret < 0)
>>> -            goto err;
>>> -        ret = af9035_wr_reg(d, 0x00d8b3, 1);
>>> -        if (ret < 0)
>>> -            goto err;
>>> +            ret = af9035_wr_reg(d, 0x00d8c0, 1);
>>> +            if (ret < 0)
>>> +                goto err;
>>> +            ret = af9035_wr_reg(d, 0x00d8c1, 1);
>>> +            if (ret < 0)
>>> +                goto err;
>>> +            ret = af9035_wr_reg(d, 0x00d8bf, 0);
>>> +            if (ret < 0)
>>> +                goto err;
>>> +            ret = af9035_wr_reg(d, 0x00d8b4, 1);
>>> +            if (ret < 0)
>>> +                goto err;
>>> +            ret = af9035_wr_reg(d, 0x00d8b5, 1);
>>> +            if (ret < 0)
>>> +                goto err;
>>> +            ret = af9035_wr_reg(d, 0x00d8b3, 1);
>>> +            if (ret < 0)
>>> +                goto err;
>>> +        }
>>>
>>>           /* attach tuner */
>>>           fe = dvb_attach(mxl5007t_attach, adap->fe[0],
>>> -                &d->i2c_adap, 0x60, &af9035_mxl5007t_config);
>>> +                &d->i2c_adap, state->tuner_address[adap->id],
>>> +                &af9035_mxl5007t_config[adap->id]);
>>>           break;
>>>       case AF9033_TUNER_TDA18218:
>>>           /* attach tuner */
>>> @@ -879,8 +942,8 @@ static int af9035_init(struct dvb_usb_de
>>>           { 0x00dd8a, (frame_size >> 0) & 0xff, 0xff},
>>>           { 0x00dd8b, (frame_size >> 8) & 0xff, 0xff},
>>>           { 0x00dd0d, packet_size, 0xff },
>>> -        { 0x80f9a3, 0x00, 0x01 },
>>> -        { 0x80f9cd, 0x00, 0x01 },
>>> +        { 0x80f9a3, state->dual_mode, 0x01 },
>>> +        { 0x80f9cd, state->dual_mode, 0x01 },
>>>           { 0x80f99d, 0x00, 0x01 },
>>>           { 0x80f9a4, 0x00, 0x01 },
>>>       };
>>> @@ -1001,7 +1064,7 @@ static const struct dvb_usb_device_prope
>>>       .init = af9035_init,
>>>       .get_rc_config = af9035_get_rc_config,
>>>
>>> -    .num_adapters = 1,
>>> +    .get_adapter_count = af9035_get_adapter_count,
>>>       .adapter = {
>>>           {
>>>               .stream = DVB_USB_STREAM_BULK(0x84, 6, 87 * 188),
>>> diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.h
>>> linux.new/drivers/media/usb/dvb-usb-v2/af9035.h
>>> --- linux/drivers/media/usb/dvb-usb-v2/af9035.h    2012-08-14
>>> 05:45:22.000000000 +0200
>>> +++ linux.new/drivers/media/usb/dvb-usb-v2/af9035.h    2012-08-29
>>> 12:31:28.630973960 +0200
>>> @@ -54,6 +54,8 @@ struct state {
>>>       bool dual_mode;
>>>
>>>       struct af9033_config af9033_config[2];
>>> +
>>> +    u8 tuner_address[2];
>>>   };
>>>
>>>   u32 clock_lut[] = {
>>> @@ -87,6 +89,7 @@ u32 clock_lut_it9135[] = {
>>>   /* EEPROM locations */
>>>   #define EEPROM_IR_MODE            0x430d
>>>   #define EEPROM_DUAL_MODE          0x4326
>>> +#define EEPROM_2WIREADDR          0x4327
>>>   #define EEPROM_IR_TYPE            0x4329
>>>   #define EEPROM_1_IFFREQ_L         0x432d
>>>   #define EEPROM_1_IFFREQ_H         0x432e
>>>
>>>
>>
>>
>
>
> --
> http://palosaari.fi/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
