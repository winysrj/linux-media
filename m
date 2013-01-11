Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50520 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab3AKMGF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 07:06:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEW PATCHv1 1/2] DocBook: improve the error_idx field documentation.
Date: Fri, 11 Jan 2013 13:07:45 +0100
Message-ID: <5369864.8TV5KUicak@avalon>
In-Reply-To: <201301111248.19511.hverkuil@xs4all.nl>
References: <1357560588-5263-1-git-send-email-hverkuil@xs4all.nl> <5589342.kjDUmhmVqU@avalon> <201301111248.19511.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 11 January 2013 12:48:19 Hans Verkuil wrote:
> On Mon January 7 2013 20:56:07 Laurent Pinchart wrote:
> > On Monday 07 January 2013 13:09:47 Hans Verkuil wrote:
> > > From: Hans Verkuil <hans.verkuil@cisco.com>
> > > 
> > > The documentation of the error_idx field was incomplete and confusing.
> > > This patch improves it.
> > > 
> > > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > ---

[snip]

> > I think some flexibility should still probably be left to drivers (and I'm
> > not talking about UVC here), as some drivers might not be able to know
> > that a control is write-only before trying to read it and getting an
> > error.
>
> Well, if drivers don't know if a control is e.g. write-only until they try
> it, then it can't be done during pre-validation anyway, so that's no
> problem.

Sure, but my point is that we don't want to enforce in the spec that those 
checks must always be done during pre-validation, otherwise drivers that can't 
do it will violate the spec.

> The pre-validation should at minimum check whether ctrl_class is set up
> correctly, whether all controls in the list actually exist, and check
> against READ_ONLY or WRITE_ONLY (if known upfront).
> 
> The v4l2-compliance tool will test those minimum checks.
> 
> The control framework will also check whether the GRABBED flag is set for
> a control and if the new value of a control is valid.

-- 
Regards,

Laurent Pinchart

