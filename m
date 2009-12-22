Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:1188 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbZLVWrS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2009 17:47:18 -0500
Received: by ey-out-2122.google.com with SMTP id 25so362552eya.19
        for <linux-media@vger.kernel.org>; Tue, 22 Dec 2009 14:47:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B2B9842.6040108@gmail.com>
References: <59cf47a80912180605o41708efao769d09d46b20a87e@mail.gmail.com>
	 <829197380912180644y31f520fawee04a66ab28666e7@mail.gmail.com>
	 <4B2B9842.6040108@gmail.com>
Date: Tue, 22 Dec 2009 22:47:17 +0000
Message-ID: <59cf47a80912221447m770e53f2u8d981cb3342b96d1@mail.gmail.com>
Subject: Re: Adaptec VideOh! DVD Media Center
From: Paulo Assis <pj.assis@gmail.com>
To: Mauro Carvalho Chehab <maurochehab@gmail.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I'm having a real bad time with this, I've just noticed the strangest thing:
The product id on the box changes when loading the firmware:
from the initial vid:pid of 03f3:008b to 03f3:008c I guess the same
also happens for 03f3:0087 to 03f3:0088
This is way the original firmware loader uses the inital pid in the
configuration and the driver module sets the later in the device tab:
udev loads the firmware, the pid changes and the driver module gets
loaded.
So if If I want the driver to request the firmware I have to set both
pids and end up with two device entries, the first of which will never
get removed since the inital pid is no more :D

Is there any solution/ideas on how to handle this behaviour?
Also I exctrated the firmware into a ihex file, I see that existing
modules use several diferent types of firmware binary files (fw, bin)
obtained from the ihex file, some even use ihex directly
(request_ihex_firmware), is there a optimal format for this?

Regards,
Paulo

2009/12/18 Mauro Carvalho Chehab <maurochehab@gmail.com>:
> Devin Heitmueller wrote:
>> On Fri, Dec 18, 2009 at 9:05 AM, Paulo Assis <pj.assis@gmail.com> wrote:
>>> Hi,
>
>>> Is there any simpler/standard way of handling these firmware uploads ?
>>>
>>> Regards,
>>> Paulo
>>
>> Hi Paulo,
>>
>> I would start by looking at the request_firmware() function, which is
>> used by a variety of other v4l cards.
>
> Yes. Basically, you store all firmwares you need on /lib/firmware and
> request_firmware loads them when the driver is loaded.
>
> You don't need to add any extra udev magic for it to work, since there are
> already some userspace programs that handle firmware requests when using
> request_firmware().
>
> Cheers,
> Mauro.
>
