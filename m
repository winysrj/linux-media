Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44759 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab1CKIzy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 03:55:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: [PATCH v3 1/4] v4l: add V4L2_PIX_FMT_Y12 format
Date: Fri, 11 Mar 2011 09:56:18 +0100
Cc: linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <1299830749-7269-1-git-send-email-michael.jones@matrix-vision.de> <1299830749-7269-2-git-send-email-michael.jones@matrix-vision.de>
In-Reply-To: <1299830749-7269-2-git-send-email-michael.jones@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103110956.19233.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michael,

Thanks for the patch.

On Friday 11 March 2011 09:05:46 Michael Jones wrote:
> Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
> ---
>  Documentation/DocBook/v4l/pixfmt-y12.xml |   79 +++++++++++++++++++++++++++
>  include/linux/videodev2.h                |    1 +
>  2 files changed, 80 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/DocBook/v4l/pixfmt-y12.xml

You also need to modify Documentation/DocBook/v4l/pixfmt.xml (and 
Documentation/DocBook/media-entities.tmpl) to include pixfmt-y12.xml, 
otherwise the new documentation file won't be used. Search for 'sub-y16' for 
an example.

-- 
Regards,

Laurent Pinchart
