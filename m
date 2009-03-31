Return-path: <linux-media-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.184]:45550 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbZCaEDl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 00:03:41 -0400
Received: by ti-out-0910.google.com with SMTP id i7so1894921tid.23
        for <linux-media@vger.kernel.org>; Mon, 30 Mar 2009 21:03:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <412bdbff0903302046x16dcc6a4w8df7506f68f14f7e@mail.gmail.com>
References: <15ed362e0903301947rf0de73eo8edbd8cbcd5b5abd@mail.gmail.com>
	 <412bdbff0903301957i77c36f10hcb9e9cb919124057@mail.gmail.com>
	 <15ed362e0903302039g6d9575cnca5d9b62b566db72@mail.gmail.com>
	 <412bdbff0903302046x16dcc6a4w8df7506f68f14f7e@mail.gmail.com>
Date: Tue, 31 Mar 2009 12:03:37 +0800
Message-ID: <15ed362e0903302103p1fa300c0w295ad6992a166c3c@mail.gmail.com>
Subject: Re: XC5000 DVB-T/DMB-TH support
From: David Wong <davidtlwong@gmail.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 31, 2009 at 11:46 AM, Devin Heitmueller
<devin.heitmueller@gmail.com> wrote:
> On Mon, Mar 30, 2009 at 11:39 PM, David Wong <davidtlwong@gmail.com> wrote:
>> On Tue, Mar 31, 2009 at 10:57 AM, Devin Heitmueller
>> <devin.heitmueller@gmail.com> wrote:
>>> On Mon, Mar 30, 2009 at 10:47 PM, David Wong <davidtlwong@gmail.com> wrote:
>>>> Does anyone know how to get XC5000 working for DVB-T, especially 8MHz bandwidth?
>>>> Current driver only supports ATSC with 6MHz bandwidth only.
>>>> It seems there is a trick at setting compensated RF frequency.
>>>>
>>>> DVB-T 8MHz support would probably works for DMB-TH, but DMB-TH
>>>> settings is very welcome.
>>>>
>>>> Regards,
>>>> David
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>>> All of my xc5000 work has been with ATSC/QAM, so I can't say
>>> authoritatively what is required to make it work.
>>>
>>> Well, at a minimum you will have to modify xc5000_set_params to
>>> support setting priv->video_standard to DTV8.  Beyond that, I don't
>>> think you need to do anything specific for DVB-T.
>>>
>>> Devin
>>>
>>> --
>>> Devin J. Heitmueller
>>> http://www.devinheitmueller.com
>>> AIM: devinheitmueller
>>>
>>
>> I have tried followings in xc5000_set_params()
>>
>> if (fe->ops.info.type == FE_ATSC) {
>>  ...
>> } else if (fe->ops.info.type == FE_OFDM) {
>>                switch (params->u.ofdm.bandwidth) {
>>                case BANDWIDTH_6_MHZ:
>>                        printk("xc5000 bandwidth 6MHz\n");
>>                        priv->bandwidth = BANDWIDTH_6_MHZ;
>>                        priv->video_standard = DTV6;
>>                        break;
>>                case BANDWIDTH_7_MHZ:
>>                        printk("xc5000 bandwidth 7MHz\n");
>>                        priv->bandwidth = BANDWIDTH_7_MHZ;
>>                        priv->video_standard = DTV7;
>>                        break;
>>                case BANDWIDTH_8_MHZ:
>>                        printk("xc5000 bandwidth 8MHz\n");
>>                        priv->bandwidth = BANDWIDTH_8_MHZ;
>>                        priv->video_standard = DTV8;
>>                        break;
>>                default:
>>                        printk("xc5000 bandwidth not set!\n");
>>                        return -EINVAL;
>>                }
>>                priv->rf_mode = XC_RF_MODE_AIR;
>>                priv->freq_hz = params->frequency - 1750000;
>> }
>>
>>
>> But no success yet.
>> I am wondering the -1750000 compensation for DTV8.
>>
>> BTW, The xc_debug_dump() could get more information like firmware
>> build number and tuner total gain
>>
>> diff -r 2276e777f950 linux/drivers/media/common/tuners/xc5000.c
>> --- a/linux/drivers/media/common/tuners/xc5000.c        Thu Mar 26 22:17:48 2009 -0300
>> +++ b/linux/drivers/media/common/tuners/xc5000.c        Mon Mar 30 16:23:11 2009 +0800
>> @@ -84,6 +84,7 @@
>>  #define XREG_IF_OUT       0x05
>>  #define XREG_SEEK_MODE    0x07
>>  #define XREG_POWER_DOWN   0x0A
>> +#define XREG_OUTPUT_AMP   0x0B
>>  #define XREG_SIGNALSOURCE 0x0D /* 0=Air, 1=Cable */
>>  #define XREG_SMOOTHEDCVBS 0x0E
>>  #define XREG_XTALFREQ     0x0F
>> @@ -100,6 +101,8 @@
>>  #define XREG_VERSION      0x07
>>  #define XREG_PRODUCT_ID   0x08
>>  #define XREG_BUSY         0x09
>> +#define XREG_BUILD_NUM    0x0D
>> +#define XREG_TOTAL_GAIN   0x0F
>>
>>  /*
>>    Basic firmware description. This will remain with
>> @@ -468,7 +485,8 @@
>>
>>  static int xc_get_version(struct xc5000_priv *priv,
>>        u8 *hw_majorversion, u8 *hw_minorversion,
>> -       u8 *fw_majorversion, u8 *fw_minorversion)
>> +       u8 *fw_majorversion, u8 *fw_minorversion,
>> +       u16 *fw_buildnum)
>>  {
>>        u16 data;
>>        int result;
>> @@ -481,6 +499,11 @@
>>        (*hw_minorversion) = (data >>  8) & 0x0F;
>>        (*fw_majorversion) = (data >>  4) & 0x0F;
>>        (*fw_minorversion) = data & 0x0F;
>> +
>> +       result = xc_read_reg(priv, XREG_BUILD_NUM, &data);
>> +       if (result)
>> +               return result;
>> +       *fw_buildnum = data;
>>
>>        return 0;
>>  }
>> @@ -506,6 +529,11 @@
>>  static int xc_get_quality(struct xc5000_priv *priv, u16 *quality)
>>  {
>>        return xc_read_reg(priv, XREG_QUALITY, quality);
>> +}
>> +
>> +static int xc_get_total_gain(struct xc5000_priv *priv, u16 *gain)
>> +{
>> +       return xc_read_reg(priv, XREG_TOTAL_GAIN, gain);
>>  }
>>
>>  static u16 WaitForLock(struct xc5000_priv *priv)
>> @@ -626,8 +654,10 @@
>>        u32 hsync_freq_hz = 0;
>>        u16 frame_lines;
>>        u16 quality;
>> +       u16 gain;
>>        u8 hw_majorversion = 0, hw_minorversion = 0;
>>        u8 fw_majorversion = 0, fw_minorversion = 0;
>> +       u16 fw_buildnum = 0;
>>
>>        /* Wait for stats to stabilize.
>>         * Frame Lines needs two frame times after initial lock
>> @@ -646,10 +676,11 @@
>>                lock_status);
>>
>>        xc_get_version(priv,  &hw_majorversion, &hw_minorversion,
>> -               &fw_majorversion, &fw_minorversion);
>> -       dprintk(1, "*** HW: V%02x.%02x, FW: V%02x.%02x\n",
>> +               &fw_majorversion, &fw_minorversion, &fw_buildnum);
>> +       dprintk(1, "*** HW: V%02x.%02x, FW: V%02x.%02x build %d\n",
>>                hw_majorversion, hw_minorversion,
>> -               fw_majorversion, fw_minorversion);
>> +               fw_majorversion, fw_minorversion,
>> +               fw_buildnum);
>>
>>        xc_get_hsync_freq(priv,  &hsync_freq_hz);
>>        dprintk(1, "*** Horizontal sync frequency = %d Hz\n", hsync_freq_hz);
>> @@ -659,6 +690,9 @@
>>
>>        xc_get_quality(priv,  &quality);
>>        dprintk(1, "*** Quality (0:<8dB, 7:>56dB) = %d\n", quality);
>> +
>> +       xc_get_total_gain(priv,  &gain);
>> +       dprintk(1, "*** Total Gain = %d mdB\n", gain * 1000 / 256);
>>  }
>>
>
> That compensation offset should be correct for all of the digital standards.
>

Thanks Devin, perhaps there is something that I don't know between the
tuner and the demod (lgs8gl5) on my card, so it doesn't work.
Honestly I have never seen such digital output from a tuner (DDI
interface). I don't know if my card use that, and I have never seen
lgs8xxx with
serial digital input from tuner.
What is the "protocol" of DDI of XC5000? UART-like or I2C-like? it has
only two wires, p and n. I am wonder how it defines clock and data.

David
