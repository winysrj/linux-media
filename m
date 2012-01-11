Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34520 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932786Ab2AKOZd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 09:25:33 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: vkalia@codeaurora.org
Subject: Re: Pause/Resume and flush for V4L2 codec drivers.
Date: Wed, 11 Jan 2012 15:25:57 +0100
Cc: linux-media@vger.kernel.org
References: <4e9191cad2837e2710d3ccb8be4aa735.squirrel@www.codeaurora.org>
In-Reply-To: <4e9191cad2837e2710d3ccb8be4aa735.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201111525.58494.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vinay,

On Friday 06 January 2012 03:31:37 vkalia@codeaurora.org wrote:
> Hi
> 
> I am trying to implement v4l2 driver for video decoders. The problem I am
> facing is how to send pause/resume and flush commands from user-space to
> v4l2 driver. I am thinking of using controls for this. Has anyone done
> this before or if anyone has any ideas please let me know. Appreciate your
> help.

Is this a memory-to-memory device, or a live stream decoder ?

-- 
Regards,

Laurent Pinchart
