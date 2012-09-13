Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:54354 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab2IMKqJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 06:46:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFCv2 API PATCH 06/28] v4l2-core: deprecate V4L2_BUF_TYPE_PRIVATE
Date: Thu, 13 Sep 2012 12:46:04 +0200
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl> <673c927597decb682b3ca4b732ffbb306bc99496.1347023744.git.hans.verkuil@cisco.com> <3896855.5Ed4GMDzB4@avalon>
In-Reply-To: <3896855.5Ed4GMDzB4@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209131246.04973.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 13 September 2012 04:21:14 Laurent Pinchart wrote:
> Hi Hans,
> 
> Thanks for the patch.
> 
> On Friday 07 September 2012 15:29:06 Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > This buffer type isn't used at all, and since it is effectively undefined
> > what it should do it is deprecated. The define still exists, but any
> > internal support for such buffers is removed.
> > 
> > The decisions to deprecate this was taken during the 2012 Media Workshop.
> 
> What about also adding V4L2_BUF_TYPE_PRIVATE to Documentation/feature-removal-
> schedule.txt ?

I don't think it is important enough to do that. Removing it in the future may
cause application breakage, and frankly, perhaps we might need it again at some
time. Unlikely, but you'll never know.

Regards,

	Hans
