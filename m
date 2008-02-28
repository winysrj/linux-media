Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: Peter Hartley <pdh@utter.chaos.org.uk>
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="=-KSLt0A+eVI7UuTfljXE7"
Date: Thu, 28 Feb 2008 11:52:26 +0000
Message-Id: <1204199546.1002.12.camel@amd64.pyotr.org>
Mime-Version: 1.0
Cc: v4l-dvb-maintainer@linuxtv.org
Subject: [linux-dvb] [PATCH] DMX_OUT_TSDEMUX_TAP: record two streams from
	same mux, resend
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


--=-KSLt0A+eVI7UuTfljXE7
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

[Resending patch with proper signed-off-by and updated description, but
otherwise unchanged]

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

At least one existing solution -- GStreamer -- sends all its streams
simultaneously via dvr0 and demuxes again in userland, but it seems a
bit of a shame to pick out all the PIDs in kernel, stick them back
together in kernel, and send them to userland only to get unpicked
again, when the alternative is such a small API addition.

The attached patch adds a new value for dmx_output_t:
DMX_OUT_TSDEMUX_TAP, which sends TS to the demux0 device. With this
patch and a dvb-usb-dib0700 (and UK Freeview from Sandy Heath), I can
successfully capture an audio/video PID pair into a TS file that mplayer
can play back.

	Peter


Signed-off-by: Peter Hartley <pdh@utter.chaos.org.uk>
Acked-by: Andreas Oberritter <obi@linuxtv.org>



--=-KSLt0A+eVI7UuTfljXE7
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

--=-KSLt0A+eVI7UuTfljXE7
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--=-KSLt0A+eVI7UuTfljXE7--
