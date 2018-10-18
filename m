Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f44.google.com ([209.85.221.44]:38156 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728934AbeJSB76 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Oct 2018 21:59:58 -0400
Received: by mail-wr1-f44.google.com with SMTP id a13-v6so34676156wrt.5
        for <linux-media@vger.kernel.org>; Thu, 18 Oct 2018 10:57:51 -0700 (PDT)
MIME-Version: 1.0
References: <m37eobudmo.fsf@t19.piap.pl> <m3fu2oswjh.fsf@t19.piap.pl>
 <m3603hsa4o.fsf@t19.piap.pl> <db162792-22c2-7225-97a9-d18b0d2a5b9c@gmail.com>
 <m3h8mxqc7t.fsf@t19.piap.pl> <e7485d6e-d8e7-8111-c318-083228bf2a5c@gmail.com>
 <1527229949.4938.1.camel@pengutronix.de> <m3y3g8p5j3.fsf@t19.piap.pl>
 <1e11fa9a-8fa6-c746-7ee1-a64666bfc44e@gmail.com> <m3lgc2q5vl.fsf@t19.piap.pl>
 <06b9dd3d-3b7d-d34d-5263-411c99ab1a8b@gmail.com> <m38t81plry.fsf@t19.piap.pl>
 <4f49cf44-431d-1971-e5c5-d66381a6970e@gmail.com> <m336y9ouc4.fsf@t19.piap.pl>
 <6923fcd4-317e-d6a6-7975-47a8c712f8f9@gmail.com> <m3sh66omdk.fsf@t19.piap.pl>
 <1527858788.5913.2.camel@pengutronix.de> <05703b20-3280-3bdd-c438-dfce8e475aaa@gmail.com>
 <1528102047.5808.11.camel@pengutronix.de> <m3zi0blyhh.fsf@t19.piap.pl>
 <CAJ+vNU06QEOEBMfz3+CRG=J=C-wpFxwWCarRLs-c2gdspsfLpQ@mail.gmail.com>
 <57dfdc0b-5f04-e10a-2ffd-c7ba561fe7ce@gmail.com> <CAJ+vNU0Wh6bXHAJG1yRT_5ta4Tb9AAdfuOo_rekTcyVTjqx+bQ@mail.gmail.com>
 <59a97e01-93b4-292b-419d-f353b5fbc951@gmail.com>
In-Reply-To: <59a97e01-93b4-292b-419d-f353b5fbc951@gmail.com>
From: Tim Harvey <tharvey@gateworks.com>
Date: Thu, 18 Oct 2018 10:56:58 -0700
Message-ID: <CAJ+vNU1h+3ZXq_-urdhxt3UHSZhskHUSVNrrwRiBvfzu5o7H5A@mail.gmail.com>
Subject: Re: i.MX6 IPU CSI analog video input on Ventana
To: Steve Longerbeam <slongerbeam@gmail.com>,
        =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 17, 2018 at 4:37 PM Steve Longerbeam <slongerbeam@gmail.com> wr=
ote:
>
>
> On 10/17/18 4:05 PM, Tim Harvey wrote:
> > On Wed, Oct 17, 2018 at 2:33 PM Steve Longerbeam <slongerbeam@gmail.com=
> wrote:
> >> Hi Tim,
> >>
> >> On 10/17/18 1:38 PM, Tim Harvey wrote:
> >>
> >> On Mon, Jun 4, 2018 at 1:58 AM Krzysztof Ha=C5=82asa <khalasa@piap.pl>=
 wrote:
> >>
> >> I've just tested the PAL setup: in currect situation (v4.17 + Steve's
> >> fix-csi-interlaced.2 + "media: adv7180: fix field type" + a small chea=
p
> >> PAL camera) the following produces bottom-first interlaced frames:
> >>
> >> media-ctl -r -l '"adv7180 2-0020":0->"ipu2_csi1_mux":1[1],
> >>                   "ipu2_csi1_mux":2->"ipu2_csi1":0[1],
> >>                   "ipu2_csi1":2->"ipu2_csi1 capture":0[1]'
> >>
> >> media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/720x576 field:alternate]=
"
> >> media-ctl -V "'ipu2_csi1_mux':2 [fmt:UYVY2X8/720x576]"
> >> media-ctl -V "'ipu2_csi1':2 [fmt:AYUV32/720x576 field:interlaced]"
> >>
> >> "adv7180 2-0020":0 [fmt:UYVY2X8/720x576 field:alternate]
> >> "ipu2_csi1_mux":1  [fmt:UYVY2X8/720x576 field:alternate]
> >> "ipu2_csi1_mux":2  [fmt:UYVY2X8/720x576 field:alternate]
> >> "ipu2_csi1":0      [fmt:UYVY2X8/720x576 field:alternate]
> >> "ipu2_csi1":2      [fmt:AYUV32/720x576 field:interlaced]
> >>
> >> I think it would be great if these changes make their way upstream.
> >> The details could be refined then.
> >>
> >> Krzysztof / Steve / Philipp,
> >>
> >> I jumped back onto IMX6 video capture from the adv7180 the other day
> >> trying to help out a customer that's using mainline and found things
> >> are still not working right. Where is all of this at these days?
> >>
> >> If I use v4.19 with Steves 'imx-media: Fixes for interlaced capture'
> >> v3 series (https://patchwork.kernel.org/cover/10626499/) I
> >> rolling/split (un-synchronized) video using:
> >>
> >> # Setup links
> >> media-ctl -r
> >> media-ctl -l '"adv7180 2-0020":0 -> "ipu2_csi1_mux":1[1]'
> >> media-ctl -l '"ipu2_csi1_mux":2 -> "ipu2_csi1":0[1]'
> >> media-ctl -l '"ipu2_csi1":1 -> "ipu2_ic_prp":0[1]'
> >> media-ctl -l '"ipu2_ic_prp":2 -> "ipu2_ic_prpvf":0[1]'
> >> media-ctl -l '"ipu2_ic_prpvf":1 -> "ipu2_ic_prpvf capture":0[1]'
> >> # Configure pads
> >> media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/720x480]"
> >> media-ctl -V "'ipu2_csi1_mux':2 [fmt:UYVY2X8/720x480 field:interlaced]=
"
> >> media-ctl -V "'ipu2_csi1':1 [fmt:UYVY2X8/720x480 field:interlaced]"
> >> media-ctl -V "'ipu2_ic_prp':2 [fmt:UYVY2X8/720x480 field:interlaced]"
> >> media-ctl -V "'ipu2_ic_prpvf':1 [fmt:UYVY2X8/720x480 field:none]"
> >> # stream JPEG/RTP/UDP
> >> gst-launch-1.0 v4l2src device=3D/dev/video3 ! video/x-raw,format=3DUYV=
Y !
> >> jpegenc ! rtpjpegpay ! udpsink host=3D$SERVER port=3D$PORT
> >> ERROR: from element /GstPipeline:pipeline0/GstV4l2Src:v4l2src0: Device
> >> '/dev/video3' does not support progressive interlacing
> >>
> >> I'm doing the above on a Gateworks GW5404 IMXQ which has a tda1997x
> >> HDMI receiver sensor and an adv7180 Analog CVBS sensor - media graph
> >> is here: http://dev.gateworks.com/docs/linux/media/imx6q-gw54xx-media.=
png
> >>
> >> Are there other patches I need or different field formats above with
> >> 4.19? Do any of the other kernels work without patchsets that you know
> >> of between 4.16 and 4.19?
> >>
> >>
> >> First, the v3 series is out of date. Please apply the latest v5 postin=
g
> >> of that series. See the imx.rst doc regarding field type negotiation,
> >> all pads starting at ipu2_csi1:1 should be 'seq-bt' or 'seq-tb' until =
the
> >> capture device, which should be set to 'interlaced' to enable IDMAC
> >> interweave. The ADV7180 now correctly sets its field type to alternate=
,
> >> which imx-media-csi.c translates to seq-tb or seq-bt at its output pad=
.
> >>
> >> See the SabreAuto examples in the doc.
> >>
> >> For the rolling/split image problem, try the attached somewhat hackish=
 patch.
