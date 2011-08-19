Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47724 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab1HSKMu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Aug 2011 06:12:50 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: CJ <cjpostor@gmail.com>
Subject: Re: [beagleboard] Re: [PATCH v7 1/2] Add driver for Aptina (Micron) mt9p031 sensor.
Date: Fri, 19 Aug 2011 12:12:49 +0200
Cc: javier Martin <javier.martin@vista-silicon.com>,
	Koen Kooi <koen@beagleboard.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, mch_kot@yahoo.com.cn
References: <1307014603-22944-1-git-send-email-javier.martin@vista-silicon.com> <BANLkTinqZ5xbTG=h+64rxVui=kXjjtehig@mail.gmail.com> <4E4DC6C3.1000800@gmail.com>
In-Reply-To: <4E4DC6C3.1000800@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108191212.49729.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Friday 19 August 2011 04:13:23 CJ wrote:
> Hi,
> 
> I am trying to get the mt9p031 working from nand with a ubifs file
> system and I am having a few problems.
> 
> /dev/media0 is not present unless I run:
> #mknod /dev/media0 c 251 0
> #chown root:video /dev/media0
> 
> #media-ctl -p
> Enumerating entities
> media_open: Unable to enumerate entities for device /dev/media0
> (Inappropriate ioctl for device)
> 
> With the same rig/files it works fine running from EXT4 on an SD card.
> Any idea why this does not work on nand with ubifs?

Is the OMAP3 ISP driver loaded ? Has it probed the device successfully ? Check 
the kernel log for OMAP3 ISP-related messages.

-- 
Regards,

Laurent Pinchart
