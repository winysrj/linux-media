Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:56541 "EHLO
        homiemail-a58.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751753AbeA3T4v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 14:56:51 -0500
Subject: Re: [PATCH 2/9] em28xx: Bulk transfer implementation fix
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
        Michael Ira Krufky <mkrufky@linuxtv.org>
Cc: Brad Love <brad@nextdimension.cc>,
        linux-media <linux-media@vger.kernel.org>
References: <1515110659-20145-1-git-send-email-brad@nextdimension.cc>
 <1515110659-20145-3-git-send-email-brad@nextdimension.cc>
 <CAOcJUbwmCysV7pcCZK6udNpZVsaU+pxfCrJnEGBWcP9ta0Jqrg@mail.gmail.com>
 <CAGoCfizB9+zLFOv7NJ3WGmeD1Z59yb2dSWOS+13=2DkzAGSNnA@mail.gmail.com>
From: Brad Love <brad@nextdimension.cc>
Message-ID: <8d7da094-8a5d-aa63-8951-e26c1835260c@nextdimension.cc>
Date: Tue, 30 Jan 2018 13:56:49 -0600
MIME-Version: 1.0
In-Reply-To: <CAGoCfizB9+zLFOv7NJ3WGmeD1Z59yb2dSWOS+13=2DkzAGSNnA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 2018-01-05 08:20, Devin Heitmueller wrote:
> Hi Brad,
>
> My documents indicate that Register 0x5D and 0x5E are read-only, and
> populated based on the eeprom programming.
>
> On your device, what is the value of those registers prior to you chang=
ing them?
>
> If you write to those registers, do they reflect the new values if you
> read them back?
>
> Does changing these values result in any change to the device's
> endpoint configuration (which is typically statically defined when the
> device is probed)?
>
> What precisely is the behavior you were seeing prior to this patch?
>
> Devin

Hi Devin,

I answered ISOC half of the question dealing with endpoint configuration
in Mauro's email, just now, apologies for not cc'ing you. Here I'll
answer about the bulk half.

These registers according to Empia and my own research are writeable. I
instrumented the driver to get before and after values. The registers
are indeed updated with the 0xff value written.

The behaviour encountered is as follows. The DualHD DVB bulk model I
have with me, after device init, has TS1_PKT_SIZE:0x05 and
TS2_PKT_SIZE:0x10. Since the devices are bulk models, this leads to TS1
producing bulk packets of 940B and TS2 producing bulk packets of 3008B.
With this patch both PKT_SIZE registers are set to 0xff, and verified
returning 0xff. After that the bulk packet size produced by the em28xx
is 48128B, or 256*188. Patch 3/9 sets the bulk dvb multiplier to 94, so
then (512*94=3D=3D48128) is used when starting the USB transfer. For bulk=

transfers, everything should be in sync.

Such small bulk multipliers, as currently used, completely destroys
performance on embedded devices and in VMWare. This patch makes both of
those use cases very happy, and, usable at all.

Cheers,

Brad



>
> On Thu, Jan 4, 2018 at 7:22 PM, Michael Ira Krufky <mkrufky@linuxtv.org=
> wrote:
>> On Thu, Jan 4, 2018 at 7:04 PM, Brad Love <brad@nextdimension.cc> wrot=
e:
>>> Set appropriate bulk/ISOC transfer multiplier on capture start.
>>> This sets ISOC transfer to 940 bytes (188 * 5)
>>> This sets bulk transfer to 48128 bytes (188 * 256)
>>>
>>> The above values are maximum allowed according to Empia.
>>>
>>> Signed-off-by: Brad Love <brad@nextdimension.cc>
>> :+1
>>
>> Reviewed-by: Michael Ira Krufky <mkrufky@linuxtv.org>
>>
>>> ---
>>>  drivers/media/usb/em28xx/em28xx-core.c | 12 ++++++++++++
>>>  1 file changed, 12 insertions(+)
>>>
>>> diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/u=
sb/em28xx/em28xx-core.c
>>> index ef38e56..67ed6a3 100644
>>> --- a/drivers/media/usb/em28xx/em28xx-core.c
>>> +++ b/drivers/media/usb/em28xx/em28xx-core.c
>>> @@ -638,6 +638,18 @@ int em28xx_capture_start(struct em28xx *dev, int=
 start)
>>>             dev->chip_id =3D=3D CHIP_ID_EM28174 ||
>>>             dev->chip_id =3D=3D CHIP_ID_EM28178) {
>>>                 /* The Transport Stream Enable Register moved in em28=
74 */
>>> +               if (dev->dvb_xfer_bulk) {
>>> +                       /* Max Tx Size =3D 188 * 256 =3D 48128 - LCM(=
188,512) * 2 */
>>> +                       em28xx_write_reg(dev, (dev->ts =3D=3D PRIMARY=
_TS) ?
>>> +                                       EM2874_R5D_TS1_PKT_SIZE :
>>> +                                       EM2874_R5E_TS2_PKT_SIZE,
>>> +                                       0xFF);
>>> +               } else {
>>> +                       /* TS2 Maximum Transfer Size =3D 188 * 5 */
>>> +                       em28xx_write_reg(dev, (dev->ts =3D=3D PRIMARY=
_TS) ?
>>> +                                       EM2874_R5D_TS1_PKT_SIZE :
>>> +                                       EM2874_R5E_TS2_PKT_SIZE, 0x05=
);
>>> +               }
>>>                 if (dev->ts =3D=3D PRIMARY_TS)
>>>                         rc =3D em28xx_write_reg_bits(dev,
>>>                                 EM2874_R5F_TS_ENABLE,
>>> --
>>> 2.7.4
>>>
>
>
