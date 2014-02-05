Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:32932 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751434AbaBEIOK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Feb 2014 03:14:10 -0500
Date: Wed, 5 Feb 2014 10:13:35 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	k.debski@samsung.com
Subject: Re: [PATCH v4.1 3/3] v4l: Add V4L2_BUF_FLAG_TIMESTAMP_SOF and use it
Message-ID: <20140205081334.GD15635@valkosipuli.retiisi.org.uk>
References: <201308281419.52009.hverkuil@xs4all.nl>
 <20140131164233.GB15383@valkosipuli.retiisi.org.uk>
 <52EBDB8B.80202@xs4all.nl>
 <1393149.6OyBNhdFTt@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393149.6OyBNhdFTt@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Feb 02, 2014 at 10:27:49AM +0100, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Friday 31 January 2014 18:21:15 Hans Verkuil wrote:
> > On 01/31/2014 05:42 PM, Sakari Ailus wrote:
> > > On Fri, Jan 31, 2014 at 04:45:56PM +0100, Hans Verkuil wrote:
> > >>
> > >> How about defining a capability for use with ENUMINPUT/OUTPUT? I agree
> > >> that this won't change between buffers, but it is a property of a
> > >> specific input or output.
> > >
> > > Over 80 characters per line. :-P
> > 
> > Stupid thunderbird doesn't show the column, and I can't enable
> > automatic word-wrap because that plays hell with patches. Solutions
> > welcome!
> > 
> > >> There are more than enough bits available in v4l2_input/output to add one
> > >> for SOF timestamps.
> > > 
> > > In complex devices with a non-linear media graph inputs and outputs are
> > > not very relevant, and for that reason many drivers do not even implement
> > > them. I'd rather not bind video buffer queues to inputs or outputs.
> > 
> > Then we end up again with buffer flags. It's a property of the selected
> > input or output, so if you can't/don't want to use that, then it's buffer
> > flags.
> > 
> > Which I like as well, but it's probably useful that the documentation states
> > that it can only change if the input or output changes as well.
> > 
> > > My personal favourite is still to use controls for the purpose but the
> > > buffer flags come close, too, especially now that we're using them for
> > > timestamp sources.
> > 
> > Laurent, can we please end this discussion? It makes perfect sense to store
> > this information as a BUF_FLAG IMHO. You can just do a QUERYBUF once after
> > you called REQBUFS and you know what you have to deal with.
> 
> I'm OK with a buffer flag. Can we state in the documentation that the same 
> timestamp flag will be used for all buffers and that QUERYBUF can be used to 
> query it before the first buffer gets dequeued ?

I think that'd be reasonable. Otherwise it'd be quite painful to use. I'll
resend.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