> >> There used to be code in imx-media-csi.c that searched for the backend=
 sensor
> >> and queries via .g_skip_frames whether the sensor produces bad frames =
at first
> >> stream-on. But there was push-back on that, so the attached is another
> >> approach that doesn't require searching for a backend sensor.
> > Steve,
> >
> > Thanks - I hadn't noticed the updated series. I've built it on top of
> > linux-media/master and tested with:
> >
> > - Testing linux-media/master + your v5 now:
> >
> > # Use simple interweaving
> > media-ctl -r
> > # Setup links
> > media-ctl -l '"adv7180 2-0020":0 -> "ipu2_csi1_mux":1[1]'
> > media-ctl -l '"ipu2_csi1_mux":2 -> "ipu2_csi1":0[1]'
> > media-ctl -l '"ipu2_csi1":2 -> "ipu2_csi1 capture":0[1]'
> > # Configure pads
> > media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/720x480 field:seq-bt]"
> > media-ctl -V "'ipu2_csi1_mux':2 [fmt:UYVY2X8/720x480]"
> > media-ctl -V "'ipu2_csi1':1 [fmt:AYUV32/720x480]"
> > # Configure ipu_csi capture interface (/dev/video7)
> > v4l2-ctl -d7 --set-fmt-video=3Dfield=3Dinterlaced_bt
> > # Stream JPEG/RTP/UDP
> > gst-launch-1.0 v4l2src device=3D/dev/video7 ! video/x-raw,format=3DUYVY=
 !
