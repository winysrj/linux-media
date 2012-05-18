Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53137 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967112Ab2ERJP3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 May 2012 05:15:29 -0400
Received: by bkcji2 with SMTP id ji2so2173025bkc.19
        for <linux-media@vger.kernel.org>; Fri, 18 May 2012 02:15:27 -0700 (PDT)
Message-ID: <4FB61328.3090707@gmail.com>
Date: Fri, 18 May 2012 11:15:20 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Thomas Mair <thomas.mair86@googlemail.com>
CC: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH v4 1/5] rtl2832 ver. 0.4: removed signal statistics
References: <1337206420-23810-1-git-send-email-thomas.mair86@googlemail.com> <1337206420-23810-2-git-send-email-thomas.mair86@googlemail.com> <4FB50909.7030101@iki.fi> <4FB59E03.7080800@gmail.com> <CAKZ=SG_mvvFae9ZE2H3ci_3HosLmQ1kihyGx6QCdyQGgQro52Q@mail.gmail.com>
In-Reply-To: <CAKZ=SG_mvvFae9ZE2H3ci_3HosLmQ1kihyGx6QCdyQGgQro52Q@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060709080306030803070501"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060709080306030803070501
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit

On 05/18/2012 08:20 AM, Thomas Mair wrote:
> Am 18.05.2012 02:55 schrieb "poma" <pomidorabelisima@gmail.com>:
>>
>> On 05/17/2012 04:19 PM, Antti Palosaari wrote:
>>> Moikka Thomas,
>>>
>>> Here is the review. See comments below.
>>>
>>> And conclusion is that it is ready for the Kernel merge. I did not see
>>> any big functiuonality problems - only some small issues that are likely
>>> considered as a coding style etc. Feel free to fix those and sent new
>>> patc serie or just new patch top of that.
>>>
>>> Reviewed-by: Antti Palosaari <crope@iki.fi>
>>>
>>>
>>> On 17.05.2012 01:13, Thomas Mair wrote:
>>>> Changelog for ver. 0.3:
>>>> - removed statistics as their calculation was wrong
>>>> - fixed bug in Makefile
>>>> - indentation and code style improvements
>>>>
>>>> Signed-off-by: Thomas Mair<thomas.mair86@googlemail.com>
>>>> ---
>>>>   drivers/media/dvb/frontends/Kconfig        |    7 +
>>>>   drivers/media/dvb/frontends/Makefile       |    1 +
>>>>   drivers/media/dvb/frontends/rtl2832.c      |  825
>>>> ++++++++++++++++++++++++++++
>>>>   drivers/media/dvb/frontends/rtl2832.h      |   74 +++
>>>>   drivers/media/dvb/frontends/rtl2832_priv.h |  258 +++++++++
>>>>   5 files changed, 1165 insertions(+), 0 deletions(-)
>>>>   create mode 100644 drivers/media/dvb/frontends/rtl2832.c
>>>>   create mode 100644 drivers/media/dvb/frontends/rtl2832.h
>>>>   create mode 100644 drivers/media/dvb/frontends/rtl2832_priv.h
>>>>
>>>> diff --git a/drivers/media/dvb/frontends/Kconfig
>>>> b/drivers/media/dvb/frontends/Kconfig
>>>> index f479834..f7d67d7 100644
>>>> --- a/drivers/media/dvb/frontends/Kconfig
>>>> +++ b/drivers/media/dvb/frontends/Kconfig
>>>> @@ -432,6 +432,13 @@ config DVB_RTL2830
>>>>       help
>>>>         Say Y when you want to support this frontend.
>>>>
>>>> +config DVB_RTL2832
>>>> +    tristate "Realtek RTL2832 DVB-T"
>>>> +    depends on DVB_CORE&&  I2C
>>>> +    default m if DVB_FE_CUSTOMISE
>>>> +    help
>>>> +      Say Y when you want to support this frontend.
>>>> +
>>>
>>> It is correct.
>>>
>>> Just for the comment as you said in cover letter that you are unsure
>>> about that.
>>>
>>>>   comment "DVB-C (cable) frontends"
>>>>       depends on DVB_CORE
>>>>
>>>> diff --git a/drivers/media/dvb/frontends/Makefile
>>>> b/drivers/media/dvb/frontends/Makefile
>>>> index b0381dc..bbf2955 100644
>>>> --- a/drivers/media/dvb/frontends/Makefile
>>>> +++ b/drivers/media/dvb/frontends/Makefile
>>>> @@ -98,6 +98,7 @@ obj-$(CONFIG_DVB_IT913X_FE) += it913x-fe.o
>>>>   obj-$(CONFIG_DVB_A8293) += a8293.o
>>>>   obj-$(CONFIG_DVB_TDA10071) += tda10071.o
>>>>   obj-$(CONFIG_DVB_RTL2830) += rtl2830.o
>>>> +obj-$(CONFIG_DVB_RTL2830) += rtl2832.o
>>>>   obj-$(CONFIG_DVB_M88RS2000) += m88rs2000.o
>>>>   obj-$(CONFIG_DVB_AF9033) += af9033.o
>>>>
>>>> diff --git a/drivers/media/dvb/frontends/rtl2832.c
>>>> b/drivers/media/dvb/frontends/rtl2832.c
>>>> new file mode 100644
>>>> index 0000000..51c7927
>>>> --- /dev/null
>>>> +++ b/drivers/media/dvb/frontends/rtl2832.c
>>>> @@ -0,0 +1,825 @@
>>>> +/*
>>>> + * Realtek RTL2832 DVB-T demodulator driver
>>>> + *
>>>> + * Copyright (C) 2012 Thomas Mair<thomas.mair86@gmail.com>
>>>> + *
>>>> + *    This program is free software; you can redistribute it and/or
>>>> modify
>>>> + *    it under the terms of the GNU General Public License as
>>>> published by
>>>> + *    the Free Software Foundation; either version 2 of the License,
> or
>>>> + *    (at your option) any later version.
>>>> + *
>>>> + *    This program is distributed in the hope that it will be useful,
>>>> + *    but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>> + *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>> + *    GNU General Public License for more details.
>>>> + *
>>>> + *    You should have received a copy of the GNU General Public
>>>> License along
>>>> + *    with this program; if not, write to the Free Software
>>>> Foundation, Inc.,
>>>> + *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
>>>> + */
>>>> +
>>>> +#include "rtl2832_priv.h"
>>>> +
>>>> +
>>>> +int rtl2832_debug;
>>>> +module_param_named(debug, rtl2832_debug, int, 0644);
>>>> +MODULE_PARM_DESC(debug, "Turn on/off frontend debugging
>>>> (default:off).");
>>>> +
>>>> +
>>>> +static int reg_mask[32] = {
>>>
>>> This should be static const.
>>>
>>>> +    0x00000001,
>>>> +    0x00000003,
>>>> +    0x00000007,
>>>> +    0x0000000f,
>>>> +    0x0000001f,
>>>> +    0x0000003f,
>>>> +    0x0000007f,
>>>> +    0x000000ff,
>>>> +    0x000001ff,
>>>> +    0x000003ff,
>>>> +    0x000007ff,
>>>> +    0x00000fff,
>>>> +    0x00001fff,
>>>> +    0x00003fff,
>>>> +    0x00007fff,
>>>> +    0x0000ffff,
>>>> +    0x0001ffff,
>>>> +    0x0003ffff,
>>>> +    0x0007ffff,
>>>> +    0x000fffff,
>>>> +    0x001fffff,
>>>> +    0x003fffff,
>>>> +    0x007fffff,
>>>> +    0x00ffffff,
>>>> +    0x01ffffff,
>>>> +    0x03ffffff,
>>>> +    0x07ffffff,
>>>> +    0x0fffffff,
>>>> +    0x1fffffff,
>>>> +    0x3fffffff,
>>>> +    0x7fffffff,
>>>> +    0xffffffff
>>>> +};
>>>> +
>>>> +struct rtl2832_reg_entry registers[] = {
>>>
>>> static const struct
>>>
>>>> +    [DVBT_SOFT_RST]        = {0x1, 0x1,   2, 2},
>>>> +    [DVBT_IIC_REPEAT]    = {0x1, 0x1,   3, 3},
>>>> +    [DVBT_TR_WAIT_MIN_8K]    = {0x1, 0x88, 11, 2},
>>>> +    [DVBT_RSD_BER_FAIL_VAL]    = {0x1, 0x8f, 15, 0},
>>>> +    [DVBT_EN_BK_TRK]    = {0x1, 0xa6,  7, 7},
>>>> +    [DVBT_AD_EN_REG]    = {0x0, 0x8,   7, 7},
>>>> +    [DVBT_AD_EN_REG1]    = {0x0, 0x8,   6, 6},
>>>> +    [DVBT_EN_BBIN]        = {0x1, 0xb1,  0, 0},
>>>> +    [DVBT_MGD_THD0]        = {0x1, 0x95,  7, 0},
>>>> +    [DVBT_MGD_THD1]        = {0x1, 0x96,  7, 0},
>>>> +    [DVBT_MGD_THD2]        = {0x1, 0x97,  7, 0},
>>>> +    [DVBT_MGD_THD3]        = {0x1, 0x98,  7, 0},
>>>> +    [DVBT_MGD_THD4]        = {0x1, 0x99,  7, 0},
>>>> +    [DVBT_MGD_THD5]        = {0x1, 0x9a,  7, 0},
>>>> +    [DVBT_MGD_THD6]        = {0x1, 0x9b,  7, 0},
>>>> +    [DVBT_MGD_THD7]        = {0x1, 0x9c,  7, 0},
>>>> +    [DVBT_EN_CACQ_NOTCH]    = {0x1, 0x61,  4, 4},
>>>> +    [DVBT_AD_AV_REF]    = {0x0, 0x9,   6, 0},
>>>> +    [DVBT_REG_PI]        = {0x0, 0xa,   2, 0},
>>>> +    [DVBT_PIP_ON]        = {0x0, 0x21,  3, 3},
>>>> +    [DVBT_SCALE1_B92]    = {0x2, 0x92,  7, 0},
>>>> +    [DVBT_SCALE1_B93]    = {0x2, 0x93,  7, 0},
>>>> +    [DVBT_SCALE1_BA7]    = {0x2, 0xa7,  7, 0},
>>>> +    [DVBT_SCALE1_BA9]    = {0x2, 0xa9,  7, 0},
>>>> +    [DVBT_SCALE1_BAA]    = {0x2, 0xaa,  7, 0},
>>>> +    [DVBT_SCALE1_BAB]    = {0x2, 0xab,  7, 0},
>>>> +    [DVBT_SCALE1_BAC]    = {0x2, 0xac,  7, 0},
>>>> +    [DVBT_SCALE1_BB0]    = {0x2, 0xb0,  7, 0},
>>>> +    [DVBT_SCALE1_BB1]    = {0x2, 0xb1,  7, 0},
>>>> +    [DVBT_KB_P1]        = {0x1, 0x64,  3, 1},
>>>> +    [DVBT_KB_P2]        = {0x1, 0x64,  6, 4},
>>>> +    [DVBT_KB_P3]        = {0x1, 0x65,  2, 0},
>>>> +    [DVBT_OPT_ADC_IQ]    = {0x0, 0x6,   5, 4},
>>>> +    [DVBT_AD_AVI]        = {0x0, 0x9,   1, 0},
>>>> +    [DVBT_AD_AVQ]        = {0x0, 0x9,   3, 2},
>>>> +    [DVBT_K1_CR_STEP12]    = {0x2, 0xad,  9, 4},
>>>> +    [DVBT_TRK_KS_P2]    = {0x1, 0x6f,  2, 0},
>>>> +    [DVBT_TRK_KS_I2]    = {0x1, 0x70,  5, 3},
>>>> +    [DVBT_TR_THD_SET2]    = {0x1, 0x72,  3, 0},
>>>> +    [DVBT_TRK_KC_P2]    = {0x1, 0x73,  5, 3},
>>>> +    [DVBT_TRK_KC_I2]    = {0x1, 0x75,  2, 0},
>>>> +    [DVBT_CR_THD_SET2]    = {0x1, 0x76,  7, 6},
>>>> +    [DVBT_PSET_IFFREQ]    = {0x1, 0x19, 21, 0},
>>>> +    [DVBT_SPEC_INV]        = {0x1, 0x15,  0, 0},
>>>> +    [DVBT_RSAMP_RATIO]    = {0x1, 0x9f, 27, 2},
>>>> +    [DVBT_CFREQ_OFF_RATIO]    = {0x1, 0x9d, 23, 4},
>>>> +    [DVBT_FSM_STAGE]    = {0x3, 0x51,  6, 3},
>>>> +    [DVBT_RX_CONSTEL]    = {0x3, 0x3c,  3, 2},
>>>> +    [DVBT_RX_HIER]        = {0x3, 0x3c,  6, 4},
>>>> +    [DVBT_RX_C_RATE_LP]    = {0x3, 0x3d,  2, 0},
>>>> +    [DVBT_RX_C_RATE_HP]    = {0x3, 0x3d,  5, 3},
>>>> +    [DVBT_GI_IDX]        = {0x3, 0x51,  1, 0},
>>>> +    [DVBT_FFT_MODE_IDX]    = {0x3, 0x51,  2, 2},
>>>> +    [DVBT_RSD_BER_EST]    = {0x3, 0x4e, 15, 0},
>>>> +    [DVBT_CE_EST_EVM]    = {0x4, 0xc,  15, 0},
>>>> +    [DVBT_RF_AGC_VAL]    = {0x3, 0x5b, 13, 0},
>>>> +    [DVBT_IF_AGC_VAL]    = {0x3, 0x59, 13, 0},
>>>> +    [DVBT_DAGC_VAL]        = {0x3, 0x5,   7, 0},
>>>> +    [DVBT_SFREQ_OFF]    = {0x3, 0x18, 13, 0},
>>>> +    [DVBT_CFREQ_OFF]    = {0x3, 0x5f, 17, 0},
>>>> +    [DVBT_POLAR_RF_AGC]    = {0x0, 0xe,   1, 1},
>>>> +    [DVBT_POLAR_IF_AGC]    = {0x0, 0xe,   0, 0},
>>>> +    [DVBT_AAGC_HOLD]    = {0x1, 0x4,   5, 5},
>>>> +    [DVBT_EN_RF_AGC]    = {0x1, 0x4,   6, 6},
>>>> +    [DVBT_EN_IF_AGC]    = {0x1, 0x4,   7, 7},
>>>> +    [DVBT_IF_AGC_MIN]    = {0x1, 0x8,   7, 0},
>>>> +    [DVBT_IF_AGC_MAX]    = {0x1, 0x9,   7, 0},
>>>> +    [DVBT_RF_AGC_MIN]    = {0x1, 0xa,   7, 0},
>>>> +    [DVBT_RF_AGC_MAX]    = {0x1, 0xb,   7, 0},
>>>> +    [DVBT_IF_AGC_MAN]    = {0x1, 0xc,   6, 6},
>>>> +    [DVBT_IF_AGC_MAN_VAL]    = {0x1, 0xc,  13, 0},
>>>> +    [DVBT_RF_AGC_MAN]    = {0x1, 0xe,   6, 6},
>>>> +    [DVBT_RF_AGC_MAN_VAL]    = {0x1, 0xe,  13, 0},
>>>> +    [DVBT_DAGC_TRG_VAL]    = {0x1, 0x12,  7, 0},
>>>> +    [DVBT_AGC_TARG_VAL_0]    = {0x1, 0x2,   0, 0},
>>>> +    [DVBT_AGC_TARG_VAL_8_1]    = {0x1, 0x3,   7, 0},
>>>> +    [DVBT_AAGC_LOOP_GAIN]    = {0x1, 0xc7,  5, 1},
>>>> +    [DVBT_LOOP_GAIN2_3_0]    = {0x1, 0x4,   4, 1},
>>>> +    [DVBT_LOOP_GAIN2_4]    = {0x1, 0x5,   7, 7},
>>>> +    [DVBT_LOOP_GAIN3]    = {0x1, 0xc8,  4, 0},
>>>> +    [DVBT_VTOP1]        = {0x1, 0x6,   5, 0},
>>>> +    [DVBT_VTOP2]        = {0x1, 0xc9,  5, 0},
>>>> +    [DVBT_VTOP3]        = {0x1, 0xca,  5, 0},
>>>> +    [DVBT_KRF1]        = {0x1, 0xcb,  7, 0},
>>>> +    [DVBT_KRF2]        = {0x1, 0x7,   7, 0},
>>>> +    [DVBT_KRF3]        = {0x1, 0xcd,  7, 0},
>>>> +    [DVBT_KRF4]        = {0x1, 0xce,  7, 0},
>>>> +    [DVBT_EN_GI_PGA]    = {0x1, 0xe5,  0, 0},
>>>> +    [DVBT_THD_LOCK_UP]    = {0x1, 0xd9,  8, 0},
>>>> +    [DVBT_THD_LOCK_DW]    = {0x1, 0xdb,  8, 0},
>>>> +    [DVBT_THD_UP1]        = {0x1, 0xdd,  7, 0},
>>>> +    [DVBT_THD_DW1]        = {0x1, 0xde,  7, 0},
>>>> +    [DVBT_INTER_CNT_LEN]    = {0x1, 0xd8,  3, 0},
>>>> +    [DVBT_GI_PGA_STATE]    = {0x1, 0xe6,  3, 3},
>>>> +    [DVBT_EN_AGC_PGA]    = {0x1, 0xd7,  0, 0},
>>>> +    [DVBT_CKOUTPAR]        = {0x1, 0x7b,  5, 5},
>>>> +    [DVBT_CKOUT_PWR]    = {0x1, 0x7b,  6, 6},
>>>> +    [DVBT_SYNC_DUR]        = {0x1, 0x7b,  7, 7},
>>>> +    [DVBT_ERR_DUR]        = {0x1, 0x7c,  0, 0},
>>>> +    [DVBT_SYNC_LVL]        = {0x1, 0x7c,  1, 1},
>>>> +    [DVBT_ERR_LVL]        = {0x1, 0x7c,  2, 2},
>>>> +    [DVBT_VAL_LVL]        = {0x1, 0x7c,  3, 3},
>>>> +    [DVBT_SERIAL]        = {0x1, 0x7c,  4, 4},
>>>> +    [DVBT_SER_LSB]        = {0x1, 0x7c,  5, 5},
>>>> +    [DVBT_CDIV_PH0]        = {0x1, 0x7d,  3, 0},
>>>> +    [DVBT_CDIV_PH1]        = {0x1, 0x7d,  7, 4},
>>>> +    [DVBT_MPEG_IO_OPT_2_2]    = {0x0, 0x6,   7, 7},
>>>> +    [DVBT_MPEG_IO_OPT_1_0]    = {0x0, 0x7,   7, 6},
>>>> +    [DVBT_CKOUTPAR_PIP]    = {0x0, 0xb7,  4, 4},
>>>> +    [DVBT_CKOUT_PWR_PIP]    = {0x0, 0xb7,  3, 3},
>>>> +    [DVBT_SYNC_LVL_PIP]    = {0x0, 0xb7,  2, 2},
>>>> +    [DVBT_ERR_LVL_PIP]    = {0x0, 0xb7,  1, 1},
>>>> +    [DVBT_VAL_LVL_PIP]    = {0x0, 0xb7,  0, 0},
>>>> +    [DVBT_CKOUTPAR_PID]    = {0x0, 0xb9,  4, 4},
>>>> +    [DVBT_CKOUT_PWR_PID]    = {0x0, 0xb9,  3, 3},
>>>> +    [DVBT_SYNC_LVL_PID]    = {0x0, 0xb9,  2, 2},
>>>> +    [DVBT_ERR_LVL_PID]    = {0x0, 0xb9,  1, 1},
>>>> +    [DVBT_VAL_LVL_PID]    = {0x0, 0xb9,  0, 0},
>>>> +    [DVBT_SM_PASS]        = {0x1, 0x93, 11, 0},
>>>> +    [DVBT_AD7_SETTING]    = {0x0, 0x11, 15, 0},
>>>> +    [DVBT_RSSI_R]        = {0x3, 0x1,   6, 0},
>>>> +    [DVBT_ACI_DET_IND]    = {0x3, 0x12,  0, 0},
>>>> +    [DVBT_REG_MON]        = {0x0, 0xd,   1, 0},
>>>> +    [DVBT_REG_MONSEL]    = {0x0, 0xd,   2, 2},
>>>> +    [DVBT_REG_GPE]        = {0x0, 0xd,   7, 7},
>>>> +    [DVBT_REG_GPO]        = {0x0, 0x10,  0, 0},
>>>> +    [DVBT_REG_4MSEL]    = {0x0, 0x13,  0, 0},
>>>> +};
>>>> +
>>>> +/* write multiple hardware registers */
>>>> +static int rtl2832_wr(struct rtl2832_priv *priv, u8 reg, u8 *val, int
>>>> len)
>>>> +{
>>>> +    int ret;
>>>> +    u8 buf[1+len];
>>>> +    struct i2c_msg msg[1] = {
>>>> +        {
>>>> +            .addr = priv->cfg.i2c_addr,
>>>> +            .flags = 0,
>>>> +            .len = 1+len,
>>>> +            .buf = buf,
>>>> +        }
>>>> +    };
>>>> +
>>>> +    buf[0] = reg;
>>>> +    memcpy(&buf[1], val, len);
>>>> +
>>>> +    ret = i2c_transfer(priv->i2c, msg, 1);
>>>> +    if (ret == 1) {
>>>> +        ret = 0;
>>>> +    } else {
>>>> +        warn("i2c wr failed=%d reg=%02x len=%d", ret, reg, len);
>>>> +        ret = -EREMOTEIO;
>>>> +    }
>>>> +    return ret;
>>>> +}
>>>> +
>>>> +/* read multiple hardware registers */
>>>> +static int rtl2832_rd(struct rtl2832_priv *priv, u8 reg, u8 *val, int
>>>> len)
>>>> +{
>>>> +    int ret;
>>>> +    struct i2c_msg msg[2] = {
>>>> +        {
>>>> +            .addr = priv->cfg.i2c_addr,
>>>> +            .flags = 0,
>>>> +            .len = 1,
>>>> +            .buf =&reg,
>>>> +        }, {
>>>> +            .addr = priv->cfg.i2c_addr,
>>>> +            .flags = I2C_M_RD,
>>>> +            .len = len,
>>>> +            .buf = val,
>>>> +        }
>>>> +    };
>>>> +
>>>> +    ret = i2c_transfer(priv->i2c, msg, 2);
>>>> +    if (ret == 2) {
>>>> +        ret = 0;
>>>> +    } else {
>>>> +        warn("i2c rd failed=%d reg=%02x len=%d", ret, reg, len);
>>>> +        ret = -EREMOTEIO;
>>>> +}
>>>> +return ret;
>>>> +}
>>>> +
>>>> +/* write multiple registers */
>>>> +static int rtl2832_wr_regs(struct rtl2832_priv *priv, u8 reg, u8
>>>> page, u8 *val,
>>>> +    int len)
>>>> +{
>>>> +    int ret;
>>>> +
>>>> +
>>>> +    /* switch bank if needed */
>>>> +    if (page != priv->page) {
>>>> +        ret = rtl2832_wr(priv, 0x00,&page, 1);
>>>> +        if (ret)
>>>> +            return ret;
>>>> +
>>>> +        priv->page = page;
>>>> +}
>>>> +
>>>> +return rtl2832_wr(priv, reg, val, len);
>>>> +}
>>>> +
>>>> +/* read multiple registers */
>>>> +static int rtl2832_rd_regs(struct rtl2832_priv *priv, u8 reg, u8
>>>> page, u8 *val,
>>>> +    int len)
>>>> +{
>>>> +    int ret;
>>>> +
>>>> +    /* switch bank if needed */
>>>> +    if (page != priv->page) {
>>>> +        ret = rtl2832_wr(priv, 0x00,&page, 1);
>>>> +        if (ret)
>>>> +            return ret;
>>>> +
>>>> +        priv->page = page;
>>>> +    }
>>>> +
>>>> +    return rtl2832_rd(priv, reg, val, len);
>>>> +}
>>>> +
>>>> +#if 0 /* currently not used */
>>>> +/* write single register */
>>>> +static int rtl2832_wr_reg(struct rtl2832_priv *priv, u8 reg, u8 page,
>>>> u8 val)
>>>> +{
>>>> +    return rtl2832_wr_regs(priv, reg, page,&val, 1);
>>>> +}
>>>> +#endif
>>>> +
>>>> +/* read single register */
>>>> +static int rtl2832_rd_reg(struct rtl2832_priv *priv, u8 reg, u8 page,
>>>> u8 *val)
>>>> +{
>>>> +    return rtl2832_rd_regs(priv, reg, page, val, 1);
>>>> +}
>>>> +
>>>> +int rtl2832_rd_demod_reg(struct rtl2832_priv *priv, int reg, u32 *val)
>>>> +{
>>>> +    int ret;
>>>> +
>>>> +    u8 reg_start_addr;
>>>> +    u8 msb, lsb;
>>>> +    u8 page;
>>>> +    u8 reading[4];
>>>> +    u32 reading_tmp;
>>>> +    int i;
>>>> +
>>>> +    u8 len;
>>>> +    u32 mask;
>>>> +
>>>> +    reg_start_addr = registers[reg].start_address;
>>>> +    msb = registers[reg].msb;
>>>> +    lsb = registers[reg].lsb;
>>>> +    page = registers[reg].page;
>>>> +
>>>> +    len = (msb>>  3) + 1;
>>>> +    mask = reg_mask[msb-lsb];
>>>
>>> You should use spaces here. See Documentation/CodingStyle line 206.
>>>
>>>> +
>>>> +
>>>> +    ret = rtl2832_rd_regs(priv, reg_start_addr, page,&reading[0],
> len);
>>>> +    if (ret)
>>>> +        goto err;
>>>> +
>>>> +    reading_tmp = 0;
>>>> +    for (i = 0; i<  len; i++)
>>>> +        reading_tmp |= reading[i]<<  ((len-1-i)*8);
>>>
>>> You should use spaces here. See Documentation/CodingStyle line 206.
>>>
>>>> +
>>>> +    *val = (reading_tmp>>  lsb)&  mask;
>>>> +
>>>> +    return ret;
>>>> +
>>>> +err:
>>>> +    dbg("%s: failed=%d", __func__, ret);
>>>> +    return ret;
>>>> +
>>>> +}
>>>> +
>>>> +int rtl2832_wr_demod_reg(struct rtl2832_priv *priv, int reg, u32 val)
>>>> +{
>>>> +    int ret, i;
>>>> +    u8 len;
>>>> +    u8 reg_start_addr;
>>>> +    u8 msb, lsb;
>>>> +    u8 page;
>>>> +    u32 mask;
>>>> +
>>>> +
>>>> +    u8 reading[4];
>>>> +    u8 writing[4];
>>>> +    u32 reading_tmp;
>>>> +    u32 writing_tmp;
>>>> +
>>>> +
>>>> +    reg_start_addr = registers[reg].start_address;
>>>> +    msb = registers[reg].msb;
>>>> +    lsb = registers[reg].lsb;
>>>> +    page = registers[reg].page;
>>>> +
>>>> +    len = (msb>>  3) + 1;
>>>> +    mask = reg_mask[msb-lsb];
>>>
>>> You should use spaces here. See Documentation/CodingStyle line 206.
>>>
>>>> +
>>>> +
>>>> +    ret = rtl2832_rd_regs(priv, reg_start_addr, page,&reading[0],
> len);
>>>> +    if (ret)
>>>> +        goto err;
>>>> +
>>>> +    reading_tmp = 0;
>>>> +    for (i = 0; i<  len; i++)
>>>> +        reading_tmp |= reading[i]<<  ((len-1-i)*8);
>>>
>>> You should use spaces here. See Documentation/CodingStyle line 206.
>>>
>>>> +
>>>> +    writing_tmp = reading_tmp&  ~(mask<<  lsb);
>>>> +    writing_tmp |= ((val&  mask)<<  lsb);
>>>> +
>>>> +
>>>> +    for (i = 0; i<  len; i++)
>>>> +        writing[i] = (writing_tmp>>  ((len-1-i)*8))&  0xff;
>>>
>>> You should use spaces here. See Documentation/CodingStyle line 206.
>>>
>>>> +
>>>> +    ret = rtl2832_wr_regs(priv, reg_start_addr, page,&writing[0],
> len);
>>>> +    if (ret)
>>>> +        goto err;
>>>> +
>>>> +    return ret;
>>>> +
>>>> +err:
>>>> +    dbg("%s: failed=%d", __func__, ret);
>>>> +    return ret;
>>>> +
>>>> +}
>>>> +
>>>> +
>>>> +static int rtl2832_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
>>>> +{
>>>> +    int ret;
>>>> +    struct rtl2832_priv *priv = fe->demodulator_priv;
>>>> +
>>>> +    dbg("%s: enable=%d", __func__, enable);
>>>> +
>>>> +    /* gate already open or close */
>>>> +    if (priv->i2c_gate_state == enable)
>>>> +        return 0;
>>>> +
>>>> +    ret = rtl2832_wr_demod_reg(priv, DVBT_IIC_REPEAT, (enable ? 0x1 :
>>>> 0x0));
>>>> +
>>>> +    if (ret)
>>>> +        goto err;
>>>
>>> Excessive newline between function call and error check.
>>>
>>>> +
>>>> +    priv->i2c_gate_state = enable;
>>>> +
>>>> +    return ret;
>>>> +err:
>>>> +    dbg("%s: failed=%d", __func__, ret);
>>>> +    return ret;
>>>> +}
>>>> +
>>>> +
>>>> +
>>>> +static int rtl2832_init(struct dvb_frontend *fe)
>>>> +{
>>>> +    struct rtl2832_priv *priv = fe->demodulator_priv;
>>>> +    int i, ret;
>>>> +
>>>> +    u8 en_bbin;
>>>> +    u64 pset_iffreq;
>>>> +
>>>> +    /* initialization values for the demodulator registers */
>>>> +    struct rtl2832_reg_value rtl2832_initial_regs[] = {
>>>> +        {DVBT_AD_EN_REG,        0x1},
>>>> +        {DVBT_AD_EN_REG1,        0x1},
>>>> +        {DVBT_RSD_BER_FAIL_VAL,        0x2800},
>>>> +        {DVBT_MGD_THD0,            0x10},
>>>> +        {DVBT_MGD_THD1,            0x20},
>>>> +        {DVBT_MGD_THD2,            0x20},
>>>> +        {DVBT_MGD_THD3,            0x40},
>>>> +        {DVBT_MGD_THD4,            0x22},
>>>> +        {DVBT_MGD_THD5,            0x32},
>>>> +        {DVBT_MGD_THD6,            0x37},
>>>> +        {DVBT_MGD_THD7,            0x39},
>>>> +        {DVBT_EN_BK_TRK,        0x0},
>>>> +        {DVBT_EN_CACQ_NOTCH,        0x0},
>>>> +        {DVBT_AD_AV_REF,        0x2a},
>>>> +        {DVBT_REG_PI,            0x6},
>>>> +        {DVBT_PIP_ON,            0x0},
>>>> +        {DVBT_CDIV_PH0,            0x8},
>>>> +        {DVBT_CDIV_PH1,            0x8},
>>>> +        {DVBT_SCALE1_B92,        0x4},
>>>> +        {DVBT_SCALE1_B93,        0xb0},
>>>> +        {DVBT_SCALE1_BA7,        0x78},
>>>> +        {DVBT_SCALE1_BA9,        0x28},
>>>> +        {DVBT_SCALE1_BAA,        0x59},
>>>> +        {DVBT_SCALE1_BAB,        0x83},
>>>> +        {DVBT_SCALE1_BAC,        0xd4},
>>>> +        {DVBT_SCALE1_BB0,        0x65},
>>>> +        {DVBT_SCALE1_BB1,        0x43},
>>>> +        {DVBT_KB_P1,            0x1},
>>>> +        {DVBT_KB_P2,            0x4},
>>>> +        {DVBT_KB_P3,            0x7},
>>>> +        {DVBT_K1_CR_STEP12,        0xa},
>>>> +        {DVBT_REG_GPE,            0x1},
>>>> +        {DVBT_SERIAL,            0x0},
>>>> +        {DVBT_CDIV_PH0,            0x9},
>>>> +        {DVBT_CDIV_PH1,            0x9},
>>>> +        {DVBT_MPEG_IO_OPT_2_2,        0x0},
>>>> +        {DVBT_MPEG_IO_OPT_1_0,        0x0},
>>>> +        {DVBT_TRK_KS_P2,        0x4},
>>>> +        {DVBT_TRK_KS_I2,        0x7},
>>>> +        {DVBT_TR_THD_SET2,        0x6},
>>>> +        {DVBT_TRK_KC_I2,        0x5},
>>>> +        {DVBT_CR_THD_SET2,        0x1},
>>>> +        {DVBT_SPEC_INV,            0x0},
>>>> +        {DVBT_DAGC_TRG_VAL,        0x5a},
>>>> +        {DVBT_AGC_TARG_VAL_0,        0x0},
>>>> +        {DVBT_AGC_TARG_VAL_8_1,        0x5a},
>>>> +        {DVBT_AAGC_LOOP_GAIN,        0x16},
>>>> +        {DVBT_LOOP_GAIN2_3_0,        0x6},
>>>> +        {DVBT_LOOP_GAIN2_4,        0x1},
>>>> +        {DVBT_LOOP_GAIN3,        0x16},
>>>> +        {DVBT_VTOP1,            0x35},
>>>> +        {DVBT_VTOP2,            0x21},
>>>> +        {DVBT_VTOP3,            0x21},
>>>> +        {DVBT_KRF1,            0x0},
>>>> +        {DVBT_KRF2,            0x40},
>>>> +        {DVBT_KRF3,            0x10},
>>>> +        {DVBT_KRF4,            0x10},
>>>> +        {DVBT_IF_AGC_MIN,        0x80},
>>>> +        {DVBT_IF_AGC_MAX,        0x7f},
>>>> +        {DVBT_RF_AGC_MIN,        0x80},
>>>> +        {DVBT_RF_AGC_MAX,        0x7f},
>>>> +        {DVBT_POLAR_RF_AGC,        0x0},
>>>> +        {DVBT_POLAR_IF_AGC,        0x0},
>>>> +        {DVBT_AD7_SETTING,        0xe9bf},
>>>> +        {DVBT_EN_GI_PGA,        0x0},
>>>> +        {DVBT_THD_LOCK_UP,        0x0},
>>>> +        {DVBT_THD_LOCK_DW,        0x0},
>>>> +        {DVBT_THD_UP1,            0x11},
>>>> +        {DVBT_THD_DW1,            0xef},
>>>> +        {DVBT_INTER_CNT_LEN,        0xc},
>>>> +        {DVBT_GI_PGA_STATE,        0x0},
>>>> +        {DVBT_EN_AGC_PGA,        0x1},
>>>> +        {DVBT_IF_AGC_MAN,        0x0},
>>>> +    };
>>>> +
>>>> +
>>>> +    dbg("%s", __func__);
>>>> +
>>>> +    en_bbin = (priv->cfg.if_dvbt == 0 ? 0x1 : 0x0);
>>>> +
>>>> +    /*
>>>> +    * PSET_IFFREQ = - floor((IfFreqHz % CrystalFreqHz) * pow(2, 22)
>>>> +    *        / CrystalFreqHz)
>>>> +    */
>>>> +    pset_iffreq = priv->cfg.if_dvbt % priv->cfg.xtal;
>>>> +    pset_iffreq *= 0x400000;
>>>> +    pset_iffreq = div_u64(pset_iffreq, priv->cfg.xtal);
>>>> +    pset_iffreq = pset_iffreq&  0x3fffff;
>>>> +
>>>> +
>>>> +
>>>> +    for (i = 0; i<  ARRAY_SIZE(rtl2832_initial_regs); i++) {
>>>> +        ret = rtl2832_wr_demod_reg(priv, rtl2832_initial_regs[i].reg,
>>>> +            rtl2832_initial_regs[i].value);
>>>> +        if (ret)
>>>> +            goto err;
>>>> +    }
>>>> +
>>>> +    /* if frequency settings */
>>>> +    ret = rtl2832_wr_demod_reg(priv, DVBT_EN_BBIN, en_bbin);
>>>> +        if (ret)
>>>> +            goto err;
>>>> +
>>>> +    ret = rtl2832_wr_demod_reg(priv, DVBT_PSET_IFFREQ, pset_iffreq);
>>>> +        if (ret)
>>>> +            goto err;
>>>> +
>>>> +    priv->sleeping = false;
>>>> +
>>>> +    return ret;
>>>> +
>>>> +err:
>>>> +    dbg("%s: failed=%d", __func__, ret);
>>>> +    return ret;
>>>> +}
>>>> +
>>>> +static int rtl2832_sleep(struct dvb_frontend *fe)
>>>> +{
>>>> +    struct rtl2832_priv *priv = fe->demodulator_priv;
>>>> +
>>>> +    dbg("%s", __func__);
>>>> +    priv->sleeping = true;
>>>> +    return 0;
>>>> +}
>>>> +
>>>> +int rtl2832_get_tune_settings(struct dvb_frontend *fe,
>>>> +    struct dvb_frontend_tune_settings *s)
>>>> +{
>>>> +    dbg("%s", __func__);
>>>> +    s->min_delay_ms = 1000;
>>>> +    s->step_size = fe->ops.info.frequency_stepsize * 2;
>>>> +    s->max_drift = (fe->ops.info.frequency_stepsize * 2) + 1;
>>>> +    return 0;
>>>> +}
>>>> +
>>>> +static int rtl2832_set_frontend(struct dvb_frontend *fe)
>>>> +{
>>>> +    struct rtl2832_priv *priv = fe->demodulator_priv;
>>>> +    struct dtv_frontend_properties *c =&fe->dtv_property_cache;
>>>> +    int ret, i, j;
>>>> +    u64 bw_mode, num, num2;
>>>> +    u32 resamp_ratio, cfreq_off_ratio;
>>>> +
>>>> +
>>>> +    static u8 bw_params[3][32] = {
>>>> +    /* 6 MHz bandwidth */
>>>> +        {
>>>> +        0xf5, 0xff, 0x15, 0x38, 0x5d, 0x6d, 0x52, 0x07, 0xfa, 0x2f,
>>>> +        0x53, 0xf5, 0x3f, 0xca, 0x0b, 0x91, 0xea, 0x30, 0x63, 0xb2,
>>>> +        0x13, 0xda, 0x0b, 0xc4, 0x18, 0x7e, 0x16, 0x66, 0x08, 0x67,
>>>> +        0x19, 0xe0,
>>>> +        },
>>>> +
>>>> +    /*  7 MHz bandwidth */
>>>> +        {
>>>> +        0xe7, 0xcc, 0xb5, 0xba, 0xe8, 0x2f, 0x67, 0x61, 0x00, 0xaf,
>>>> +        0x86, 0xf2, 0xbf, 0x59, 0x04, 0x11, 0xb6, 0x33, 0xa4, 0x30,
>>>> +        0x15, 0x10, 0x0a, 0x42, 0x18, 0xf8, 0x17, 0xd9, 0x07, 0x22,
>>>> +        0x19, 0x10,
>>>> +        },
>>>> +
>>>> +    /*  8 MHz bandwidth */
>>>> +        {
>>>> +        0x09, 0xf6, 0xd2, 0xa7, 0x9a, 0xc9, 0x27, 0x77, 0x06, 0xbf,
>>>> +        0xec, 0xf4, 0x4f, 0x0b, 0xfc, 0x01, 0x63, 0x35, 0x54, 0xa7,
>>>> +        0x16, 0x66, 0x08, 0xb4, 0x19, 0x6e, 0x19, 0x65, 0x05, 0xc8,
>>>> +        0x19, 0xe0,
>>>> +        },
>>>> +    };
>>>> +
>>>> +
>>>> +    dbg("%s: frequency=%d bandwidth_hz=%d inversion=%d", __func__,
>>>> +        c->frequency, c->bandwidth_hz, c->inversion);
>>>> +
>>>> +
>>>> +    /* program tuner */
>>>> +    if (fe->ops.tuner_ops.set_params)
>>>> +        fe->ops.tuner_ops.set_params(fe);
>>>> +
>>>> +
>>>> +    switch (c->bandwidth_hz) {
>>>> +    case 6000000:
>>>> +        i = 0;
>>>> +        bw_mode = 48000000;
>>>> +        break;
>>>> +    case 7000000:
>>>> +        i = 1;
>>>> +        bw_mode = 56000000;
>>>> +        break;
>>>> +    case 8000000:
>>>> +        i = 2;
>>>> +        bw_mode = 64000000;
>>>> +        break;
>>>> +    default:
>>>> +        dbg("invalid bandwidth");
>>>> +        return -EINVAL;
>>>> +    }
>>>> +
>>>> +    for (j = 0; j<  sizeof(bw_params[j]); j++) {
>>>> +        ret = rtl2832_wr_regs(priv, 0x1c+j, 1,&bw_params[i][j], 1);
>>>> +        if (ret)
>>>> +            goto err;
>>>> +    }
>>>> +
>>>> +    /* calculate and set resample ratio
>>>> +    * RSAMP_RATIO = floor(CrystalFreqHz * 7 * pow(2, 22)
>>>> +    *    / ConstWithBandwidthMode)
>>>> +    */
>>>> +    num = priv->cfg.xtal * 7;
>>>> +    num *= 0x400000;
>>>> +    num = div_u64(num, bw_mode);
>>>> +    resamp_ratio =  num&  0x3ffffff;
>>>> +    ret = rtl2832_wr_demod_reg(priv, DVBT_RSAMP_RATIO, resamp_ratio);
>>>> +    if (ret)
>>>> +        goto err;
>>>> +
>>>> +    /* calculate and set cfreq off ratio
>>>> +    * CFREQ_OFF_RATIO = - floor(ConstWithBandwidthMode * pow(2, 20)
>>>> +    *    / (CrystalFreqHz * 7))
>>>> +    */
>>>> +    num = bw_mode<<  20;
>>>> +    num2 = priv->cfg.xtal * 7;
>>>> +    num = div_u64(num, num2);
>>>> +    num = -num;
>>>> +    cfreq_off_ratio = num&  0xfffff;
>>>> +    ret = rtl2832_wr_demod_reg(priv, DVBT_CFREQ_OFF_RATIO,
>>>> cfreq_off_ratio);
>>>> +    if (ret)
>>>> +        goto err;
>>>> +
>>>> +
>>>> +    /* soft reset */
>>>> +    ret = rtl2832_wr_demod_reg(priv, DVBT_SOFT_RST, 0x1);
>>>> +    if (ret)
>>>> +        goto err;
>>>> +
>>>> +    ret = rtl2832_wr_demod_reg(priv, DVBT_SOFT_RST, 0x0);
>>>> +    if (ret)
>>>> +        goto err;
>>>> +
>>>> +    return ret;
>>>> +err:
>>>> +    info("%s: failed=%d", __func__, ret);
>>>> +    return ret;
>>>> +}
>>>> +
>>>> +static int rtl2832_read_status(struct dvb_frontend *fe, fe_status_t
>>>> *status)
>>>> +{
>>>> +    struct rtl2832_priv *priv = fe->demodulator_priv;
>>>> +    int ret;
>>>> +    u32 tmp;
>>>> +    *status = 0;
>>>> +
>>>> +
>>>> +    dbg("%s", __func__);
>>>> +    if (priv->sleeping)
>>>> +        return 0;
>>>> +
>>>> +    ret = rtl2832_rd_demod_reg(priv, DVBT_FSM_STAGE,&tmp);
>>>> +    if (ret)
>>>> +        goto err;
>>>> +
>>>> +    if (tmp == 11) {
>>>> +        *status |= FE_HAS_SIGNAL | FE_HAS_CARRIER |
>>>> +                FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
>>>> +    }
>>>> +    /* TODO find out if this is also true for rtl2832? */
>>>> +    /*else if (tmp == 10) {
>>>> +        *status |= FE_HAS_SIGNAL | FE_HAS_CARRIER |
>>>> +                FE_HAS_VITERBI;
>>>> +    }*/
>>>> +
>>>> +    return ret;
>>>> +err:
>>>> +    info("%s: failed=%d", __func__, ret);
>>>> +    return ret;
>>>> +}
>>>> +
>>>> +static int rtl2832_read_snr(struct dvb_frontend *fe, u16 *snr)
>>>> +{
>>>> +    *snr = 0;
>>>> +    return 0;
>>>> +}
>>>> +
>>>> +static int rtl2832_read_ber(struct dvb_frontend *fe, u32 *ber)
>>>> +{
>>>> +    *ber = 0;
>>>> +    return 0;
>>>> +}
>>>> +
>>>> +static int rtl2832_read_ucblocks(struct dvb_frontend *fe, u32
> *ucblocks)
>>>> +{
>>>> +    *ucblocks = 0;
>>>> +    return 0;
>>>> +}
>>>> +
>>>> +
>>>> +static int rtl2832_read_signal_strength(struct dvb_frontend *fe, u16
>>>> *strength)
>>>> +{
>>>> +    *strength = 0;
>>>> +    return 0;
>>>> +}
>>>> +
>>>> +static struct dvb_frontend_ops rtl2832_ops;
>>>> +
>>>> +static void rtl2832_release(struct dvb_frontend *fe)
>>>> +{
>>>> +    struct rtl2832_priv *priv = fe->demodulator_priv;
>>>> +
>>>> +    dbg("%s", __func__);
>>>> +    kfree(priv);
>>>> +}
>>>> +
>>>> +struct dvb_frontend *rtl2832_attach(const struct rtl2832_config *cfg,
>>>> +    struct i2c_adapter *i2c)
>>>> +{
>>>> +    struct rtl2832_priv *priv = NULL;
>>>> +    int ret = 0;
>>>> +    u8 tmp;
>>>> +
>>>> +    dbg("%s", __func__);
>>>> +
>>>> +    /* allocate memory for the internal state */
>>>> +    priv = kzalloc(sizeof(struct rtl2832_priv), GFP_KERNEL);
>>>> +    if (priv == NULL)
>>>> +        goto err;
>>>> +
>>>> +    /* setup the priv */
>>>> +    priv->i2c = i2c;
>>>> +    priv->tuner = cfg->tuner;
>>>> +    memcpy(&priv->cfg, cfg, sizeof(struct rtl2832_config));
>>>> +
>>>> +    /* check if the demod is there */
>>>> +    ret = rtl2832_rd_reg(priv, 0x00, 0x0,&tmp);
>>>> +    if (ret)
>>>> +        goto err;
>>>> +
>>>> +    /* create dvb_frontend */
>>>> +    memcpy(&priv->fe.ops,&rtl2832_ops, sizeof(struct
> dvb_frontend_ops));
>>>> +    priv->fe.demodulator_priv = priv;
>>>> +
>>>> +    /* TODO implement sleep mode */
>>>> +    priv->sleeping = true;
>>>> +
>>>> +    return&priv->fe;
>>>> +err:
>>>> +    dbg("%s: failed=%d", __func__, ret);
>>>> +    kfree(priv);
>>>> +    return NULL;
>>>> +}
>>>> +EXPORT_SYMBOL(rtl2832_attach);
>>>> +
>>>> +static struct dvb_frontend_ops rtl2832_ops = {
>>>> +    .delsys = { SYS_DVBT },
>>>> +    .info = {
>>>> +        .name = "Realtek RTL2832 (DVB-T)",
>>>> +        .frequency_min      = 174000000,
>>>> +        .frequency_max      = 862000000,
>>>> +        .frequency_stepsize = 166667,
>>>> +        .caps = FE_CAN_FEC_1_2 |
>>>> +            FE_CAN_FEC_2_3 |
>>>> +            FE_CAN_FEC_3_4 |
>>>> +            FE_CAN_FEC_5_6 |
>>>> +            FE_CAN_FEC_7_8 |
>>>> +            FE_CAN_FEC_AUTO |
>>>> +            FE_CAN_QPSK |
>>>> +            FE_CAN_QAM_16 |
>>>> +            FE_CAN_QAM_64 |
>>>> +            FE_CAN_QAM_AUTO |
>>>> +            FE_CAN_TRANSMISSION_MODE_AUTO |
>>>> +            FE_CAN_GUARD_INTERVAL_AUTO |
>>>> +            FE_CAN_HIERARCHY_AUTO |
>>>> +            FE_CAN_RECOVER |
>>>> +            FE_CAN_MUTE_TS
>>>> +     },
>>>> +
>>>> +    .release = rtl2832_release,
>>>> +
>>>> +    .init = rtl2832_init,
>>>> +    .sleep = rtl2832_sleep,
>>>> +
>>>> +    .get_tune_settings = rtl2832_get_tune_settings,
>>>> +
>>>> +    .set_frontend = rtl2832_set_frontend,
>>>> +
>>>> +    .read_status = rtl2832_read_status,
>>>> +    .read_snr = rtl2832_read_snr,
>>>> +    .read_ber = rtl2832_read_ber,
>>>> +    .read_ucblocks = rtl2832_read_ucblocks,
>>>> +    .read_signal_strength = rtl2832_read_signal_strength,
>>>> +    .i2c_gate_ctrl = rtl2832_i2c_gate_ctrl,
>>>> +};
>>>> +
>>>> +MODULE_AUTHOR("Thomas Mair<mair.thomas86@gmail.com>");
>>>> +MODULE_DESCRIPTION("Realtek RTL2832 DVB-T demodulator driver");
>>>> +MODULE_LICENSE("GPL");
>>>> +MODULE_VERSION("0.4");
>>>> diff --git a/drivers/media/dvb/frontends/rtl2832.h
>>>> b/drivers/media/dvb/frontends/rtl2832.h
>>>> new file mode 100644
>>>> index 0000000..d94dc9a
>>>> --- /dev/null
>>>> +++ b/drivers/media/dvb/frontends/rtl2832.h
>>>> @@ -0,0 +1,74 @@
>>>> +/*
>>>> + * Realtek RTL2832 DVB-T demodulator driver
>>>> + *
>>>> + * Copyright (C) 2012 Thomas Mair<thomas.mair86@gmail.com>
>>>> + *
>>>> + *    This program is free software; you can redistribute it and/or
>>>> modify
>>>> + *    it under the terms of the GNU General Public License as
>>>> published by
>>>> + *    the Free Software Foundation; either version 2 of the License,
> or
>>>> + *    (at your option) any later version.
>>>> + *
>>>> + *    This program is distributed in the hope that it will be useful,
>>>> + *    but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>> + *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>> + *    GNU General Public License for more details.
>>>> + *
>>>> + *    You should have received a copy of the GNU General Public
>>>> License along
>>>> + *    with this program; if not, write to the Free Software
>>>> Foundation, Inc.,
>>>> + *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
>>>> + */
>>>> +
>>>> +#ifndef RTL2832_H
>>>> +#define RTL2832_H
>>>> +
>>>> +#include<linux/dvb/frontend.h>
>>>> +
>>>> +struct rtl2832_config {
>>>> +    /*
>>>> +     * Demodulator I2C address.
>>>> +     */
>>>> +    u8 i2c_addr;
>>>> +
>>>> +    /*
>>>> +     * Xtal frequency.
>>>> +     * Hz
>>>> +     * 4000000, 16000000, 25000000, 28800000
>>>> +     */
>>>> +    u32 xtal;
>>>> +
>>>> +    /*
>>>> +     * IFs for all used modes.
>>>> +     * Hz
>>>> +     * 4570000, 4571429, 36000000, 36125000, 36166667, 44000000
>>>> +     */
>>>> +    u32 if_dvbt;
>>>> +
>>>> +    /*
>>>> +     */
>>>> +    u8 tuner;
>>>> +};
>>>> +
>>>> +
>>>> +#if defined(CONFIG_DVB_RTL2832) || \
>>>> +    (defined(CONFIG_DVB_RTL2832_MODULE)&&  defined(MODULE))
>>>> +extern struct dvb_frontend *rtl2832_attach(
>>>> +    const struct rtl2832_config *cfg,
>>>> +    struct i2c_adapter *i2c
>>>> +);
>>>> +
>>>> +extern struct i2c_adapter *rtl2832_get_tuner_i2c_adapter(
>>>> +    struct dvb_frontend *fe
>>>> +);
>>>> +#else
>>>> +static inline struct dvb_frontend *rtl2832_attach(
>>>> +    const struct rtl2832_config *config,
>>>> +    struct i2c_adapter *i2c
>>>> +)
>>>> +{
>>>> +    printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
>>>> +    return NULL;
>>>> +}
>>>> +#endif
>>>> +
>>>> +
>>>> +#endif /* RTL2832_H */
>>>> diff --git a/drivers/media/dvb/frontends/rtl2832_priv.h
>>>> b/drivers/media/dvb/frontends/rtl2832_priv.h
>>>> new file mode 100644
>>>> index 0000000..3e52674
>>>> --- /dev/null
>>>> +++ b/drivers/media/dvb/frontends/rtl2832_priv.h
>>>> @@ -0,0 +1,258 @@
>>>> +/*
>>>> + * Realtek RTL2832 DVB-T demodulator driver
>>>> + *
>>>> + * Copyright (C) 2012 Thomas Mair<thomas.mair86@gmail.com>
>>>> + *
>>>> + *    This program is free software; you can redistribute it and/or
>>>> modify
>>>> + *    it under the terms of the GNU General Public License as
>>>> published by
>>>> + *    the Free Software Foundation; either version 2 of the License,
> or
>>>> + *    (at your option) any later version.
>>>> + *
>>>> + *    This program is distributed in the hope that it will be useful,
>>>> + *    but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>> + *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>> + *    GNU General Public License for more details.
>>>> + *
>>>> + *    You should have received a copy of the GNU General Public
>>>> License along
>>>> + *    with this program; if not, write to the Free Software
>>>> Foundation, Inc.,
>>>> + *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
>>>> + */
>>>> +
>>>> +#ifndef RTL2832_PRIV_H
>>>> +#define RTL2832_PRIV_H
>>>> +
>>>> +#include "dvb_frontend.h"
>>>> +#include "rtl2832.h"
>>>> +
>>>> +#define LOG_PREFIX "rtl2832"
>>>> +
>>>> +#undef dbg
>>>> +#define dbg(f, arg...) \
>>>> +    if (rtl2832_debug) \
>>>> +        printk(KERN_INFO LOG_PREFIX": " f "\n" , ## arg)
>>>
>>> ERROR: Macros with complex values should be enclosed in parenthesis
>>> #30: FILE: media/dvb/frontends/rtl2832_priv.h:30:
>>> +#define dbg(f, arg...) \
>>> +    if (rtl2832_debug) \
>>> +        printk(KERN_INFO LOG_PREFIX": " f "\n" , ## arg)
>>>
>>>> +#undef err
>>>> +#define err(f, arg...)  printk(KERN_ERR    LOG_PREFIX": " f "\n" , ##
>>>> arg)
>>>> +#undef info
>>>> +#define info(f, arg...) printk(KERN_INFO LOG_PREFIX": " f "\n" , ##
> arg)
>>>> +#undef warn
>>>> +#define warn(f, arg...) printk(KERN_WARNING LOG_PREFIX": " f "\n" ,
>>>> ## arg)
>>>> +
>>>> +struct rtl2832_priv {
>>>> +    struct i2c_adapter *i2c;
>>>> +    struct dvb_frontend fe;
>>>> +    struct rtl2832_config cfg;
>>>> +
>>>> +    bool i2c_gate_state;
>>>> +    bool sleeping;
>>>> +
>>>> +    u8 tuner;
>>>> +    u8 page; /* active register page */
>>>> +};
>>>> +
>>>> +struct rtl2832_reg_entry {
>>>> +    u8 page;
>>>> +    u8 start_address;
>>>> +    u8 msb;
>>>> +    u8 lsb;
>>>> +};
>>>> +
>>>> +struct rtl2832_reg_value {
>>>> +    int reg;
>>>
>>> As this reg is enum I wonder if it is possible to use enum as a type
>>> (enum reg)? Still I am not sure about it and I dont like to test it :)
>>>
>>>> +    u32 value;
>>>> +};
>>>> +
>>>> +
>>>> +/* Demod register bit names */
>>>> +enum DVBT_REG_BIT_NAME {
>>>> +    DVBT_SOFT_RST,
>>>> +    DVBT_IIC_REPEAT,
>>>> +    DVBT_TR_WAIT_MIN_8K,
>>>> +    DVBT_RSD_BER_FAIL_VAL,
>>>> +    DVBT_EN_BK_TRK,
>>>> +    DVBT_REG_PI,
>>>> +    DVBT_REG_PFREQ_1_0,
>>>> +    DVBT_PD_DA8,
>>>> +    DVBT_LOCK_TH,
>>>> +    DVBT_BER_PASS_SCAL,
>>>> +    DVBT_CE_FFSM_BYPASS,
>>>> +    DVBT_ALPHAIIR_N,
>>>> +    DVBT_ALPHAIIR_DIF,
>>>> +    DVBT_EN_TRK_SPAN,
>>>> +    DVBT_LOCK_TH_LEN,
>>>> +    DVBT_CCI_THRE,
>>>> +    DVBT_CCI_MON_SCAL,
>>>> +    DVBT_CCI_M0,
>>>> +    DVBT_CCI_M1,
>>>> +    DVBT_CCI_M2,
>>>> +    DVBT_CCI_M3,
>>>> +    DVBT_SPEC_INIT_0,
>>>> +    DVBT_SPEC_INIT_1,
>>>> +    DVBT_SPEC_INIT_2,
>>>> +    DVBT_AD_EN_REG,
>>>> +    DVBT_AD_EN_REG1,
>>>> +    DVBT_EN_BBIN,
>>>> +    DVBT_MGD_THD0,
>>>> +    DVBT_MGD_THD1,
>>>> +    DVBT_MGD_THD2,
>>>> +    DVBT_MGD_THD3,
>>>> +    DVBT_MGD_THD4,
>>>> +    DVBT_MGD_THD5,
>>>> +    DVBT_MGD_THD6,
>>>> +    DVBT_MGD_THD7,
>>>> +    DVBT_EN_CACQ_NOTCH,
>>>> +    DVBT_AD_AV_REF,
>>>> +    DVBT_PIP_ON,
>>>> +    DVBT_SCALE1_B92,
>>>> +    DVBT_SCALE1_B93,
>>>> +    DVBT_SCALE1_BA7,
>>>> +    DVBT_SCALE1_BA9,
>>>> +    DVBT_SCALE1_BAA,
>>>> +    DVBT_SCALE1_BAB,
>>>> +    DVBT_SCALE1_BAC,
>>>> +    DVBT_SCALE1_BB0,
>>>> +    DVBT_SCALE1_BB1,
>>>> +    DVBT_KB_P1,
>>>> +    DVBT_KB_P2,
>>>> +    DVBT_KB_P3,
>>>> +    DVBT_OPT_ADC_IQ,
>>>> +    DVBT_AD_AVI,
>>>> +    DVBT_AD_AVQ,
>>>> +    DVBT_K1_CR_STEP12,
>>>> +    DVBT_TRK_KS_P2,
>>>> +    DVBT_TRK_KS_I2,
>>>> +    DVBT_TR_THD_SET2,
>>>> +    DVBT_TRK_KC_P2,
>>>> +    DVBT_TRK_KC_I2,
>>>> +    DVBT_CR_THD_SET2,
>>>> +    DVBT_PSET_IFFREQ,
>>>> +    DVBT_SPEC_INV,
>>>> +    DVBT_BW_INDEX,
>>>> +    DVBT_RSAMP_RATIO,
>>>> +    DVBT_CFREQ_OFF_RATIO,
>>>> +    DVBT_FSM_STAGE,
>>>> +    DVBT_RX_CONSTEL,
>>>> +    DVBT_RX_HIER,
>>>> +    DVBT_RX_C_RATE_LP,
>>>> +    DVBT_RX_C_RATE_HP,
>>>> +    DVBT_GI_IDX,
>>>> +    DVBT_FFT_MODE_IDX,
>>>> +    DVBT_RSD_BER_EST,
>>>> +    DVBT_CE_EST_EVM,
>>>> +    DVBT_RF_AGC_VAL,
>>>> +    DVBT_IF_AGC_VAL,
>>>> +    DVBT_DAGC_VAL,
>>>> +    DVBT_SFREQ_OFF,
>>>> +    DVBT_CFREQ_OFF,
>>>> +    DVBT_POLAR_RF_AGC,
>>>> +    DVBT_POLAR_IF_AGC,
>>>> +    DVBT_AAGC_HOLD,
>>>> +    DVBT_EN_RF_AGC,
>>>> +    DVBT_EN_IF_AGC,
>>>> +    DVBT_IF_AGC_MIN,
>>>> +    DVBT_IF_AGC_MAX,
>>>> +    DVBT_RF_AGC_MIN,
>>>> +    DVBT_RF_AGC_MAX,
>>>> +    DVBT_IF_AGC_MAN,
>>>> +    DVBT_IF_AGC_MAN_VAL,
>>>> +    DVBT_RF_AGC_MAN,
>>>> +    DVBT_RF_AGC_MAN_VAL,
>>>> +    DVBT_DAGC_TRG_VAL,
>>>> +    DVBT_AGC_TARG_VAL,
>>>> +    DVBT_LOOP_GAIN_3_0,
>>>> +    DVBT_LOOP_GAIN_4,
>>>> +    DVBT_VTOP,
>>>> +    DVBT_KRF,
>>>> +    DVBT_AGC_TARG_VAL_0,
>>>> +    DVBT_AGC_TARG_VAL_8_1,
>>>> +    DVBT_AAGC_LOOP_GAIN,
>>>> +    DVBT_LOOP_GAIN2_3_0,
>>>> +    DVBT_LOOP_GAIN2_4,
>>>> +    DVBT_LOOP_GAIN3,
>>>> +    DVBT_VTOP1,
>>>> +    DVBT_VTOP2,
>>>> +    DVBT_VTOP3,
>>>> +    DVBT_KRF1,
>>>> +    DVBT_KRF2,
>>>> +    DVBT_KRF3,
>>>> +    DVBT_KRF4,
>>>> +    DVBT_EN_GI_PGA,
>>>> +    DVBT_THD_LOCK_UP,
>>>> +    DVBT_THD_LOCK_DW,
>>>> +    DVBT_THD_UP1,
>>>> +    DVBT_THD_DW1,
>>>> +    DVBT_INTER_CNT_LEN,
>>>> +    DVBT_GI_PGA_STATE,
>>>> +    DVBT_EN_AGC_PGA,
>>>> +    DVBT_CKOUTPAR,
>>>> +    DVBT_CKOUT_PWR,
>>>> +    DVBT_SYNC_DUR,
>>>> +    DVBT_ERR_DUR,
>>>> +    DVBT_SYNC_LVL,
>>>> +    DVBT_ERR_LVL,
>>>> +    DVBT_VAL_LVL,
>>>> +    DVBT_SERIAL,
>>>> +    DVBT_SER_LSB,
>>>> +    DVBT_CDIV_PH0,
>>>> +    DVBT_CDIV_PH1,
>>>> +    DVBT_MPEG_IO_OPT_2_2,
>>>> +    DVBT_MPEG_IO_OPT_1_0,
>>>> +    DVBT_CKOUTPAR_PIP,
>>>> +    DVBT_CKOUT_PWR_PIP,
>>>> +    DVBT_SYNC_LVL_PIP,
>>>> +    DVBT_ERR_LVL_PIP,
>>>> +    DVBT_VAL_LVL_PIP,
>>>> +    DVBT_CKOUTPAR_PID,
>>>> +    DVBT_CKOUT_PWR_PID,
>>>> +    DVBT_SYNC_LVL_PID,
>>>> +    DVBT_ERR_LVL_PID,
>>>> +    DVBT_VAL_LVL_PID,
>>>> +    DVBT_SM_PASS,
>>>> +    DVBT_UPDATE_REG_2,
>>>> +    DVBT_BTHD_P3,
>>>> +    DVBT_BTHD_D3,
>>>> +    DVBT_FUNC4_REG0,
>>>> +    DVBT_FUNC4_REG1,
>>>> +    DVBT_FUNC4_REG2,
>>>> +    DVBT_FUNC4_REG3,
>>>> +    DVBT_FUNC4_REG4,
>>>> +    DVBT_FUNC4_REG5,
>>>> +    DVBT_FUNC4_REG6,
>>>> +    DVBT_FUNC4_REG7,
>>>> +    DVBT_FUNC4_REG8,
>>>> +    DVBT_FUNC4_REG9,
>>>> +    DVBT_FUNC4_REG10,
>>>> +    DVBT_FUNC5_REG0,
>>>> +    DVBT_FUNC5_REG1,
>>>> +    DVBT_FUNC5_REG2,
>>>> +    DVBT_FUNC5_REG3,
>>>> +    DVBT_FUNC5_REG4,
>>>> +    DVBT_FUNC5_REG5,
>>>> +    DVBT_FUNC5_REG6,
>>>> +    DVBT_FUNC5_REG7,
>>>> +    DVBT_FUNC5_REG8,
>>>> +    DVBT_FUNC5_REG9,
>>>> +    DVBT_FUNC5_REG10,
>>>> +    DVBT_FUNC5_REG11,
>>>> +    DVBT_FUNC5_REG12,
>>>> +    DVBT_FUNC5_REG13,
>>>> +    DVBT_FUNC5_REG14,
>>>> +    DVBT_FUNC5_REG15,
>>>> +    DVBT_FUNC5_REG16,
>>>> +    DVBT_FUNC5_REG17,
>>>> +    DVBT_FUNC5_REG18,
>>>> +    DVBT_AD7_SETTING,
>>>> +    DVBT_RSSI_R,
>>>> +    DVBT_ACI_DET_IND,
>>>> +    DVBT_REG_MON,
>>>> +    DVBT_REG_MONSEL,
>>>> +    DVBT_REG_GPE,
>>>> +    DVBT_REG_GPO,
>>>> +    DVBT_REG_4MSEL,
>>>> +    DVBT_TEST_REG_1,
>>>> +    DVBT_TEST_REG_2,
>>>> +    DVBT_TEST_REG_3,
>>>> +    DVBT_TEST_REG_4,
>>>> +    DVBT_REG_BIT_NAME_ITEM_TERMINATOR,
>>>> +};
>>>> +
>>>> +#endif /* RTL2832_PRIV_H */
>>>
>>>
>>
>> checkpatch.pl:
>> author  Joe Perches <joe@perches.com>
>>        Fri, 11 May 2012 00:59:25 +0000 (10:59 +1000)
>> committer       Stephen Rothwell <sfr@canb.auug.org.au>
>>        Thu, 17 May 2012 07:18:17 +0000 (17:18 +1000)
>>
>>
> http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commit;h=2a7561d6bbf29c631ad05a8fabe313142ba3d7d0
>>
>> ./checkpatch.pl --no-tree --no-signoff rtl2832.c-v2.diff
>> total: 0 errors, 0 warnings, 63 lines checked
>>
>> rtl2832.c-v2.diff has no obvious style problems and is ready for
> submission.
>>
>> ./checkpatch.pl --no-tree --no-signoff rtl2832.h.diff
>> total: 0 errors, 0 warnings, 8 lines checked
>>
>> rtl2832.h.diff has no obvious style problems and is ready for submission.
>>
>> ./checkpatch.pl --no-tree --no-signoff rtl2832_priv.h.diff
>> total: 0 errors, 0 warnings, 17 lines checked
>>
>> rtl2832_priv.h.diff has no obvious style problems and is ready for
>> submission.
>>
>> ./checkpatch.pl --no-tree --file rtl2832.c
>> total: 0 errors, 0 warnings, 824 lines checked
>>
>> rtl2832.c has no obvious style problems and is ready for submission.
>>
>> ./checkpatch.pl --no-tree --file rtl2832.h
>> total: 0 errors, 0 warnings, 74 lines checked
>>
>> rtl2832.h has no obvious style problems and is ready for submission.
>>
>>  ./checkpatch.pl --no-tree --file rtl2832_priv.h
>> ERROR: Macros with complex values should be enclosed in parenthesis
>> #30: FILE: rtl2832_priv.h:30:
>> +#define dbg(f, arg...) \
>> +       if (rtl2832_debug) \
>> +               pr_info(KERN_INFO LOG_PREFIX": " f "\n" , ## arg)
>>
>> total: 1 errors, 0 warnings, 258 lines checked
>>
>> rtl2832_priv.h has style problems, please review.
>>
>> If any of these errors are false positives, please report
>> them to the maintainer, see CHECKPATCH in MAINTAINERS.
>>
>>
>> Regarding "ERROR: Macros with complex values should be enclosed in
>> parenthesis":
>>
>> ./checkpatch.pl --no-tree --file *_priv.h | grep -A 1 "ERROR: Macros
>> with complex values"
>> ERROR: Macros with complex values should be enclosed in parenthesis
>> #35: FILE: af9013_priv.h:35:
>> --
>> ERROR: Macros with complex values should be enclosed in parenthesis
>> #241: FILE: bcm3510_priv.h:241:
>> --
>> ERROR: Macros with complex values should be enclosed in parenthesis
>> #242: FILE: bcm3510_priv.h:242:
>> --
>> ERROR: Macros with complex values should be enclosed in parenthesis
>> #243: FILE: bcm3510_priv.h:243:
>> --
>> ERROR: Macros with complex values should be enclosed in parenthesis
>> #244: FILE: bcm3510_priv.h:244:
>> --
>> ERROR: Macros with complex values should be enclosed in parenthesis
>> #245: FILE: bcm3510_priv.h:245:
>> --
>> ERROR: Macros with complex values should be enclosed in parenthesis
>> #246: FILE: bcm3510_priv.h:246:
>> --
>> ERROR: Macros with complex values should be enclosed in parenthesis
>> #247: FILE: bcm3510_priv.h:247:
>> --
>> ERROR: Macros with complex values should be enclosed in parenthesis
>> #33: FILE: cxd2820r_priv.h:33:
>> --
>> ERROR: Macros with complex values should be enclosed in parenthesis
>> #24: FILE: dib3000mb_priv.h:24:
>> --
>> ERROR: Macros with complex values should be enclosed in parenthesis
>> #34: FILE: hd29l2_priv.h:34:
>> --
>> ERROR: Macros with complex values should be enclosed in parenthesis
>> #30: FILE: rtl2830_priv.h:30:
>> --
>> ERROR: Macros with complex values should be enclosed in parenthesis
>> #30: FILE: rtl2832_priv.h:30:
>> […]
>> --
>> ERROR: Macros with complex values should be enclosed in parenthesis
>> #69: FILE: stb0899_priv.h:69:
>> […]
>> --
>> ERROR: Macros with complex values should be enclosed in parenthesis
>> #31: FILE: tda10071_priv.h:31:
>>
>> E voilà!
>>
>> cheers,
>> poma
>>
>> ps.
>> CHECKPATCH
>> M:      Andy Whitcroft <apw@canonical.com>
>> S:      Supported
>> F:      scripts/checkpatch.pl
> Thanks.
> What about your changes of printk to pr_*? Is that the right way to go for
> error messages and debuging?
> 
> Regards
> Thomas
> 

grep -R 'pr_info\|pr_warn\|pr_err' * > suggest-pr_level.txt
It's latest suggestion from 'checkpatch' and as you can see in
'suggest-pr_level.txt' already present. So far as I am concerned, give
it a go!
;)

