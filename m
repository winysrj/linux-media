Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1768 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758620Ab2AFKpE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 05:45:04 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: vkalia@codeaurora.org
Subject: Re: Pause/Resume and flush for V4L2 codec drivers.
Date: Fri, 6 Jan 2012 11:44:49 +0100
Cc: linux-media@vger.kernel.org
References: <4e9191cad2837e2710d3ccb8be4aa735.squirrel@www.codeaurora.org>
In-Reply-To: <4e9191cad2837e2710d3ccb8be4aa735.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201061144.49354.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, January 06, 2012 03:31:37 vkalia@codeaurora.org wrote:
> Hi
> 
> I am trying to implement v4l2 driver for video decoders. The problem I am
> facing is how to send pause/resume and flush commands from user-space to
> v4l2 driver. I am thinking of using controls for this. Has anyone done
> this before or if anyone has any ideas please let me know. Appreciate your
> help.

See this patch series:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg40516.html

Does this give you what you need?

Regards,

	Hans

> 
> Thanks
> Vinay
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
