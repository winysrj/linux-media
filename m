Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:40540 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934318Ab1KJLcQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 06:32:16 -0500
From: Alain VOLMAT <alain.volmat@st.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Thu, 10 Nov 2011 12:32:09 +0100
Subject: RE: MediaController support in LinuxDVB demux
Message-ID: <E27519AE45311C49887BE8C438E68FAA01010C68B139@SAFEX1MAIL1.st.com>
References: <E27519AE45311C49887BE8C438E68FAA01010C61F5A6@SAFEX1MAIL1.st.com>
 <201111041057.26112.pboettcher@kernellabs.com>
In-Reply-To: <201111041057.26112.pboettcher@kernellabs.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Patrick,

> Would it be a problem for you to elaborate a little bit more around 
> the why and how and what around MC in DVB? Before starting to 
> implement it like Mauro suggested. Could you go more in detail for you 
> actual problem (like what is missing in the current dvb-demux)?
> 
> I think it is absolutely necessary to know more about the reasoning 
> around MC - as it has a big potential - before any implementation.
> 
> Maybe there are some block-diagrams and presentations around somewhere.
> Until now I only saw this Email-thread and this:
> http://www.linuxtv.org/events.php (at the very bottom).

Unfortunately, the slides we presented last month in Prague are not available online.
In our SoCs, it is possible to create one or several PES filters from one or multiple demux devices. Those PES can then be either pulled to user space via the demux or dvr device node or tunneled in the kernel directly to audio and video decoders. (we have several audio or video decoders that we can use in parallel).
So what we end up with is several sets of demux/audio/video entry points in order to exercise our demux and decoders.

We also have to keep a relation between our decoders input (in LinuxDVB world) and output (in V4L2 worlds) since after decode, V4L2 capture, A/V sync, display stuff are done via the V4L2 world.

So at the end we now have stuff like
	demux0 ------ audio0
                |-- video0

	demux1 ------ audio1
                |-- video1

This mapping helps to "know" which audio/video decoder will be use when doing direct tunneling between demux and decoders. (in real nothing prevent the demux0 to be ordered to send stuff to audio1 also ... ).
We however have some use case where we need to demux/decode more than 2 PES/streams in parallel (ex: 2 audio/1 video in case of you have a video stream displayed on TV with 1 language sent to TV speakers and a second language sent to headsets let say). In such case the demux0->(audio0,video0) mapping is not enough and we need to have a way to say demux0 will send its data to yet another decoder that is not audio0 not video0.

MediaController for sure would allow us to do that by linking demux output pad (PES filter) with a decoder entity.

That said, actually MediaController is not the only solution here and we can actually think of something even more simple such as adding outputs in the dmx_output_t field of struct dmx_pes_filter_params. For example in our case we would have DMX_OUT_DECODER1, DMX_OUT_DECODER2, DMX_OUT_DECODER3 and so on. 

So my feeling is that the MediaController would most probably help in some cases in the LinuxDVB and also it seems to be good to be able to link all together within a same pipeline LinuxDVB FE/DEMUX and V4L2 decoders/planes and outputs (in our cases). That done it would allow to exercise the whole pipeline from a single place in the pipeline (V4L2 or LinuxDVB) while currently we have to configure and control LinuxDVB and V4L2 separately. However, for the very time being, the first solution that it would solve it the case described above.

Regards,

Alain
