Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f45.google.com ([209.85.128.45]:51286 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbeJREhG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Oct 2018 00:37:06 -0400
Received: by mail-wm1-f45.google.com with SMTP id 143-v6so3283027wmf.1
        for <linux-media@vger.kernel.org>; Wed, 17 Oct 2018 13:39:40 -0700 (PDT)
MIME-Version: 1.0
References: <m37eobudmo.fsf@t19.piap.pl> <m3tvresqfw.fsf@t19.piap.pl>
 <08726c4a-fb60-c37a-75d3-9a0ca164280d@gmail.com> <m3fu2oswjh.fsf@t19.piap.pl>
 <m3603hsa4o.fsf@t19.piap.pl> <db162792-22c2-7225-97a9-d18b0d2a5b9c@gmail.com>
 <m3h8mxqc7t.fsf@t19.piap.pl> <e7485d6e-d8e7-8111-c318-083228bf2a5c@gmail.com>
 <1527229949.4938.1.camel@pengutronix.de> <m3y3g8p5j3.fsf@t19.piap.pl>
 <1e11fa9a-8fa6-c746-7ee1-a64666bfc44e@gmail.com> <m3lgc2q5vl.fsf@t19.piap.pl>
 <06b9dd3d-3b7d-d34d-5263-411c99ab1a8b@gmail.com> <m38t81plry.fsf@t19.piap.pl>
 <4f49cf44-431d-1971-e5c5-d66381a6970e@gmail.com> <m336y9ouc4.fsf@t19.piap.pl>
 <6923fcd4-317e-d6a6-7975-47a8c712f8f9@gmail.com> <m3sh66omdk.fsf@t19.piap.pl>
 <1527858788.5913.2.camel@pengutronix.de> <05703b20-3280-3bdd-c438-dfce8e475aaa@gmail.com>
 <1528102047.5808.11.camel@pengutronix.de> <m3zi0blyhh.fsf@t19.piap.pl>
In-Reply-To: <m3zi0blyhh.fsf@t19.piap.pl>
From: Tim Harvey <tharvey@gateworks.com>
Date: Wed, 17 Oct 2018 13:38:48 -0700
Message-ID: <CAJ+vNU06QEOEBMfz3+CRG=J=C-wpFxwWCarRLs-c2gdspsfLpQ@mail.gmail.com>
Subject: Re: i.MX6 IPU CSI analog video input on Ventana
To: =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 4, 2018 at 1:58 AM Krzysztof Ha=C5=82asa <khalasa@piap.pl> wrot=
e:
>
> I've just tested the PAL setup: in currect situation (v4.17 + Steve's
> fix-csi-interlaced.2 + "media: adv7180: fix field type" + a small cheap
> PAL camera) the following produces bottom-first interlaced frames:
>
> media-ctl -r -l '"adv7180 2-0020":0->"ipu2_csi1_mux":1[1],
>                  "ipu2_csi1_mux":2->"ipu2_csi1":0[1],
>                  "ipu2_csi1":2->"ipu2_csi1 capture":0[1]'
>
> media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/720x576 field:alternate]"
> media-ctl -V "'ipu2_csi1_mux':2 [fmt:UYVY2X8/720x576]"
> media-ctl -V "'ipu2_csi1':2 [fmt:AYUV32/720x576 field:interlaced]"
>
> "adv7180 2-0020":0 [fmt:UYVY2X8/720x576 field:alternate]
> "ipu2_csi1_mux":1  [fmt:UYVY2X8/720x576 field:alternate]
> "ipu2_csi1_mux":2  [fmt:UYVY2X8/720x576 field:alternate]
> "ipu2_csi1":0      [fmt:UYVY2X8/720x576 field:alternate]
> "ipu2_csi1":2      [fmt:AYUV32/720x576 field:interlaced]
>
> I think it would be great if these changes make their way upstream.
> The details could be refined then.

Krzysztof / Steve / Philipp,

I jumped back onto IMX6 video capture from the adv7180 the other day
trying to help out a customer that's using mainline and found things
are still not working right. Where is all of this at these days?

If I use v4.19 with Steves 'imx-media: Fixes for interlaced capture'
v3 series (https://patchwork.kernel.org/cover/10626499/) I
rolling/split (un-synchronized) video using:

# Setup links
media-ctl -r
media-ctl -l '"adv7180 2-0020":0 -> "ipu2_csi1_mux":1[1]'
media-ctl -l '"ipu2_csi1_mux":2 -> "ipu2_csi1":0[1]'
media-ctl -l '"ipu2_csi1":1 -> "ipu2_ic_prp":0[1]'
media-ctl -l '"ipu2_ic_prp":2 -> "ipu2_ic_prpvf":0[1]'
media-ctl -l '"ipu2_ic_prpvf":1 -> "ipu2_ic_prpvf capture":0[1]'
# Configure pads
media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/720x480]"
media-ctl -V "'ipu2_csi1_mux':2 [fmt:UYVY2X8/720x480 field:interlaced]"
media-ctl -V "'ipu2_csi1':1 [fmt:UYVY2X8/720x480 field:interlaced]"
media-ctl -V "'ipu2_ic_prp':2 [fmt:UYVY2X8/720x480 field:interlaced]"
media-ctl -V "'ipu2_ic_prpvf':1 [fmt:UYVY2X8/720x480 field:none]"
# stream JPEG/RTP/UDP
gst-launch-1.0 v4l2src device=3D/dev/video3 ! video/x-raw,format=3DUYVY !
jpegenc ! rtpjpegpay ! udpsink host=3D$SERVER port=3D$PORT
ERROR: from element /GstPipeline:pipeline0/GstV4l2Src:v4l2src0: Device
'/dev/video3' does not support progressive interlacing

I'm doing the above on a Gateworks GW5404 IMXQ which has a tda1997x
HDMI receiver sensor and an adv7180 Analog CVBS sensor - media graph
is here: http://dev.gateworks.com/docs/linux/media/imx6q-gw54xx-media.png

Are there other patches I need or different field formats above with
4.19? Do any of the other kernels work without patchsets that you know
of between 4.16 and 4.19?

Steve, I haven't tried your 'media: imx: Switch to subdev notifiers'
v7 series yet (https://patchwork.kernel.org/cover/10620967/) but can
certainly do so if you need testing. I'm hoping those changes are all
internal and won't affect the userspace pipeline configuration between
kernel versions?

I'm also interested in looking at Philipps' 'i.MX media mem2mem
scaler' series (https://patchwork.kernel.org/cover/10603881/) and am
wondering if anyone has some example pipelines showing that in use.
I'm hoping that is what is needed to be able to use hardware
scaling/CSC and coda based encoding on streams from v4l2 PCI capture
devices.

Lastly, is there any hope to use IMX6 hardware compositing to say
stitch together multiple streams from a v4l2 PCI capture device into a
single stream for coda based hw encoding?

Regards,

Tim
