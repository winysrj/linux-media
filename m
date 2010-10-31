Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:56524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab0JaH2q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Oct 2010 03:28:46 -0400
Message-ID: <4CCD1AA3.4090501@redhat.com>
Date: Sun, 31 Oct 2010 08:28:35 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Anca Emanuel <anca.emanuel@gmail.com>
CC: linux-media@vger.kernel.org, moinejf@free.fr, mchehab@infradead.org
Subject: Re: Webcam driver not working: drivers/media/video/gspca/ov519.c
 device 05a9:4519
References: <AANLkTik8__Q9au8u3fxsRr3cNdpjXZqmra9ohKTpSR+k@mail.gmail.com> <AANLkTimFimU5FiAmmTqsaJOhqUQAjSGkbPe1XJTtCGhe@mail.gmail.com>
In-Reply-To: <AANLkTimFimU5FiAmmTqsaJOhqUQAjSGkbPe1XJTtCGhe@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

On 10/30/2010 12:40 PM, Anca Emanuel wrote:
> On Fri, Oct 29, 2010 at 3:12 PM, Anca Emanuel<anca.emanuel@gmail.com>  wrote:
>> Hi all, sorry for the noise, but in current mainline (2.6.36-git12)
>> there are some updates in ov519.c
>> I'm running this kernel now and my camera is still not working (tested
>> in windows and it works).
>>
>> lsusb:
>> Bus 008 Device 002: ID 05a9:4519 OmniVision Technologies, Inc. Webcam Classic
>
> found this: http://www.rastageeks.org/ov51x-jpeg/index.php/Ov51xJpegHackedSource
> and this: http://packages.ubuntu.com/maverick/ov51x-jpeg-source
>
> but I get an error when I try to compile:
> ov51x-jpeg-core.c:87: fatal error: linux/autoconf.h: No such file or directory
> compilation terminated.
>

Please do the following (as root):
echo 63 > /sys/module/gspca_main/parameters/debug

Then unplug your camera, re plug it, and then do
dmesg > plug.log

Try to use it and then do:
dmesg > stream.log

Then send another mail with plug.log and stream.log
attached. Please CC me on that mail (I'm not sure of
the list will allow the attachments).

Regards,

Hans
