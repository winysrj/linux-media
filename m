Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39808 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754786Ab2D3OGU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 10:06:20 -0400
Date: Mon, 30 Apr 2012 17:06:16 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 1/1] v4l: drop v4l2_buffer.input and V4L2_BUF_FLAG_INPUT
Message-ID: <20120430140615.GM7913@valkosipuli.localdomain>
References: <20120430130413.GL7913@valkosipuli.localdomain>
 <1335792898-28620-1-git-send-email-sakari.ailus@iki.fi>
 <201204301548.14618.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204301548.14618.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for your comments.

On Mon, Apr 30, 2012 at 03:48:14PM +0200, Hans Verkuil wrote:
> On Monday 30 April 2012 15:34:58 Sakari Ailus wrote:
> > Remove input field in struct v4l2_buffer and flag V4L2_BUF_FLAG_INPUT which
> > tells the former is valid. The flag is used by no driver currently.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> > Hi all,
> > 
> > I thought this would be a good time to get rid of the input field in
> > v4l2_buffer to avoid writing more useless compat code for it --- the enum
> > compat code.
> > 
> > Comments are welcome. This patch is compile tested on videobuf and
> > videobuf2.
> 
> I'm all in favor of this. Don't forget to update the documentation as well, 
> though!

Good point. I'll go through that next.

> What would the impact be on applications, though? Any app that currently does 
> 'reserved = 0' would fail to compile after this change.

I had a bit of that in drivers and videobuf(2), too.

Is there a known good practice of dealing with this? The reserved fields are
supposed to be set to zero by applications but the reserved fields may even
vanish over time from some structs.

One option is to keep the reserved fields as array even there was just one
of them or if it no longer was there. If so, reserved should have been
reserved[1] in the first place. This would make it easier to deal with
the changing size of the reserved field.

> Perhaps rather than removing 'input' and changing 'reserved' to 'reserved[2]' 
> we should do something like this:
> 
> union {
> 	u32 input;
> 	u32 reserved2;
> };
> u32 reserved;
> 
> Or perhaps leave out the union and just replace 'input' by 'reserved2'.

That sounds like a good option to me, too.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
