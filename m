Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:46625 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbZHRTKg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2009 15:10:36 -0400
Received: by ewy3 with SMTP id 3so1853652ewy.18
        for <linux-media@vger.kernel.org>; Tue, 18 Aug 2009 12:10:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090818210107.2a6a5146.don@tricon.hu>
References: <20090818170820.3d999fb9.don@tricon.hu>
	 <alpine.DEB.2.01.0908181959241.27276@ybpnyubfg.ybpnyqbznva>
	 <20090818210107.2a6a5146.don@tricon.hu>
Date: Tue, 18 Aug 2009 21:10:37 +0200
Message-ID: <d9def9db0908181210k20054201je2270a13446cc92d@mail.gmail.com>
Subject: Re: [linux-dvb] Anysee E30 C Plus + MPEG-4?
From: Markus Rechberger <mrechberger@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/8/18 Pásztor Szilárd <don@tricon.hu>:
> Thanks for the comprehensive answer.
> Mr. Thommeret's hint about the missing video PID pushed me into the right
> direction so I'm a step further now. With scan -vv I could find the video PIDs
> for the HD channels and indeed they were missing in my channels.conf (values
> were 0) as scan detected them as "OTHER", but with a "type 0x1b" addition with
> which I don't know what to do for the time being...
>
> After adding the correct PID values, mplayer still can't demux the incoming
> stream but the video is there, and with -dumpvideo a h264 elementary stream
> gets produced in the file that can be played back if I specify -demuxer
> h264es on the command line. What are beyond me now are:
> 1) how can mplayer not demux the stream if it can dump the video out
> (shouldn't a video dump involve a demux operation before all?)
> 2) is it a missing feature of mplayer that no metastream is processed that
> would carry the necessary information about the muxed streams? It would be
> adequate for me if I could specify a demuxer to use but it seems impossible in
> just one step - which I currently don't understand because an elementary
> stream is dumped as video.
>

You might try: dvbstream -o 8192 | mplayer -cache 10240 -

this forwards the entire stream to mplayer, you can switch the
channels with [tab]

Regards,
Markus
