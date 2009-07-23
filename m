Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:46457 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbZGWOsi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jul 2009 10:48:38 -0400
Received: by ewy26 with SMTP id 26so1046001ewy.37
        for <linux-media@vger.kernel.org>; Thu, 23 Jul 2009 07:48:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <m3fxcnxy38.fsf@ursa.amorsen.dk>
References: <20090723111006.59010@gmx.net>
	 <d9def9db0907230433ua9f567fm15e1794f6b87fdf1@mail.gmail.com>
	 <m3fxcnxy38.fsf@ursa.amorsen.dk>
Date: Thu, 23 Jul 2009 16:48:37 +0200
Message-ID: <d9def9db0907230748n320f51bbkeea3e4b0aa4ecd78@mail.gmail.com>
Subject: Re: [linux-dvb] Terratec Cinergy HTC USB XS HD
From: Markus Rechberger <mrechberger@gmail.com>
To: Benny Amorsen <benny+usenet@amorsen.dk>
Cc: anderse@gmx.de, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 23, 2009 at 4:39 PM, Benny Amorsen<benny+usenet@amorsen.dk> wrote:
> Markus Rechberger <mrechberger@gmail.com> writes:
>
>> For those who are interested in such a solution:
>>
>> http://support.sundtek.de/index.php/topic,2.0.html
>>
>> http://sundtek.de/shop/Digital-TV-Sticks/Sundtek-MediaTV-Pro.html
>
> This doesn't appear to have any support for CA modules? DVB-C is not
> very useful around here without a CAM...
>

We are currently discussing this with one of our partners as the
situation changed
with having everything in userspace the devices will usually have
manufacturer support.

>> There's a fully supported solution available for Linux already, it
>> also includes online Linux support. The installation of the drivers
>> can't be easier.
>
> I have to admit that it is cool that the driver is in user space. How
> about getting it included in the various Linux distributions?
>

We do not aim to include the drivers in any distribution as we can
keep control on driver updates
any time.
The driver can be downloaded on our site.
It is tested with various Linuxversions between 2.6.15 and 2.6.30 (32
and 64bit).
The entire system can coexist with already available Kerneldrivers
(eg. linuxuvc driver), but it
does not need any video4linux or dvb support in the kernel to be supported.
It makes installing videodrivers a totally new experience, doable
within a few seconds on
most systems.

Best Regards,
Markus
