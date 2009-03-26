Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:35124 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733AbZCZQrB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 12:47:01 -0400
Date: Thu, 26 Mar 2009 17:46:39 +0100
From: Janne Grunau <j@jannau.net>
To: Steven Toth <stoth@linuxtv.org>
Cc: linux-media@vger.kernel.org
Subject: Re: V4L2 Advanced Codec questions
Message-ID: <20090326164639.GA32219@aniel>
References: <49CBA64F.2080506@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CBA64F.2080506@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 26, 2009 at 11:59:11AM -0400, Steven Toth wrote:
> 
> I want to open a couple of HVR22xx items up for discussion.
> 
> The HVR-22xx analog encoder is capable of encoded to all kinds of video and 
> audio codecs in various containers formats.
> 
>  From memory, wm9, mpeg4, mpeg2, divx, AAC, AC3, Windows audio codecs in asf, 
> ts, ps, avi containers, depending on various firmware license enablements and 
> configuration options. Maybe more, maybe, I'll draw up a complete list when I 
> begin to focus on analog.

Well, the current list is already impressive. I guess MPEG audio layer 2 or 3
are missing. 

> Any single encoder on the HVR22xx can produce (if licensed) any of the formats 
> above. However, due to a lack of CPU horsepower in the RISC engine, the board is 
> not completely symmetrical when the encoders are running concurrently. This is 
> the main reason why Hauppauge have disabled these features in the windows driver.

I guess that will also be a problem within the v4l2 driver since user
space has generally no idea if two video devices share hardware.

> It's possible for example to get two concurrent MPEG2 PS streams but only if the 
> bitrate is limited to 6Mbps, which we also do in the windows driver.
> 
> Apart from the fact that we (the LinuxTV community) will need to determine 
> what's possible concurrently, and what isn't, it does raise interesting issues 
> for the V4L2 API.
> 
> So, how do we expose this advanced codec and hardware encoder limitation 
> information through v4l2 to the applications?

One possibility is adding an mpeg control which request concurrent usage
of the hardware encoder and limits the control values to allow
concurrent usage. If the control is not set, the hardware encoder will
be only useable on one device. User space applications need to discover
the devices sharing hardware and can set the concurrent mode if they wishes.

Current applications won't break but can only use hardware decoding on a
single device. A module option could force concurrent mode in which case
only the encoding parameters are limited but both devices can use
hardware encoding.

Janne

