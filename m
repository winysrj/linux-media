Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53143 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab1HLU6x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2011 16:58:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sriram V <vshrirama@gmail.com>
Subject: Re: omap3isp driver
Date: Fri, 12 Aug 2011 22:58:56 +0200
Cc: linux-media@vger.kernel.org
References: <CAH9_wROx_jQRtJ-2bFz8dRq-=E=oy1CUpN5n-4Fm9o-zaMHgvg@mail.gmail.com>
In-Reply-To: <CAH9_wROx_jQRtJ-2bFz8dRq-=E=oy1CUpN5n-4Fm9o-zaMHgvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108122258.58012.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sriram,

On Tuesday 09 August 2011 19:03:17 Sriram V wrote:
> Hi,
>    Does the omap3isp driver implementation support rgb888 format?

No, that's not supported. The driver only support raw sensors. Support for 
YUYV sensors could be implemented, but the hardware doesn't support RGB888 
(except maybe to capture it directly to memory for CSI2 sensors).

-- 
Regards,

Laurent Pinchart
