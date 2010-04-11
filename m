Return-path: <linux-media-owner@vger.kernel.org>
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:38603 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab0DKDVP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Apr 2010 23:21:15 -0400
Message-ID: <4BC1401F.9080203@pobox.com>
Date: Sat, 10 Apr 2010 23:21:03 -0400
From: Mark Lord <mlord@pobox.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org
Subject: Re: cx18: "missing audio" for analog recordings
References: <4B8BE647.7070709@teksavvy.com>
 <1267493641.4035.17.camel@palomino.walls.org> <4B8CA8DD.5030605@teksavvy.com>
 <1267533630.3123.17.camel@palomino.walls.org> <4B9DA003.90306@teksavvy.com>
 <1268653884.3209.32.camel@palomino.walls.org>  <4BC0FB79.7080601@pobox.com>
 <1270940043.3100.43.camel@palomino.walls.org>
In-Reply-To: <1270940043.3100.43.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/04/10 06:54 PM, Andy Walls wrote:
>
> Hmmm.  Darren's having problems (loss of video/black screen) with my
> patches under my cx18-audio repo, but I'm not quite convinced he doesn't
> have some other PCI bus problem either.
>
> Anyway, my plan now is this:
>
> 1. on cx18-av-core.c:input_change()
> 	a. set register 0x808 for audio autodetection
> 	b. restart the format detection loop
> 	c. set or reset a 1.5 second timeout
>
> 2. after the timer expires, if no audio standard was detected,
> 	a. force the audio standard by programming register 0x808
> 		(e.g. BTSC for NTSC-M)
> 	b. restart the format detection loop so the micrcontroller will
> 		do the unmute when it detects audio
>
> Darren is in NTSC-M/BTSC land.  What TV standard are you dealing with?
..

I'm in Canada, using the tuner for over-the-air NTSC broadcasts.

Cheers!
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
