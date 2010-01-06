Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:58140 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070Ab0AFBvi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jan 2010 20:51:38 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mitar <mitar@tnode.com>
Subject: Re: uvcvideo Logitech patch
Date: Wed, 6 Jan 2010 02:54:58 +0100
Cc: Ondrej Zary <linux@rainbow-software.org>,
	linux-uvc-devel@lists.berlios.de, linux-media@vger.kernel.org
References: <4B27DD88.3090900@tnode.com> <200912262048.53769.laurent.pinchart@ideasonboard.com> <4B3A3382.4080203@tnode.com>
In-Reply-To: <4B3A3382.4080203@tnode.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001060254.58500.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mitar,

On Tuesday 29 December 2009 17:51:14 Mitar wrote:
> Hi!
> 
> > Could be, but I'd like to know if increasing the control streaming
> > timeout is required as well.
> 
> I had some time now and have tested it and it is enough just to increase
> UVC_CTRL_STREAMING_TIMEOUT to 5000, I left UVC_CTRL_CONTROL_TIMEOUT at
> 300. And everything seems to work.

Thanks. I'll increase the streaming timeout value to 5000.

-- 
Regards,

Laurent Pinchart
