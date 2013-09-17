Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailex.mailcore.me ([94.136.40.61]:46935 "EHLO
	mailex.mailcore.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab3IQPPf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Sep 2013 11:15:35 -0400
Message-ID: <5238720B.7040106@sca-uk.com>
Date: Tue, 17 Sep 2013 12:15:23 -0300
From: Steve Cookson <it@sca-uk.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	stoth@kernellabs.com
Subject: Re: Canvassing for Linux support for Startech PEXHDCAP
References: <523769B0.6070908@sca-uk.com> <CAGoCfiwVPGKSYOObirz+X3_AN6S1LL5Eff9kcWswcHx-msguiA@mail.gmail.com>
In-Reply-To: <CAGoCfiwVPGKSYOObirz+X3_AN6S1LL5Eff9kcWswcHx-msguiA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16/09/2013 19:09, Devin Heitmueller wrote:
 > To be clear, this card is a *raw* capture card.  It does not have any
 > hardware compression for H.264.  It's done entirely in software.

Ok, well I misunderstood that.  And, in addition, I also thought that 
hardware encoding *reduced* latency, something you seem to indicate is 
not true.

If this is stored in a file, somehow it needs to be encoded, I just 
imagined that metal was faster than code.

 > Aside from the Mstar video decoder (for which there is no public
 > documentation), you would also need a driver for the saa7160 chip,
 > which there have been various half-baked drivers floating around but
 > nothing upstream, and none of them currently support HD capture
 > (AFAIK).

Well the chip thing is confusing me.

1) I don't understand the difference between the MST3367CMK-LF-170 and 
the saa7160.  Is one analogue and one digital?  Or do they perform 
different steps in the process (like one does encoding and one does the 
DMA thing?

2) If you look here,

http://katocctv.en.alibaba.com/product/594834688-213880911/1080p_PCIe_Video_Grabber_Video_Capture_Card.html

You'll see a very similar card with an extra chip.  You can just see 
that it is produced by Gennum (but I can't see the number).  There is 
also another chip on the underside, maybe this is the saa7160? And maybe 
it's on the underside of the PEXHDCAP too.  This is actually the one I 
saw working.  As I say it was very fast and high quality, but under windows.

Scroll down and you see this:

     Operation System: WINDOWS XP /VISTA/ 7 Linux 2.6. 14 or higher 
(32-bit and 64-bit)

Drilling into this, it appeared the statement was more aspirational than 
actual, but that it *had* been compatible, but there was not yet an 
available driver.  They would need to recompile something to include the 
latest linux libraries before it would be possible to write the 
drivers.  I've no idea what this could mean.  Although 2 clients had 
indeed written gstreamer drivers, one was Cisco systems, but had kept 
the code to themselves.

 > and none of them currently support HD capture (AFAIK).

What does this mean?  No saa7160 drivers, or no drivers period?  I have 
the Intensity Pro doing full-screen 1080i capture with minimal latency, 
but I hate the decklinksrc module.  It just does nearly nothing.  Maybe 
it could be re-written for v4l2src, but anyway it only accepts YPbPr, as 
I said before.

 > As always, a driver *can* be written, but it would be a rather large
 > project (probably several weeks of an engineer working full time on
 > it, assuming the engineer has experience in this area).  In this case
 > it's worse because a significant amount of reverse engineering would
 > be required.

Kato Vision agreed with you.  They were saying a few months (maybe two 
or three).  They didn't offer to write it, but they offered technical 
support with the driver-writing.

Thanks for your input.

Regards

Steve
