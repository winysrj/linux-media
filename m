Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:9688 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757102Ab2AKIh5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 03:37:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: vkalia@codeaurora.org
Subject: Re: Pause/Resume and flush for V4L2 codec drivers.
Date: Wed, 11 Jan 2012 09:37:53 +0100
Cc: linux-media@vger.kernel.org
References: <4e9191cad2837e2710d3ccb8be4aa735.squirrel@www.codeaurora.org> <201201061144.49354.hverkuil@xs4all.nl> <0a833d4c5de7f07094de25c5769121e3.squirrel@www.codeaurora.org>
In-Reply-To: <0a833d4c5de7f07094de25c5769121e3.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201110937.53176.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 07 January 2012 02:55:08 vkalia@codeaurora.org wrote:
> Thanks Hans.
> 
> Yes it does solve a part of my problem - Pause/Resume. But I dont see any
> command defined for Flush yet. Do you think we should add one more command
> to Flush.

What exactly does flush do? Is it the equivalent of an immediate stop?

> Also, I see two more commands
> 
> #define V4L2_DEC_CMD_START       (0)
> #define V4L2_DEC_CMD_STOP        (1)
> 
> How should I use the above two commands for an encoding/decoding session?
> I was calling start/stop to hardware in streamon/streamoff earlier.

See the documentation of these commands in patch 2/8: a write() or streamon
does an implicit decoder start, and close/streamoff() does an implicit 
immediate stop.

For hardware codecs that handle a compressed stream (as opposed to separate 
compressed frames) it is often very useful to implement the read/write API. 
That tends to be a natural API to use. E.g. you can just do:

	cat test.mpg >/dev/videoX

Regards,

	Hans

> 
> Thanks
> Vinay
> 
> > On Friday, January 06, 2012 03:31:37 vkalia@codeaurora.org wrote:
> >> Hi
> >> 
> >> I am trying to implement v4l2 driver for video decoders. The problem I
> >> am
> >> facing is how to send pause/resume and flush commands from user-space to
> >> v4l2 driver. I am thinking of using controls for this. Has anyone done
> >> this before or if anyone has any ideas please let me know. Appreciate
> >> your
> >> help.
> > 
> > See this patch series:
> > 
> > http://www.mail-archive.com/linux-media@vger.kernel.org/msg40516.html
> > 
> > Does this give you what you need?
> > 
> > Regards,
> > 
> > 	Hans
> > 	
> >> Thanks
> >> Vinay
> >> 
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-media"
> >> in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
