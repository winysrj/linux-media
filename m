Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:33107 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726407AbeJXWgp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Oct 2018 18:36:45 -0400
Date: Wed, 24 Oct 2018 16:08:20 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Adam Ford <aford173@gmail.com>
Cc: steve_longerbeam@mentor.com, Fabio Estevam <festevam@gmail.com>,
        Jagan Teki <jagan@amarulasolutions.com>,
        p.zabel@pengutronix.de, Fabio Estevam <fabio.estevam@nxp.com>,
        gstreamer-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: i.MX6 MIPI-CSI2 OV5640 Camera testing on Mainline Linux
Message-ID: <20181024140820.GB3766@w540>
References: <20181022113306.GB2867@w540>
 <CAHCN7xJkc5RW73C0zruWBgyF7G0J3C5tLE=ZdfxTKbrUqs=-PQ@mail.gmail.com>
 <CAOMZO5ATm4BRzPEQOU+ZD6bHCP2Aqjp4raRYhuc+wNe0t4+C=w@mail.gmail.com>
 <CAHCN7x+csKEk25CF=teUv+F5_GoTe6_3Yqb5PODLn+AmCCm88w@mail.gmail.com>
 <d78877f8-2c23-2bf0-0a9c-cd98b855e95e@mentor.com>
 <CAHCN7xKhGAXs0jGv96CfOfLQfVubxzsdE9UjpDu+4NM6oLDGWw@mail.gmail.com>
 <bc034299-4a32-f248-d09a-0d1b5872a506@mentor.com>
 <CAHCN7xKVUgpyCb5k7s0PNXW-efySSwP25ZGMLdbFnohATPwKhg@mail.gmail.com>
 <20181023230259.GA3766@w540>
 <CAHCN7xJaY_916OLHvaN_q1FwM2vqH5UXzVxLAS4DuEV0icPUXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="32u276st3Jlj2kUU"
Content-Disposition: inline
In-Reply-To: <CAHCN7xJaY_916OLHvaN_q1FwM2vqH5UXzVxLAS4DuEV0icPUXg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--32u276st3Jlj2kUU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Adam,

