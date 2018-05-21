Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:39633 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752739AbeEUPz7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 11:55:59 -0400
Received: by mail-wm0-f41.google.com with SMTP id f8-v6so27500808wmc.4
        for <linux-media@vger.kernel.org>; Mon, 21 May 2018 08:55:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <m3603hsa4o.fsf@t19.piap.pl>
References: <m37eobudmo.fsf@t19.piap.pl> <b6e7ba76-09a4-2b6a-3c73-0e3ef92ca8bf@gmail.com>
 <m3tvresqfw.fsf@t19.piap.pl> <08726c4a-fb60-c37a-75d3-9a0ca164280d@gmail.com>
 <m3fu2oswjh.fsf@t19.piap.pl> <m3603hsa4o.fsf@t19.piap.pl>
From: Tim Harvey <tharvey@gateworks.com>
Date: Mon, 21 May 2018 08:55:57 -0700
Message-ID: <CAJ+vNU3UAU1DRAt5iyqMg-tvYjJZpTuyW1X=kYU8j-7ND92EWw@mail.gmail.com>
Subject: Re: i.MX6 IPU CSI analog video input on Ventana
To: =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media <linux-media@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 21, 2018 at 1:09 AM, Krzysztof Ha=C5=82asa <khalasa@piap.pl> wr=
ote:
> Tested with NTSC camera, it's the same as with PAL.
> The only case when IPU2_CSI1_SENS_CONF register is set to interlaced
> mode (PRCTL=3D3, CCIR interlaced mode (BT.656)) is when all parts of the
> pipeline are set to interlaced:
>
> "adv7180 2-0020":0 [fmt:UYVY2X8/720x576 field:interlaced]
> "ipu2_csi1_mux":1  [fmt:UYVY2X8/720x576 field:interlaced]
> "ipu2_csi1_mux":2  [fmt:UYVY2X8/720x576 field:interlaced]
> "ipu2_csi1":0      [fmt:UYVY2X8/720x576 field:interlaced]
> "ipu2_csi1":2      [fmt:AYUV32/720x576 field:interlaced]
>
> The image is stable and in sync, the "only" problem is that I get two
> concatenated field images (in one V4L2 frame) instead of a normal
> interlaced frame (all lines in order - 0, 1, 2, 3, 4 etc).
> IOW I get V4L2_FIELD_ALTERNATE, V4L2_FIELD_SEQ_TB or V4L2_FIELD_SEQ_BT
> (the data format, I don't mean the pixel format.field) while I need to
> get V4L2_FIELD_INTERLACED, V4L2_FIELD_INTERLACED_TB or _BT.
>
>
> If I set "ipu2_csi1":2 to field:none, the IPU2_CSI1_SENS_CONF is set to
> progressive mode (PRCTL=3D2). It's the last element of the pipeline I can
> configure, it's connected straight to "ipu2_csi1 capture" aka
> /dev/videoX. I think CSI can't work with interlaced camera (and ADV7180)
> when set to progressive, can it?
>
>
> I wonder... perhaps to get an interlaced frame I need to route the data
> through VDIC (ipu2_vdic, the deinterlacer)?

Krzysztof,

Right, your doing a raw capture where you get both fields in one
buffer and I'm not clear what to do with that.

Here's what I've used on a GW54xx with IMX6Q and an adv7180 for NTSC.

using VDIC to deinterlace:
# adv7180 -> vdic -> ic_prpvf -> /dev/video3
# VDIC will de-interlace using motion compensation
media-ctl -r # reset all links
# Setup links
media-ctl -l '"adv7180 2-0020":0 -> "ipu2_csi1_mux":1[1]'
media-ctl -l '"ipu2_csi1_mux":2 -> "ipu2_csi1":0[1]'
media-ctl -l '"ipu2_csi1":1 -> "ipu2_vdic":0[1]'
media-ctl -l '"ipu2_vdic":2 -> "ipu2_ic_prp":0[1]'
media-ctl -l '"ipu2_ic_prp":2 -> "ipu2_ic_prpvf":0[1]'
media-ctl -l '"ipu2_ic_prpvf":1 -> "ipu2_ic_prpvf capture":0[1]'
# Configure pads
media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/720x480]"
media-ctl -V "'ipu2_csi1_mux':2 [fmt:UYVY2X8/720x480 field:interlaced]"
media-ctl -V "'ipu2_csi1':1 [fmt:UYVY2X8/720x480 field:interlaced]"
media-ctl -V "'ipu2_vdic':2 [fmt:UYVY2X8/720x480 field:interlaced]"
media-ctl -V "'ipu2_ic_prp':2 [fmt:UYVY2X8/720x480 field:none]"
media-ctl -V "'ipu2_ic_prpvf':1 [fmt:UYVY2X8/720x480 field:none]"
# streaming can now begin on /dev/video3
v4l2-ctl -d3 --set-fmt-video=3Dwidth=3D720,height=3D480,pixelformat=3DUYVY
v4l2-ctl -d3 --set-ctrl=3Ddeinterlacing_mode=3D3 # set max motion
compensation (default)
#^^^^ this is the default so could be skipped; also its the only value
allowed when capturing direct from CSI
v4l2-ctl -d3 --stream-mmap --stream-to=3D/x.raw --stream-count=3D1 # captur=
e 1 frame
convert -size 720x480 -depth 16 uyvy:/x.raw /var/www/html/frame.png #
and convert
# or stream jpeg's via gst
gst-launch-1.0 v4l2src device=3D/dev/video3 ! "video/x-raw,format=3DUYVY"
! jpegenc ! queue ! avimux name=3Dmux ! udpsink host=3D172.24.20.19
port=3D5000

