Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54895 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab1KGRdy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2011 12:33:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andrew Tubbiolo <andrew.tubbiolo@gmail.com>
Subject: Re: mt9p031 driver source.
Date: Mon, 7 Nov 2011 18:33:51 +0100
Cc: linux-media@vger.kernel.org
References: <CAAN7ACRw1nGXRgs6Mtx4x-0USWMMohH0WrW4H7XEhMVnFaVSLw@mail.gmail.com> <CAAN7ACQQLAao2rGp2zWgob0mBSs+DUqd1SLkBgzZW-poRBDVsA@mail.gmail.com>
In-Reply-To: <CAAN7ACQQLAao2rGp2zWgob0mBSs+DUqd1SLkBgzZW-poRBDVsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111071833.52553.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrew,

On Saturday 05 November 2011 05:01:01 Andrew Tubbiolo wrote:
> Hi All:
> 
>    I've been playing with the mt9p031 for some time now. Last weekend
> I got the raw 12 bit data dump I've been wanting for some time. As of
> now the module I'm using only works if it is included in the kernel. I
> cannot obtain functionality or enumeration on the i2c bus if I insert
> it as a module. I think some of the init code is missing in the
> version of the driver I've been working with. Can folks who are
> working with the aptina mt9p031.c driver tell me the location from
> which you obtained your source? I need a driver that is compatiable
> with linux 2.6.39 and ready to respond to commands from media-ctl.

Where have you got the mt9p031 driver you're currently using ? An mt9p031 
driver is now available in mainline, you should use that one.

-- 
Regards,

Laurent Pinchart
