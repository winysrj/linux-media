Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60685 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab0JSUrK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 16:47:10 -0400
Received: by ywi6 with SMTP id 6so1547849ywi.19
        for <linux-media@vger.kernel.org>; Tue, 19 Oct 2010 13:47:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201010192227.39364.hverkuil@xs4all.nl>
References: <B757CA7E-493B-44D6-8CE5-2F7AED446D70@gmail.com>
	<AANLkTim+QfU5hJwi_DkdpnAvUWSOLdEM5kXoTDK5+tsy@mail.gmail.com>
	<201010192227.39364.hverkuil@xs4all.nl>
Date: Tue, 19 Oct 2010 16:47:09 -0400
Message-ID: <AANLkTim8BZvyxbj9SV3rNi0sSpnjX8WneCjAu5XxN0ve@mail.gmail.com>
Subject: Re: rtl2832u support
From: Alex Deucher <alexdeucher@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Damjan Marion <damjan.marion@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Oct 19, 2010 at 4:27 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Tuesday, October 19, 2010 21:26:13 Devin Heitmueller wrote:
>> On Tue, Oct 19, 2010 at 1:42 PM, Damjan Marion <damjan.marion@gmail.com> wrote:
>> >
>> > Hi,
>> >
>> > Is there any special reason why driver for rtl2832u DVB-T receiver chipset is not included into v4l-dvb?
>> >
>> > Realtek published source code under GPL:
>> >
>> > MODULE_AUTHOR("Realtek");
>> > MODULE_DESCRIPTION("Driver for the RTL2832U DVB-T / RTL2836 DTMB USB2.0 device");
>> > MODULE_VERSION("1.4.2");
>> > MODULE_LICENSE("GPL");
>>
>> Unfortunately, in most cases much more is "required" than having a
>> working driver under the GPL in order for it to be accepted upstream.
>> In some cases it can mean a developer spending a few hours cleaning up
>> whitespace and indentation, and in other cases it means significant
>> work to the driver is required.
>>
>> The position the LinuxTV team has taken is that they would rather have
>> no upstream driver at all than to have a driver which doesn't have the
>> right indentation or other aesthetic problems which has no bearing on
>> how well the driver actually works.
>>
>> This is one of the big reasons KernelLabs has tens of thousands of
>> lines of code adding support for a variety of devices with many happy
>> users (who are willing to go through the trouble to compile from
>> source), but the code cannot be accepted upstream.  I just cannot find
>> the time to do the "idiot work".
>
> Bullshit. First of all these rules are those of the kernel community
> as a whole and *not* linuxtv as such, and secondly you can upstream such
> drivers in the staging tree. If you want to move it out of staging, then
> it will take indeed more work since the quality requirements are higher
> there.
>
> Them's the rules for kernel development.
>
> I've done my share of coding style cleanups. I never understand why people
> dislike doing that. In my experience it always greatly improves the code
> (i.e. I can actually understand it) and it tends to highlight the remaining
> problematic areas in the driver.
>
> Of course, I can also rant for several paragraphs about companies throwing
> code over the wall without bothering to actually do the remaining work to
> get it mainlined. The very least they can do is to sponsor someone to do the
> work for them.

To start, I appreciate the kernel coding style requirements.  I think
it makes the code much easier to read and more consistent across the
kernel tree.  But, just to play devil's advocate, it's a fair amount
of work to write a driver especially if the hw is complex.  It's much
easier to share a common codebase between different OSs because to
reduces the maintenance burden and makes it easier to support new asic
variants.  This is especially true if you are a small company with
limited resources.  It annoys me somewhat when IHVs put in the effort
to actually produce a GPLed Linux driver and the community shits on
them for not writing it from scratch to match the kernel style
requirements.  Lets face it, there are a lot of hw specs out there
with no driver.  A working driver with source is vastly more useful.
It would be nice if every company out there had the resources to
develop a nice clean native Linux driver, but right now that's not
always the case.

Alex
