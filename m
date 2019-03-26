Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89FF7C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 11:15:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 475592070B
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 11:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbfCZLPx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 07:15:53 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:40499 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbfCZLPx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 07:15:53 -0400
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 4F27B1BF208;
        Tue, 26 Mar 2019 11:15:46 +0000 (UTC)
Date:   Tue, 26 Mar 2019 12:16:28 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Bingbu Cao <bingbu.cao@linux.intel.com>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Zhi, Yong" <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>,
        libcamera-devel@lists.libcamera.org
Subject: Re: [PATCH v7 00/16] Intel IPU3 ImgU patchset
Message-ID: <20190326111628.5hninfqhtxpxqqu4@uno.localdomain>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <1609628.n3aCoxV5Mp@avalon>
 <b7380656-13bd-884d-366f-87d690090be8@linux.intel.com>
 <4147983.Vfm2iTi9Nh@avalon>
 <c7578347-c1ac-664c-4407-40b968daf377@linux.intel.com>
 <20190323130221.xr4bvraqnfjdfezk@uno.localdomain>
 <ad0fa0d9-b89b-1c6e-9085-fe361832e9e1@linux.intel.com>
 <20190325040630.GE12029@pendragon.ideasonboard.com>
 <20190325081105.njjpvvlj6n5rxnsb@uno.localdomain>
 <83e79e5a-6503-51a6-2c45-0fbd1cbfbdaa@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="imum3gg274fsyriz"
Content-Disposition: inline
In-Reply-To: <83e79e5a-6503-51a6-2c45-0fbd1cbfbdaa@linux.intel.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--imum3gg274fsyriz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bingbu,

