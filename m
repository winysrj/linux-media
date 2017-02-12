Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33226 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751468AbdBLWLV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Feb 2017 17:11:21 -0500
Date: Mon, 13 Feb 2017 00:10:43 +0200
From: Sakari <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] smiapp: add CCP2 support
Message-ID: <20170212221042.GA16975@valkosipuli.retiisi.org.uk>
References: <20170208131127.GA29237@amd>
 <20170211220752.zr3j7irpxl42ewo3@ihha.localdomain>
 <20170211232258.GA11232@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170211232258.GA11232@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Sun, Feb 12, 2017 at 12:22:58AM +0100, Pavel Machek wrote:
> Hi!
> 
> > Besides this patch, what else is needed? The CSI-2 / CCP2 support is
> > missing in V4L2 OF at least. It'd be better to have this all in the same
> > set.
> 
> Quite a lot of is needed.
> 
> > I pushed the two DT patches here:
> > 
> > <URL:https://git.linuxtv.org/sailus/media_tree.git/commit/?h=ccp2>
> 
> Thanks for a branch. If you could the two patches that look ok there,
> it would mean less work for me, I could just mark those two as applied
> here.

I think a verb could be missing from the sentence. :-) I'll send a pull
request for the entire set, containing more than just the DT changes. Feel
free to base yours on top of this.

A word of warning: I have patches to replace the V4L2 OF framework by V4L2
fwnode. The preliminary set (which is still missing V4L2 OF removal) is
here, I'll post a refresh soon:

<URL:http://www.spinics.net/lists/linux-media/msg106160.html>

Let's see what the order ends up to be in the end. If the fwnode set is
applicable first, then I'd like to rebase the lane parsing changes on top of
that rather than the other way around --- it's easier that way.

> 
> Core changes for CSI2 support are needed.

CCP2? We could get these and the smiapp and possibly also the omap3isp
patches in first, to avoid having to manage a large patchset. What do you
think?

The rest could come later.

> 
> There are core changes in notifier locking, and subdev support.
> 
> I need video-bus-switch, at least for testing.
> 
> I need subdev support for omap3isp, so that we can attach flash and
> focus devices.
> 
> Finally dts support on N900 can be enabled.

Yes! 8-)

I don't know if any euros were saved by using that video bus switch but it
sure has caused a lot of hassle (and perhaps some gray hair) for software
engineers. X-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
