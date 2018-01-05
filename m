Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:45278 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751400AbeAEOUm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Jan 2018 09:20:42 -0500
Received: by mail-qk0-f195.google.com with SMTP id o126so6063753qke.12
        for <linux-media@vger.kernel.org>; Fri, 05 Jan 2018 06:20:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOcJUbwmCysV7pcCZK6udNpZVsaU+pxfCrJnEGBWcP9ta0Jqrg@mail.gmail.com>
References: <1515110659-20145-1-git-send-email-brad@nextdimension.cc>
 <1515110659-20145-3-git-send-email-brad@nextdimension.cc> <CAOcJUbwmCysV7pcCZK6udNpZVsaU+pxfCrJnEGBWcP9ta0Jqrg@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Fri, 5 Jan 2018 09:20:40 -0500
Message-ID: <CAGoCfizB9+zLFOv7NJ3WGmeD1Z59yb2dSWOS+13=2DkzAGSNnA@mail.gmail.com>
Subject: Re: [PATCH 2/9] em28xx: Bulk transfer implementation fix
To: Michael Ira Krufky <mkrufky@linuxtv.org>
Cc: Brad Love <brad@nextdimension.cc>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Brad,

My documents indicate that Register 0x5D and 0x5E are read-only, and
populated based on the eeprom programming.

On your device, what is the value of those registers prior to you changing them?

If you write to those registers, do they reflect the new values if you
read them back?

Does changing these values result in any change to the device's
endpoint configuration (which is typically statically defined when the
device is probed)?

What precisely is the behavior you were seeing prior to this patch?

Devin

On Thu, Jan 4, 2018 at 7:22 PM, Michael Ira Krufky <mkrufky@linuxtv.org> wrote:
> On Thu, Jan 4, 2018 at 7:04 PM, Brad Love <brad@nextdimension.cc> wrote:
>> Set appropriate bulk/ISOC transfer multiplier on capture start.
>> This sets ISOC transfer to 940 bytes (188 * 5)
>> This sets bulk transfer to 48128 bytes (188 * 256)
>>
>> The above values are maximum allowed according to Empia.
>>
>> Signed-off-by: Brad Love <brad@nextdimension.cc>
>
> :+1
>
> Reviewed-by: Michael Ira Krufky <mkrufky@linuxtv.org>
>
>> ---
>>  drivers/media/usb/em28xx/em28xx-core.c | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
>> index ef38e56..67ed6a3 100644
>> --- a/drivers/media/usb/em28xx/em28xx-core.c
>> +++ b/drivers/media/usb/em28xx/em28xx-core.c
>> @@ -638,6 +638,18 @@ int em28xx_capture_start(struct em28xx *dev, int start)
>>             dev->chip_id == CHIP_ID_EM28174 ||
>>             dev->chip_id == CHIP_ID_EM28178) {
>>                 /* The Transport Stream Enable Register moved in em2874 */
>> +               if (dev->dvb_xfer_bulk) {
>> +                       /* Max Tx Size = 188 * 256 = 48128 - LCM(188,512) * 2 */
>> +                       em28xx_write_reg(dev, (dev->ts == PRIMARY_TS) ?
>> +                                       EM2874_R5D_TS1_PKT_SIZE :
>> +                                       EM2874_R5E_TS2_PKT_SIZE,
>> +                                       0xFF);
>> +               } else {
>> +                       /* TS2 Maximum Transfer Size = 188 * 5 */
>> +                       em28xx_write_reg(dev, (dev->ts == PRIMARY_TS) ?
>> +                                       EM2874_R5D_TS1_PKT_SIZE :
>> +                                       EM2874_R5E_TS2_PKT_SIZE, 0x05);
>> +               }
>>                 if (dev->ts == PRIMARY_TS)
>>                         rc = em28xx_write_reg_bits(dev,
>>                                 EM2874_R5F_TS_ENABLE,
>> --
>> 2.7.4
>>



-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
