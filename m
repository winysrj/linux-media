Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:53528 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab2EHLzw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2012 07:55:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] v4l: v4l2-ctrls: Add forward declaration of struct file
Date: Tue, 8 May 2012 13:55:25 +0200
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com
References: <1335180551-27856-1-git-send-email-laurent.pinchart@ideasonboard.com> <2444415.6B1b1hMN1o@avalon>
In-Reply-To: <2444415.6B1b1hMN1o@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205081355.25412.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun 29 April 2012 18:30:24 Laurent Pinchart wrote:
> On Monday 23 April 2012 13:29:11 Laurent Pinchart wrote:
> > This fixes the following warning:
> > 
> > In file included from drivers/media/video/v4l2-subdev.c:29:
> > include/media/v4l2-ctrls.h:501: warning: 'struct file' declared inside
> > parameter list
> > include/media/v4l2-ctrls.h:501: warning: its scope is only this
> > definition or declaration, which is probably not what you want
> > include/media/v4l2-ctrls.h:509: warning: 'struct file' declared inside
> > parameter list
> 
> Ping ? Should I include this in my next pull request ?

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> >  include/media/v4l2-ctrls.h |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> > index 33907a9..9022e1c 100644
> > --- a/include/media/v4l2-ctrls.h
> > +++ b/include/media/v4l2-ctrls.h
> > @@ -25,6 +25,7 @@
> >  #include <linux/videodev2.h>
> > 
> >  /* forward references */
> > +struct file;
> >  struct v4l2_ctrl_handler;
> >  struct v4l2_ctrl_helper;
> >  struct v4l2_ctrl;
> 
> 
