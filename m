Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:40571 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966526AbeAONFf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 08:05:35 -0500
Message-ID: <1516020546.10524.4.camel@pengutronix.de>
Subject: Re: MT9M131 on I.MX6DL CSI color issue
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Florian Boor <florian.boor@kernelconcepts.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Mon, 15 Jan 2018 13:49:06 +0100
In-Reply-To: <b704a2fb-efa1-a2f8-7af0-43d869c688eb@kernelconcepts.de>
References: <b704a2fb-efa1-a2f8-7af0-43d869c688eb@kernelconcepts.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Florian,

On Fri, 2018-01-12 at 01:16 +0100, Florian Boor wrote:
> Hello all,
> 
> I have a Phytec VM-009 camera based on MT9M131 connected to CSI0 of a I.MX6DL
> based board running mainline 4.13.0 + custom devicetree. Its using the parallel
> interface, 8 bit bus width on pins 12 to 19.
> 
> Basically it works pretty well apart from the really strange colors. I guess its
> some YUV vs. RGB issue or similar. Here [1] is an example generated with the
> following command.
> 
> gst-launch v4l2src device=/dev/video4 num-buffers=1 ! jpegenc ! filesink
> location=capture1.jpeg
> 
> Apart from the colors everything is fine.
> I'm pretty sure I have not seen such an effect before - what might be wrong here?
> 
> The current setup looks like this:
> 
> IF=UYVY2X8
> GEOM="1280x1024"
> media-ctl -l "'mt9m111 2-0048':0 -> 'ipu1_csi0_mux':4[1]"
> media-ctl -l "'ipu1_csi0_mux':5 -> 'ipu1_csi0':0[1]"
> media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
> 
> media-ctl -d /dev/media0 -v -V "'ipu1_csi0':2 [fmt:${IF}/${GEOM} field:none]"
> media-ctl -d /dev/media0 -v -V "'ipu1_csi0 capture':0 [fmt:${IF}/${GEOM}
> field:none]"
> media-ctl -d /dev/media0 -v -V "'ipu1_csi0_mux':4 [fmt:${IF}/${GEOM} field: none]"
> media-ctl -d /dev/media0 -v -V "'ipu1_csi0_mux':5 [fmt:${IF}/${GEOM} field: none]"
> media-ctl -d /dev/media0 -v -V "'mt9m111 2-0048':0 [fmt:${IF}/${GEOM} field: none]"

media-ctl propagates video formats downstream, can you try reversing the
order?
Also, while the external format is UYVY2X8, internally the IPU only
supports AYUV32, so the last call should be 

media-ctl -d /dev/media0 -v -V "'ipu1_csi0':2 [fmt:AYUV32/${GEOM} field:none]"

not that it should make a difference.
And setting a format on 'ipu1_csi0 capture' is not necessary.

The new picture looks a little like there is 10-bit sensor data and only
the lower 8-bit arrive in memory, given the number of wraparounds.

Can you show the output of "media-ctl -p" (or "media-ctl --get-v4l2" for
each pad in the pipeline)?

media-ctl --get-v4l2 "'mt9m111 2-0048':0"
media-ctl --get-v4l2 "'ipu1_csi0_mux':4"
media-ctl --get-v4l2 "'ipu1_csi0_mux':5"
media-ctl --get-v4l2 "'ipu1_csi0':0"
media-ctl --get-v4l2 "'ipu1_csi0':2"

regards
Philipp