On Mon, Mar 25, 2019 at 06:07:58PM +0800, Bingbu Cao wrote:
>
>
> On 3/25/19 4:11 PM, Jacopo Mondi wrote:
> > Hi Laurent, Bingbu
> >
> > On Mon, Mar 25, 2019 at 06:06:30AM +0200, Laurent Pinchart wrote:
> >> Hi Bingbu,
> >>
> > [snip]
> >
> >>>>>>>>
> >>>>>>>> Thank you for the information. This will need to be captured in =
the
> >>>>>>>> documentation, along with information related to how each block =
in the
> >>>>>>>> hardware pipeline interacts with the image size. It should be po=
ssible for
> >>>>>>>> a developer to compute the output and viewfinder resolutions bas=
ed on the
> >>>>>>>> parameters of the image processing algorithms just with the info=
rmation
> >>>>>>>> contained in the driver documentation.
> >>>>
> >>>> In libcamera development we're now at the point of having to calcula=
te
> >>>> the sizes to apply to all intermediate pipeline stages based on the
> >>>> following informations:
> >>>>
> >>>> 1) Main output resolution
> >>>> 2) Secondary output resolution (optional)
> >>>> 3) Image sensor's available resolutions
> >>>>
> >>>> Right now that informations are captured in the xml file you linked
> >>>> here above, but we need a programmatic way to do the calculation,
> >>>> without going through an XML file, that refers to two specific senso=
rs
> >>>> only.
> >>>>
> >>>> As Laurent said here, this should come as part of the documentation
> >>>> for driver users and would unblock libcamera IPU3 support
> >>>> development.
> >>>>
> >>>> Could you provide documentation on how to calculate each
> >>>> intermediate step resolutions?
> >>>
> >>> All the intermediate step resolutions are generated by the specific t=
ool
> >>> with sensor input and outputs resolutions.
> >>>
> >>> The tool try to keep maximum fov and has the knowledge of all the
> >>> limitations of each intermediate hardware components(mainly BDS and G=
DC).
> >>
> >> That's exactly what we want to do in software in libcamera :-) And
> >> that's why we need more infirmation about the limitations of each
> >> intermediate hardware component. Eventually those limitations should be
> >> documented in the IPU3 driver documentation in the kernel sources, but
> >> for now we can move forward if they're just communicated by e-mail (if
> >> time permits we may be able to submit a kernel patch to integrate that
> >> in the documentation).
> >>
> >>> Currently, there is not a very simple calculation to get the
> >>> intermediate resolutions.
> >>> Let's take some effort to try find a programmatic way to do calculati=
on
> >>> instead of the tool.
> >
> > Thank you for your effort.
> >
> >>>
> >>>> [snip]
> >>>>
> >>>>>>>>>>>> 3. The ImgU V4L2 subdev composing should be set by using the
> >>>>>>>>>>>> VIDIOC_SUBDEV_S_SELECTION on pad 0, with V4L2_SEL_TGT_COMPOS=
E as the
> >>>>>>>>>>>> target, using the BDS height and width.
> >>>>>>>>>>>>
> >>>>>>>>>>>> Once these 2 steps are done, the raw bayer frames can be inp=
ut to the
> >>>>>>>>>>>> ImgU V4L2 subdev for processing.
> >>>>>>>>>>> Do I need to capture from both the output and viewfinder node=
s ? How
> >>>>>>>>>>> are they related to the IF -> BDS -> GDC pipeline, are they b=
oth fed
> >>>>>>>>>>> from the GDC output ? If so, how does the viewfinder scaler f=
it in that
> >>>>>>>>>>> picture ?
> >>>>>>>>> The output capture should be set, the viewfinder can be disable=
d.
> >>>>>>>>> The IF and BDS are seen as crop and compose of the imgu input v=
ideo
> >>>>>>>>> device. The GDC is seen as the subdev sink pad and OUTPUT/VF ar=
e source
> >>>>>>>>> pads.
> >>>>
> >>>> This is another point that we would like to have clarified:
> >>>> 1) which outputs are mandatory and which one are not
> >>>> 2) which operations are mandatory on un-used outputs
> >>>> 3) does the 'ipu_pipe_mode' control impact this
> >>>>
> >>>> As you mentioned here, "output" seems to be mandatory, while
> >>>> "viewfinder" and "stat" are optional. We have tried using the "outpu=
t"
> >>>> video node only but the system hangs to an un-recoverable state.
> >>>
> >>> Yes, main output is mandatory, 'vf' and 'stat' are optional.
> >>
> >> I will let Jacopo confirm this, but unless I'm mistaken, when he tried
> >> to use the main output only (with the links between the ImgU subdev and
> >> the vf and stat video nodes disabled), the driver would hang without
> >> processing any frame. I believe this was a complete system hang,
> >> requiring a hard reboot to recover.
> >>
> >
> > Yes, that's what I have noticed.
> >
> > On the other hand, if I link, configure, prepare buffers and start the
> > 'vf' and 'stat' nodes, but never queue buffers there, I can capture
> > from output only.
> >
> >>>> What I have noticed is instead that the viewfinder and stat nodes
> >>>> needs to be:
> >>>> 1) Linked to the respective "ImgU" subdevice pads
> >>>> 2) Format configured
> >>>> 3) Memory reserved
> >>>> 4) video device nodes started
> >>>>
> >>>> It it not required to queue/dequeue buffers from viewfinder and stat,
> >>>> but steps 1-4 have to be performed.
> >>>>
> >>>> Can you confirm this is intended?
> >>>
> >>> viewfinder and stats are enabled when the link for respective subdev
> >>> pads enabled, and then driver can use these input conditions to find =
the
> >>> binary to run.
> >>>
> >
> > As Laurent reported above, if I leave the the 'vf' and 'stat' links
> > disabled, the system hangs.
> >
> >>>> Could you please list all the steps that have to be applied to the
> >>>> ImgU's capture video nodes, and which ones are mandatory and which o=
nes
> >>>> are optional, for the following use cases:
> >>>> 1) Main output capture only
> >>>> 2) Main + secondary output capture
> >>>> 3) Secondary capture only.
> >>>
> >>> I think the 3) is not supported.
> >>>
> >>> The steps are:
> >>> 1). link necessary the respective subdevices
> >>> input --> imgu -->output
> >>>             |  -->vf
> >>>             |  -->3a stats
> >
> > For which use case, in the above reported list?
> >
> >  1) Main output capture only
> >         Does 'vf' and 'stat' links needs to be enabled?
> >
> >  2) Main + secondary output capture
> >         Does 'stat' link need to be enabled?
> >
> >  3) Secondary capture only.
> >         not supported
>
> The list above is a typical use, all outputs enabled, you can setup link
> for main output only.

I think we should clarify better what you mean by 'enabled'.

