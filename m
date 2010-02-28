Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:34031 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702Ab0B1NEd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2010 08:04:33 -0500
Subject: Re: cx18: where do the transport stream PIDs come from?
From: Andy Walls <awalls@radix.net>
To: Lars Hanisch <dvb@cinnamon-sage.de>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4B87F59A.7070006@cinnamon-sage.de>
References: <4B87F59A.7070006@cinnamon-sage.de>
Content-Type: text/plain
Date: Sun, 28 Feb 2010 08:04:33 -0500
Message-Id: <1267362273.3106.12.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-02-26 at 17:23 +0100, Lars Hanisch wrote:
> Hi,
> 
>   while working on a small test app which repacks the ivtv-PS into a TS, I received a sample from a cx18-based card. The 
> TS contains the video PID 301, audio PID 300 and PCR pid 101.
> 
>   Where do these PIDs come from, are they set by the driver or are they firmware given?

For analog captures, for which the firmware creates the TS, the firmware
sets them.


>   Is it possible to change them?

It is not possible to tell the firmware to change them.  There are two
documented CX23418 API commands in cx23418.h:

CX18_CPU_SET_VIDEO_PID
CX18_CPU_SET_AUDIO_PID

Unfortunately, I know they do nothing and will always directly return
0x200800ff, which is a CX23418 API error code.

Regards,
Andy

> Regards,
> Lars.


