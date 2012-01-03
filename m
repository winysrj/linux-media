Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33394 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab2ACLRF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2012 06:17:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: James <angweiyang@gmail.com>
Subject: Re: Using OMAP3 ISP live display and snapshot sample applications
Date: Tue, 3 Jan 2012 12:17:19 +0100
Cc: linux-media@vger.kernel.org
References: <CAOy7-nNSu2v9VS9Bh5O5StvEAvoxA4DqN7KdSGfZZSje1_Fgnw@mail.gmail.com>
In-Reply-To: <CAOy7-nNSu2v9VS9Bh5O5StvEAvoxA4DqN7KdSGfZZSje1_Fgnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201031217.20473.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi James,

On Tuesday 03 January 2012 10:40:10 James wrote:
> Hi Laurent,
> 
> Happy New Year!!

Thank you. Happy New Year to you as well. May 2012 bring you a workable OMAP3 
ISP solution ;-)

> I saw that there is a simple viewfinder in your repo for OMAP3 and
> wish to know more about it.
> 
> http://git.ideasonboard.org/?p=omap3-isp-live.git;a=summary
> 
> I intend to test it with my 12-bit (Y12) monochrome camera sensor
> driver, running on top of Gumstix's (Steve v3.0) kernel.
> 
> Is it workable at the moment?

The application is usable but supports raw Bayer sensors only at the moment. 
It requires a frame buffer and an omap_vout device (both should be located 
automatically) and configures the OMAP3 ISP pipeline automatically to produce 
the display resolution.

-- 
Regards,

Laurent Pinchart
