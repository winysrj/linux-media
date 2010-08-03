Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49874 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360Ab0HCOVI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 10:21:08 -0400
Received: by qyk7 with SMTP id 7so726009qyk.19
        for <linux-media@vger.kernel.org>; Tue, 03 Aug 2010 07:21:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C581A5F.5020403@redhat.com>
References: <cover.1280693675.git.mchehab@redhat.com>
	<20100801171718.5ad62978@pedra>
	<20100802072711.GA5852@linux-m68k.org>
	<4C577888.30408@redhat.com>
	<20100803130552.GA9954@linux-m68k.org>
	<4C581A5F.5020403@redhat.com>
Date: Tue, 3 Aug 2010 10:21:03 -0400
Message-ID: <AANLkTi=SH9U16muauwQ-TSzJ4Z2=L4Oq-e=KdT0vmPxp@mail.gmail.com>
Subject: Re: [PATCH 3/6] V4L/DVB: smsusb: enable IR port for Hauppauge WinTV
	MiniStick
From: Jarod Wilson <jarod@wilsonet.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Richard Zidlicky <rz@linux-m68k.org>, linux-media@vger.kernel.org,
	udia@siano-ms.com, Michael Krufky <mkrufky@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 3, 2010 at 9:32 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 03-08-2010 10:05, Richard Zidlicky escreveu:
>> Hi,
>>
>>> Em 02-08-2010 04:27, Richard Zidlicky escreveu:
>>>> On Sun, Aug 01, 2010 at 05:17:18PM -0300, Mauro Carvalho Chehab wrote:
>>>>> Add the proper gpio port for WinTV MiniStick, with the information provided
>>>>> by Michael.
>>>>>
>>>>> Thanks-to: Michael Krufky <mkrufky@kernellabs.com>
>>>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>>>>
>>>>> diff --git a/drivers/media/dvb/siano/sms-cards.c b/drivers/media/dvb/siano/sms-cards.c
>>>>> index cff77e2..dcde606 100644
>>>>> --- a/drivers/media/dvb/siano/sms-cards.c
>>>>> +++ b/drivers/media/dvb/siano/sms-cards.c
>>>>> @@ -67,6 +67,7 @@ static struct sms_board sms_boards[] = {
>>>>>            .board_cfg.leds_power = 26,
>>>>>            .board_cfg.led0 = 27,
>>>>>            .board_cfg.led1 = 28,
>>>>> +          .board_cfg.ir = 9,
>>>>                                ^^^^
>>>>
>>>> are you sure about this?
>>>>
>>>> I am using the value of 4 for the ir port and it definitely works.. confused.
>>>
>>> I got this from a reliable source, and that worked perfectly  my with a Model 55009
>>> LF Rev B1F7. What's the model of your device?
>>
>> mine says
>>
>> Aug  3 14:58:10 localhost kernel: [149778.591862] usb 5-5: New USB device found, idVendor=2040, idProduct=5500
>> Aug  3 14:58:10 localhost kernel: [149778.591865] usb 5-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
>> Aug  3 14:58:10 localhost kernel: [149778.591868] usb 5-5: Product: WinTV MiniStick
>> Aug  3 14:58:10 localhost kernel: [149778.591870] usb 5-5: Manufacturer: Hauppauge Computer Works
>> Aug  3 14:58:10 localhost kernel: [149778.591872] usb 5-5: SerialNumber: f069684c
>>
>> not sure what else to report.
>
> The model number is on a label at the back of the stick (at least, mine have it).
>
>> I will compile and try a new kernel tonight.
>>
>> Wondering - is this
>>   http://git.sliepen.org/browse?p=inputlirc
>> usefull to feed the input events to LIRC when trying the new driver with a slightly older
>> LIRC based distro?
>
> The in-kernel lirc support need a new version of LIRC since a few ioctls numbers were changed,
> to avoid needing to write a code in kernel to handle compatibility between 32 and 64 bit kernels.
> If you're running a 32 bits kernel, it may work.

Should also be able to skirt around the issue if you don't use the
/dev/lircX interface to get data out of the receiver. For example, one
could use the lircd devinput driver, a la "lircd -H devinput -d
/dev/input/by-id/<my-remote's-input-device>", and I don't think the
ioctl changes should matter.


-- 
Jarod Wilson
jarod@wilsonet.com
