Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53875 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759Ab2IAW6T (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Sep 2012 18:58:19 -0400
Received: by wgbdr13 with SMTP id dr13so3536438wgb.1
        for <linux-media@vger.kernel.org>; Sat, 01 Sep 2012 15:58:18 -0700 (PDT)
Message-ID: <50429307.7000706@gmail.com>
Date: Sun, 02 Sep 2012 00:58:15 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: Re: [PATCH] rtl28xxu: correct usb_clear_halt() usage
References: <1346507683-3621-1-git-send-email-crope@iki.fi> <50422B57.60701@gmail.com> <50422E32.9000501@iki.fi> <504247F0.40500@gmail.com>
In-Reply-To: <504247F0.40500@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/01/2012 07:37 PM, poma wrote:
> On 09/01/2012 05:48 PM, Antti Palosaari wrote:
>> On 09/01/2012 06:35 PM, poma wrote:
>>> On 09/01/2012 03:54 PM, Antti Palosaari wrote:
>>>> It is not allowed to call usb_clear_halt() after urbs are submitted.
>>>> That causes oops sometimes. Move whole streaming_ctrl() logic to
>>>> power_ctrl() in order to avoid wrong usb_clear_halt() use. Also,
>>>> configuring streaming endpoint in streaming_ctrl() sounds like a
>>>> little bit wrong as it is aimed for control stream gate.
>>>>
>>>> Reported-by: Hin-Tak Leung <htl10@users.sourceforge.net>
>>>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>>>> ---
>>>>   drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 55
>>>> +++++++++++++++------------------
>>>>   1 file changed, 25 insertions(+), 30 deletions(-)
>>>>
>>>> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
>>>> b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
>>>> index e29fca2..7d11c5d 100644
>>>> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
>>>> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
>>>> @@ -825,37 +825,10 @@ err:
>>>>       return ret;
>>>>   }
>>>>
>>>> -static int rtl28xxu_streaming_ctrl(struct dvb_frontend *fe , int onoff)
>>>> -{
>>>> -    int ret;
>>>> -    u8 buf[2];
>>>> -    struct dvb_usb_device *d = fe_to_d(fe);
>>>> -
>>>> -    dev_dbg(&d->udev->dev, "%s: onoff=%d\n", __func__, onoff);
>>>> -
>>>> -    if (onoff) {
>>>> -        buf[0] = 0x00;
>>>> -        buf[1] = 0x00;
>>>> -        usb_clear_halt(d->udev, usb_rcvbulkpipe(d->udev, 0x81));
>>>> -    } else {
>>>> -        buf[0] = 0x10; /* stall EPA */
>>>> -        buf[1] = 0x02; /* reset EPA */
>>>> -    }
>>>> -
>>>> -    ret = rtl28xx_wr_regs(d, USB_EPA_CTL, buf, 2);
>>>> -    if (ret)
>>>> -        goto err;
>>>> -
>>>> -    return ret;
>>>> -err:
>>>> -    dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
>>>> -    return ret;
>>>> -}
>>>> -
>>>>   static int rtl2831u_power_ctrl(struct dvb_usb_device *d, int onoff)
>>>>   {
>>>>       int ret;
>>>> -    u8 gpio, sys0;
>>>> +    u8 gpio, sys0, epa_ctl[2];
>>>>
>>>>       dev_dbg(&d->udev->dev, "%s: onoff=%d\n", __func__, onoff);
>>>>
>>>> @@ -878,11 +851,15 @@ static int rtl2831u_power_ctrl(struct
>>>> dvb_usb_device *d, int onoff)
>>>>           gpio |= 0x04; /* GPIO2 = 1, LED on */
>>>>           sys0 = sys0 & 0x0f;
>>>>           sys0 |= 0xe0;
>>>> +        epa_ctl[0] = 0x00; /* clear stall */
>>>> +        epa_ctl[1] = 0x00; /* clear reset */
>>>>       } else {
>>>>           gpio &= (~0x01); /* GPIO0 = 0 */
>>>>           gpio |= 0x10; /* GPIO4 = 1 */
>>>>           gpio &= (~0x04); /* GPIO2 = 1, LED off */
>>>>           sys0 = sys0 & (~0xc0);
>>>> +        epa_ctl[0] = 0x10; /* set stall */
>>>> +        epa_ctl[1] = 0x02; /* set reset */
>>>>       }
>>>>
>>>>       dev_dbg(&d->udev->dev, "%s: WR SYS0=%02x GPIO_OUT_VAL=%02x\n",
>>>> __func__,
>>>> @@ -898,6 +875,14 @@ static int rtl2831u_power_ctrl(struct
>>>> dvb_usb_device *d, int onoff)
>>>>       if (ret)
>>>>           goto err;
>>>>
>>>> +    /* streaming EP: stall & reset */
>>>> +    ret = rtl28xx_wr_regs(d, USB_EPA_CTL, epa_ctl, 2);
>>>> +    if (ret)
>>>> +        goto err;
>>>> +
>>>> +    if (onoff)
>>>> +        usb_clear_halt(d->udev, usb_rcvbulkpipe(d->udev, 0x81));
>>>> +
>>>>       return ret;
>>>>   err:
>>>>       dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
>>>> @@ -972,6 +957,14 @@ static int rtl2832u_power_ctrl(struct
>>>> dvb_usb_device *d, int onoff)
>>>>               goto err;
>>>>
>>>>
>>>> +        /* streaming EP: clear stall & reset */
>>>> +        ret = rtl28xx_wr_regs(d, USB_EPA_CTL, "\x00\x00", 2);
>>>> +        if (ret)
>>>> +            goto err;
>>>> +
>>>> +        ret = usb_clear_halt(d->udev, usb_rcvbulkpipe(d->udev, 0x81));
>>>> +        if (ret)
>>>> +            goto err;
>>>>       } else {
>>>>           /* demod_ctl_1 */
>>>>           ret = rtl28xx_rd_reg(d, SYS_DEMOD_CTL1, &val);
>>>> @@ -1006,6 +999,10 @@ static int rtl2832u_power_ctrl(struct
>>>> dvb_usb_device *d, int onoff)
>>>>           if (ret)
>>>>               goto err;
>>>>
>>>> +        /* streaming EP: set stall & reset */
>>>> +        ret = rtl28xx_wr_regs(d, USB_EPA_CTL, "\x10\x02", 2);
>>>> +        if (ret)
>>>> +            goto err;
>>>>       }
>>>>
>>>>       return ret;
>>>> @@ -1182,7 +1179,6 @@ static const struct dvb_usb_device_properties
>>>> rtl2831u_props = {
>>>>       .tuner_attach = rtl2831u_tuner_attach,
>>>>       .init = rtl28xxu_init,
>>>>       .get_rc_config = rtl2831u_get_rc_config,
>>>> -    .streaming_ctrl = rtl28xxu_streaming_ctrl,
>>>>
>>>>       .num_adapters = 1,
>>>>       .adapter = {
>>>> @@ -1204,7 +1200,6 @@ static const struct dvb_usb_device_properties
>>>> rtl2832u_props = {
>>>>       .tuner_attach = rtl2832u_tuner_attach,
>>>>       .init = rtl28xxu_init,
>>>>       .get_rc_config = rtl2832u_get_rc_config,
>>>> -    .streaming_ctrl = rtl28xxu_streaming_ctrl,
>>>>
>>>>       .num_adapters = 1,
>>>>       .adapter = {
>>>>
>>>
>>> OK, after patching with this one from http://goo.gl/5wtpT there is no
>>> OOPS, but this happened[1][2]:
>>> 1. mythtv-setup version: fixes/0.25 [v0.25.2-3-gf0e2ad8-dirty]:
>>> …
>>>     E  DVBChan(1:/dev/dvb/adapter0/frontend0): Getting Frontend
>>> uncorrected block count failed.
>>> eno: Operation not supported (95)
>>> 2012-09-01 17:08:20.577044 W  DVBSM(/dev/dvb/adapter0/frontend0): Cannot
>>> count Uncorrected Blocks
>>> eno: Operation not supported (95)
>>> …
>>> 2. tzap/femon:
>>> …
>>> status 1f | signal 2f2f | snr 00f2 | ber 0000001e | unc 00000033 |
>>> FE_HAS_LOCK
>>> status 1f | signal 2f2f | snr 00f3 | ber 0000000b | unc 00000033 |
>>> FE_HAS_LOCK
>>> status 1f | signal 2f2f | snr 00f1 | ber 00000000 | unc 00000033 |
>>> FE_HAS_LOCK
>>> …
>>> …
>>> Problem retrieving frontend information: Operation not supported
>>> status SCVYL | signal  18% | snr   0% | ber 19 | unc 1 | FE_HAS_LOCK
>>> Problem retrieving frontend information: Operation not supported
>>> status SCVYL | signal  18% | snr   0% | ber 7 | unc 1 | FE_HAS_LOCK
>>> Problem retrieving frontend information: Operation not supported
>>> status SCVYL | signal  18% | snr   0% | ber 54 | unc 1 | FE_HAS_LOCK
>>> …
>>
>> It is correct as driver does not report uncorrected blocks at all. Those
>> applications should be fixed. When I removed stub callback
>> implementation I looked quite many frontend drivers and there is surely
>> more than 10 other demod drivers reporting errors too. Unfortunately
>> returned error codes varies from driver by driver. Correct error code
>> for non-supported IOCTL is ENOTTY and DVB-frontend is changed to return
>> it too, but you don't seems to have a such patch.
>>
> 
> Yeah, as you mentioned before this case;
> http://www.spinics.net/lists/linux-media/msg49869.html
> Thanks for explain that again!
> 
>> And also, patch in question has nothing to do with that error code.
>>
> 
> I'll go from 1st patch just to confirm ;)
> 

You are right!
Actually none of this patches:
- RFC-Fix-DVB-ioctls-failing-if-frontend-open-closed-too-fast.patch
- 1-5-rtl28xxu-stream-did-not-start-after-stop-on-USB3.0.patch
- 2-5-rtl28xxu-fix-rtl2832u-module-reload-fails-bug.patch
- 3-5-rtl2832-implement-.get_frontend.patch
- 4-5-rtl2832-implement-.read_snr.patch
- 5-5-rtl2832-implement-.read_ber.patch
- rtl28xxu-correct-usb_clear_halt-usage.patch
cause errors from femon during tzap-ing and mythtv-setup during scan-ing.
What is causing them is removed mentioned stub callback,
actually:
static int rtl2832_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
{
      *ucblocks = 0;
      return 0;
}
…
.read_ucblocks = rtl2832_read_ucblocks,
in 'dvb-frontends/rtl2832.c'
Yes, it is still part of media_build, although you send relative
patches, right :)
If 'rtl2832_read_ucblocks' stay in 'rtl2832.c' no problemo with femon
and mythtv-setup.

I checked and compared current hg femon source -
http://linuxtv.org/hg/dvb-apps/file/96025655e6e8/util/femon with current
fedora - zero diff.
I can understand non-engagement from mythtv devs, but femon's…
All this is for the reader's sake ;)
And excuse me for hurriedness.

Cheers,
poma


