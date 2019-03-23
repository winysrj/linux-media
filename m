Return-Path: <SRS0=n2cC=R2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3267C43381
	for <linux-media@archiver.kernel.org>; Sat, 23 Mar 2019 13:01:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C79C218A2
	for <linux-media@archiver.kernel.org>; Sat, 23 Mar 2019 13:01:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbfCWNBr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 23 Mar 2019 09:01:47 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:43795 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbfCWNBq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Mar 2019 09:01:46 -0400
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id A5123100002;
        Sat, 23 Mar 2019 13:01:40 +0000 (UTC)
Date:   Sat, 23 Mar 2019 14:02:21 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Bingbu Cao <bingbu.cao@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>
Cc:     "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Zhi, Yong" <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>,
        libcamera-devel@lists.libcamera.org
Subject: Re: [PATCH v7 00/16] Intel IPU3 ImgU patchset
Message-ID: <20190323130221.xr4bvraqnfjdfezk@uno.localdomain>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <1609628.n3aCoxV5Mp@avalon>
 <b7380656-13bd-884d-366f-87d690090be8@linux.intel.com>
 <4147983.Vfm2iTi9Nh@avalon>
 <c7578347-c1ac-664c-4407-40b968daf377@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7izyplabq4cupqia"
Content-Disposition: inline
In-Reply-To: <c7578347-c1ac-664c-4407-40b968daf377@linux.intel.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--7izyplabq4cupqia
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello,
   sorry for resurrecting the thread.

The development of libcamera has IPU3 devices as first target, and
we're now at the point where some clarifications are required.
I'll re-use this email, as some of points were already stated here
and, as they've become pressing for libcamera development, I would like
to have them clarified here on the list.

On Wed, Jan 02, 2019 at 10:38:33AM +0800, Bingbu Cao wrote:
>
> On 12/26/2018 07:03 PM, Laurent Pinchart wrote:
> > Hello Bingbu,
> >

[snip]

> > > > > > > > 2. ImgU pipeline needs to be configured for image processing as below.
> > > > > > > >
> > > > > > > > RAW bayer frames go through the following ISP pipeline HW blocks to
> > > > > > > > have the processed image output to the DDR memory.
> > > > > > > >
> > > > > > > > RAW bayer frame -> Input Feeder -> Bayer Down Scaling (BDS) ->
> > > > > > > > Geometric Distortion Correction (GDC) -> DDR
> > > > > > > >
> > > > > > > > The ImgU V4L2 subdev has to be configured with the supported
> > > > > > > > resolutions in all the above HW blocks, for a given input resolution.
> > > > > > > >
> > > > > > > > For a given supported resolution for an input frame, the Input Feeder,
> > > > > > > > Bayer Down Scaling and GDC blocks should be configured with the
> > > > > > > > supported resolutions. This information can be obtained by looking at
> > > > > > > > the following IPU3 ISP configuration table for ov5670 sensor.
> > > > > > > >
> > > > > > > > https://chromium.googlesource.com/chromiumos/overlays/board-overlays/+
> > > > > > > > /master/baseboard-poppy/media-libs/cros-camera-hal-configs-poppy/
> > > > > > > > files/gcss/graph_settings_ov5670.xml
> > > > > > > >
> > > > > > > > For the ov5670 example, for an input frame with a resolution of
> > > > > > > > 2592x1944 (which is input to the ImgU subdev pad 0), the corresponding
> > > > > > > > resolutions for input feeder, BDS and GDC are 2592x1944, 2592x1944 and
> > > > > > > > 2560x1920 respectively.
> > > > > > > How is the GDC output resolution computed from the input resolution ?
> > > > > > > Does the GDC always consume 32 columns and 22 lines ?
> > > > > All the intermediate resolutions in the pipeline are determined by the
> > > > > actual use case, in other word determined by the IMGU input
> > > > > resolution(sensor output) and the final output and viewfinder resolution.
> > > > > BDS mainly do Bayer downscaling, it has limitation that the downscaling
> > > > > factor must be a value a integer multiple of 1/32.
> > > > > GDC output depends on the input and width should be x8 and height x4
> > > > > alignment.
> > > > Thank you for the information. This will need to be captured in the
> > > > documentation, along with information related to how each block in the
> > > > hardware pipeline interacts with the image size. It should be possible for
> > > > a developer to compute the output and viewfinder resolutions based on the
> > > > parameters of the image processing algorithms just with the information
> > > > contained in the driver documentation.

