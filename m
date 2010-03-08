Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx-mail.opticon.hu ([85.90.160.75]:53067 "EHLO
	mx-mail.opticon.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744Ab0CHVmV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Mar 2010 16:42:21 -0500
Subject: Re: DVB TS to DVD? Part 2
From: Levente =?ISO-8859-1?Q?Nov=E1k?= <lnovak@dragon.unideb.hu>
To: Juhana Sadeharju <kouhia@nic.funet.fi>
Cc: linux-media@vger.kernel.org
In-Reply-To: <S77953Ab0CHSEK7IBAI/20100308180411Z+8462@nic.funet.fi>
References: <S77953Ab0CHSEK7IBAI/20100308180411Z+8462@nic.funet.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Mar 2010 22:35:37 +0100
Message-ID: <1268084137.14970.15.camel@szisz.cimpi>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2010. 03. 8, hétfő keltezéssel 20.04-kor Juhana Sadeharju ezt írta:
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

Either try:

ffmpeg -i test.ts -target pal-dvd -vcodec copy -acodec copy test.vob

or download dvbcut and load your video into it. You can cut out the
parts you don't need and export the final version as MPEG-PS (DVD
compatible). There will be no transcoding, only at the few frames
inbetween two I-frames where the cut occurs. All the rest (audio as well
as video) is simply copied and muxed into the resulting VOB file. Dvbcut
will give out a very simplistic XML file you can use to feed dvdauthor
with in order to make your DVD directory. From there, use whatever DVD
burning app (brasero, k3b, etc.) you like to toast the DVD. I recommend
to use the svn version of dvbcut, not the age-old released version.

If you need menus, etc., then download e.g. devede or dvdwizard. The
first is menu-driven, the latter is a command-line tool which is as
simple to use as:

dvdwizard test.vob

(Please read the man page if you need to tweak the layout further.) Here
also, you will get a DVD directory, which can directly be burnt onto a
disc.

Levente