=46rom my testing what I see is that in order to operate the main
output I have to:
- link the stat and vf nodes (as well as input and output of course)
- reserve memory buffers on stat and vf video nodes, even if not used
- set format on all device ndoes
- start the all video devices

If one of these steps is not performed, the ImgU processing stalls and
I need to hard reboot the device to have it operational again.

On the other hand, I see that there is no need to queue any buffer to
any of the output capture devices to have frames processed by the
ImgU.

IF links are setup as explained above, format configured and all the video
device node started, I can queue all the frames I want to the ImgU input
and never queue anything on its outputs, and they will get processed and
returned to userspace nicely from the ImgU input device node. As soon
as I queue a buffer to the ImgU main output video device, I see it
returned filled with the processed data. This is good, as it doesen't
stall the pipeline if there are no capture buffers to queue to the
ImgU output, but now I wonder what you meant with "main output is
mandatory"

> >
> >>>
> >>> 2). set all the formats for input, output and intermediate resolution=
s.
> >>> 3). start stream
> >>>
> >>> The ipu pipe_mode will not impact the whole pipe behavior. It just ask
> >>> firmware to run different processing to generate same format outputs.
> >>
> >
> > I would apreciate to have a better description of the pipe_mode
> > control, in order to better understand when and if the library has to
> > modify its value and which mode to use (0=3Dvideo, 1=3Dstill_capture).
>
> In some application, it will request continuous viewfinder, that means
> you must keep preview continuous when take capture. That means you can
> not switch out pipeline (preview and still mode, back and force), so the
> driver need create 2 pipelines to satisfy this usage, 1 video mode pipe
> and another is still mode. Both 2 pipes are created at first, run the
> pipe as you command. It also can support still during video usage.
>

Thanks for the explanation, but it is still vague to me and it worries
me a bit as in this typical usage scenario (viewfinder + sporadic
capture) -both- ImgU pipes have to be used, preventing usage of two
cameras at the same time (one camera assigned to one ImgU pipe
instance).

Why would you use both the ImgU pipes in this case? Shouldn't you
always capture from viewfinder (discarding main output frames
if not required), and when requested by the application capture from
both the main and secondary output from the same ImgU pipe? Why would I
need to change the pipe_mode for doing this?

Thank for your patience to answer all this questions :)


> >
> > Thanks
> >    j
> >
> >> --
> >> Regards,
> >>
> >> Laurent Pinchart

--imum3gg274fsyriz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlyaCgwACgkQcjQGjxah
VjxKexAAxbFymjjkmmXRHRNY/X/z2y/peMgnAhjciMaGnjIb67WictAr8k/7R/rB
+N2G858U9u6QfsLJFHE5H+YZ/etNMQyfspGlwsa9M/FpteTuLGUIJntbz7oZW8cO
fJVfm9xlYPN2S8w8+9bDEb+h4DgTrHq7VQwsqwgvjFPWr0OXHqx87M0O5hLUwsM8
xHoV3g19bS4ucP+JeLha6KaRKAsBigNURpA0Gu8KHpZUk5lLpO6Oa/9wfXDx3n0x
CXHXUjSQMAHRwkvJjrrmRgKcscjUT0Ycmit5rA0ScjsjOukN9vUCOWkQSLxJ/zFS
EBGofZY6GljRD72djXEARrHFlPDcVAsdD+Uq3Xn6/2iLuh1UyAmsGgIS/2pxoKVo
rmP+FC/N+x1gBGwrdydniuGNQk5gxXyYzKa792GEd6OkfE7O4toY+TfxhHg22R8T
YmHUbUkx+cl9xwmVt1TNuMeh2j5xjzJxwC8g1NWhdlSst9BOg8LEJnlkguGwCVwm
teG3yNCXt/0sP5q38eRtY6PhpTZ3Th67CGxJpMYpamobIfYW65y24jeMj8wU+svR
1j/xvgoeEb1w0kv0MuVMBIn4ktJBcBd8B+pu+leZ4UhCyRP6rOuUs34vsaUqKmed
XaKhWOIphoBMmQ4uJykLe9/JoHUGRqee0dI29WNS6cwj9ZMQ6xo=
=wqbE
-----END PGP SIGNATURE-----

--imum3gg274fsyriz--