cheers,
poma

--------------060709080306030803070501
Content-Type: text/plain; charset=UTF-8;
 name="suggest-pr_level.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="suggest-pr_level.txt"

media/dvb/bt8xx/dvb-bt8xx.c:			pr_err("No memory\n");
media/dvb/bt8xx/dvb-bt8xx.c:			pr_err("%s: Could not find a Twinhan DST\n", __func__);
media/dvb/bt8xx/dvb-bt8xx.c:		pr_err("A frontend driver was not found for device [%04x:%04x] subsystem [%04x:%04x]\n",
media/dvb/bt8xx/dvb-bt8xx.c:			pr_err("Frontend registration failed!\n");
media/dvb/bt8xx/dvb-bt8xx.c:		pr_err("dvb_register_adapter failed (errno = %d)\n", result);
media/dvb/bt8xx/dvb-bt8xx.c:		pr_err("dvb_dmx_init failed (errno = %d)\n", result);
media/dvb/bt8xx/dvb-bt8xx.c:		pr_err("dvb_dmxdev_init failed (errno = %d)\n", result);
media/dvb/bt8xx/dvb-bt8xx.c:		pr_err("dvb_dmx_init failed (errno = %d)\n", result);
media/dvb/bt8xx/dvb-bt8xx.c:		pr_err("dvb_dmx_init failed (errno = %d)\n", result);
media/dvb/bt8xx/dvb-bt8xx.c:		pr_err("dvb_dmx_init failed (errno = %d)\n", result);
media/dvb/bt8xx/dvb-bt8xx.c:		pr_err("dvb_net_init failed (errno = %d)\n", result);
media/dvb/bt8xx/dvb-bt8xx.c:		pr_err("Unknown bttv card type: %d\n", sub->core->type);
media/dvb/bt8xx/dvb-bt8xx.c:		pr_err("no pci device for card %d\n", card->bttv_nr);
media/dvb/bt8xx/dvb-bt8xx.c:		pr_err("unable to determine DMA core of card %d,\n", card->bttv_nr);
media/dvb/bt8xx/dvb-bt8xx.c:		pr_err("if you have the ALSA bt87x audio driver installed, try removing it.\n");
media/dvb/ttpci/av7110_v4l.c:		pr_info("DVB-C analog module @ card %d detected, initializing MSP3400\n",
media/dvb/ttpci/av7110_v4l.c:		pr_info("DVB-C analog module @ card %d detected, initializing MSP3415\n",
media/dvb/ttpci/av7110_v4l.c:		pr_info("saa7113 not accessible\n");
media/dvb/ttpci/budget-av.c:		pr_info("cam ejected 1\n");
media/dvb/ttpci/budget-av.c:		pr_info("cam ejected 2\n");
media/dvb/ttpci/budget-av.c:		pr_info("cam ejected 3\n");
media/dvb/ttpci/budget-av.c:		pr_info("cam ejected 5\n");
media/dvb/ttpci/budget-av.c:				pr_info("cam inserted A\n");
media/dvb/ttpci/budget-av.c:			pr_info("cam inserted B\n");
media/dvb/ttpci/budget-av.c:				pr_info("cam ejected 5\n");
media/dvb/ttpci/budget-av.c:		pr_err("ci initialisation failed\n");
media/dvb/ttpci/budget-av.c:	pr_info("ci interface initialised\n");
media/dvb/ttpci/budget-av.c:		pr_err("A frontend driver was not found for device [%04x:%04x] subsystem [%04x:%04x]\n",
media/dvb/ttpci/budget-av.c:		pr_err("Frontend registration failed!\n");
media/dvb/ttpci/budget-av.c:		pr_err("KNC1-%d: Could not read MAC from KNC1 card\n",
media/dvb/ttpci/budget-av.c:		pr_info("KNC1-%d: MAC addr = %pM\n",
media/dvb/ttusb-dec/ttusbdecfe.c:			pr_info("%s: returned unknown value: %d\n",
media/dvb/frontends/rtl2832.h:	pr_warn(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
media/dvb/frontends/rtl2830.h:	pr_warn(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
media/dvb/frontends/rtl2832_priv.h:		pr_info(KERN_INFO LOG_PREFIX": " f "\n" , ## arg)
media/dvb/frontends/rtl2832_priv.h:#define err(f, arg...) pr_err(KERN_ERR LOG_PREFIX": " f "\n" , ## arg)
media/dvb/frontends/rtl2832_priv.h:#define info(f, arg...) pr_info(KERN_INFO LOG_PREFIX": " f "\n" , ## arg)
media/dvb/frontends/rtl2832_priv.h:#define warn(f, arg...) pr_warn(KERN_WARNING LOG_PREFIX": " f "\n" , ## arg)
media/rc/redrat3.c:	pr_info("%s:\n", __func__);
media/rc/redrat3.c:	pr_info(" * length: %u, transfer_type: 0x%02x\n",
media/rc/redrat3.c:	pr_info(" * pause: %u, freq_count: %u, no_periods: %u\n",
media/rc/redrat3.c:	pr_info(" * lengths: %u (max: %u)\n",
media/rc/redrat3.c:	pr_info(" * sig_size: %u (max: %u)\n",
media/rc/redrat3.c:	pr_info(" * repeats: %u\n", header->no_repeats);
media/rc/redrat3.c:	pr_info("%s:", __func__);
media/rc/redrat3.c:		pr_err("%s called with no context!\n", __func__);
media/rc/redrat3.c:		pr_err("%s called with invalid context!\n", __func__);
media/rc/imon.c:		pr_err("could not find interface for minor %d\n", subminor);
media/rc/imon.c:		pr_err("no context found for minor %d\n", subminor);
media/rc/imon.c:		pr_err("display not supported by device\n");
media/rc/imon.c:		pr_err("display port is already open\n");
media/rc/imon.c:		pr_err("no context for device\n");
media/rc/imon.c:		pr_err("display not supported by device\n");
media/rc/imon.c:		pr_err("display is not open\n");
media/rc/imon.c:		pr_err_ratelimited("error submitting urb(%d)\n", retval);
media/rc/imon.c:			pr_err_ratelimited("task interrupted\n");
media/rc/imon.c:			pr_err_ratelimited("packet tx failed (%d)\n", retval);
media/rc/imon.c:		pr_err("no context for device\n");
media/rc/imon.c:		pr_err("no iMON device present\n");
media/rc/imon.c:		pr_err("no context for device\n");
media/rc/imon.c:			pr_err("send_packet failed for packet %d\n", i);
media/rc/imon.c:		pr_err_ratelimited("no context for device\n");
media/rc/imon.c:		pr_err_ratelimited("no iMON device present\n");
media/rc/imon.c:		pr_err_ratelimited("invalid payload size\n");
media/rc/imon.c:			pr_err_ratelimited("send packet #%d failed\n", seq / 2);
media/rc/imon.c:		pr_err_ratelimited("send packet #%d failed\n", seq / 2);
media/rc/imon.c:		pr_err_ratelimited("no context for device\n");
media/rc/imon.c:		pr_err_ratelimited("no iMON display present\n");
media/rc/imon.c:		pr_err_ratelimited("invalid payload size: %d (expected 8)\n",
media/rc/imon.c:		pr_err_ratelimited("send packet failed!\n");
media/rc/imon.c:		pr_err("no valid input (IR) endpoint found\n");
media/rc/imon.c:		pr_err("usb_submit_urb failed for intf0 (%d)\n", ret);
media/rc/imon.c:		pr_err("usb_alloc_urb failed for IR urb\n");
media/rc/imon.c:		pr_err("usb_submit_urb failed for intf1 (%d)\n", ret);
media/rc/imon.c:			pr_err("failed to initialize context!\n");
media/rc/imon.c:			pr_err("failed to attach to context!\n");
media/rc/imon.c:				pr_err("Could not create RF sysfs entries(%d)\n",
media/rc/winbond-cir.c:		pr_err("Invalid power-on protocol\n");
media/rc/winbond-cir.c:		pr_err("Unable to register driver\n");
media/rc/ene_ir.c:		pr_warn("device seems to be disabled\n");
media/rc/ene_ir.c:		pr_warn("send a mail to lirc-list@lists.sourceforge.net\n");
media/rc/ene_ir.c:		pr_warn("please attach output of acpidump and dmidecode\n");
media/rc/ene_ir.c:		pr_warn("chips 0x33xx aren't supported\n");
media/rc/ene_ir.c:	pr_warn("Error validating extra buffers, device probably won't work\n");
media/rc/ene_ir.c:		pr_warn("TX: transmitter cable isn't connected!\n");
media/rc/ene_ir.c:		pr_warn("TX: BUG: attempt to transmit NULL buffer\n");
media/rc/ene_ir.c:		pr_warn("Simulation of TX activated\n");
media/common/saa7146_i2c.c:			pr_warn("%s %s [irq]: timed out waiting for end of xfer\n",
media/common/saa7146_i2c.c:				pr_warn("%s %s: timed out waiting for MC2\n",
media/common/saa7146_i2c.c:				pr_warn("%s %s [poll]: timed out waiting for end of xfer\n",
media/common/saa7146_i2c.c:			pr_info("revision 0 error. this should never happen\n");
media/common/saa7146_fops.c:	pr_info("%s: registered device %s [v4l2]\n",
media/common/tuners/tda18212.c:		pr_info("%s: " fmt, __func__, ##arg);		\
media/common/tuners/tda18212.c:		pr_warn("i2c wr failed ret:%d reg:%02x len:%d\n",
media/common/tuners/tda18212.c:		pr_warn("i2c rd failed ret:%d reg:%02x len:%d\n",
media/common/tuners/tda18212.c:	pr_info("NXP TDA18212HN successfully identified\n");
media/common/tuners/tda18271-priv.h:#define tda_info(fmt, arg...)	pr_info(fmt, ##arg)
media/common/saa7146_core.c:	pr_info(" @ %li jiffies:\n", jiffies);
media/common/saa7146_core.c:		pr_info("0x%03x: 0x%08x\n", i, saa7146_read(dev, i));
media/common/saa7146_core.c:			pr_err("%s: %s timed out while waiting for registers getting programmed\n",
media/common/saa7146_core.c:			pr_err("%s: %s timed out while waiting for registers getting programmed\n",
media/common/saa7146_core.c:			pr_warn("%s: unexpected i2c irq: isr %08x psr %08x ssr %08x\n",
media/common/saa7146_core.c:	pr_info("found saa7146 @ mem %p (revision %d, irq %d) (0x%04x,0x%04x)\n",
media/common/saa7146_core.c:	pr_info("register extension '%s'\n", ext->name);
media/common/saa7146_core.c:	pr_info("unregister extension '%s'\n", ext->name);
media/radio/radio-wl1273.c:		pr_err("Cannot allocate memory for RDS buffer.\n");
media/radio/wl128x/fmdrv_rx.c:		pr_info("Frequency is set to (%d) but "
media/radio/radio-keene.c:		pr_err(KBUILD_MODNAME
media/video/usbvision/usbvision-video.c:		pr_err("%s: usb_get_intfdata() failed\n", __func__);
media/video/v4l2-subdev.c:		pr_info("%s: =================  START STATUS  =================\n",
media/video/v4l2-subdev.c:		pr_info("%s: ==================  END STATUS  ==================\n",
media/video/bt8xx/bttv-gpio.c:	pr_info("%d: add subdevice \"%s\"\n", core->nr, dev_name(&sub->dev));
media/video/bt8xx/bttv-i2c.c:		pr_info("%d: i2c: checking for %s @ 0x%02x... ",
media/video/bt8xx/bttv-i2c.c:			pr_warn("%d: i2c read 0x%x: error\n",
media/video/bt8xx/bttv-i2c.c:		pr_info("%s: i2c scan: found device @ 0x%x  [%s]\n",
media/video/bt8xx/bttv-driver.c:		pr_err("BUG! (btres)\n");
media/video/bt8xx/bttv-driver.c:			pr_info("%d: PLL can sleep, using XTAL (%d)\n",
media/video/bt8xx/bttv-driver.c:		pr_info("%d: Setting PLL: %d => %d (needs up to 100ms)\n",
media/video/bt8xx/bttv-driver.c:				pr_info("PLL set ok\n");
media/video/bt8xx/bttv-driver.c:		pr_info("Setting PLL failed\n");
media/video/bt8xx/bttv-driver.c:		pr_info("%d: reset, reinitialize\n", btv->c.nr);
media/video/bt8xx/bttv-driver.c:		pr_err("V4L2_BUF_TYPE_VIDEO_OVERLAY: no_overlay\n");
media/video/bt8xx/bttv-driver.c:		pr_err("V4L2_BUF_TYPE_VIDEO_OVERLAY: no_overlay\n");
media/video/bt8xx/bttv-driver.c:	pr_info("%s: risc disasm: %p [dma=0x%08lx]\n",
media/video/bt8xx/bttv-driver.c:		pr_info("%s:   0x%lx: ",
media/video/bt8xx/bttv-driver.c:			pr_info("%s:   0x%lx: 0x%08x [ arg #%d ]\n",
media/video/bt8xx/bttv-driver.c:	pr_info("  main: %08llx\n", (unsigned long long)btv->main.dma);
media/video/bt8xx/bttv-driver.c:	pr_info("  vbi : o=%08llx e=%08llx\n",
media/video/bt8xx/bttv-driver.c:	pr_info("  cap : o=%08llx e=%08llx\n",
media/video/bt8xx/bttv-driver.c:	pr_info("  scr : o=%08llx e=%08llx\n",
media/video/bt8xx/bttv-driver.c:	pr_warn("%d: irq: skipped frame [main=%lx,o_vbi=%lx,o_field=%lx,rc=%lx]\n",
media/video/bt8xx/bttv-driver.c:		pr_info("%d: timeout: drop=%d irq=%d/%d, risc=%08x, ",
media/video/bt8xx/bttv-driver.c:			pr_info("%d: %s%s @ %08x,",
media/video/bt8xx/bttv-driver.c:			pr_info("%d: FDSR @ %08x\n",
media/video/bt8xx/bttv-driver.c:				pr_err("%d: IRQ lockup, cleared int mask [",
media/video/bt8xx/bttv-driver.c:				pr_err("%d: IRQ lockup, clearing GPINT from int mask [",
media/video/bt8xx/bttv-driver.c:	pr_info("%d: registered device %s\n",
media/video/bt8xx/bttv-driver.c:		pr_err("%d: device_create_file 'card' failed\n", btv->c.nr);
media/video/bt8xx/bttv-driver.c:	pr_info("%d: registered device %s\n",
media/video/bt8xx/bttv-driver.c:	pr_info("%d: registered device %s\n",
media/video/bt8xx/bttv-driver.c:	pr_info("Bt8xx card found (%d)\n", bttv_num);
media/video/bt8xx/bttv-driver.c:		pr_err("out of memory\n");
media/video/bt8xx/bttv-driver.c:		pr_warn("%d: Can't enable device\n", btv->c.nr);
media/video/bt8xx/bttv-driver.c:		pr_warn("%d: No suitable DMA available\n", btv->c.nr);
media/video/bt8xx/bttv-driver.c:		pr_warn("%d: can't request iomem (0x%llx)\n",
media/video/bt8xx/bttv-driver.c:		pr_warn("%d: v4l2_device_register() failed\n", btv->c.nr);
media/video/bt8xx/bttv-driver.c:	pr_info("%d: Bt%d (rev %d) at %s, irq: %d, latency: %d, mmio: 0x%llx\n",
media/video/bt8xx/bttv-driver.c:		pr_err("%d: ioremap() failed\n", btv->c.nr);
media/video/bt8xx/bttv-driver.c:		pr_err("%d: can't get IRQ %d\n",
media/video/bt8xx/bttv-driver.c:		pr_info("%d: unloading\n", btv->c.nr);
media/video/bt8xx/bttv-driver.c:			pr_warn("%d: Can't enable device\n", btv->c.nr);
media/video/bt8xx/bttv-driver.c:		pr_warn("%d: Can't enable device\n", btv->c.nr);
media/video/bt8xx/bttv-driver.c:	pr_info("driver version %s loaded\n", BTTV_VERSION);
media/video/bt8xx/bttv-driver.c:		pr_info("using %d buffers with %dk (%d pages) each for capture\n",
media/video/bt8xx/bttv-driver.c:		pr_warn("bus_register error: %d\n", ret);
media/video/bt8xx/bttv-cards.c:			pr_info("%d: detected: %s [card=%d], PCI subsystem ID is %04x:%04x\n",
media/video/bt8xx/bttv-cards.c:			pr_info("%d: subsystem: %04x:%04x (UNKNOWN)\n",
media/video/bt8xx/bttv-cards.c:	pr_info("%d: using: %s [card=%d,%s]\n",
media/video/bt8xx/bttv-cards.c:	pr_info("%d: gpio config override: mask=0x%x, mux=",
media/video/bt8xx/bttv-cards.c:		pr_info("%d: detected by eeprom: %s [card=%d]\n",
media/video/bt8xx/bttv-cards.c:		pr_info("%d: FlyVideo_gpio: unknown tuner type\n", btv->c.nr);
media/video/bt8xx/bttv-cards.c:	pr_info("%d: FlyVideo Radio=%s RemoteControl=%s Tuner=%d gpio=0x%06x\n",
media/video/bt8xx/bttv-cards.c:	pr_info("%d: FlyVideo  LR90=%s tda9821/tda9820=%s capture_only=%s\n",
media/video/bt8xx/bttv-cards.c:		pr_info("%d: miro: id=%d tuner=%d radio=%s stereo=%s\n",
media/video/bt8xx/bttv-cards.c:		pr_info("%d: pinnacle/mt: id=%d info=\"%s\" radio=%s\n",
media/video/bt8xx/bttv-cards.c:			pr_info("%d: radio detected by subsystem id (CPH05x)\n",
media/video/bt8xx/bttv-cards.c:		pr_info("%d: tuner absent\n", btv->c.nr);
media/video/bt8xx/bttv-cards.c:		pr_warn("%d: tuner type unset\n", btv->c.nr);
media/video/bt8xx/bttv-cards.c:		pr_info("%d: tuner type=%d\n", btv->c.nr, btv->tuner_type);
media/video/bt8xx/bttv-cards.c:		pr_warn("%d: the autoload option is obsolete\n", btv->c.nr);
media/video/bt8xx/bttv-cards.c:		pr_warn("%d: use option msp3400, tda7432 or tvaudio to override which audio module should be used\n",
media/video/bt8xx/bttv-cards.c:		pr_warn("%d: unknown audiodev value!\n", btv->c.nr);
media/video/bt8xx/bttv-cards.c:	pr_warn("%d: audio absent, no audio device found!\n", btv->c.nr);
media/video/bt8xx/bttv-cards.c:		pr_info("%d: Modtec: Tuner autodetected by eeprom: %s\n",
media/video/bt8xx/bttv-cards.c:		pr_info("%d: Modtec: Tuner autodetected by eeprom: %s\n",
media/video/bt8xx/bttv-cards.c:		pr_info("%d: Modtec: Tuner autodetected by eeprom: %s\n",
media/video/bt8xx/bttv-cards.c:		pr_info("%d: Modtec: Unknown TunerString: %s\n",
media/video/bt8xx/bttv-cards.c:	pr_info("%d: Hauppauge eeprom indicates model#%d\n",
media/video/bt8xx/bttv-cards.c:		pr_info("%d: Switching board type from %s to %s\n",
media/video/bt8xx/bttv-cards.c:		pr_info("%d: Terratec Active Radio Upgrade found\n", btv->c.nr);
media/video/bt8xx/bttv-cards.c:		pr_warn("%d: no altera firmware [via hotplug]\n", btv->c.nr);
media/video/bt8xx/bttv-cards.c:	pr_info("%d: altera firmware upload %s\n",
media/video/bt8xx/bttv-cards.c:			pr_info("%d: osprey eeprom: unknown card type 0x%04x\n",
media/video/bt8xx/bttv-cards.c:	pr_info("%d: osprey eeprom: card=%d '%s' serial=%u\n",
media/video/bt8xx/bttv-cards.c:		pr_warn("%d: osprey eeprom: Not overriding user specified card type\n",
media/video/bt8xx/bttv-cards.c:		pr_info("%d: osprey eeprom: Changing card type from %d to %d\n",
media/video/bt8xx/bttv-cards.c:	pr_info("%d: Avermedia eeprom[0x%02x%02x]: tuner=",
media/video/bt8xx/bttv-cards.c:		pr_info("%d: Hauppauge/Voodoo msp34xx: reset line init [%d]\n",
media/video/bt8xx/bttv-cards.c:	pr_info("Setting DAC reference voltage level ...\n");
media/video/bt8xx/bttv-cards.c:	pr_info("Initialising 12C508 PIC chip ...\n");
media/video/bt8xx/bttv-cards.c:			pr_info("I2C Write(%2.2x) = %i\nI2C Read () = %2.2x\n\n",
media/video/bt8xx/bttv-cards.c:	pr_info("PXC200 Initialised\n");
media/video/bt8xx/bttv-cards.c:	pr_info("%d: Adlink RTV-24 initialisation in progress ...\n",
media/video/bt8xx/bttv-cards.c:		pr_info("%d: Adlink RTV-24 initialisation(1) ERROR_CPLD_Check_Failed (read %d)\n",
media/video/bt8xx/bttv-cards.c:		pr_info("%d: Adlink RTV-24 initialisation(2) ERROR_CPLD_Check_Failed (read %d)\n",
media/video/bt8xx/bttv-cards.c:	pr_info("%d: Adlink RTV-24 initialisation complete\n", btv->c.nr);
media/video/bt8xx/bttv-cards.c:		pr_warn("%d: tea5757: read timeout\n", btv->c.nr);
media/video/bt8xx/bttv-cards.c:		pr_info("Host bridge needs ETBF enabled\n");
media/video/bt8xx/bttv-cards.c:		pr_info("Host bridge needs VSFX enabled\n");
media/video/bt8xx/bttv-cards.c:		pr_info("bttv and your chipset may not work together\n");
media/video/bt8xx/bttv-cards.c:			pr_info("overlay will be disabled\n");
media/video/bt8xx/bttv-cards.c:			pr_info("overlay forced. Use this option at your own risk.\n");
media/video/bt8xx/bttv-cards.c:		pr_info("pci latency fixup [%d]\n", latency);
media/video/bt8xx/bttv-cards.c:			pr_info("Host bridge: 82441FX Natoma, bufcon=0x%02x\n",
media/video/bt8xx/bttv-cards.c:			pr_info("%d: enabling ETBF (430FX/VP3 compatibility)\n",
media/video/bt8xx/bttv-cards.c:			pr_info("%d: enabling VSFX\n", btv->c.nr);
media/video/bt8xx/bttv-cards.c:			pr_info("%d: setting pci timer to %d\n",
media/video/bt8xx/bttv-input.c:		pr_info(fmt, ##__VA_ARGS__);	\
media/video/bt8xx/bttv-input.c:			pr_info(DEVNAME ":"
media/video/cx25821/cx25821-audio-upstream.c:		pr_err("%s(): ERROR opening file(%s) with errno = %d!\n",
media/video/cx25821/cx25821-audio-upstream.c:			pr_err("%s(): File has no file operations registered!\n",
media/video/cx25821/cx25821-audio-upstream.c:			pr_err("%s(): File has no READ operations registered!\n",
media/video/cx25821/cx25821-audio-upstream.c:				pr_info("Done: exit %s() since no more bytes to read from Audio file\n",
media/video/cx25821/cx25821-audio-upstream.c:		pr_err("ERROR %s(): since container_of(work_struct) FAILED!\n",
media/video/cx25821/cx25821-audio-upstream.c:		pr_err("%s(): ERROR opening file(%s) with errno = %d!\n",
media/video/cx25821/cx25821-audio-upstream.c:			pr_err("%s(): File has no file operations registered!\n",
media/video/cx25821/cx25821-audio-upstream.c:			pr_err("%s(): File has no READ operations registered!\n",
media/video/cx25821/cx25821-audio-upstream.c:					pr_info("Done: exit %s() since no more bytes to read from Audio file\n",
media/video/cx25821/cx25821-audio-upstream.c:			pr_warn("%s(): Audio Received Overflow Error Interrupt!\n",
media/video/cx25821/cx25821-audio-upstream.c:			pr_warn("%s(): Audio Received Sync Error Interrupt!\n",
media/video/cx25821/cx25821-audio-upstream.c:			pr_warn("%s(): Audio Received OpCode Error Interrupt!\n",
media/video/cx25821/cx25821-audio-upstream.c:		pr_warn("EOF Channel Audio Framecount = %d\n",
media/video/cx25821/cx25821-audio-upstream.c:			pr_err("ERROR: %s() fifo is NOT turned on. Timeout!\n",
media/video/cx25821/cx25821-audio-upstream.c:		pr_err("%s: can't get upstream IRQ %d\n", dev->name,
media/video/cx25821/cx25821-audio-upstream.c:		pr_warn("Audio Channel is still running so return!\n");
media/video/cx25821/cx25821-audio-upstream.c:		pr_err("%s: Failed to set up Audio upstream buffers!\n",
media/video/cx25821/cx25821-video-upstream-ch2.c:		pr_info("No video file is currently running so return!\n");
media/video/cx25821/cx25821-video-upstream-ch2.c:		pr_err("%s(): ERROR opening file(%s) with errno = %d!\n",
media/video/cx25821/cx25821-video-upstream-ch2.c:			pr_err("%s(): File has no file operations registered!\n",
media/video/cx25821/cx25821-video-upstream-ch2.c:			pr_err("%s(): File has no READ operations registered!\n",
media/video/cx25821/cx25821-video-upstream-ch2.c:				pr_info("Done: exit %s() since no more bytes to read from Video file\n",
media/video/cx25821/cx25821-video-upstream-ch2.c:		pr_err("ERROR %s(): since container_of(work_struct) FAILED!\n",
media/video/cx25821/cx25821-video-upstream-ch2.c:		pr_err("%s(): ERROR opening file(%s) with errno = %d!\n",
media/video/cx25821/cx25821-video-upstream-ch2.c:			pr_err("%s(): File has no file operations registered!\n",
media/video/cx25821/cx25821-video-upstream-ch2.c:			pr_err("%s(): File has no READ operations registered!  Returning\n",
media/video/cx25821/cx25821-video-upstream-ch2.c:					pr_info("Done: exit %s() since no more bytes to read from Video file\n",
media/video/cx25821/cx25821-video-upstream-ch2.c:		pr_err("FAILED to allocate memory for Risc buffer! Returning\n");
media/video/cx25821/cx25821-video-upstream-ch2.c:		pr_err("FAILED to allocate memory for data buffer! Returning\n");
media/video/cx25821/cx25821-video-upstream-ch2.c:		pr_info("Failed creating Video Upstream Risc programs!\n");
media/video/cx25821/cx25821-video-upstream-ch2.c:		pr_info("EOF Channel 2 Framecount = %d\n",
media/video/cx25821/cx25821-video-upstream-ch2.c:		pr_err("%s: can't get upstream IRQ %d\n",
media/video/cx25821/cx25821-video-upstream-ch2.c:		pr_info("Video Channel is still running so return!\n");
media/video/cx25821/cx25821-video-upstream-ch2.c:		pr_err("create_singlethread_workqueue() for Video FAILED!\n");
media/video/cx25821/cx25821-video-upstream-ch2.c:		pr_err("%s: Failed to set up Video upstream buffers!\n",
media/video/cx25821/cx25821-video-upstream.c:		pr_info("No video file is currently running so return!\n");
media/video/cx25821/cx25821-video-upstream.c:		pr_err("%s(): ERROR opening file(%s) with errno = %d!\n",
media/video/cx25821/cx25821-video-upstream.c:			pr_err("%s(): File has no file operations registered!\n",
media/video/cx25821/cx25821-video-upstream.c:			pr_err("%s(): File has no READ operations registered!\n",
media/video/cx25821/cx25821-video-upstream.c:				pr_info("Done: exit %s() since no more bytes to read from Video file\n",
media/video/cx25821/cx25821-video-upstream.c:		pr_err("ERROR %s(): since container_of(work_struct) FAILED!\n",
media/video/cx25821/cx25821-video-upstream.c:		pr_err("%s(): ERROR opening file(%s) with errno = %d!\n",
media/video/cx25821/cx25821-video-upstream.c:			pr_err("%s(): File has no file operations registered!\n",
media/video/cx25821/cx25821-video-upstream.c:			pr_err("%s(): File has no READ operations registered!  Returning\n",
media/video/cx25821/cx25821-video-upstream.c:					pr_info("Done: exit %s() since no more bytes to read from Video file\n",
media/video/cx25821/cx25821-video-upstream.c:		pr_err("FAILED to allocate memory for Risc buffer! Returning\n");
media/video/cx25821/cx25821-video-upstream.c:		pr_err("FAILED to allocate memory for data buffer! Returning\n");
media/video/cx25821/cx25821-video-upstream.c:		pr_info("Failed creating Video Upstream Risc programs!\n");
media/video/cx25821/cx25821-video-upstream.c:			pr_err("%s(): Video Received Underflow Error Interrupt!\n",
media/video/cx25821/cx25821-video-upstream.c:			pr_err("%s(): Video Received Sync Error Interrupt!\n",
media/video/cx25821/cx25821-video-upstream.c:			pr_err("%s(): Video Received OpCode Error Interrupt!\n",
media/video/cx25821/cx25821-video-upstream.c:		pr_err("EOF Channel 1 Framecount = %d\n", dev->_frame_count);
media/video/cx25821/cx25821-video-upstream.c:		pr_err("%s: can't get upstream IRQ %d\n",
media/video/cx25821/cx25821-video-upstream.c:		pr_info("Video Channel is still running so return!\n");
media/video/cx25821/cx25821-video-upstream.c:		pr_err("create_singlethread_workqueue() for Video FAILED!\n");
media/video/cx25821/cx25821-video-upstream.c:		pr_err("%s: Failed to set up Video upstream buffers!\n",
media/video/cx25821/cx25821.h:	pr_err("(%d): " fmt, dev->board, ##args)
media/video/cx25821/cx25821.h:	pr_warn("(%d): " fmt, dev->board, ##args)
media/video/cx25821/cx25821.h:	pr_info("(%d): " fmt, dev->board, ##args)
media/video/cx25821/cx25821-alsa.c:		pr_info("%s/1: " fmt, chip->dev->name, ##arg);	\
media/video/cx25821/cx25821-alsa.c:	pr_info("DEBUG: Start audio DMA, %d B/line, cmds_start(0x%x)= %d lines/FIFO, %d periods, %d byte buffer\n",
media/video/cx25821/cx25821-alsa.c:		pr_warn("WARNING %s/1: Audio risc op code error\n", dev->name);
media/video/cx25821/cx25821-alsa.c:		pr_warn("WARNING %s: Downstream sync error!\n", dev->name);
media/video/cx25821/cx25821-alsa.c:		pr_err("DEBUG: cx25821 can't find device struct. Can't proceed with open\n");
media/video/cx25821/cx25821-alsa.c:		pr_info("DEBUG: ERROR after cx25821_risc_databuffer_audio()\n");
media/video/cx25821/cx25821-alsa.c:		pr_info("ERROR: FAILED snd_pcm_new() in %s\n", __func__);
media/video/cx25821/cx25821-alsa.c:		pr_info("DEBUG ERROR: devno >= SNDRV_CARDS %s\n", __func__);
media/video/cx25821/cx25821-alsa.c:		pr_info("DEBUG ERROR: !enable[devno] %s\n", __func__);
media/video/cx25821/cx25821-alsa.c:		pr_info("DEBUG ERROR: cannot create snd_card_new in %s\n",
media/video/cx25821/cx25821-alsa.c:		pr_err("ERROR %s: can't get IRQ %d for ALSA\n", chip->dev->name,
media/video/cx25821/cx25821-alsa.c:		pr_info("DEBUG ERROR: cannot create snd_cx25821_pcm %s\n",
media/video/cx25821/cx25821-alsa.c:	pr_info("%s/%i: ALSA support for cx25821 boards\n", card->driver,
media/video/cx25821/cx25821-alsa.c:		pr_info("DEBUG ERROR: cannot register sound card %s\n",
media/video/cx25821/cx25821-alsa.c:		pr_info("ERROR ALSA: no cx25821 cards found\n");
media/video/cx25821/cx25821-medusa-video.c:		pr_info("%s(): width %d > MAX_WIDTH %d ! resetting to MAX_WIDTH\n",
media/video/cx25821/cx25821-i2c.c:		pr_err(" ERR: %d\n", retval);
media/video/cx25821/cx25821-i2c.c:		pr_err(" ERR: %d\n", retval);
media/video/cx25821/cx25821-video.c:	pr_err("%s(0x%08x) NOT FOUND\n", __func__, fourcc);
media/video/cx25821/cx25821-video.c:		pr_err("%s: %d buffers handled (should be 1)\n", __func__, bc);
media/video/cx25821/cx25821-video.c:		pr_warn("%s, %s: video risc op code error\n",
media/video/cx25821/cx25821-video.c:		pr_warn("device %d released!\n", chan_num);
media/video/cx25821/cx25821-video.c:	pr_info("%s/2: ============  START LOG STATUS  ============\n",
media/video/cx25821/cx25821-video.c:	pr_info("Video input 0 is %s\n",
media/video/cx25821/cx25821-video.c:	pr_info("%s/2: =============  END LOG STATUS  =============\n",
media/video/cx25821/cx25821-video.c:		pr_err("Invalid fh pointer!\n");
media/video/cx25821/cx25821-video.c:		pr_err("%s(): Upstream data is INVALID. Returning\n", __func__);
media/video/cx25821/cx25821-video.c:		pr_err("%s(): Upstream data is INVALID. Returning\n", __func__);
media/video/cx25821/cx25821-video.c:		pr_err("%s(): Upstream data is INVALID. Returning\n", __func__);
media/video/cx25821/cx25821-video.c:		pr_err("%s(): User data is INVALID. Returning\n", __func__);
media/video/cx25821/cx25821-core.c:	pr_warn("%s: %s - dma channel status dump\n", dev->name, ch->name);
media/video/cx25821/cx25821-core.c:		pr_warn("cmds + 0x%2x:   %-15s: 0x%08x\n",
media/video/cx25821/cx25821-core.c:		pr_warn("cmds + 0x%2x:   risc%d: ", j + i * 4, i);
media/video/cx25821/cx25821-core.c:		pr_warn("ctrl + 0x%2x (0x%08x): iq %x: ",
media/video/cx25821/cx25821-core.c:			pr_warn("ctrl + 0x%2x :   iq %x: 0x%08x [ arg #%d ]\n",
media/video/cx25821/cx25821-core.c:	pr_warn("        :   fifo: 0x%08x -> 0x%x\n",
media/video/cx25821/cx25821-core.c:	pr_warn("        :   ctrl: 0x%08x -> 0x%x\n",
media/video/cx25821/cx25821-core.c:	pr_warn("        :   ptr1_reg: 0x%08x\n",
media/video/cx25821/cx25821-core.c:	pr_warn("        :   ptr2_reg: 0x%08x\n",
media/video/cx25821/cx25821-core.c:	pr_warn("        :   cnt1_reg: 0x%08x\n",
media/video/cx25821/cx25821-core.c:	pr_warn("        :   cnt2_reg: 0x%08x\n",
media/video/cx25821/cx25821-core.c:	pr_info("\n%s: %s - dma Audio channel status dump\n",
media/video/cx25821/cx25821-core.c:		pr_info("%s: cmds + 0x%2x:   %-15s: 0x%08x\n",
media/video/cx25821/cx25821-core.c:		pr_warn("cmds + 0x%2x:   risc%d: ", j + i * 4, i);
media/video/cx25821/cx25821-core.c:		pr_warn("ctrl + 0x%2x (0x%08x): iq %x: ",
media/video/cx25821/cx25821-core.c:			pr_warn("ctrl + 0x%2x :   iq %x: 0x%08x [ arg #%d ]\n",
media/video/cx25821/cx25821-core.c:	pr_warn("        :   fifo: 0x%08x -> 0x%x\n",
media/video/cx25821/cx25821-core.c:	pr_warn("        :   ctrl: 0x%08x -> 0x%x\n",
media/video/cx25821/cx25821-core.c:	pr_warn("        :   ptr1_reg: 0x%08x\n",
media/video/cx25821/cx25821-core.c:	pr_warn("        :   ptr2_reg: 0x%08x\n",
media/video/cx25821/cx25821-core.c:	pr_warn("        :   cnt1_reg: 0x%08x\n",
media/video/cx25821/cx25821-core.c:	pr_warn("        :   cnt2_reg: 0x%08x\n",
media/video/cx25821/cx25821-core.c:		pr_warn("instruction %d = 0x%x\n", i, risc);
media/video/cx25821/cx25821-core.c:	pr_warn("\nread cdt loc=0x%x\n", risc);
media/video/cx25821/cx25821-core.c:	pr_err("%s: can't get MMIO memory @ 0x%llx\n",
media/video/cx25821/cx25821-core.c:	pr_info("%s(): Hardware revision = 0x%02x\n",
media/video/cx25821/cx25821-core.c:	pr_info("\n***********************************\n");
media/video/cx25821/cx25821-core.c:	pr_info("cx25821 set up\n");
media/video/cx25821/cx25821-core.c:	pr_info("***********************************\n\n");
media/video/cx25821/cx25821-core.c:		pr_info("%s(): Exiting. Incorrect Hardware device = 0x%02x\n",
media/video/cx25821/cx25821-core.c:		pr_info("Athena Hardware device = 0x%02x\n", dev->pci->device);
media/video/cx25821/cx25821-core.c:		pr_err("%s: No more PCIe resources for subsystem: %04x:%04x\n",
media/video/cx25821/cx25821-core.c:	pr_info("%s: subsystem: %04x:%04x, board: %s [card=%d,%s]\n",
media/video/cx25821/cx25821-core.c:		pr_err("%s(): Failed to register video adapter for IOCTL, so unregistering videoioctl device\n",
media/video/cx25821/cx25821-core.c:		pr_info("pci enable failed!\n");
media/video/cx25821/cx25821-core.c:	pr_info("Athena pci enable !\n");
media/video/cx25821/cx25821-core.c:	pr_info("%s/0: found at %s, rev: %d, irq: %d, latency: %d, mmio: 0x%llx\n",
media/video/cx25821/cx25821-core.c:		pr_err("%s/0: Oops: no 32bit PCI DMA ???\n", dev->name);
media/video/cx25821/cx25821-core.c:		pr_err("%s: can't get IRQ %d\n", dev->name, pci_dev->irq);
media/video/cx25821/cx25821-core.c:	pr_info("cx25821_initdev() can't get IRQ !\n");
media/video/cx25821/cx25821-core.c:	pr_info("driver version %d.%d.%d loaded\n",
media/video/sh_vou.c:		pr_warning("%s(): Invalid bus-format code %d, using default 8-bit\n",
media/video/v4l2-ioctl.c.orig:			pr_info("%s: =================  START STATUS  =================\n",
media/video/v4l2-ioctl.c.orig:			pr_info("%s: ==================  END STATUS  ==================\n",
media/video/blackfin/ppi.c:		pr_err("Unable to allocate DMA channel for PPI\n");
media/video/blackfin/ppi.c:			pr_err("Unable to allocate IRQ for PPI\n");
media/video/blackfin/ppi.c:		pr_err("request peripheral failed\n");
media/video/blackfin/ppi.c:		pr_err("unable to allocate memory for ppi handle\n");
media/video/blackfin/ppi.c:	pr_info("ppi probe success\n");
media/video/gspca/sn9c20x.c:		pr_err("Read register %02x failed %d\n", reg, result);
media/video/gspca/sn9c20x.c:		pr_err("Write register %02x failed %d\n", reg, result);
media/video/gspca/sn9c20x.c:				pr_err("i2c_w error\n");
media/video/gspca/sn9c20x.c:	pr_err("i2c_w reg %02x no response\n", buffer[2]);
media/video/gspca/sn9c20x.c:		pr_err("sensor id for ov9650 doesn't match (0x%04x)\n", id);
media/video/gspca/sn9c20x.c:		pr_err("OV9650 sensor initialization failed\n");
media/video/gspca/sn9c20x.c:		pr_err("OV9655 sensor initialization failed\n");
media/video/gspca/sn9c20x.c:		pr_err("SOI968 sensor initialization failed\n");
media/video/gspca/sn9c20x.c:		pr_err("OV7660 sensor initialization failed\n");
media/video/gspca/sn9c20x.c:		pr_err("OV7670 sensor initialization failed\n");
media/video/gspca/sn9c20x.c:			pr_err("MT9V011 sensor initialization failed\n");
media/video/gspca/sn9c20x.c:		pr_info("MT9V011 sensor detected\n");
media/video/gspca/sn9c20x.c:			pr_err("MT9V111 sensor initialization failed\n");
media/video/gspca/sn9c20x.c:		pr_info("MT9V111 sensor detected\n");
media/video/gspca/sn9c20x.c:			pr_err("MT9V112 sensor initialization failed\n");
media/video/gspca/sn9c20x.c:		pr_info("MT9V112 sensor detected\n");
media/video/gspca/sn9c20x.c:		pr_err("MT9M112 sensor initialization failed\n");
media/video/gspca/sn9c20x.c:		pr_err("MT9M111 sensor initialization failed\n");
media/video/gspca/sn9c20x.c:		pr_info("MT9M001 color sensor detected\n");
media/video/gspca/sn9c20x.c:		pr_info("MT9M001 mono sensor detected\n");
media/video/gspca/sn9c20x.c:		pr_err("No MT9M001 chip detected, ID = %x\n\n", id);
media/video/gspca/sn9c20x.c:		pr_err("MT9M001 sensor initialization failed\n");
media/video/gspca/sn9c20x.c:		pr_err("HV7131R Sensor initialization failed\n");
media/video/gspca/sn9c20x.c:		pr_err("Could not initialize controls\n");
media/video/gspca/sn9c20x.c:			pr_err("Device initialization failed\n");
media/video/gspca/sn9c20x.c:		pr_err("Device initialization failed\n");
media/video/gspca/sn9c20x.c:		pr_info("OV9650 sensor detected\n");
media/video/gspca/sn9c20x.c:		pr_info("OV9655 sensor detected\n");
media/video/gspca/sn9c20x.c:		pr_info("SOI968 sensor detected\n");
media/video/gspca/sn9c20x.c:		pr_info("OV7660 sensor detected\n");
media/video/gspca/sn9c20x.c:		pr_info("OV7670 sensor detected\n");
media/video/gspca/sn9c20x.c:		pr_info("MT9VPRB sensor detected\n");
media/video/gspca/sn9c20x.c:		pr_info("MT9M111 sensor detected\n");
media/video/gspca/sn9c20x.c:		pr_info("MT9M112 sensor detected\n");
media/video/gspca/sn9c20x.c:		pr_info("HV7131R sensor detected\n");
media/video/gspca/sn9c20x.c:		pr_err("Unsupported sensor\n");
media/video/gspca/sn9c20x.c:			pr_warn("sn9c20x camera with unknown number of alt "
media/video/gspca/sn9c20x.c:		pr_info("Set 1280x1024\n");
media/video/gspca/sn9c20x.c:		pr_info("Set 640x480\n");
media/video/gspca/sn9c20x.c:		pr_info("Set 320x240\n");
media/video/gspca/sn9c20x.c:		pr_info("Set 160x120\n");
media/video/gspca/sq905.c:		pr_err("%s: usb_control_msg failed (%d)\n", __func__, ret);
media/video/gspca/sq905.c:		pr_err("%s: usb_control_msg failed 2 (%d)\n", __func__, ret);
media/video/gspca/sq905.c:		pr_err("%s: usb_control_msg failed (%d)\n", __func__, ret);
media/video/gspca/sq905.c:		pr_err("%s: usb_control_msg failed (%d)\n", __func__, ret);
media/video/gspca/sq905.c:		pr_err("bulk read fail (%d) len %d/%d\n", ret, act_len, size);
media/video/gspca/sq905.c:		pr_err("Couldn't allocate USB buffer\n");
media/video/gspca/vicam.c:		pr_err("control msg req %02X error %d\n", request, ret);
media/video/gspca/vicam.c:		pr_err("bulk read fail (%d) len %d/%d\n",
media/video/gspca/vicam.c:		pr_err("Couldn't allocate USB buffer\n");
media/video/gspca/vicam.c:		pr_err("Failed to load \"vicam/firmware.fw\": %d\n", ret);
media/video/gspca/sn9c2028.c:		pr_err("command write [%02x] error %d\n",
media/video/gspca/sn9c2028.c:		pr_err("read1 error %d\n", rc);
media/video/gspca/sn9c2028.c:		pr_err("read4 error %d\n", rc);
media/video/gspca/sn9c2028.c:		pr_err("long command status read error %d\n", status);
media/video/gspca/sn9c2028.c:		pr_err("Starting unknown camera, please report this\n");
media/video/gspca/jl2005bcd.c:		pr_err("command write [%02x] error %d\n",
media/video/gspca/jl2005bcd.c:		pr_err("read command [0x%02x] error %d\n",
media/video/gspca/jl2005bcd.c:		pr_err("Couldn't allocate USB buffer\n");
media/video/gspca/jl2005bcd.c:				pr_err("First block is not the first block\n");
media/video/gspca/jl2005bcd.c:		pr_err("Unknown resolution specified\n");
media/video/gspca/spca508.c:		pr_err("reg write: error %d\n", ret);
media/video/gspca/spca508.c:		pr_err("reg_read err %d\n", ret);
media/video/gspca/ov519.c:		pr_err("reg_w %02x failed %d\n", index, ret);
media/video/gspca/ov519.c:		pr_err("reg_r %02x failed %d\n", index, ret);
media/video/gspca/ov519.c:		pr_err("reg_r8 %02x failed %d\n", index, ret);
media/video/gspca/ov519.c:		pr_err("reg_w32 %02x failed %d\n", index, ret);
media/video/gspca/ov519.c:		pr_err("ovfx2_i2c_w %02x failed %d\n", reg, ret);
media/video/gspca/ov519.c:		pr_err("ovfx2_i2c_r %02x failed %d\n", reg, ret);
media/video/gspca/ov519.c:		pr_err("error hires sensors only supported with ovfx2\n");
media/video/gspca/ov519.c:	pr_err("Error unknown sensor type: %02x%02x\n", high, low);
media/video/gspca/ov519.c:		pr_err("Unknown image sensor version: %d\n", rc & 3);
media/video/gspca/ov519.c:		pr_err("Error detecting sensor type\n");
media/video/gspca/ov519.c:			pr_err("Error detecting camera chip PID\n");
media/video/gspca/ov519.c:			pr_err("Error detecting camera chip VER\n");
media/video/gspca/ov519.c:				pr_err("Sensor is an OV7630/OV7635\n");
media/video/gspca/ov519.c:				pr_err("7630 is not supported by this driver\n");
media/video/gspca/ov519.c:				pr_err("Unknown sensor: 0x76%02x\n", low);
media/video/gspca/ov519.c:		pr_err("Unknown image sensor version: %d\n", rc & 3);
media/video/gspca/ov519.c:		pr_err("Error detecting sensor type\n");
media/video/gspca/ov519.c:		pr_warn("WARNING: Sensor is an OV66308. Your camera may have been misdetected in previous driver versions.\n");
media/video/gspca/ov519.c:		pr_warn("WARNING: Sensor is an OV66307. Your camera may have been misdetected in previous driver versions.\n");
media/video/gspca/ov519.c:		pr_err("FATAL: Unknown sensor version: 0x%02x\n", rc);
media/video/gspca/ov519.c:		pr_err("Can't determine sensor slave IDs\n");
media/video/gspca/ov519.c:		pr_err("Couldn't get altsetting\n");
media/video/gspca/ov519.c:		pr_err("Couldn't get altsetting\n");
media/video/gspca/finepix.c:		pr_err("init failed %d\n", ret);
media/video/gspca/finepix.c:		pr_err("usb_bulk_msg failed %d\n", ret);
media/video/gspca/finepix.c:		pr_err("frame request failed %d\n", ret);
media/video/gspca/sq905c.c:		pr_err("%s: usb_control_msg failed (%d)\n", __func__, ret);
media/video/gspca/sq905c.c:		pr_err("%s: usb_control_msg failed (%d)\n", __func__, ret);
media/video/gspca/sq905c.c:		pr_err("Couldn't allocate USB buffer\n");
media/video/gspca/spca501.c:		pr_err("reg write: error %d\n", ret);
media/video/gspca/mr97310a.c:		pr_err("reg write [%02x] error %d\n",
media/video/gspca/mr97310a.c:		pr_err("reg read [%02x] error %d\n",
media/video/gspca/mr97310a.c:			pr_err("Unknown CIF Sensor id : %02x\n",
media/video/gspca/mr97310a.c:			pr_err("Unknown VGA Sensor id Byte 0: %02x\n",
media/video/gspca/mr97310a.c:			pr_err("Defaults assumed, may not work\n");
media/video/gspca/mr97310a.c:			pr_err("Please report this\n");
media/video/gspca/mr97310a.c:				pr_err("Unknown VGA Sensor id Byte 1: %02x\n",
media/video/gspca/mr97310a.c:				pr_err("Defaults assumed, may not work\n");
media/video/gspca/mr97310a.c:				pr_err("Please report this\n");
media/video/gspca/conex.c:		pr_err("reg_r: buffer overflow\n");
media/video/gspca/conex.c:		pr_err("reg_w: buffer overflow\n");
media/video/gspca/t613.c:			pr_err("Out of memory\n");
media/video/gspca/t613.c:			pr_err("Out of memory\n");
media/video/gspca/t613.c:		pr_err("Bad sensor reset %02x\n", byte);
media/video/gspca/t613.c:		pr_err("unknown sensor %04x\n", sensor_id);
media/video/gspca/t613.c:			pr_err("Bad sensor reset %02x\n", test_byte);
media/video/gspca/spca561.c:		pr_err("reg write: error %d\n", ret);
media/video/gspca/gspca.c:			pr_err("Resubmit URB failed with error %i\n", ret);
media/video/gspca/gspca.c:			pr_err("Input device registration failed with error %i\n",
media/video/gspca/gspca.c:			pr_err("ISOC data error: [%d] len=%d, status=%d\n",
media/video/gspca/gspca.c:		pr_err("usb_submit_urb() ret %d\n", st);
media/video/gspca/gspca.c:			pr_err("usb_submit_urb() ret %d\n", st);
media/video/gspca/gspca.c:				pr_err("gspca_frame_add() image == NULL\n");
media/video/gspca/gspca.c:		pr_err("frame alloc failed\n");
media/video/gspca/gspca.c:		pr_err("set alt 0 err %d\n", ret);
media/video/gspca/gspca.c:				pr_err("alt %d iso endp with 0 interval\n", j);
media/video/gspca/gspca.c:			pr_err("usb_alloc_urb failed\n");
media/video/gspca/gspca.c:			pr_err("usb_alloc_coherent failed\n");
media/video/gspca/gspca.c:			pr_err("bad altsetting %d\n", gspca_dev->alt);
media/video/gspca/gspca.c:			pr_err("no transfer endpoint found\n");
media/video/gspca/gspca.c:					pr_err("set alt %d err %d\n", alt, ret);
media/video/gspca/gspca.c:			pr_err("usb_submit_urb alt %d err %d\n",
media/video/gspca/gspca.c:				pr_err("no transfer endpoint found\n");
media/video/gspca/gspca.c:	pr_info("%s-" GSPCA_VERSION " probing %04x:%04x\n",
media/video/gspca/gspca.c:		pr_err("couldn't kzalloc gspca struct\n");
media/video/gspca/gspca.c:		pr_err("out of memory\n");
media/video/gspca/gspca.c:		pr_err("video_register_device err %d\n", ret);
media/video/gspca/gspca.c:		pr_err("%04x:%04x too many config\n",
media/video/gspca/gspca.c:	pr_info("v" GSPCA_VERSION " registered\n");
media/video/gspca/spca505.c:		pr_err("reg write: error %d\n", ret);
media/video/gspca/spca505.c:		pr_err("After vector read returns 0x%04x should be 0x0101\n",
media/video/gspca/kinect.c:		pr_err("send_cmd: Invalid command length (0x%x)\n", cmd_len);
media/video/gspca/kinect.c:		pr_err("send_cmd: Output control transfer failed (%d)\n", res);
media/video/gspca/kinect.c:		pr_err("send_cmd: Input control transfer failed (%d)\n", res);
media/video/gspca/kinect.c:		pr_err("send_cmd: Bad magic %02x %02x\n",
media/video/gspca/kinect.c:		pr_err("send_cmd: Bad cmd %02x != %02x\n",
media/video/gspca/kinect.c:		pr_err("send_cmd: Bad tag %04x != %04x\n",
media/video/gspca/kinect.c:		pr_err("send_cmd: Bad len %04x != %04x\n",
media/video/gspca/kinect.c:		pr_warn("send_cmd: Data buffer is %d bytes long, but got %d bytes\n",
media/video/gspca/kinect.c:		pr_warn("send_cmd returned %d [%04x %04x], 0000 expected\n",
media/video/gspca/kinect.c:		pr_warn("[Stream %02x] Invalid magic %02x%02x\n",
media/video/gspca/kinect.c:		pr_warn("Packet type not recognized...\n");
media/video/gspca/nw80x.c:		pr_err("reg_w err %d\n", ret);
media/video/gspca/nw80x.c:		pr_err("reg_r err %d\n", ret);
media/video/gspca/nw80x.c:		pr_err("Bad webcam type %d for NW80%d\n",
media/video/gspca/konica.c:		pr_err("reg_w err %d\n", ret);
media/video/gspca/konica.c:		pr_err("reg_w err %d\n", ret);
media/video/gspca/konica.c:		pr_err("Couldn't get altsetting\n");
media/video/gspca/konica.c:			pr_err("usb_alloc_urb failed\n");
media/video/gspca/konica.c:			pr_err("usb_buffer_alloc failed\n");
media/video/gspca/konica.c:			pr_err("resubmit urb error %d\n", st);
media/video/gspca/konica.c:		pr_err("usb_submit_urb(status_urb) ret %d\n", st);
media/video/gspca/ov534.c:		pr_err("write failed %d\n", ret);
media/video/gspca/ov534.c:		pr_err("read failed %d\n", ret);
media/video/gspca/ov534.c:		pr_err("sccb_reg_write failed\n");
media/video/gspca/ov534.c:		pr_err("sccb_reg_read failed 1\n");
media/video/gspca/ov534.c:		pr_err("sccb_reg_read failed 2\n");
media/video/gspca/pac207.c:		pr_err("Failed to write registers to index 0x%04X, error %d\n",
media/video/gspca/pac207.c:		pr_err("Failed to write a register (index 0x%04X, value 0x%02X, error %d)\n",
media/video/gspca/pac207.c:		pr_err("Failed to read a register (index 0x%04X, error %d)\n",
media/video/gspca/pac207.c:		pr_err("Could not initialize controls\n");
media/video/gspca/pac7302.c:		pr_err("reg_w_buf failed i: %02x error %d\n",
media/video/gspca/pac7302.c:		pr_err("reg_w() failed i: %02x v: %02x error %d\n",
media/video/gspca/pac7302.c:			pr_err("reg_w_page() failed i: %02x v: %02x error %d\n",
media/video/gspca/pac7311.c.orig:		pr_err("reg_w_buf() failed index 0x%02x, error %d\n",
media/video/gspca/pac7311.c.orig:		pr_err("reg_w() failed index 0x%02x, value 0x%02x, error %d\n",
media/video/gspca/pac7311.c.orig:			pr_err("reg_w_page() failed index 0x%02x, value 0x%02x, error %d\n",
media/video/gspca/pac7311.c.orig:		pr_err("Could not initialize controls\n");
media/video/gspca/ov534_9.c:		pr_err("reg_w failed %d\n", ret);
media/video/gspca/ov534_9.c:		pr_err("reg_r err %d\n", ret);
media/video/gspca/ov534_9.c:		pr_err("sccb_write failed\n");
media/video/gspca/ov534_9.c:		pr_err("sccb_read failed 1\n");
media/video/gspca/ov534_9.c:		pr_err("sccb_read failed 2\n");
media/video/gspca/spca500.c:		pr_err("reg write: error %d\n", ret);
media/video/gspca/spca500.c:		pr_err("reg_r_12 err %d\n", ret);
media/video/gspca/jeilinj.c:		pr_err("command write [%02x] error %d\n",
media/video/gspca/jeilinj.c:		pr_err("read command [%02x] error %d\n",
media/video/gspca/cpia1.c:		pr_err("usb_control_msg %02x, error %d\n", command[1], ret);
media/video/gspca/cpia1.c:		pr_err("ReadVPRegs(30,4,9,8) - failed: %d\n", ret);
media/video/gspca/m5602/m5602_core.c:		pr_info("ALi m5602 address 0x%x contains 0x%x\n", i, val);
media/video/gspca/m5602/m5602_core.c:	pr_info("Warning: The ALi m5602 webcam probably won't work until it's power cycled\n");
media/video/gspca/m5602/m5602_core.c:	pr_info("Failed to find a sensor\n");
media/video/gspca/m5602/m5602_po1030.c:			pr_info("Forcing a %s sensor\n", po1030.name);
media/video/gspca/m5602/m5602_po1030.c:		pr_info("Detected a po1030 sensor\n");
media/video/gspca/m5602/m5602_po1030.c:			pr_info("Invalid stream command, exiting init\n");
media/video/gspca/m5602/m5602_po1030.c:	pr_info("Dumping the po1030 sensor core registers\n");
media/video/gspca/m5602/m5602_po1030.c:		pr_info("register 0x%x contains 0x%x\n", address, value);
media/video/gspca/m5602/m5602_po1030.c:	pr_info("po1030 register state dump complete\n");
media/video/gspca/m5602/m5602_po1030.c:	pr_info("Probing for which registers that are read/write\n");
media/video/gspca/m5602/m5602_po1030.c:			pr_info("register 0x%x is writeable\n", address);
media/video/gspca/m5602/m5602_po1030.c:			pr_info("register 0x%x is read only\n", address);
media/video/gspca/m5602/m5602_ov7660.c:			pr_info("Forcing an %s sensor\n", ov7660.name);
media/video/gspca/m5602/m5602_ov7660.c:	pr_info("Sensor reported 0x%x%x\n", prod_id, ver_id);
media/video/gspca/m5602/m5602_ov7660.c:		pr_info("Detected a ov7660 sensor\n");
media/video/gspca/m5602/m5602_ov7660.c:	pr_info("Dumping the ov7660 register state\n");
media/video/gspca/m5602/m5602_ov7660.c:		pr_info("register 0x%x contains 0x%x\n", address, value);
media/video/gspca/m5602/m5602_ov7660.c:	pr_info("ov7660 register state dump complete\n");
media/video/gspca/m5602/m5602_ov7660.c:	pr_info("Probing for which registers that are read/write\n");
media/video/gspca/m5602/m5602_ov7660.c:			pr_info("register 0x%x is writeable\n", address);
media/video/gspca/m5602/m5602_ov7660.c:			pr_info("register 0x%x is read only\n", address);
media/video/gspca/m5602/m5602_s5k4aa.c:			pr_info("Forcing a %s sensor\n", s5k4aa.name);
media/video/gspca/m5602/m5602_s5k4aa.c:			pr_info("Invalid stream command, exiting init\n");
media/video/gspca/m5602/m5602_s5k4aa.c:		pr_info("Detected a s5k4aa sensor\n");
media/video/gspca/m5602/m5602_s5k4aa.c:				pr_err("Invalid stream command, exiting init\n");
media/video/gspca/m5602/m5602_s5k4aa.c:				pr_err("Invalid stream command, exiting init\n");
media/video/gspca/m5602/m5602_s5k4aa.c:			pr_info("Invalid stream command, exiting init\n");
media/video/gspca/m5602/m5602_s5k4aa.c:		pr_info("Dumping the s5k4aa register state for page 0x%x\n",
media/video/gspca/m5602/m5602_s5k4aa.c:			pr_info("register 0x%x contains 0x%x\n",
media/video/gspca/m5602/m5602_s5k4aa.c:	pr_info("s5k4aa register state dump complete\n");
media/video/gspca/m5602/m5602_s5k4aa.c:		pr_info("Probing for which registers that are read/write for page 0x%x\n",
media/video/gspca/m5602/m5602_s5k4aa.c:				pr_info("register 0x%x is writeable\n",
media/video/gspca/m5602/m5602_s5k4aa.c:				pr_info("register 0x%x is read only\n",
media/video/gspca/m5602/m5602_s5k4aa.c:	pr_info("Read/write register probing complete\n");
media/video/gspca/m5602/m5602_mt9m111.c:			pr_info("Forcing a %s sensor\n", mt9m111.name);
media/video/gspca/m5602/m5602_mt9m111.c:		pr_info("Detected a mt9m111 sensor\n");
media/video/gspca/m5602/m5602_mt9m111.c:	pr_info("Dumping the mt9m111 register state\n");
media/video/gspca/m5602/m5602_mt9m111.c:	pr_info("Dumping the mt9m111 sensor core registers\n");
media/video/gspca/m5602/m5602_mt9m111.c:		pr_info("register 0x%x contains 0x%x%x\n",
media/video/gspca/m5602/m5602_mt9m111.c:	pr_info("Dumping the mt9m111 color pipeline registers\n");
media/video/gspca/m5602/m5602_mt9m111.c:		pr_info("register 0x%x contains 0x%x%x\n",
media/video/gspca/m5602/m5602_mt9m111.c:	pr_info("Dumping the mt9m111 camera control registers\n");
media/video/gspca/m5602/m5602_mt9m111.c:		pr_info("register 0x%x contains 0x%x%x\n",
media/video/gspca/m5602/m5602_mt9m111.c:	pr_info("mt9m111 register state dump complete\n");
media/video/gspca/m5602/m5602_ov9650.c:			pr_info("Forcing an %s sensor\n", ov9650.name);
media/video/gspca/m5602/m5602_ov9650.c:		pr_info("Detected an ov9650 sensor\n");
media/video/gspca/m5602/m5602_ov9650.c:	pr_info("Dumping the ov9650 register state\n");
media/video/gspca/m5602/m5602_ov9650.c:		pr_info("register 0x%x contains 0x%x\n", address, value);
media/video/gspca/m5602/m5602_ov9650.c:	pr_info("ov9650 register state dump complete\n");
media/video/gspca/m5602/m5602_ov9650.c:	pr_info("Probing for which registers that are read/write\n");
media/video/gspca/m5602/m5602_ov9650.c:			pr_info("register 0x%x is writeable\n", address);
media/video/gspca/m5602/m5602_ov9650.c:			pr_info("register 0x%x is read only\n", address);
media/video/gspca/m5602/m5602_s5k83a.c:			pr_info("Forcing a %s sensor\n", s5k83a.name);
media/video/gspca/m5602/m5602_s5k83a.c:		pr_info("Detected a s5k83a sensor\n");
media/video/gspca/m5602/m5602_s5k83a.c:			pr_info("Invalid stream command, exiting init\n");
media/video/gspca/m5602/m5602_s5k83a.c:			pr_info("Camera was flipped\n");
media/video/gspca/m5602/m5602_s5k83a.c:		pr_info("Dumping the s5k83a register state for page 0x%x\n",
media/video/gspca/m5602/m5602_s5k83a.c:			pr_info("register 0x%x contains 0x%x\n", address, val);
media/video/gspca/m5602/m5602_s5k83a.c:	pr_info("s5k83a register state dump complete\n");
media/video/gspca/m5602/m5602_s5k83a.c:		pr_info("Probing for which registers that are read/write for page 0x%x\n",
media/video/gspca/m5602/m5602_s5k83a.c:				pr_info("register 0x%x is writeable\n",
media/video/gspca/m5602/m5602_s5k83a.c:				pr_info("register 0x%x is read only\n",
media/video/gspca/m5602/m5602_s5k83a.c:	pr_info("Read/write register probing complete\n");
media/video/gspca/pac7302.c.orig:		pr_err("reg_w_buf failed i: %02x error %d\n",
media/video/gspca/pac7302.c.orig:		pr_err("reg_w() failed i: %02x v: %02x error %d\n",
media/video/gspca/pac7302.c.orig:			pr_err("reg_w_page() failed i: %02x v: %02x error %d\n",
media/video/gspca/vc032x.c:		pr_err("reg_r err %d\n", ret);
media/video/gspca/vc032x.c:		pr_err("reg_w err %d\n", ret);
media/video/gspca/vc032x.c:		pr_err("I2c Bus Busy Wait %02x\n", gspca_dev->usb_buf[0]);
media/video/gspca/vc032x.c:		pr_err("i2c_write timeout\n");
media/video/gspca/vc032x.c:		pr_err("Unknown sensor...\n");
media/video/gspca/se401.c:			pr_err("write req failed req %#04x val %#04x error %d\n",
media/video/gspca/se401.c:		pr_err("USB_BUF_SZ too small!!\n");
media/video/gspca/se401.c:			pr_err("read req failed req %#04x error %d\n",
media/video/gspca/se401.c:		pr_err("set feature failed sel %#04x param %#04x error %d\n",
media/video/gspca/se401.c:		pr_err("USB_BUF_SZ too small!!\n");
media/video/gspca/se401.c:		pr_err("get feature failed sel %#04x error %d\n",
media/video/gspca/se401.c:		pr_err("Wrong descriptor type\n");
media/video/gspca/se401.c:		pr_err("Bayer format not supported!\n");
media/video/gspca/se401.c:		pr_info("ExtraFeatures: %d\n", cd[3]);
media/video/gspca/se401.c:		pr_err("Too many frame sizes\n");
media/video/gspca/se401.c:			pr_info("Frame size: %dx%d bayer\n",
media/video/gspca/se401.c:			pr_info("Frame size: %dx%d 1/%dth janggu\n",
media/video/gspca/se401.c:			pr_err("invalid packet len %d restarting stream\n",
media/video/gspca/se401.c:			pr_err("unknown frame info value restarting stream\n");
media/video/gspca/se401.c:				pr_err("frame size %d expected %d\n",
media/video/gspca/etoms.c:		pr_err("reg_r: buffer overflow\n");
media/video/gspca/etoms.c:		pr_err("reg_w: buffer overflow\n");
media/video/gspca/spca1528.c:		pr_err("reg_r err %d\n", ret);
media/video/gspca/spca1528.c:		pr_err("reg_w err %d\n", ret);
media/video/gspca/spca1528.c:		pr_err("reg_w err %d\n", ret);
media/video/gspca/mars.c:		pr_err("reg write [%02x] error %d\n",
media/video/gspca/mars.c:		pr_err("Could not initialize controls\n");
media/video/gspca/gl860/gl860.c:		pr_err("ctrl transfer failed %4d [p%02x r%d v%04x i%04x len%d]\n",
media/video/gspca/gspca.h:		pr_info(fmt, ##__VA_ARGS__);			\
media/video/gspca/benq.c:		pr_err("reg_w err %d\n", ret);
media/video/gspca/benq.c:			pr_err("usb_alloc_urb failed\n");
media/video/gspca/benq.c:			pr_err("usb_alloc_coherent failed\n");
media/video/gspca/benq.c:		pr_err("urb status: %d\n", urb->status);
media/video/gspca/benq.c:			pr_err("ISOC data error: [%d] status=%d\n",
media/video/gspca/benq.c:		pr_err("usb_submit_urb(0) ret %d\n", st);
media/video/gspca/benq.c:		pr_err("usb_submit_urb() ret %d\n", st);
media/video/gspca/sq930x.c:		pr_err("reg_r %04x failed %d\n", value, ret);
media/video/gspca/sq930x.c:		pr_err("reg_w %04x %04x failed %d\n", value, index, ret);
media/video/gspca/sq930x.c:		pr_err("reg_wb %04x %04x failed %d\n", value, index, ret);
media/video/gspca/sq930x.c:		pr_err("i2c_write failed %d\n", ret);
media/video/gspca/sq930x.c:		pr_err("Bug: usb_buf overflow\n");
media/video/gspca/sq930x.c:			pr_err("ucbus_write failed %d\n", ret);
media/video/gspca/sq930x.c:		pr_err("Unknown sensor\n");
media/video/gspca/sq930x.c:		pr_err("Sensor %s not yet treated\n",
media/video/gspca/sq930x.c:		pr_err("sd_dq_callback() err %d\n", ret);
media/video/gspca/zc3xx.c:		pr_err("reg_r err %d\n", ret);
media/video/gspca/zc3xx.c:		pr_err("reg_w_i err %d\n", ret);
media/video/gspca/zc3xx.c:		pr_err("i2c_r status error %02x\n", retbyte);
media/video/gspca/zc3xx.c:		pr_err("i2c_w status error %02x\n", retbyte);
media/video/gspca/zc3xx.c:		pr_err("Could not initialize controls\n");
media/video/gspca/zc3xx.c:				pr_warn("Unknown sensor - set to TAS5130C\n");
media/video/gspca/zc3xx.c:			pr_err("Unknown sensor %04x\n", sensor);
media/video/gspca/stv06xx/stv06xx_st6422.c:	pr_info("st6422 sensor detected\n");
media/video/gspca/stv06xx/stv06xx_pb0100.c:	pr_info("Photobit pb0100 sensor detected\n");
media/video/gspca/stv06xx/stv06xx.c:		pr_err("I2C: Read error writing address: %d\n", err);
media/video/gspca/stv06xx/stv06xx.c:	pr_info("Dumping all stv06xx bridge registers\n");
media/video/gspca/stv06xx/stv06xx.c:		pr_info("Read 0x%x from address 0x%x\n", data, i);
media/video/gspca/stv06xx/stv06xx.c:	pr_info("Testing stv06xx bridge registers for writability\n");
media/video/gspca/stv06xx/stv06xx.c:			pr_info("Register 0x%x is read/write\n", i);
media/video/gspca/stv06xx/stv06xx.c:			pr_info("Register 0x%x is read/write, but only partially\n",
media/video/gspca/stv06xx/stv06xx.c:			pr_info("Register 0x%x is read-only\n", i);
media/video/gspca/stv06xx/stv06xx_vv6410.c:	pr_info("vv6410 sensor detected\n");
media/video/gspca/stv06xx/stv06xx_vv6410.c:	pr_info("Dumping all vv6410 sensor registers\n");
media/video/gspca/stv06xx/stv06xx_vv6410.c:		pr_info("Register 0x%x contained 0x%x\n", i, data);
media/video/gspca/stv06xx/stv06xx_hdcs.c:	pr_info("HDCS-1000/1100 sensor detected\n");
media/video/gspca/stv06xx/stv06xx_hdcs.c:	pr_info("HDCS-1020 sensor detected\n");
media/video/gspca/stv06xx/stv06xx_hdcs.c:	pr_info("Dumping sensor registers:\n");
media/video/gspca/stv06xx/stv06xx_hdcs.c:		pr_info("reg 0x%02x = 0x%02x\n", reg, val);
media/video/gspca/pac7311.c:		pr_err("reg_w_buf() failed index 0x%02x, error %d\n",
media/video/gspca/pac7311.c:		pr_err("reg_w() failed index 0x%02x, value 0x%02x, error %d\n",
media/video/gspca/pac7311.c:			pr_err("reg_w_page() failed index 0x%02x, value 0x%02x, error %d\n",
media/video/gspca/pac7311.c:		pr_err("Could not initialize controls\n");
media/video/gspca/stk014.c:		pr_err("reg_r err %d\n", ret);
media/video/gspca/stk014.c:		pr_err("reg_w err %d\n", ret);
media/video/gspca/stk014.c:		pr_err("rcv_val err %d\n", ret);
media/video/gspca/stk014.c:		pr_err("snd_val err %d\n", ret);
media/video/gspca/stk014.c:			pr_err("init reg: 0x%02x\n", ret);
media/video/gspca/stk014.c:		pr_err("set intf %d %d failed\n",
media/video/gspca/sonixj.c:		pr_err("reg_r: buffer overflow\n");
media/video/gspca/sonixj.c:		pr_err("reg_r err %d\n", ret);
media/video/gspca/sonixj.c:		pr_err("reg_w1 err %d\n", ret);
media/video/gspca/sonixj.c:		pr_err("reg_w: buffer overflow\n");
media/video/gspca/sonixj.c:		pr_err("reg_w err %d\n", ret);
media/video/gspca/sonixj.c:		pr_err("i2c_w1 err %d\n", ret);
media/video/gspca/sonixj.c:		pr_err("i2c_w8 err %d\n", ret);
media/video/gspca/sonixj.c:	pr_warn("Erroneous HV7131R ID 0x%02x 0x%02x 0x%02x\n",
media/video/gspca/sonixj.c:	pr_err("Unknown sensor %04x\n", val);
media/video/gspca/sonixj.c:		pr_err("Unknown sensor ID %04x\n", val);
media/video/gspca/xirlink_cit.c:		pr_err("Failed to write a register (index 0x%04X, value 0x%02X, error %d)\n",
media/video/gspca/xirlink_cit.c:		pr_err("Failed to read a register (index 0x%04X, error %d)\n",
media/video/gspca/xirlink_cit.c:		pr_err("Couldn't get altsetting\n");
media/video/gspca/xirlink_cit.c:		pr_err("set alt 1 err %d\n", ret);
media/video/gspca/w996Xcf.c:		pr_err("Write FSB registers failed (%d)\n", ret);
media/video/gspca/w996Xcf.c:		pr_err("Write SB reg [01] %04x failed\n", value);
media/video/gspca/w996Xcf.c:		pr_err("Read SB reg [01] failed\n");
media/video/gspca/sunplus.c:		pr_err("reg_r: buffer overflow\n");
media/video/gspca/sunplus.c:		pr_err("reg_r err %d\n", ret);
media/video/gspca/sunplus.c:		pr_err("reg_w_1 err %d\n", ret);
media/video/gspca/sunplus.c:		pr_err("reg_w_riv err %d\n", ret);
media/video/gspca/topro.c:		pr_err("reg_w err %d\n", ret);
media/video/gspca/topro.c:		pr_err("reg_r err %d\n", ret);
media/video/gspca/topro.c:			pr_err("bulk write error %d tag=%02x\n",
media/video/gspca/topro.c:				pr_warn("Unknown sensor %d - forced to soi763a\n",
media/video/gspca/topro.c:		pr_info("Sensor soi763a\n");
media/video/gspca/topro.c:		pr_info("Sensor cx0342\n");
media/video/gspca/topro.c:			pr_err("bulk err %d\n", ret);
media/video/gspca/topro.c:			pr_err("bulk err %d\n", ret);
media/video/gspca/stv0680.c:		pr_err("usb_control_msg error %i, request = 0x%x, error = %i\n",
media/video/gspca/stv0680.c:		pr_err("Could not get descriptor 0100\n");
media/video/hdpvr/hdpvr-video.c:		pr_err("open failing with with ENODEV\n");
media/video/mx2_emmaprp.c:		pr_err("Instance released before the end of transaction\n");
media/video/mx2_emmaprp.c:			pr_err("PrP bus error ocurred, this transfer is probably corrupted\n");
media/video/mxb.c:		pr_err("did not find all i2c devices. aborting\n");
media/video/mxb.c:		pr_info("'sound arena module' detected\n");
media/video/mxb.c:		pr_err("VIDIOC_S_INPUT: could not address saa7111a\n");
media/video/mxb.c:	pr_info("found Multimedia eXtension Board #%d\n", mxb_num);
media/video/pvrusb2/pvrusb2-v4l2.c.orig:			pr_err(KBUILD_MODNAME
media/video/pvrusb2/pvrusb2-v4l2.c.orig:		pr_err(KBUILD_MODNAME ": Failed to set up pvrusb2 v4l dev"
media/video/pvrusb2/pvrusb2-v4l2.c.orig:		pr_err(KBUILD_MODNAME
media/video/pvrusb2/pvrusb2-v4l2.c:			pr_err(KBUILD_MODNAME
media/video/pvrusb2/pvrusb2-v4l2.c:		pr_err(KBUILD_MODNAME ": Failed to set up pvrusb2 v4l dev"
media/video/pvrusb2/pvrusb2-v4l2.c:		pr_err(KBUILD_MODNAME
media/video/v4l2-ioctl.c:			pr_info("%s: =================  START STATUS  =================\n",
media/video/v4l2-ioctl.c:			pr_info("%s: ==================  END STATUS  ==================\n",
media/video/hexium_orion.c:		pr_err("hexium_probe: not enough kernel memory\n");
media/video/hexium_orion.c:		pr_info("device is a Hexium Orion w/ 1 SVHS + 3 BNC inputs\n");
media/video/hexium_orion.c:		pr_info("device is a Hexium Orion w/ 4 BNC inputs\n");
media/video/hexium_orion.c:		pr_info("device is a Hexium HV-PCI6/Orion (old)\n");
media/video/hexium_orion.c:			pr_err("failed for address 0x%02x\n", i);
media/video/hexium_orion.c:		pr_err("cannot register capture v4l2 device. skipping.\n");
media/video/hexium_orion.c:	pr_err("found 'hexium orion' frame grabber-%d\n", hexium_num);
media/video/mx3_camera.c:		pr_err("Couldn't map %x@%x\n", resource_size(res), res->start);
media/video/videobuf-dma-contig.c:		pr_err("magic mismatch: %x expected %x\n", (is), (should)); \
media/video/videobuf2-vmalloc.c:		pr_err("Address of an unallocated plane requested "
media/video/videobuf2-vmalloc.c:		pr_err("No memory to map\n");
media/video/videobuf2-vmalloc.c:		pr_err("Remapping vmalloc memory, error: %d\n", ret);
media/video/hexium_gemini.c:			pr_err("hexium_init_done() failed for address 0x%02x\n",
media/video/hexium_gemini.c:			pr_err("hexium_init_done: hexium_set_standard() failed for address 0x%02x\n",
media/video/hexium_gemini.c:		pr_err("not enough kernel memory in hexium_attach()\n");
media/video/hexium_gemini.c:		pr_err("cannot register capture v4l2 device. skipping.\n");
media/video/hexium_gemini.c:	pr_info("found 'hexium gemini' frame grabber-%d\n", hexium_num);
media/video/pms.c:		pr_err("PMS: not enabled, use pms.enable=1 to probe\n");
media/video/s5p-jpeg/jpeg-core.c:		pr_err("%s data will not fit into plane (%lu < %lu)\n",
media/video/s5p-jpeg/jpeg-core.c:	pr_info("S5P JPEG V4L2 Driver, (c) 2011 Samsung Electronics\n");
media/video/s5p-jpeg/jpeg-core.c:		pr_err("%s: failed to register jpeg driver\n", __func__);
media/video/sn9c102/sn9c102.h:			pr_info("sn9c102: " fmt "\n", ## args);               \
staging/media/as102/as102_drv.c:	pr_info("Registered device %s", as102_dev->name);
staging/media/as102/as102_drv.c:	pr_info("Unregistered device %s", as102_dev->name);
staging/media/as102/as102_usb_drv.c:	pr_info("%s: device has been disconnected\n", DRIVER_NAME);
staging/media/as102/as102_usb_drv.c:		pr_err("Device names table invalid size");
staging/media/as102/as102_usb_drv.c:	pr_info("%s: device has been detected\n", DRIVER_NAME);
staging/media/as102/as102_usb_drv.c:		pr_err("%s: can't find device for minor %d\n",
staging/media/as102/as102_fw.c:		pr_err("invalid firmware file\n");
staging/media/as102/as102_fw.c:		pr_err("%s: unable to locate firmware file: %s\n",
staging/media/as102/as102_fw.c:		pr_err("%s: error during firmware upload part1\n",
staging/media/as102/as102_fw.c:	pr_info("%s: firmware: %s loaded with success\n",
staging/media/as102/as102_fw.c:		pr_err("%s: unable to locate firmware file: %s\n",
staging/media/as102/as102_fw.c:		pr_err("%s: error during firmware upload part2\n",
staging/media/as102/as102_fw.c:	pr_info("%s: firmware: %s loaded with success\n",

--------------060709080306030803070501--