> > jpegenc ! rtpjpegpay ! udpsink host=3D$SERVER port=3D5000
> > ^^^^^^ gives me ERROR: from element
> > /GstPipeline:pipeline0/GstV4l2Src:v4l2src0: Device '/dev/video7' does
> > not support progressive interlacing
> >
> > I'm assuming this is because the format is still 'interlaced' - not
> > sure how to stream this from GStreamer?
>
>
> I don't know what v4l2src plugin is trying to say by "progressive
> interlacing" -
> that's meaningless, the video is either progressive or interlaced, not bo=
th.
>
> But what is probably meant is v4l2src is trying to set field type at
> /dev/video7
> to 'none', and complains that it can't. That's a bug in v4l2src, it
> should accept
> 'interlaced'.
>
>
> I'm not getting this error in the version of v42lsrc I have been testing
> with, it
> must be something added recently. Haven't looked at the v4l2src git log
> yet.
>

Steve,

Your right the above was not working using GStreamer 1.14.1 from an
Ubuntu Bionic rootfs but works fine Using GStreamer 1.8.3 on an Ubuntu
Xenial rootfs. I'll ask about this with the GStreamer folk.

>
> >
> > # Use VDIC motion compensated de-interlace
> > # Setup links
> > media-ctl -r
> > media-ctl -l "'adv7180 2-0020':0 -> 'ipu2_csi1_mux':1[1]"
> > media-ctl -l "'ipu2_csi1_mux':2 -> 'ipu2_csi1':0[1]"
> > media-ctl -l "'ipu2_csi1':1 -> 'ipu2_vdic':0[1]"
> > media-ctl -l "'ipu2_vdic':2 -> 'ipu2_ic_prp':0[1]"
> > media-ctl -l "'ipu2_ic_prp':2 -> 'ipu2_ic_prpvf':0[1]"
> > media-ctl -l "'ipu2_ic_prpvf':1 -> 'ipu2_ic_prpvf capture':0[1]"
> > # Configure pads
> > media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/720x480 field:seq-tb]"
> > media-ctl -V "'ipu2_csi1_mux':2 [fmt:UYVY2X8/720x480]"
> > media-ctl -V "'ipu2_csi1':1 [fmt:AYUV32/720x480]"
> > media-ctl -V "'ipu2_vdic':2 [fmt:AYUV32/720x480 field:none]"
> > media-ctl -V "'ipu2_ic_prp':2 [fmt:AYUV32/720x480 field:none]"
> > media-ctl -V "'ipu2_ic_prpvf':1 [fmt:AYUV32/720x480 field:none]"
> > # Stream JPEG/RTP/UDP
> > gst-launch-1.0 v4l2src device=3D/dev/video3 ! video/x-raw,format=3DUYVY=
 !
