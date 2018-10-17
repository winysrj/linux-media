Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f48.google.com ([209.85.221.48]:37313 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727101AbeJRHEO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Oct 2018 03:04:14 -0400
Received: by mail-wr1-f48.google.com with SMTP id y11-v6so31454075wrd.4
        for <linux-media@vger.kernel.org>; Wed, 17 Oct 2018 16:06:16 -0700 (PDT)
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
 <CAJ+vNU06QEOEBMfz3+CRG=J=C-wpFxwWCarRLs-c2gdspsfLpQ@mail.gmail.com> <57dfdc0b-5f04-e10a-2ffd-c7ba561fe7ce@gmail.com>
In-Reply-To: <57dfdc0b-5f04-e10a-2ffd-c7ba561fe7ce@gmail.com>
From: Tim Harvey <tharvey@gateworks.com>
Date: Wed, 17 Oct 2018 16:05:24 -0700
Message-ID: <CAJ+vNU0Wh6bXHAJG1yRT_5ta4Tb9AAdfuOo_rekTcyVTjqx+bQ@mail.gmail.com>
Subject: Re: i.MX6 IPU CSI analog video input on Ventana
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 17, 2018 at 2:33 PM Steve Longerbeam <slongerbeam@gmail.com> wr=
ote:
>
> Hi Tim,
>
> On 10/17/18 1:38 PM, Tim Harvey wrote:
>
> On Mon, Jun 4, 2018 at 1:58 AM Krzysztof Ha=C5=82asa <khalasa@piap.pl> wr=
ote:
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
>
> Krzysztof / Steve / Philipp,
>
> I jumped back onto IMX6 video capture from the adv7180 the other day
> trying to help out a customer that's using mainline and found things
> are still not working right. Where is all of this at these days?
>
> If I use v4.19 with Steves 'imx-media: Fixes for interlaced capture'
> v3 series (https://patchwork.kernel.org/cover/10626499/) I
> rolling/split (un-synchronized) video using:
>
> # Setup links
> media-ctl -r
> media-ctl -l '"adv7180 2-0020":0 -> "ipu2_csi1_mux":1[1]'
> media-ctl -l '"ipu2_csi1_mux":2 -> "ipu2_csi1":0[1]'
> media-ctl -l '"ipu2_csi1":1 -> "ipu2_ic_prp":0[1]'
> media-ctl -l '"ipu2_ic_prp":2 -> "ipu2_ic_prpvf":0[1]'
> media-ctl -l '"ipu2_ic_prpvf":1 -> "ipu2_ic_prpvf capture":0[1]'
> # Configure pads
> media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/720x480]"
> media-ctl -V "'ipu2_csi1_mux':2 [fmt:UYVY2X8/720x480 field:interlaced]"
> media-ctl -V "'ipu2_csi1':1 [fmt:UYVY2X8/720x480 field:interlaced]"
> media-ctl -V "'ipu2_ic_prp':2 [fmt:UYVY2X8/720x480 field:interlaced]"
> media-ctl -V "'ipu2_ic_prpvf':1 [fmt:UYVY2X8/720x480 field:none]"
> # stream JPEG/RTP/UDP
> gst-launch-1.0 v4l2src device=3D/dev/video3 ! video/x-raw,format=3DUYVY !
> jpegenc ! rtpjpegpay ! udpsink host=3D$SERVER port=3D$PORT
> ERROR: from element /GstPipeline:pipeline0/GstV4l2Src:v4l2src0: Device
> '/dev/video3' does not support progressive interlacing
>
> I'm doing the above on a Gateworks GW5404 IMXQ which has a tda1997x
> HDMI receiver sensor and an adv7180 Analog CVBS sensor - media graph
> is here: http://dev.gateworks.com/docs/linux/media/imx6q-gw54xx-media.png
>
> Are there other patches I need or different field formats above with
> 4.19? Do any of the other kernels work without patchsets that you know
> of between 4.16 and 4.19?
>
>
> First, the v3 series is out of date. Please apply the latest v5 posting
> of that series. See the imx.rst doc regarding field type negotiation,
> all pads starting at ipu2_csi1:1 should be 'seq-bt' or 'seq-tb' until the
> capture device, which should be set to 'interlaced' to enable IDMAC
> interweave. The ADV7180 now correctly sets its field type to alternate,
> which imx-media-csi.c translates to seq-tb or seq-bt at its output pad.
>
> See the SabreAuto examples in the doc.
>
> For the rolling/split image problem, try the attached somewhat hackish pa=
tch.
> There used to be code in imx-media-csi.c that searched for the backend se=
nsor
> and queries via .g_skip_frames whether the sensor produces bad frames at =
first
> stream-on. But there was push-back on that, so the attached is another
> approach that doesn't require searching for a backend sensor.

Steve,

Thanks - I hadn't noticed the updated series. I've built it on top of
linux-media/master and tested with:

- Testing linux-media/master + your v5 now:

# Use simple interweaving
media-ctl -r
# Setup links
media-ctl -l '"adv7180 2-0020":0 -> "ipu2_csi1_mux":1[1]'
media-ctl -l '"ipu2_csi1_mux":2 -> "ipu2_csi1":0[1]'
media-ctl -l '"ipu2_csi1":2 -> "ipu2_csi1 capture":0[1]'
# Configure pads
media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/720x480 field:seq-bt]"
media-ctl -V "'ipu2_csi1_mux':2 [fmt:UYVY2X8/720x480]"
media-ctl -V "'ipu2_csi1':1 [fmt:AYUV32/720x480]"
# Configure ipu_csi capture interface (/dev/video7)
v4l2-ctl -d7 --set-fmt-video=3Dfield=3Dinterlaced_bt
# Stream JPEG/RTP/UDP
gst-launch-1.0 v4l2src device=3D/dev/video7 ! video/x-raw,format=3DUYVY !
jpegenc ! rtpjpegpay ! udpsink host=3D$SERVER port=3D5000
^^^^^^ gives me ERROR: from element
/GstPipeline:pipeline0/GstV4l2Src:v4l2src0: Device '/dev/video7' does
not support progressive interlacing

