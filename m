Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57306 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757424Ab1DHPK3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2011 11:10:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 3/9] v4l2-ioctl: add ctrl_handler to v4l2_fh
Date: Fri, 8 Apr 2011 17:10:32 +0200
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
References: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com> <b4f1a4000c9764bfd326a4f9b3fbfa57b40ac102.1301916466.git.hans.verkuil@cisco.com>
In-Reply-To: <b4f1a4000c9764bfd326a4f9b3fbfa57b40ac102.1301916466.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201104081710.32652.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Monday 04 April 2011 13:51:48 Hans Verkuil wrote:
> From: Hans Verkuil <hverkuil@xs4all.nl>
> 
> This is required to implement control events and is also needed to allow
> for per-filehandle control handlers.

Thanks for the patch.

Shouldn't you modify v4l2-subdev.c similarly ?

-- 
Regards,

Laurent Pinchart
