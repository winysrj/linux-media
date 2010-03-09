Return-path: <linux-media-owner@vger.kernel.org>
Received: from csmtp1.one.com ([195.47.247.21]:57440 "EHLO csmtp1.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756516Ab0CICLm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Mar 2010 21:11:42 -0500
Subject: Re: DVB TS to DVD? Part 2
From: Mike <mike@redtux.org.uk>
To: Juhana Sadeharju <kouhia@nic.funet.fi>
Cc: linux-media@vger.kernel.org
In-Reply-To: <S77953Ab0CHSEK7IBAI/20100308180411Z+8462@nic.funet.fi>
References: <S77953Ab0CHSEK7IBAI/20100308180411Z+8462@nic.funet.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Mar 2010 02:15:31 +0000
Message-Id: <1268100931.1825.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-03-08 at 20:04 +0200, Juhana Sadeharju wrote:
> I have not got any replies. Considering that in Finland the
> main Digital TV recording format is DVB TS and that DVD uses VOBs,
> I find it hard to believe that nobody knows how to convert
> between them.
> 
> I kind of expected that GNU/Linux has a DVD burner which has button
> "burn this video to DVD", but I could not find such a thing.
> Neither I could not find a video editor which can edit DVB TS files.
> I use head/tail/split now.
> 
> Instead, the geek stuff is pouring from every corner. Here is my
> best attempt so far:
> 
> 1. ffmpeg -i test.ts -vcodec copy -acodec copy test.vob
> 2. copy a commercial DVD to /tmp/dvd/
> 3. overwrite test.vob to vts_01_1.vob (byte-to-byte overwrite because
> test.vob is smaller)
> 4. growisofs -speed=4 -dvd-compat -Z /dev/dvd -udf -dvd-video /tmp/dvd
> 
> Problems:
> -First try with ffmpeg made a poor quality vob, and much smaller; every
> option adds to geek-meter!
> -ffmpeg with "copy" made vob which works poorly in Xine; skip forward/backward
> does not work
> -ffmpeg with "copy" made vob which works very poorly in LG DVD player:
> video skips, has noisy dropouts in audio, and eventually freezes
> 
> I don't think the problem is in the way how I made the DVD, because
> Xine can play the commercial vobs well, but not the vob made by ffmpeg.
> 
> I tested movie-to-dvd as well, but it wanted to convert the audio to
> WAV first. Stopped the test to that point. WAV conversion should not be
> necessary. I also tested other DVD burners but it looks like they could
> not make the required UDF disc. Check!
> 
> Juhana

try my app http://sourceforge.net/projects/burn360/

should do what you want

