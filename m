Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33595 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab2D3Jst (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 05:48:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: jean-philippe francois <jp.francois@cynove.com>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: subdev_pad_ops vs video_ops
Date: Mon, 30 Apr 2012 11:49:11 +0200
Message-ID: <1623809.9sSP79J6ei@avalon>
In-Reply-To: <CAGGh5h0nFxmX8rP-Sxu3CqCccX=dzpiqHy3VLvne2X3CwgvXHA@mail.gmail.com>
References: <CAGGh5h0nFxmX8rP-Sxu3CqCccX=dzpiqHy3VLvne2X3CwgvXHA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Philippe,

On Monday 30 April 2012 10:34:54 jean-philippe francois wrote:
> subdev_pad_ops and video_ops both contains operation related
> to format, crop and bus format.
> 
> When should one or the other be used ?
> For example mt9p031 implement everything using pad_ops, but other drivers
> use video_ops functions.

The pad ops are required by the media controller framework. New drivers should 
use pad ops for format and selection handling. We need wrappers to translate 
video ops to pad ops to be used by bridge drivers that don't support pad ops 
yet.

-- 
Regards,

Laurent Pinchart