or de-interlace via IDMAC:
# PRPVF will do simple IDMAC line interweaving for de-interlacing,
since VDIC is not involved in the pipeline, but it will only enable
this in the IDMAC if it sees interlaced input at prpvf
media-ctl -r # reset all links
# Setup links
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
# streaming can now begin on /dev/video3
v4l2-ctl -d3 --set-fmt-video=3Dwidth=3D720,height=3D480,pixelformat=3DUYVY
v4l2-ctl -d3 --stream-mmap --stream-to=3D/x.raw --stream-count=3D1 # captur=
e
gst-launch-1.0 v4l2src device=3D/dev/video3 ! "video/x-raw,format=3DUYVY"
! jpegenc ! queue ! avimux name=3Dmux ! udpsink host=3D172.24.20.19
port=3D5000

or the following for non deinterlaced:
# adv7180 -> ic_prp -> ic_prpenc -> /dev/video2
media-ctl -r # reset all links
# Setup links
media-ctl -l '"adv7180 2-0020":0 -> "ipu2_csi1_mux":1[1]'
media-ctl -l '"ipu2_csi1_mux":2 -> "ipu2_csi1":0[1]'
media-ctl -l '"ipu2_csi1":1 -> "ipu2_ic_prp":0[1]'
media-ctl -l '"ipu2_ic_prp":1 -> "ipu2_ic_prpenc":0[1]'
media-ctl -l '"ipu2_ic_prpenc":1 -> "ipu2_ic_prpenc capture":0[1]'
# Configure pads
media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/720x480]"
media-ctl -V "'ipu2_csi1_mux':2 [fmt:UYVY2X8/720x480 field:interlaced]"
media-ctl -V "'ipu2_csi1':1 [fmt:UYVY2X8/720x480 field:interlaced]"
media-ctl -V "'ipu2_ic_prp':1 [fmt:UYVY2X8/720x480 field:interlaced]"
media-ctl -V "'ipu2_ic_prpenc':1 [fmt:UYVY2X8/720x480 field:none]"
# streaming can now begin on /dev/video2
v4l2-ctl -d2 --set-fmt-video=3Dwidth=3D720,height=3D480,pixelformat=3DUYVY
v4l2-ctl -d2 --stream-mmap --stream-to=3D/x.raw --stream-count=3D1 # captur=
e
gst-launch-1.0 v4l2src device=3D/dev/video2 ! "video/x-raw,format=3DUYVY"
! jpegenc ! queue ! avimux name=3Dmux ! udpsink host=3D172.24.20.19
port=3D5000

One of these days I intend to document all of this on our Gateworks
wiki. Its complex as heck with all the board and CPU variants. I wish
there was a tool that would auto-connect the entitites as the inputs
and outputs change depending on CPU variant but I'm not aware of
anything that does that yet. I'm also not very clear on all the
possibilities - Steve is the expert on that.

Tim
