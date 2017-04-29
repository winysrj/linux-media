Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:38751
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1946890AbdD2BqK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 21:46:10 -0400
Date: Fri, 28 Apr 2017 22:46:01 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v3 1/2] v4l: Add camera voice coil lens control class,
 current control
Message-ID: <20170428224106.44e0fdbd@vento.lan>
In-Reply-To: <20170428220004.GA23906@amd>
References: <1487074823-28274-1-git-send-email-sakari.ailus@linux.intel.com>
        <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
        <20170414232332.63850d7b@vento.lan>
        <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
        <20170419105118.72b8e284@vento.lan>
        <20170428220004.GA23906@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 29 Apr 2017 00:00:05 +0200
Pavel Machek <pavel@ucw.cz> escreveu:

> Hi!
> 
> > Hmm... if the idea is to have a control that doesn't do ringing
> > compensation, then it should be clear at the control's descriptions
> > that:
> > 
> > - V4L2_CID_FOCUS_ABSOLUTE should be used if the VCM has ringing
> >   compensation;
> > - V4L2_CID_VOICE_COIL_CURRENT and V4L2_CID_VOICE_COIL_RING_COMPENSATION
> >   should be used otherwise.
> > 
> > Btw, if the rationale for this patch is to support devices without
> > ring compensation, so, both controls and their descriptions should
> > be added at the same time, together with a patchset that would be
> > using both.
> >   
> > > How about adding such an explanation added to the commit message?  
> > 
> > It is not enough. Documentation should be clear that VCM devices
> > with ring compensation should use V4L2_CID_FOCUS_ABSOLUTE.  
> 
> Is ring compensation actually a big deal? We do not publish enough
> information to userland about how fast the autofocus system is,
> anyway, so it looks like userland can't depend on such details...

Well, I guess a V4L2 event could be used to identify the VCM's
current position and/or notify when the movement finished.

Anyway, the point is:

If V4L2_CID_VOICE_COIL_CURRENT would do the same as:
	V4L2_CID_FOCUS_ABSOLUTE
or:
	max - V4L2_CID_FOCUS_ABSOLUTE

there's no reason to create a new control, as the existing control
was already created to control the VCM current [1].

[1] Ok, we need to better document it, but that's a separate issue

We should create a new control only if it is doing something
different than the "standard" way of controlling a Voice Coil Motor.

On such case, the difference between controlling VCM via
V4L2_CID_VOICE_COIL_CURRENT or via V4L2_CID_FOCUS_ABSOLUTE should be 
clearly stated, as we expect that the other devices with the same need 
will implement the same control set and the same max/min convention
(e. g. max integer value meaning closest focus, min integer value
meaning infinite).

Thanks,
Mauro
