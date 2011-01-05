Return-path: <mchehab@gaivota>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56182 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab1AEA7W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Jan 2011 19:59:22 -0500
Received: by iwn9 with SMTP id 9so14802419iwn.19
        for <linux-media@vger.kernel.org>; Tue, 04 Jan 2011 16:59:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimucMmO8Vb_y4xnhehQt+mamNMmXyY_qfrVOSo7@mail.gmail.com>
References: <AANLkTimucMmO8Vb_y4xnhehQt+mamNMmXyY_qfrVOSo7@mail.gmail.com>
Date: Wed, 5 Jan 2011 01:59:21 +0100
Message-ID: <AANLkTinv64SL4HavFRK-s2Tr4CTGPH4iQ9bz7=40v1Hc@mail.gmail.com>
Subject: Streaming on low resource
From: ayman bs <ammoun2005@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello,

I have an http stream in MPEG1/2 Video (mpgv)
Frame rate: 50 4000kb/s

It's basically the output of a satellite receiver with various resolutions.

480/576
544/576
720/576
704/576

Anyway, I have a P4 1.6GHZ with 512M RAM and 1024kb UL speed... I have
been trying to transcode and stream the signal to LAN, but my
principal intention is to stream to Internet. I'm using these options
in VLC which I found giving the best results.

Code:
:sout=#transcode{vcodec=mp4v,vb=650,fps=24,scale=0.5,acodec=mp3,ab=90,channels=1,samplerate=22050}:duplicate{dst=http{mux=ts,dst=:6666/},dst=display}
:no-sout-rtp-sap :no-sout-standard-sap :ttl=1 :sout-keep



I would like to ask you for any suggestion about any improvements...
I'm using Http because that's the only protocol I got running on
Internet... I got RTSP on LAN running but with no luck on Internet...
I'm doing NAT, so do you have any good experience with a particular
protocol.

I didn't see any difference with encapsulation methods, but I would be
pleased to hear your word.

Codecs: as you can see I'm using mp4 + mp3, the scale 0.5 is
sufficient but could you propose other parameters?

If I ever wanted to update the hardware what would be the priority,
CPU or RAM... I know both are needed...

Finally, I'm streaming from ubuntu 10.10 and any specific lightweight
distribution is welcome... as well as any other program similar to
VLC.

Thank you!
