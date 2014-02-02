Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35465 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaBBJ0z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Feb 2014 04:26:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	k.debski@samsung.com
Subject: Re: [PATCH v4.1 3/3] v4l: Add V4L2_BUF_FLAG_TIMESTAMP_SOF and use it
Date: Sun, 02 Feb 2014 10:27:49 +0100
Message-ID: <1393149.6OyBNhdFTt@avalon>
In-Reply-To: <52EBDB8B.80202@xs4all.nl>
References: <201308281419.52009.hverkuil@xs4all.nl> <20140131164233.GB15383@valkosipuli.retiisi.org.uk> <52EBDB8B.80202@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 31 January 2014 18:21:15 Hans Verkuil wrote:
> On 01/31/2014 05:42 PM, Sakari Ailus wrote:
> > On Fri, Jan 31, 2014 at 04:45:56PM +0100, Hans Verkuil wrote:
> >>
> >> How about defining a capability for use with ENUMINPUT/OUTPUT? I agree
> >> that this won't change between buffers, but it is a property of a
> >> specific input or output.
> >
> > Over 80 characters per line. :-P
> 
> Stupid thunderbird doesn't show the column, and I can't enable
> automatic word-wrap because that plays hell with patches. Solutions
> welcome!
> 
> >> There are more than enough bits available in v4l2_input/output to add one
> >> for SOF timestamps.
> > 
> > In complex devices with a non-linear media graph inputs and outputs are
> > not very relevant, and for that reason many drivers do not even implement
> > them. I'd rather not bind video buffer queues to inputs or outputs.
> 
> Then we end up again with buffer flags. It's a property of the selected
> input or output, so if you can't/don't want to use that, then it's buffer
> flags.
> 
> Which I like as well, but it's probably useful that the documentation states
> that it can only change if the input or output changes as well.
> 
> > My personal favourite is still to use controls for the purpose but the
> > buffer flags come close, too, especially now that we're using them for
> > timestamp sources.
> 
> Laurent, can we please end this discussion? It makes perfect sense to store
> this information as a BUF_FLAG IMHO. You can just do a QUERYBUF once after
> you called REQBUFS and you know what you have to deal with.

I'm OK with a buffer flag. Can we state in the documentation that the same 
timestamp flag will be used for all buffers and that QUERYBUF can be used to 
query it before the first buffer gets dequeued ?

-- 
Regards,

Laurent Pinchart

