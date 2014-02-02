Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35545 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaBBJo3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Feb 2014 04:44:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, detlev.casanova@gmail.com
Subject: Re: [RFC PATCH 0/2] Allow inheritance of private controls
Date: Sun, 02 Feb 2014 10:45:24 +0100
Message-ID: <14055698.TyElnNSLTS@avalon>
In-Reply-To: <1391166726-27026-1-git-send-email-hverkuil@xs4all.nl>
References: <1391166726-27026-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patches.

On Friday 31 January 2014 12:12:04 Hans Verkuil wrote:
> Devices with a simple video pipeline may want to inherit private controls
> of sub-devices and expose them to the video node instead of v4l-subdev
> nodes (which may be inhibit anyway by the driver).
> 
> Add support for this.
> 
> A typical real-life example of this is a PCI capture card with just a single
> video receiver sub-device. Creating v4l-subdev nodes for this is overkill
> since it is clear which control belongs to which subdev.

The is_private flag has been introduced to allow subdevs to disable control 
inheritance. We're now adding a way for bridges to override that, which makes 
me wonder whether private controls are really the best way to express this.

Shouldn't we think about what we're trying to achieve with controls and places 
where they're exposed and then possibly rework the code accordingly ?

-- 
Regards,

Laurent Pinchart

