Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59152 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbbFKOks (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2015 10:40:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dennis Chen <barracks510@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] USB: uvc: add support for the Microsoft Surface Pro 3 Cameras
Date: Thu, 11 Jun 2015 07:04:49 +0300
Message-ID: <6864236.zlxWyD7sh8@avalon>
In-Reply-To: <1433900441.11979.11.camel@gmail.com>
References: <1433879614.3036.3.camel@gmail.com> <2450709.nghA4lNjjK@avalon> <1433900441.11979.11.camel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dennis,

On Tuesday 09 June 2015 18:40:41 Dennis Chen wrote:
> > Is this needed ? Looking at the patch your cameras are UVC-compliant
> > and should thus be picked by the uvcvideo driver without any change to
> > the code.
> 
> The cameras are UVC-compliant but are not recognized by the uvc driver.
> The patch forces the uvc driver to pick up the camera if present.

Could you please send me the output of 'lsusb -v -d 045e:07be' and 'lsusb -v -
d 045e:07bf' (running as root if possible) ?

-- 
Regards,

Laurent Pinchart