On Wed, Oct 24, 2018 at 08:53:41AM -0500, Adam Ford wrote:
> On Tue, Oct 23, 2018 at 6:03 PM jacopo mondi <jacopo@jmondi.org> wrote:
> >
> > Hi Adam,
> >
> > On Tue, Oct 23, 2018 at 12:54:12PM -0500, Adam Ford wrote:
> > > On Tue, Oct 23, 2018 at 12:39 PM Steve Longerbeam
> > > <steve_longerbeam@mentor.com> wrote:
> > > >
> > > >
> > > > On 10/23/18 10:34 AM, Adam Ford wrote:
> > > > > On Tue, Oct 23, 2018 at 11:36 AM Steve Longerbeam
> > > > > <steve_longerbeam@mentor.com> wrote:
> > > > >> Hi Adam,
> > > > >>
> > > > >> On 10/23/18 8:19 AM, Adam Ford wrote:
> > > > >>> On Mon, Oct 22, 2018 at 7:40 AM Fabio Estevam <festevam@gmail.com> wrote:
> > > > >>>> Hi Adam,
> > > > >>>>
> > > > >>>> On Mon, Oct 22, 2018 at 9:37 AM Adam Ford <aford173@gmail.com> wrote:
> > > > >>>>
> > > > >>>>> Thank you!  This tutorial web site is exactly what I need.  The
> > > > >>>>> documentation page in Linux touched on the media-ctl links, but it
> > > > >>>>> didn't explain the syntax or the mapping.  This graphical
> > > > >>>>> interpretation really helps it make more sense.
> > > > >>>> Is capturing working well on your i.MX6 board now?
> > > > >>> Fabio,
> > > > >>>
> > > > >>> Unfortunately, no.  I built the rootfs based on Jagan's instructions
> > > > >>> at https://openedev.amarulasolutions.com/display/ODWIKI/i.CoreM6+1.5
> > > > >>>
> > > > >>> I tried building both the 4.15-RC6 kernel, a 4.19 kernel and a 4.14 LTS kernel.
> > > > >>>
> > > > >>> Using the suggested method of generating the graphical display of the
> > > > >>> pipeline options, I am able to enable various pipeline options
> > > > >>> connecting different /dev/videoX options tot he camera.  I have tried
> > > > >>> both the  suggested method above as well as the instructions found in
> > > > >>> Documentation/media/v4l-drivers/imx.rst for their respective kernels,
> > > > >>> and I have tried multiple options to capture through
> > > > >>> ipu1_csi1_capture, ipu2_csi1_capture, and ip1_ic_prepenc capture, and
> > > > >>> all yield a broken pipe.
> > > > >>>
> > > > >>> libv4l2: error turning on stream: Broken pipe
> > > > >>> ERROR: from element /GstPipeline:pipeline0/GstV4l2Src:v4l2src0: Could
> > > > >>> not read from resource.
> > > > >>> Additional debug info:
> > > > >>> gstv4l2bufferpool.c(1064): gst_v4l2_buffer_pool_poll ():
> > > > >>> /GstPipeline:pipeline0/GstV4l2Src:v4l2src0:
> > > > >>> poll error 1: Broken pipe (32)
> > > > >>>
> > > > >>> I can hear the camera click when I start gstreamer and click again
> > > > >>> when it stops trying to stream.
> > > > >>>
> > > > >>> dmesg indicates a broken pipe as well..
> > > > >>>
> > > > >>> [ 2419.851502] ipu2_csi1: pipeline start failed with -32
> > > > >>>
> > > > >>> might you have any suggestions?
> > > > >>
> > > > >> This -EPIPE error might mean you have a mis-match of resolution, pixel
> > > > >> format, or field type between one of the source->sink pad links. You can
> > > > >> find out which pads have a mis-match by enabling dynamic debug in the
> > > > >> kernel function __media_pipeline_start.
> > > > > Following Jagan's suggestion, I tried to make sure all the resolution
> > > > > and pixel formats were set the same between each source and sink.
> > > > >
> > > > > media-ctl --set-v4l2 "'ov5640 2-0010':0[fmt:UYVY2X8/640x480
> > > > > field:none]"
> > > > > media-ctl --set-v4l2 "'imx6-mipi-csi2':1[fmt:UYVY2X8/640x480
> > > > > field:none]"
> > > > > media-ctl --set-v4l2 "'ipu1_csi0_mux':2[fmt:UYVY2X8/640x480
> > > > > field:none]"
> > > > > media-ctl --set-v4l2 "'ipu1_csi0':2[fmt:AYUV32/640x480 field:none]"
> > > > >
> > > > >> Also make sure you are attempting to stream from the correct /dev/videoN.
> > > > > I have graphically plotted the pipeline using media-ctl --print-dot
> > > > > and I can see the proper video is routed, but your dynamic debug
> > > > > suggestion yielded something:
> > > > >
> > > > >     imx-media capture-subsystem: link validation failed for 'ov5640
> > > > > 2-0010':0 -> 'imx6-mipi-csi2':0, error -32
> > > >
> > > >
> > > > It's what I expected, you have a format mismatch between those pads.
> > >
> > > Is the mismatch something I am doing wrong with:
> > >
> > > media-ctl --set-v4l2 "'ov5640 2-0010':0[fmt:UYVY2X8/640x480 field:none]"
> > > media-ctl --set-v4l2 "'imx6-mipi-csi2':2[fmt:UYVY2X8/640x480 field:none]"
> > >
> >
> > Could you try to verify the actual format configured on the sensor?
> > (media-ctl --get-v4l2 "'ov5640 2-0010':0").
> >
> > Depending on the driver version you are running, you might be affected
> > by different regressions.
> >
> > > or is there something else I need to do?  I just used Jagan's suggestion.
> >
> > I suggest you to update the driver version to the last one available
> > in the media-tree master, or at least try to backport the following
> > commit:
> > fb98e29 media: ov5640: fix mode change regression
> >
> > If it turns out the format and mode configured on the sensor do not
> > match the one you want.
> >
> > Thanks
>
> That got me past one hurdle.   Wtih your help, I was able to confirm
> the mis-match of the modes between the sensor and the csi1 source.  I
> applied the patch as you suggested, but now I get a new error.
>
> [  295.294370] imx6-mipi-csi2: LP-11 timeout, phy_state = 0x00000230
> [  295.300681] ipu1_csi0: pipeline start failed with -110
>
>

