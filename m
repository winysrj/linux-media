Return-path: <mchehab@gaivota>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46747 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab0KSHgs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 02:36:48 -0500
Received: by bwz15 with SMTP id 15so3610109bwz.19
        for <linux-media@vger.kernel.org>; Thu, 18 Nov 2010 23:36:47 -0800 (PST)
Subject: Re: rtl2832u support
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Damjan Marion <dmarion@me.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <C5D61175-5018-4D8F-B7D2-4A7FB5174DFB@me.com>
References: <B757CA7E-493B-44D6-8CE5-2F7AED446D70@gmail.com>
	 <AANLkTim+QfU5hJwi_DkdpnAvUWSOLdEM5kXoTDK5+tsy@mail.gmail.com>
	 <201010192227.39364.hverkuil@xs4all.nl>
	 <C5D61175-5018-4D8F-B7D2-4A7FB5174DFB@me.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Nov 2010 09:36:40 +0200
Message-ID: <1290152200.9749.1.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Wed, 2010-11-17 at 12:15 +0100, Damjan Marion wrote:
> On Oct 19, 2010, at 10:27 PM, Hans Verkuil wrote:
> > On Tuesday, October 19, 2010 21:26:13 Devin Heitmueller wrote:
> >> On Tue, Oct 19, 2010 at 1:42 PM, Damjan Marion <damjan.marion@gmail.com> wrote:
> >>> 
> >>> Hi,
> >>> 
> >>> Is there any special reason why driver for rtl2832u DVB-T receiver chipset is not included into v4l-dvb?
> >>> 
> >>> Realtek published source code under GPL:
> >>> 
> >>> MODULE_AUTHOR("Realtek");
> >>> MODULE_DESCRIPTION("Driver for the RTL2832U DVB-T / RTL2836 DTMB USB2.0 device");
> >>> MODULE_VERSION("1.4.2");
> >>> MODULE_LICENSE("GPL");
> >> 
> >> Unfortunately, in most cases much more is "required" than having a
> >> working driver under the GPL in order for it to be accepted upstream.
> >> In some cases it can mean a developer spending a few hours cleaning up
> >> whitespace and indentation, and in other cases it means significant
> >> work to the driver is required.
> >> 
> >> The position the LinuxTV team has taken is that they would rather have
> >> no upstream driver at all than to have a driver which doesn't have the
> >> right indentation or other aesthetic problems which has no bearing on
> >> how well the driver actually works.
> >> 
> >> This is one of the big reasons KernelLabs has tens of thousands of
> >> lines of code adding support for a variety of devices with many happy
> >> users (who are willing to go through the trouble to compile from
> >> source), but the code cannot be accepted upstream.  I just cannot find
> >> the time to do the "idiot work".
> > 
> > Bullshit. First of all these rules are those of the kernel community
> > as a whole and *not* linuxtv as such, and secondly you can upstream such
> > drivers in the staging tree. If you want to move it out of staging, then
> > it will take indeed more work since the quality requirements are higher
> > there.
> 
> 
> Do we have a common agreement that this driver can go to staging as-is?
> 
> If yes, I have patch ready, just need to know where to send it (It is around 1 MB).

I also bought that device few days ago.
Needless to say it works perfectly (better that in windows) with this
driver.

Best regards,
	Maxim Levitsky

