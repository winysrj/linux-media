Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58971 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965122Ab2CPWSu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 18:18:50 -0400
Received: by wibhj6 with SMTP id hj6so1470484wib.1
        for <linux-media@vger.kernel.org>; Fri, 16 Mar 2012 15:18:48 -0700 (PDT)
Message-ID: <4F63BC4B.1010900@googlemail.com>
Date: Fri, 16 Mar 2012 23:18:51 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: Move em27xx/em28xx webcams to a gspca subdriver ?
References: <CALjTZvZy4npSE0aELnmsZzzgsxUC1xjeNYVwQ_CvJG59PizfEQ@mail.gmail.com> <CALF0-+Wp03vsbiaJFUt=ymnEncEvDg_KmnV+2OWjtO-_0qqBVg@mail.gmail.com> <CALjTZvYVtuSm0v-_Q7od=iUDvHbkMe4c5ycAQZwoErCCe=N+Bg@mail.gmail.com> <CALF0-+W3HenNpUt_yGxqs+fohcZ22ozDw9MhTWua0B++ZFA2vA@mail.gmail.com> <CALjTZvYJZ32Red-UfZXubB-Lk503DWbHGTL_kEoV4DVDDYJ46w@mail.gmail.com> <4F61C79E.6090603@redhat.com> <4F61E1BC.1020807@googlemail.com> <4F61E913.4000809@redhat.com>
In-Reply-To: <4F61E913.4000809@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


[Was: eMPIA EM2710 Webcam (em28xx) and LIRC]

Continue this part of the discussion in a new thread...

Am 15.03.2012 14:05, schrieb Mauro Carvalho Chehab:
> Em 15-03-2012 09:34, Frank Schäfer escreveu:
>> ...
>>
>> I would like to bring up the question, if it wouldn't make sense to move
>> support for the em27xx/28xx webcams to a separate gspca-subdriver.
> The em2710/2750 chips are very similar to em2820. There's not much sense
> on moving it elsewhere, as it would duplicate a lot of the existing code,
> for no good reason.
Yes, that was my first thought, too.
But looking at the resulting gspca subdriver, you will see that there is
not much code duplication.
I would say that adding support for this device as a gspca subdriver
requires less new lines of code than extending/modifying the em28xx driver.

>> I'm currently working on adding support for the VAD Laplace webcam
>> (em2765 + OV2640) (http://linuxtv.org/wiki/index.php/VAD_Laplace).
>> Lots of modifications to the em28xx driver would be necessary to support
>> this device because of some significant differences:
>> - supports only bulk transfers
> em28xx supports it as well, but it is used only for dvb, currently.
You are talking about the em28xx device capabilities, right ?
AFAIK, the em28xx driver still has no bulk transfer support.

>> - uses proprietary I2C-writes
> huh? I2C writes are proprietary. What do you mean?
Maybe proprietary is not the best name...
Requests 0x06 an 0x08 are used for the usb control messages.
I have documented that at http://linuxtv.org/wiki/index.php/VAD_Laplace.
Could be the "vendor specific" usb requests the datasheet talks about.

>> - em25xx-eeprom
> Are you meaning more than 256 addresses eeprom? Newer Empia chips use it,
> not only the webcam ones. Currently, the code detects it but nobody wrote
> an implementation for it yet. It would likely make sense to implement it
> at em28xx anyway.
Yes, the device has an eeprom with 16bit addresses.
Anyway, I'm talking about a different format of the eeprom data:
http://wenku.baidu.com/view/a21a28eab8f67c1cfad6b8f6.html

You can find the eeprom content of my device at
http://linuxtv.org/wiki/index.php/VAD_Laplace

>> - ov2640 sensor
> The better is to use a separate I2C driver for the sensor. This is not
> a common practice at gspca, but doing that would help to re-use the sensor
> driver elsewhere.
I agree. But let's do things step by step...

>> Lots of changes concerning the USB-interface probing, button handling,
>> video controls, frame processing and more would be necessary, too.
> Video controls are implemented at the sensor sub-driver, so this is not
> an issue.
>
> Anyway, if em2765 is different enough from em2874 and em2750, then it makes
> sense to write it as a separate driver. Otherwise, it is better to add support
> for it there.

No, the em2765 itself seems to be very similar to the other
em27xx/em28xx chips.
But the device as a whole is different enough to consider a separate driver.

>> For reverse engineering purposes, I decided to write a gspca subdriver
>> for this device (will send a patch for testing/discussion soon).
> Ok.
See the patch posted a minute ago.

>
>> I have no strong opinion about this, but I somehow feel that the em28xx
>> driver gets bloated more and more...
> The advantage of adding it there is that it generally reduces maintenance 
> efforts, as the same code and fixes don't need to be added on two separate
> places.
Yes, that's right. But on the other hand, the benefit of separate
drivers is simpler code, which is easier to maintain/understand.
For example, there would be no LIRC modules issue ;-)

> For example, if the em2765 eeprom access is similar to em2874, the same
> code chunk would be required on both drivers.
Sure, code duplication is one of the disadvantages. The question is how
much duplicate code there would be.

Regards,
Frank

> Regards,
> Mauro