I'm assuming this is because the format is still 'interlaced' - not
sure how to stream this from GStreamer?

# Use VDIC motion compensated de-interlace
# Setup links
media-ctl -r
media-ctl -l "'adv7180 2-0020':0 -> 'ipu2_csi1_mux':1[1]"
media-ctl -l "'ipu2_csi1_mux':2 -> 'ipu2_csi1':0[1]"
media-ctl -l "'ipu2_csi1':1 -> 'ipu2_vdic':0[1]"
media-ctl -l "'ipu2_vdic':2 -> 'ipu2_ic_prp':0[1]"
media-ctl -l "'ipu2_ic_prp':2 -> 'ipu2_ic_prpvf':0[1]"
media-ctl -l "'ipu2_ic_prpvf':1 -> 'ipu2_ic_prpvf capture':0[1]"
# Configure pads
media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/720x480 field:seq-tb]"
media-ctl -V "'ipu2_csi1_mux':2 [fmt:UYVY2X8/720x480]"
media-ctl -V "'ipu2_csi1':1 [fmt:AYUV32/720x480]"
media-ctl -V "'ipu2_vdic':2 [fmt:AYUV32/720x480 field:none]"
media-ctl -V "'ipu2_ic_prp':2 [fmt:AYUV32/720x480 field:none]"
media-ctl -V "'ipu2_ic_prpvf':1 [fmt:AYUV32/720x480 field:none]"
# Stream JPEG/RTP/UDP
gst-launch-1.0 v4l2src device=3D/dev/video3 ! video/x-raw,format=3DUYVY !
jpegenc ! rtpjpegpay ! udpsink host=3D$SERVER port=3D5000
^^^^^ streams but still shows sync issues

But once I add your patch it does resolve this (with the 10 frame
skip). Strangely I don't recall having to do this way back when your
imx-media driver was still going through revisions?

I haven't enabled FIM  yet and don't recall how to do so from
userspace now that its using V4L2 CID's. Is there a way to set
V4L2_CID_IMX_FIM_NUM_SKIP, V4L2_CID_IMX_FIM_ICAP_CHANNEL and
V4L2_CID_IMX_FIM_ICAP_EDGE from userspace to test?

Tim
