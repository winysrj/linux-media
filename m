Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:15103 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaHJRFV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Aug 2014 13:05:21 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NA300DPOOSVVK40@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Sun, 10 Aug 2014 13:05:19 -0400 (EDT)
Date: Sun, 10 Aug 2014 14:05:15 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 0/3] Another series of PM fixes for au0828
Message-id: <20140810140515.513d5ec8.m.chehab@samsung.com>
In-reply-to: <53E78CC1.1030905@xs4all.nl>
References: <1407636862-19394-1-git-send-email-m.chehab@samsung.com>
 <53E78CC1.1030905@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Em Sun, 10 Aug 2014 17:16:17 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi Mauro,
> 
> The following are just some general remarks regarding PM and au0828, it's
> not specific to this patch series. I'm just brainstorming here...
> 
> It's unfortunate that the au0828 isn't using vb2 yet. I would be interested in
> seeing what can be done in vb2 to help implement suspend/resume. Basically vb2
> has already most (all?) of the information it needs to handle this. Ideally all
> you need to do in the driver is to call vb2_suspend or vb2_resume and vb2 will
> take care of the rest, calling start/stop_streaming as needed. Some work would
> have to be done there to ensure buffers are queued/dequeued to the right queues
> and in the right state.

I guess one of the problems with any core-provided method is to ensure that
the tuner is initialized and locked before it, in order to avoid filling
buffers from the wrong channel.

Btw, this is one unsolved problem that we face with PM on media: we
need to assure that resume will follow a precise init order:
	- All core subsystems are initialized before everything else;
	- The firmwares are loaded;
	- The I2C gates are in the right state;
	- The tuner is set;
	- The gpio's are properly configured;
	- The analog and/or the digital demodulator are properly
	  configured;

Only after that, the driver (and VB2) can be resumed.

A proper PM support will require lots of changes at the media core, and
likely on other subsystems. We (I, Shuah and some people I'm hiring)
are looking into those issues, but a proper fix with proper core support
will take some time.

> So vb2 would handle all the DMA/streaming aspects of suspend/resume, thus
> simplifying the driver.

The changes will be minimal. Just one patch would be affected:
	https://patchwork.linuxtv.org/patch/25277/

IMHO, for USB drivers, the best strategy for suspend/resume is the one
taken on au0828, e. g. at suspend:
	- stop DMA;
	- cancel the pending URB;
	- stop any pending kthread;
	- call vb2_discard_done() to discard any pending buffers
	  (I think VB1 doesn't have anything similar);

And, at resume, restart them.

We could provide a core support to cancel the pending URBs, but most 
of the stuff are driver-specific, because the core doesn't have
any code to handle USB streams on a generic way (well, gspca has,
but it doesn't cover the DVB specifics).

I started writing a URB handling abstraction for the tm6000 driver
that I wanted to add at the core, but I didn't finish making it
generic enough. Moving it to core and porting the existing drivers
to use it would take a lot of time and effort. Not sure if it is
worth nowadays.

What I'm trying to say is that most of the issues related to
suspend/resume aren't at the streaming engine (being VB1, VB2
or a driver-specific one). Once we fix the main issues subsystem-wide,
then we can have a clearer view if are there anything we could do at
VB2 level.

> Is it perhaps an idea to convert au0828 to vb2 in order to pursue this further?
> 
> Besides, converting to vb2 tends to get rid of a substantial amount of code
> which makes it much easier to work with.

I don't think that converting au0828 to vb2 would help to improve
the suspend issues. Ok, should do it anyway at long term, as we want
one day to get rid of VB1, but we should take some care with this driver.
It has workarounds for several hardware bugs that cause the stream to
stop working under not well known situations. There are even two
threads there to detect and apply such workarounds when stream
suddenly stops without a (known) reason.

Regards,
Mauro
