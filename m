Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2525 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab0JSU1q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 16:27:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: rtl2832u support
Date: Tue, 19 Oct 2010 22:27:39 +0200
Cc: Damjan Marion <damjan.marion@gmail.com>,
	linux-media@vger.kernel.org
References: <B757CA7E-493B-44D6-8CE5-2F7AED446D70@gmail.com> <AANLkTim+QfU5hJwi_DkdpnAvUWSOLdEM5kXoTDK5+tsy@mail.gmail.com>
In-Reply-To: <AANLkTim+QfU5hJwi_DkdpnAvUWSOLdEM5kXoTDK5+tsy@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010192227.39364.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, October 19, 2010 21:26:13 Devin Heitmueller wrote:
> On Tue, Oct 19, 2010 at 1:42 PM, Damjan Marion <damjan.marion@gmail.com> wrote:
> >
> > Hi,
> >
> > Is there any special reason why driver for rtl2832u DVB-T receiver chipset is not included into v4l-dvb?
> >
> > Realtek published source code under GPL:
> >
> > MODULE_AUTHOR("Realtek");
> > MODULE_DESCRIPTION("Driver for the RTL2832U DVB-T / RTL2836 DTMB USB2.0 device");
> > MODULE_VERSION("1.4.2");
> > MODULE_LICENSE("GPL");
> 
> Unfortunately, in most cases much more is "required" than having a
> working driver under the GPL in order for it to be accepted upstream.
> In some cases it can mean a developer spending a few hours cleaning up
> whitespace and indentation, and in other cases it means significant
> work to the driver is required.
> 
> The position the LinuxTV team has taken is that they would rather have
> no upstream driver at all than to have a driver which doesn't have the
> right indentation or other aesthetic problems which has no bearing on
> how well the driver actually works.
> 
> This is one of the big reasons KernelLabs has tens of thousands of
> lines of code adding support for a variety of devices with many happy
> users (who are willing to go through the trouble to compile from
> source), but the code cannot be accepted upstream.  I just cannot find
> the time to do the "idiot work".

Bullshit. First of all these rules are those of the kernel community
as a whole and *not* linuxtv as such, and secondly you can upstream such
drivers in the staging tree. If you want to move it out of staging, then
it will take indeed more work since the quality requirements are higher
there.

Them's the rules for kernel development.

I've done my share of coding style cleanups. I never understand why people
dislike doing that. In my experience it always greatly improves the code
(i.e. I can actually understand it) and it tends to highlight the remaining
problematic areas in the driver.

Of course, I can also rant for several paragraphs about companies throwing
code over the wall without bothering to actually do the remaining work to
get it mainlined. The very least they can do is to sponsor someone to do the
work for them.

But I'll spare you that :-)

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
