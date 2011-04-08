Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3811 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276Ab1DHPjN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2011 11:39:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFCv1 PATCH 3/9] v4l2-ioctl: add ctrl_handler to v4l2_fh
Date: Fri, 8 Apr 2011 17:39:01 +0200
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
References: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com> <b4f1a4000c9764bfd326a4f9b3fbfa57b40ac102.1301916466.git.hans.verkuil@cisco.com> <201104081710.32652.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201104081710.32652.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201104081739.01073.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday, April 08, 2011 17:10:32 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Monday 04 April 2011 13:51:48 Hans Verkuil wrote:
> > From: Hans Verkuil <hverkuil@xs4all.nl>
> > 
> > This is required to implement control events and is also needed to allow
> > for per-filehandle control handlers.
> 
> Thanks for the patch.
> 
> Shouldn't you modify v4l2-subdev.c similarly ?
> 
> 

Good question. Does it make sense to have per-filehandle controls for a
sub-device? On the other hand, does it make sense NOT to have it?

I'm inclined to add this functionality if nobody objects. Although a
use-case for this would be nice bonus.

Regards,

	Hans
