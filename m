Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50941 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683Ab2EEBJq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2012 21:09:46 -0400
Received: by bkcji2 with SMTP id ji2so2631617bkc.19
        for <linux-media@vger.kernel.org>; Fri, 04 May 2012 18:09:45 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 5 May 2012 02:09:45 +0100
Message-ID: <CAA=3Ux98BUGsMYQrmZT=t5h7yHG8Rxnb=6gZ158esXAQi61ATw@mail.gmail.com>
Subject: Creating a DVB-T transport stream with ffmpeg
From: Tom Pitcher <tom@tjbp.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I'm attempting to broadcast an mpeg2 transport stream created with
ffmpeg via DVB-T. I have a modulator card with kernel driver, and have
successfully modulated (and received with a simple Hauppage DVB-T USB
device) a transport stream file I obtained from a friend. My problem
is the stream I create myself with ffmpeg (and it's mpegts options,
see link below for docs) is detected by my USB receiver's software (it
finds the channel name and reports full signal strength), but it
displays a black screen with no audio.

I used a spectrum analyser to search for the signal, and was able to
locate it and view it with sound - so I believe the problem is with
normal consumer receivers being unable to understand the stream. I
took a look at the two streams with a hex editor, and noticed my
friend's stream appears to contain a large quantity of additional data
before the media data itself starts. I also noticed that my file
browser's thumbnailer was able to generate thumbnails for the streams
I created, but was unable to for my friend's stream. I'm hoping that
my lack of a picture on the USB receiver is caused by the absence of
this additional data.

Could anyone with more knowledge of a DVB-T stream's structure shed
some light on what my ffmpeg-created stream might be missing that
upsets simple consumer receivers (I've tried a couple with identical
results)?

Many thanks for your time,
Tom

1: http://ffmpeg.org/ffmpeg.html#toc-mpegts
