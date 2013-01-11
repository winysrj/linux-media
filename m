Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59980 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab3AKN3a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 08:29:30 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] uvcvideo: Return -EACCES when trying to access a read/write-only control
Date: Fri, 11 Jan 2013 14:31:12 +0100
Message-ID: <1912507.Y1ty4L8jHZ@avalon>
In-Reply-To: <201301111426.28433.hverkuil@xs4all.nl>
References: <1357910040-27463-1-git-send-email-laurent.pinchart@ideasonboard.com> <201301111421.40294.hverkuil@xs4all.nl> <201301111426.28433.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 11 January 2013 14:26:28 Hans Verkuil wrote:
> On Fri January 11 2013 14:21:40 Hans Verkuil wrote:
> > On Fri January 11 2013 14:13:58 Laurent Pinchart wrote:
> > > Commit ba68c8530a263dc4de440fa10bb20a1c5b9d4ff5 (Partly revert "[media]
> > > uvcvideo: Set error_idx properly for extended controls API failures")
> > > also reverted commit 30ecb936cbcd83e3735625ac63e1b4466546f5fe
> > > ("uvcvideo: Return -EACCES when trying to access a read/write-only
> > > control") by mistake. Fix it.
> > > 
> > > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Actually, I need a clarification first: the code only checks for access to
> a read-only control, but the patch title says: "Return -EACCES when trying
> to access a read/write-only control", so either there is something missing
> in the patch, or the patch title is wrong.
> 
> I suspect it is just the title that is wrong.

Yes, the title is wrong. The original commit handled both, and 
ba68c8530a263dc4de440fa10bb20a1c5b9d4ff5 reverted only half of it.

I'll send a v2 with a fixed title.

-- 
Regards,

Laurent Pinchart

