Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3663 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab0CUQlK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Mar 2010 12:41:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: gerard.klaver@xs4all.nl
Subject: Re: RFC: Phase 1: Proposal to convert V4L1 drivers
Date: Sun, 21 Mar 2010 17:40:52 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	David Ellingsworth <david@identd.dyndns.org>
References: <201003200958.49649.hverkuil@xs4all.nl> <1269110319.4102.4.camel@gk-sem3.gkall.nl>
In-Reply-To: <1269110319.4102.4.camel@gk-sem3.gkall.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201003211740.52200.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 20 March 2010 19:38:39 Gerard Klaver wrote:
> On Sat, 2010-03-20 at 09:58 +0100, Hans Verkuil wrote:
> > Hi all,
> > 
> <lines deleted>
> > 
> > - ov511
> > - ovcamchip
> > - w9968cf
> > - stv680
> > 
> 
> > Conclusion:
> > 
> > These drivers have no hardware to test with: bw-qcam, c-qcam, arv, w9966.
> > However, all four should be easy to convert to v4l2, even without hardware.
> > Volunteers?
> > 
> 
> > 
> > Regards,
> > 
> > 	Hans
> > 
> 
> Hello, 
> 
> I have a c-qcam with par. port, so i can do some test, see page below
> for some information webcam:
>  
> http://gkall.hobby.nl/connectix-quickcam.html

Well, no good deed goes unpunished, so I'd appreciate it if you could do some
testing :-)

I did a quick conversion of c-qcam to V4L2. You can find the tree here:

http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-v4l1

It is 'bug compatible' with the V4L1 driver. I.e. I only converted the API,
I didn't check anything else. And I saw some very dubious contructs in the
init and exit paths, so I am almost positive that it needs a bit more work.

Please let me know how it goes and post the kernel messages that the driver
prints when loaded, used and when unloaded.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
