Return-path: <linux-media-owner@vger.kernel.org>
Received: from rouge.crans.org ([138.231.136.3]:57970 "EHLO rouge.crans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744AbZCTJI3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2009 05:08:29 -0400
Message-ID: <49C35D3D.7070300@crans.org>
Date: Fri, 20 Mar 2009 10:09:17 +0100
From: Brice Dubost <dubost@crans.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Weird TS Stream from DMX_SET_PES_FILTER
References: <1002969792.105131237502284915.JavaMail.root@email>
In-Reply-To: <1002969792.105131237502284915.JavaMail.root@email>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bob Ingraham wrote:
> Hello,
> 
> I've been using the Linux DVB API to grab DBV-S MPEG2 video packets using a TechniSat S2 card.
> 
> But something seems odd about DMX_SET_PES_FILTER.
> 
> It returns a TS packets for my pid just fine, but by MPEG2 frames have no PES headers!  The raw compressed MPEG2 frames just immediately follow the TS/adapation-field headers directly.
> 
> When I wrote my TS packet decoder, I was expecting to have to decode PES headers after the TS header. But instead I found the raw compressed frames.
> 
> They decode fine (with ffmpeg's libavcodec mpeg2 decoder,) and they look fine when rendered using SDL.
> 
> But besides my own program, I can't get vlc or mplayer to decode this stream. Both vlc and mplayer sense a TS stream, but then they never render anything because, I suspect, that they can't find PES headers.
> 
> So, two questions:
> 
> 1. Am I crazy or is DMX_SET_PES_FILTER returning a non-standard TS stream?
> 
> 2. Is there a way to receive a compliant MPEG-TS (or MPEG2-PS,) stream?
> 
> 3. Should I use DMX_SET_FILTER instead?
> 
> 4. If so, what goes in the filter/mask members of the dmx_filter_t struct?
> 
> 
> Thanks,
> Bob
> 
> PS: I use the following to filter on my video stream pid (0x1344):
> 
>  struct dmx_pes_filter_params f;
> 
>  memset(&f, 0, sizeof(f));
>  f.pid = (uint16_t) pid;
>  f.input = DMX_IN_FRONTEND;
>  f.output = DMX_OUT_TS_TAP;
>  f.pes_type = DMX_PES_OTHER;
>  f.flags   = DMX_IMMEDIATE_START;
> 
> 

Hello,
I use exactly the same parameters and I get a raw mpeg2-TS stream (ie
packet of 188 bytes with the TS headers as defined in the mpeg2-ts norm)

If you want your stream to be read with VLC you need also the PAT and
the PMT pids. If you want the sound you'll need also the PCR pid.

I don't know how to get the PES headers

Hope this information will help you

Regards

-- 
Brice