> > jpegenc ! rtpjpegpay ! udpsink host=3D$SERVER port=3D5000
> > ^^^^^ streams but still shows sync issues
> >
> > But once I add your patch it does resolve this (with the 10 frame
> > skip). Strangely I don't recall having to do this way back when your
> > imx-media driver was still going through revisions?
>
>
> That's because the bad frame skipping existed in prior versions,
> I removed it due to negative feedback at
>
> bf3cfaa712 ("media: staging/imx: get CSI bus type from nearest upstream
> entity")
>

Thanks for that explanation.

I tested v4.15 (before the use of g_skip_frames was removed) and it
still shows the same invalid sync with adv7180 issue because adv7180
doesn't implement g_skip_frames. Adding it with a quick patch to skip
just 2 frames works fine:
diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 6fb818a..0285627 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -187,6 +187,9 @@
 #define ADV7180_DEFAULT_CSI_I2C_ADDR 0x44
 #define ADV7180_DEFAULT_VPP_I2C_ADDR 0x42

+/* Initial number of frames to skip to avoid possible garbage */
+#define ADV7180_NUM_OF_SKIP_FRAMES       2
+
 #define V4L2_CID_ADV_FAST_SWITCH       (V4L2_CID_USER_ADV7180_BASE + 0x00)

 struct adv7180_state;
@@ -759,6 +762,13 @@ static int adv7180_g_mbus_config(struct v4l2_subdev *s=
d,
        return 0;
 }

+static int adv7180_get_skip_frames(struct v4l2_subdev *sd, u32 *frames)
+{
+        *frames =3D ADV7180_NUM_OF_SKIP_FRAMES;
+
+        return 0;
+}
+
 static int adv7180_g_pixelaspect(struct v4l2_subdev *sd, struct
v4l2_fract *aspect)
 {
        struct adv7180_state *state =3D to_state(sd);
@@ -838,10 +848,15 @@ static const struct v4l2_subdev_pad_ops
adv7180_pad_ops =3D {
        .get_fmt =3D adv7180_get_pad_format,
 };

+static const struct v4l2_subdev_sensor_ops adv7180_sensor_ops =3D {
+        .g_skip_frames =3D adv7180_get_skip_frames,
+};
+
 static const struct v4l2_subdev_ops adv7180_ops =3D {
        .core =3D &adv7180_core_ops,
        .video =3D &adv7180_video_ops,
        .pad =3D &adv7180_pad_ops,
+       .sensor =3D &adv7180_sensor_ops,
 };

 static irqreturn_t adv7180_irq(int irq, void *devid)

So I still don't quite know what I was testing in the past that didn't
show this adv7180 sync issue. I'm curious how Krzysztof dealt with it
in his recent testing with v4.19. Its very likely that I was getting
around the issue by using your FIM solution which perhaps is the right
solution here as well. FIM also has the added benefit of resolving the
issue (on the capture side not the sensor side) of sync breaking
during loss of signal during streaming which I have had to resolve for
people switching inputs during streaming.

Where was the negative feedback with the use of g_skip_frames? It
looks to me like v4l2-subdev.h describes g_skip_frames specifically
for this purpose as its described in the header as "number of frames
to skip at stream start. This is needed for buggy sensors that
generate faulty frames when they are turned on.".

Perhaps use of g_skip_frames should be added back to
media/imx/imx-media-csi.c as well as an implementation of it added to
adv7180?

Or perhaps FIM resolves both of these issue?

>
> >
> > I haven't enabled FIM  yet and don't recall how to do so from
> > userspace now that its using V4L2 CID's.
>
>
> It's easy! From ipu2_csi1_capture device /dev/video7 from above pipeline:
>
> v4l2-ctl -d7 --set-ctrl=3Dfim_enable=3D1
>
>
> >   Is there a way to set
> > V4L2_CID_IMX_FIM_NUM_SKIP, V4L2_CID_IMX_FIM_ICAP_CHANNEL and
> > V4L2_CID_IMX_FIM_ICAP_EDGE from userspace to test?
>
> v4l2-ctl -d7 --set-ctrl=3Dfim_num_skip=3DN
>

that doesn't work (using v4l2-ctl from git master on Oct 4) - you must
be using a patched version of v4l2-ctl perhaps?

I wasn't sure if there was a v4l2-ctl usage that let you define CID's
by number instead of by name?

> etc.
>
> But input capture is not operational yet. I posted the patch to imx6
> clocksource driver a while ago, no replies. I can forward that patch to
> you, it will require some machinations elsewhere in imx-media driver to
> enable icap support though IIRC. Note also that input capture also requir=
es
> hardware support: the ADV7180 FIELD output pin must be routed to one of
> the imx6
> input capture pads.

Right, you explain clock capture pretty well in
Documentation/media/v4l-drivers/imx.rst. I don't have VSYNC going to
an input capture channel so I have to rely on FIM working via EOF
interrupt.

Tim