Here you go:
bad1774 media: ov5640: Fix timings setup code
aa4bb8b media: ov5640: Re-work MIPI startup sequence

Please update your ov5640 driver to the last version available on
linux-media master repository. There have been a looot of developments
and fixes recently (and I would be happy to know if they have helped
you)

> I am going to go through various patches to the imx framework and
> ov5640 driver to see if I can find the solution,  but if you have
> suggestions as to which fixes are appropriate, I'll test those.  If I

Just get what's on linux-media master tree.

> can get this working, would it make sense for me to submit some
> requests with kernel-stable to backport some of these commits to 4.19
> and if applicable, 4.14 too?

Sure it will (even if I'm not familiar with the procedure used to tag
patches to be applied to stable. I would just apply everything that's
on the latest media tree)

Keep us posted!
   j
>
> adam
> >    j
> >
> > > adam
> > > >
> > > > Steve
> > > >
> > > >
> > > > >
> > > > > I am assume this means the interface between the camera and the csi2
> > > > > isn't working.  I am going to double check the power rails and the
> > > > > clocks.  i can hear it click when activated and deactivated, so
> > > > > something is happening.
> > > > >
> > > > > adam
> > > > >
> > > > >> Steve
> > > > >>

--32u276st3Jlj2kUU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJb0HzUAAoJEHI0Bo8WoVY867MP/0ZgtRyokvkTgZKltukNV0u+
v9H/jq3fSfPkV+cPlD1E6ZGEiNByWceT+GJ9MX2t3X2EwNM3/Os7P2saMH/1b8Ov
yXsDyO+rFyPl5oMDQH1wXzgpgDA+J5oKUfIp9OOW1490siUgJt/8w20y9zfC0mRs
YL0mFdv+g7iDK3FSj0pVBXM/kAa9u9hRFq8YkMF6F1O1KC/WRyfq4Sbo4Hr7Jgs/
n8eUpYB5HhT6+HnRH1l7qdj0JNgs69Id3sNMLKmr71rvVnaMi9A4/ILb2SFMldzZ
xFrG79m2o9pX3kePCIXoA156jGrzJYD8m4N2yp2QTxKROTzl1iAXvWm3bZ4AMZrO
ynZr7QSvKm8V9xES9ssqrpKvxjOC59rG/okE9VojfWyFvIFIBiAqgTxRiltkVfNc
H/SmjERm9LzjCxjrIlmKfNb4pQ3GzsCbqSbl/PtaOBTahuHB7nnJhaxRzT13Pb/B
IJQWyS61NBp+CpALaAgjNLwReKxqf2sQkyTvtra2LfioL3qjMv5pYbYRAUwXLD4o
/qish1Wqryjb/Y9pMMXaRIyvmYtm3feDVD+s1qVdRMzumfnsS2i3PsbB2lb0W1Ln
+vyDnvhkYj1G7pAXk5XxY9YFT63YL9QjmFeyeEonKqcl9WR0xJC5zc/SjKroP32M
QtTKyzixNMVATX6xaZvQ
=w0ys
-----END PGP SIGNATURE-----

--32u276st3Jlj2kUU--
