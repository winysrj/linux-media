Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40537 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab1IBMAJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2011 08:00:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: Using atmel-isi for direct output on framebuffer ?
Date: Fri, 2 Sep 2011 14:00:35 +0200
Cc: "Wu, Josh" <Josh.wu@atmel.com>, linux-media@vger.kernel.org
References: <20110901170555.568af6ea@skate> <201109021342.03721.laurent.pinchart@ideasonboard.com> <20110902135158.41e9c84d@skate>
In-Reply-To: <20110902135158.41e9c84d@skate>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201109021400.36513.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomas,

On Friday 02 September 2011 13:51:58 Thomas Petazzoni wrote:
> Le Fri, 2 Sep 2011 13:42:03 +0200, Laurent Pinchart a écrit :
> > I'm not sure if V4L2_CAP_VIDEO_OVERLAY is a good solution for this.
> > This driver type (or rather buffer type) was used on old systems to
> > capture directly to the PCI graphics card memory. Nowadays I would
> > advice using USERPTR with framebuffer memory.
> 
> Could you give a short summary of how the USERPTR mechanism works?

In a nutshell, instead of asking the capture driver to allocate buffers and 
map them to userspace, applications pass userspace buffer pointers to the 
driver.

In your case the application would mmap() the framebuffer memory and give 
pointers to that memory to the capture driver.

-- 
Regards,

Laurent Pinchart
