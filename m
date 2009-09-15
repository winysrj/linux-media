Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:59091 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758153AbZIOVGl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 17:06:41 -0400
Date: Tue, 15 Sep 2009 14:06:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org
Subject: Re: V4L/DVB API specifications at linux kernel
Message-Id: <20090915140634.44ab3413.randy.dunlap@oracle.com>
In-Reply-To: <20090915162002.1c72c5b3@pedra.chehab.org>
References: <20090915162002.1c72c5b3@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 15 Sep 2009 16:20:02 -0300 Mauro Carvalho Chehab wrote:

> Something that always bothered me is that the documentation inside the kernel
> for V4L/DVB were never properly updated, since people that write drivers in
> general don't bother to keep the docs updated there. After some time, we've
> removed V4L1 API from kernel (in text format, as far as I can remember), but
> never added V4L2 API. Also, there weren't there any dvb api specs.
> 
> As an effort to change it, I did a work during the last few weeks to port V4L2 API
> from DocBook v3.1 to DocBook XML v4.1.2. I also ported DVB specs from LaTex
> into DocBook XML v4.1.2. This way, the API docs are compatible with the DocBook version
> used in kernel (even eventually not having the same writing style as found there).
> 
> I tried to make the port as simple as possible, yet preserving the original
> text. So, for sure there are space for style reviews, especially at the dvb
> part, where the LaTex -> xml conversion were harder.
> 
> After having both ported, I've rearranged a few chapters and merged them
> both into just one DocBook book, to allow having some parts shared, like IR.
> 
> The final document were broken into 3 parts:
> I. Video for Linux Two API Specification
> 	(basically, the same contents found at V4L2 spec version 2.6.32, except for IR chapter)
> II. Linux DVB API
> 	(basically, the same contents found at DVB spec version 3)
> III. Other API's used by media infrastructure drivers
> 	(basically, the IR chapter taken from V4L2 spec)
> 
> The resulting html pages can be seen at: http://linuxtv.org/downloads/v4l_dvb_apis/
> 
> The Kernel patches with the Document are at:
> 
> http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-next.git;a=commit;h=9444a960e4c7c49e055bb7fa66a0805c46317ba0
> http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-next.git;a=commit;h=664efd3215fdb17d5f3f70073af4a6b61d50a96c
> 
> Please review. If they're ok, I'm intending to submit them for addition at 2.6.32.


Hi Mauro,

That's large, :) so I'm not planning to review it in great detail.

Here are some comments on it:


1.  http://linuxtv.org/downloads/v4l_dvb_apis/index.html

List of Figures:

where are the figures?  how do I see them?


2.  http://linuxtv.org/downloads/v4l_dvb_apis/ch01.html


"
In /etc/modules.conf this may be written as:

alias char-major-81-0 mydriver
alias char-major-81-1 mydriver
alias char-major-81-64 mydriver              1
options mydriver video_nr=0,1 radio_nr=0,1   2
"

The trailing 1 and 2 there are not part of the modules.conf file, are they?
Are they footnote pointers?  They are a bit confusing.


3.  http://linuxtv.org/downloads/v4l_dvb_apis/ch01s10.html

footnote 11:
"Enumerating formats an application has no a-priori knowledge of (otherwise it could explicitely ask for them and need not enumerate) seems useless, but there are applications serving as proxy between drivers and the actual video applications for which this is useful."

s/explicitely/explicitly/


4.  http://linuxtv.org/downloads/v4l_dvb_apis/ch04s09.html

The URL:http://home.pages.de/~videotext/ is not found.
Checking more of them might be in order.


5.  http://linuxtv.org/downloads/v4l_dvb_apis/apc.html

" *      This program were got from V4L2 API, Draft 0.20"

s/were got/was taken/

6.  http://linuxtv.org/downloads/v4l_dvb_apis/ch17.html

"It is not rare that the same manufacturer to ship different types of controls, depending on the device."

-->
It is not rare for the same manufacturer to ship ...

"Unfortunately, during several years, there weren't any effort to uniform the IR keycodes under different boards. This resulted that the same IR keyname to be mapped completely different on different IR's. Due to that, V4L2 API now specifies a standard for mapping Media keys on IR."

--> (possibly:)
Unfortunately, for several years, there was no effort to create uniform IR keycodes for
different devices.  This caused the same IR keyname to be mapped completely differently on
different IR devices. ....



Anyway, lots of good info there.  Please push it.

Thanks,
---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