In libcamera development we're now at the point of having to calculate
the sizes to apply to all intermediate pipeline stages based on the
following informations:

1) Main output resolution
2) Secondary output resolution (optional)
3) Image sensor's available resolutions

Right now that informations are captured in the xml file you linked
here above, but we need a programmatic way to do the calculation,
without going through an XML file, that refers to two specific sensors
only.

As Laurent said here, this should come as part of the documentation
for driver users and would unblock libcamera IPU3 support
development.

Could you provide documentation on how to calculate each
intermediate step resolutions?

> > > >

[snip]

> > > > > > > > 3. The ImgU V4L2 subdev composing should be set by using the
> > > > > > > > VIDIOC_SUBDEV_S_SELECTION on pad 0, with V4L2_SEL_TGT_COMPOSE as the
> > > > > > > > target, using the BDS height and width.
> > > > > > > >
> > > > > > > > Once these 2 steps are done, the raw bayer frames can be input to the
> > > > > > > > ImgU V4L2 subdev for processing.
> > > > > > > Do I need to capture from both the output and viewfinder nodes ? How
> > > > > > > are they related to the IF -> BDS -> GDC pipeline, are they both fed
> > > > > > > from the GDC output ? If so, how does the viewfinder scaler fit in that
> > > > > > > picture ?
> > > > > The output capture should be set, the viewfinder can be disabled.
> > > > > The IF and BDS are seen as crop and compose of the imgu input video
> > > > > device. The GDC is seen as the subdev sink pad and OUTPUT/VF are source
> > > > > pads.

This is another point that we would like to have clarified:
1) which outputs are mandatory and which one are not
2) which operations are mandatory on un-used outputs
3) does the 'ipu_pipe_mode' control impact this

As you mentioned here, "output" seems to be mandatory, while
"viewfinder" and "stat" are optional. We have tried using the "output"
video node only but the system hangs to an un-recoverable state.

What I have noticed is instead that the viewfinder and stat nodes
needs to be:
1) Linked to the respective "ImgU" subdevice pads
2) Format configured
3) Memory reserved
4) video device nodes started

It it not required to queue/dequeue buffers from viewfinder and stat,
but steps 1-4 have to be performed.

Can you confirm this is intended?
Could you please list all the steps that have to be applied to the
ImgU's capture video nodes, and which ones are mandatory and which ones
are optional, for the following use cases:
1) Main output capture only
2) Main + secondary output capture
3) Secondary capture only.

Thanks
   j

--7izyplabq4cupqia
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlyWLl0ACgkQcjQGjxah
Vjz8vw/+KsiaoN7t+tP1NWIsMdFE5x7f9HmcrjM9+XTbDNVCYsi6/Vgwu1PnoCf7
ji9owYNofmMol3LcWaLxJx8qvLUIA+Okc68j1IuR9VgaiZt8mw8QCeFsdEb78yRI
zfoYr79EBttxHvFAMHRHOmVnfPtf6l8dbVVlL9LxtCMGU7k6/ZyWAxJfT9Cfx7hU
us8HmtXoM9ScZNucTJtMOksMBt09Ss6jef1rl3eAMzCjjCQCy/ZOrKHvJrPI5W+x
ngjr+ddYb5HwRPKwOkvWPQLactpmhBkcpFeIVYcezRbYCgBOR4nwi1LRQxPKbC2k
wALebDOdFfuqofqfdNfgO1M/Aw313UJWVxS/Kknr62AQjnAH9EXsP3wV/0WkLwoU
H6y6HoujlSILrQ+y/Th0mo5NtQJhA8egbp9rH15yAr0MRGNu5C1c+1MBUqpvndpH
iJ9kibg/62kleB+vobUp1LEgxPizEDzZqcMVdSbW3eEazbDBpoX1WUP1C6w9dbda
lLcPj41Wwl7umm5LGsDwhImM27m8Hzt5KTVyar3XN4c07aGwEAOR2Rq7CHya8D84
yIa0jVWN84JZbH/MGTIpHFPpHKuXK/VYCc5Zaq157FcHxFx1HaPb5gWxr8UdQy6B
IPB5YIglA7dxrNRaXsOoE2y5OId2qlhdMGfUEiyhbQV5Jsvc9jo=
=doba
-----END PGP SIGNATURE-----

--7izyplabq4cupqia--
