Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from utter.chaos.org.uk ([193.201.201.153])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <pdh@utter.chaos.org.uk>) id 1JU3YW-000173-FB
	for linux-dvb@linuxtv.org; Tue, 26 Feb 2008 18:25:28 +0100
Received: from localhost ([127.0.0.1])
	by utter.chaos.org.uk with esmtp (Exim 4.34) id 1JU3YT-0001bB-4g
	for linux-dvb@linuxtv.org; Tue, 26 Feb 2008 17:25:25 +0000
From: Peter Hartley <pdh@utter.chaos.org.uk>
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="=-ptNJU2IVQs0b0PZXh+jT"
Date: Tue, 26 Feb 2008 17:25:24 +0000
Message-Id: <1204046724.994.21.camel@amd64.pyotr.org>
Mime-Version: 1.0
Subject: [linux-dvb] [PATCH] DMX_OUT_TSDEMUX_TAP: record two streams from
	same mux
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--=-ptNJU2IVQs0b0PZXh+jT
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi there,

Currently (in linux-2.6.24, but linux-dvb hg looks similar), the
dmx_output_t in the dmx_pes_filter_params decides two things: whether
output is sent to demux0 or dvr0 (in dmxdev.c:dvb_dmxdev_ts_callback),
*and* whether to depacketise TS (in dmxdev.c:dvb_dmxdev_filter_start).
As it stands, those two things can't be set independently: output
destined for demux0 is depacketised, output for dvr0 isn't.

This is what you want for capturing multiple audio streams from the same
multiplex simultaneously: open demux0 several times and send
depacketised output there. And capturing a single video stream is fine
too: open dvr0. But for capturing multiple video streams, it's surely
not what you want: you want multi-open (so demux0, not dvr0), but you
want the TS nature preserved (because that's what you want on output, as
you're going to re-multiplex it with the audio).

The attached patch adds a new value for dmx_output_t:
DMX_OUT_TSDEMUX_TAP, which sends TS to the demux0 device. The main
question I have, is, seeing as this was such a simple change, why didn't
it already work like that? Does everyone else who wants to capture
multiple video streams, take the whole multiplex into userspace and
demux it themselves? Or do they take PES from each demux0 device and
re-multiplex that into PS, not TS?

With this patch and a dvb-usb-dib0700 (and UK Freeview from Sandy
Heath), I can successfully capture an audio/video PID pair into a TS
file that mplayer can play back.

	Peter


--=-ptNJU2IVQs0b0PZXh+jT
Content-Disposition: attachment; filename=tsdemux.diff
Content-Type: text/x-patch; name=tsdemux.diff; charset=UTF-8
Content-Transfer-Encoding: 7bit

--- include/linux/dvb/dmx.h~	2008-01-24 22:58:37.000000000 +0000
+++ include/linux/dvb/dmx.h	2008-02-25 23:01:45.000000000 +0000
@@ -39,9 +39,10 @@ typedef enum
 	DMX_OUT_DECODER, /* Streaming directly to decoder. */
 	DMX_OUT_TAP,     /* Output going to a memory buffer */
 			 /* (to be retrieved via the read command).*/
-	DMX_OUT_TS_TAP   /* Output multiplexed into a new TS  */
+	DMX_OUT_TS_TAP,  /* Output multiplexed into a new TS  */
 			 /* (to be retrieved by reading from the */
 			 /* logical DVR device).                 */
+	DMX_OUT_TSDEMUX_TAP /* Like TS_TAP but retrieved from the DMX device */
 } dmx_output_t;
 
 
--- drivers/media/dvb/dvb-core/dmxdev.c~	2008-01-24 22:58:37.000000000 +0000
+++ drivers/media/dvb/dvb-core/dmxdev.c	2008-02-25 23:02:29.000000000 +0000
@@ -374,7 +374,8 @@ static int dvb_dmxdev_ts_callback(const 
 		return 0;
 	}
 
-	if (dmxdevfilter->params.pes.output == DMX_OUT_TAP)
+	if (dmxdevfilter->params.pes.output == DMX_OUT_TAP
+	    || dmxdevfilter->params.pes.output == DMX_OUT_TSDEMUX_TAP)
 		buffer = &dmxdevfilter->buffer;
 	else
 		buffer = &dmxdevfilter->dev->dvr_buffer;
@@ -618,7 +619,7 @@ static int dvb_dmxdev_filter_start(struc
 		else
 			ts_type = 0;
 
-		if (otype == DMX_OUT_TS_TAP)
+		if (otype == DMX_OUT_TS_TAP || otype == DMX_OUT_TSDEMUX_TAP)
 			ts_type |= TS_PACKET;
 
 		if (otype == DMX_OUT_TAP)

--=-ptNJU2IVQs0b0PZXh+jT
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--=-ptNJU2IVQs0b0PZXh+jT--
