Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:35368 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbbEGNyM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 May 2015 09:54:12 -0400
Received: by obcus9 with SMTP id us9so2271378obc.2
        for <linux-media@vger.kernel.org>; Thu, 07 May 2015 06:54:11 -0700 (PDT)
MIME-Version: 1.0
From: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Date: Thu, 7 May 2015 15:53:51 +0200
Message-ID: <CAH-u=818PWuf2w7e3ysJTD6La_6BMAyXwAodkXQTQe7jtHkSZA@mail.gmail.com>
Subject: Coda : QP rate control encoding
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Robert Schwebel <r.schwebel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am playing a bit with the coda encoder on i.MX6 and try to get the
most quality out of it. So, I am trying to use the controls of the
driver, in particular h264_i_frame_qp_value and h264_p_frame_qp_value.

I can get something with the following pipeline :
gst-launch-1.0 -evvv v4l2src num-buffers=2000
device=/dev/v4l/by-path/ipu1-capture io-mode=dmabuf !
"video/x-raw,width=1280,height=720,framerate=25/1,format=YUY2" !
v4l2convert device=/dev/v4l/by-path/ipu1-scaler capture-io-mode=dmabuf
output-io-mode=dmabuf-import !
'video/x-raw,width=640,height=360,format=NV12' ! v4l2video0h264enc
output-io-mode=dmabuf-import
extra-controls="controls,h264_i_frame_qp_value=24,h264_p_frame_qp_value=30,video_gop_size=32"
! queue ! progressreport name=p2 ! h264parse ! matroskamux ! filesink
location=/data/test_encode_360p.mkv

With those values, I get ~800kbps for a 360p converted frame. This is nice :).
The same video as an input with only the "bitrate" parameter set is
not visually similar.

But, when trying to encode a 720p video with the same QP parameters,
it is not working (the first keyframe is not ok, seems to be a P frame
instead of I, as it is 2000 bits and should be ~40000). I am keeping
the videoscaler in this second case, as it should be used as a color
converter.

Philipp, did you do some tests like this one ? Did you observe that
the encoder can maybe be too long to get a frame encoded when desired
quality is "high" ?
Maybe do you have some ideas about this ?

Thanks,
JM
