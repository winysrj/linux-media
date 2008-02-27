Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from el-out-1112.google.com ([209.85.162.180])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zaheermerali@gmail.com>) id 1JUKdD-00052S-M5
	for linux-dvb@linuxtv.org; Wed, 27 Feb 2008 12:39:27 +0100
Received: by el-out-1112.google.com with SMTP id s27so2343567ele.13
	for <linux-dvb@linuxtv.org>; Wed, 27 Feb 2008 03:39:19 -0800 (PST)
Message-ID: <15e616860802270339s25938affsfede0f985111ee5f@mail.gmail.com>
Date: Wed, 27 Feb 2008 11:39:18 +0000
From: "Zaheer Merali" <zaheermerali@gmail.com>
To: "Peter Hartley" <pdh@utter.chaos.org.uk>
In-Reply-To: <1204046724.994.21.camel@amd64.pyotr.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <1204046724.994.21.camel@amd64.pyotr.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] DMX_OUT_TSDEMUX_TAP: record two streams
	from same mux
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

2008/2/26 Peter Hartley <pdh@utter.chaos.org.uk>:
> Hi there,
>
>  Currently (in linux-2.6.24, but linux-dvb hg looks similar), the
>  dmx_output_t in the dmx_pes_filter_params decides two things: whether
>  output is sent to demux0 or dvr0 (in dmxdev.c:dvb_dmxdev_ts_callback),
>  *and* whether to depacketise TS (in dmxdev.c:dvb_dmxdev_filter_start).
>  As it stands, those two things can't be set independently: output
>  destined for demux0 is depacketised, output for dvr0 isn't.
>
>  This is what you want for capturing multiple audio streams from the same
>  multiplex simultaneously: open demux0 several times and send
>  depacketised output there. And capturing a single video stream is fine
>  too: open dvr0. But for capturing multiple video streams, it's surely
>  not what you want: you want multi-open (so demux0, not dvr0), but you
>  want the TS nature preserved (because that's what you want on output, as
>  you're going to re-multiplex it with the audio).
>
>  The attached patch adds a new value for dmx_output_t:
>  DMX_OUT_TSDEMUX_TAP, which sends TS to the demux0 device. The main
>  question I have, is, seeing as this was such a simple change, why didn't
>  it already work like that? Does everyone else who wants to capture
>  multiple video streams, take the whole multiplex into userspace and
>  demux it themselves? Or do they take PES from each demux0 device and
>  re-multiplex that into PS, not TS?
>

With GStreamer, what we do is userspace demuxing and only on dvr and
not the demux device and start by only filtering the PAT pid, then
when the first PAT comes and has been parsed, add to the filter the
PMT pids for the programs that we want and then as each PMT comes add
to the filter the es pids. We provide different ts's for each of the
programs on different src (output) pads in the mpegtsparse element.
Programs can be selected, added, removed on the fly. We have a
compound gstreamer element that basically encompasses the dvbsrc which
reads from the device and the mpegtsparse that does the ts parsing
called dvbbasebin. And an example that would record multiple  programs
is as follows:

gst-launch-0.10  dvbbasebin adapter=0 frequency=10773000 polarity=h
symbol-rate=22000 program-numbers=6301:6302:6304 name=d .program_6301
! queue ! filesink location=bbc1lon.ts d.program_6302 ! queue !
filesink location=bbc2eng.ts d.program_6304 ! queue ! filesink
location=bbcnews24.ts

So we don't take the whole multiplex into userspace, just the pids we
need on an as needed basis.

Regards

Zaheer

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
