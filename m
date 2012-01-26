Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53234 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab2AZT0C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 14:26:02 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 3/8] soc-camera: Add plane layout information to struct soc_mbus_pixelfmt
Date: Thu, 26 Jan 2012 20:26:11 +0100
Cc: linux-media@vger.kernel.org
References: <1327504351-24413-1-git-send-email-laurent.pinchart@ideasonboard.com> <1327504351-24413-4-git-send-email-laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1201261629031.10057@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1201261629031.10057@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201262026.12387.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Thursday 26 January 2012 16:38:31 Guennadi Liakhovetski wrote:
> On Wed, 25 Jan 2012, Laurent Pinchart wrote:
> > To compute the number of bytes per line according to the V4L2
> > specification, we need information about planes layout for planar
> > formats. The new enum soc_mbus_layout convey that information.
> 
> Maybe it is better to call that value not "the number of bytes per line
> according to the V4L2 specification," but rather "the value of the
> .bytesperline field?" Also, "conveys" seems a better fit to me:-)

OK. I'll change that.

-- 
Regards,

Laurent Pinchart
