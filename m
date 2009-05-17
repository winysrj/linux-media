Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2805 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbZEQIhH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 May 2009 04:37:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Subject: Re: cx18: Testers needed: VBI for non-NTSC-M input signals
Date: Sun, 17 May 2009 10:35:10 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	ivtv-devel@ivtvdriver.org, ivtv-users@ivtvdriver.org
References: <1242525964.16178.15.camel@morgan.walls.org>
In-Reply-To: <1242525964.16178.15.camel@morgan.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905171035.10520.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 17 May 2009 04:06:04 Andy Walls wrote:
> Hi,
>
> Thanks to a loaner PVR-350 from Hans, I've been able to implement VBI
> support in the cx18 driver for non-NTSC video standards.
>
> If you've got a 625 line PAL, SECAM, etc, video source and can test VBI
> functions on a CX23418 based card, I'd like to hear how it works.  The
> patches for testing are here:
>
> http://linuxtv.org/hg/~awalls/cx18-av-core
> http://linuxtv.org/hg/~awalls/cx18-av-core/archive/tip.tar.bz2
>
> I've only been able to test with PAL with VPS in field 1 line 16 and WSS
> in field 1 line 23.  I wasn't able to figure out how to get Teletext B
> out of the PVR-350, so I'd certainly like to hear if Teletext is
> working.

You can't get teletext out of the PVR-350. Only WSS and VPS. It's a hardware 
limitation.

I don't have access to my HVR1600 this week, I'll see if I can test it next 
Sunday.

Regards,

	Hans

> Note: to implement Raw VBI for 625 line/50 Hz systems to extract line 23
> (WSS), I had to blank one extra line in each field.  This means that
> 625/50 systems will be missing 1 line from the top of each field (e.g.
> line 24 won't show).  I thought that was better than having the fields
> move up or down around if the user turned VBI on or off.
>
> Regards,
> Andy



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
