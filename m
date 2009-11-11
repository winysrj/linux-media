Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:47926 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758730AbZKKAIl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 19:08:41 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Martin Rod <martin.rod@email.cz>
Subject: Re: MSI StarCam Racer - No valid video chain found
Date: Wed, 11 Nov 2009 01:09:26 +0100
Cc: linux-media@vger.kernel.org
References: <4AED4C3B.3020706@email.cz> <200911041609.29721.laurent.pinchart@ideasonboard.com> <4AF1FA24.4090608@email.cz>
In-Reply-To: <4AF1FA24.4090608@email.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911110109.26415.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin,

On Wednesday 04 November 2009 23:03:16 Martin Rod wrote:
> Hi Laurent,
> 
> I send you  log file with trace (kernel 2.6.30.9)

Thanks. The log shows that your problem comes from UVC descriptors parsing. 
This has been fixed in 2.6.31, so you should upgrade to at least that version 
or install the latest uvcvideo driver.
 
> I have tried this kernel (on UBNT RouterStation and OpenWrt) with results:
> 
> 2.6.28.10. -  camera works, I tried only snapshots (I have to use
> external power for USB, without  external  power  sometimes works,
> sometimes  no ...)
> 2.6.31.5 - kernel copmpiles ok, but uvcvideo module was missing, I don't
> know why ...

Check that the uvcvideo driver is selected using make menuconfig.

-- 
Regards,

Laurent Pinchart
