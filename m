Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:42809 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751376AbdLROv0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 09:51:26 -0500
Date: Mon, 18 Dec 2017 14:51:24 +0000
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 02/17] media: v4l2-common: get rid of v4l2_routing
 dead struct
Message-ID: <20171218145123.6visinjwtd2knwi6@gofer.mess.org>
References: <cover.1506548682.git.mchehab@s-opensource.com>
 <a47fda6dbbdf84a9bdc607acfc769d00e8cb22f6.1506548682.git.mchehab@s-opensource.com>
 <84ee3a09-dec8-286e-94ce-7adf31f766a5@xs4all.nl>
 <20171218121113.4f50b6d7@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171218121113.4f50b6d7@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 18, 2017 at 12:11:13PM -0200, Mauro Carvalho Chehab wrote:
> Em Fri, 13 Oct 2017 15:24:34 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > > ---
> > >  include/media/v4l2-common.h | 14 +++++---------
> > >  1 file changed, 5 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> > > @@ -238,11 +239,6 @@ struct v4l2_priv_tun_config {
> > >  
> > >  #define VIDIOC_INT_RESET            	_IOW ('d', 102, u32)  
> 
> > 
> > Regarding this one: I *think* (long time ago) that the main reason for this
> > was to reset a locked up IR blaster. I wonder if this is still needed after
> > Sean's rework of this. Once that's all done and merged this would probably
> > merit another look to see if it can be removed.
> 
> Sean,
> 
> Could you please double-check if this is still required on RC?

The ioctl can also reset the digitizer in ivtv, I don't know anything
about that.

As far the IR receiver/blaster is concerned:

This ioctl does exactly as it says and it works. There are a few ways
that the zilog microcontroller can be crashed, but I don't know of any
that exist in the current code base.

I seem to recall that the microcontroller could get stuck due particular 
i2c states, which was fixed with patches to ivtv-i2c.c. That does not mean
there aren't any others though. 

What would be nicer if the ir driver got no response, it would reset it
automatically. I'm not sure how to wire up ir-kbd-i2c with the ir reset
function of ivtv and cx18 though.

Then again with no known use cases it seems superfluous. How about removing
the ioctl and then hooking up the IR driver to the reset, should it be
necessary?


Sean
