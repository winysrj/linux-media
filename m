Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:41175 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727595AbeKNSaa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 13:30:30 -0500
Received: by mail-yw1-f67.google.com with SMTP id c126-v6so6928355ywd.8
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2018 00:28:17 -0800 (PST)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id a4-v6sm779926ywe.37.2018.11.14.00.28.13
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Nov 2018 00:28:13 -0800 (PST)
Received: by mail-yb1-f172.google.com with SMTP id u103-v6so6568873ybi.5
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2018 00:28:13 -0800 (PST)
MIME-Version: 1.0
References: <20180904113018.14428-1-javierm@redhat.com> <0e31ae40-276e-22be-c6aa-b62f8dbea79e@xs4all.nl>
 <20180927071330.1fa3cfdd@coco.lan> <865b545d-3c3a-a2d3-4c1b-2a5b41a7ff37@xs4all.nl>
In-Reply-To: <865b545d-3c3a-a2d3-4c1b-2a5b41a7ff37@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 14 Nov 2018 17:28:00 +0900
Message-ID: <CAAFQd5C0JfVCakdXDGe_cEoEDH0X-Wwu5Zx3yi0PUNNdCWxRYg@mail.gmail.com>
Subject: Re: [PATCH 0/2] media: intel-ipu3: allow the media graph to be used
 even if a subdev fails
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        javierm@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        Yong Zhi <yong.zhi@intel.com>,
        Cao Bing Bu <bingbu.cao@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, Sep 27, 2018 at 7:22 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 09/27/2018 12:13 PM, Mauro Carvalho Chehab wrote:
> > Em Thu, 27 Sep 2018 11:52:35 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >
> >> Hi Javier,
> >>
> >> On 09/04/2018 01:30 PM, Javier Martinez Canillas wrote:
> >>> Hello,
> >>>
> >>> This series allows the ipu3-cio2 driver to properly expose a subset o=
f the
> >>> media graph even if some drivers for the pending subdevices fail to p=
robe.
> >>>
> >>> Currently the driver exposes a non-functional graph since the pad lin=
ks are
> >>> created and the subdev dev nodes are registered in the v4l2 async .co=
mplete
> >>> callback. Instead, these operations should be done in the .bound call=
back.
> >>>
> >>> Patch #1 just adds a v4l2_device_register_subdev_node() function to a=
llow
> >>> registering a single device node for a subdev of a v4l2 device.
> >>>
> >>> Patch #2 moves the logic of the ipu3-cio2 .complete callback to the .=
bound
> >>> callback. The .complete callback is just removed since is empy after =
that.
> >>
> >> Sorry, I missed this series until you pointed to it on irc just now :-=
)
> >>
> >> I have discussed this topic before with Sakari and Laurent. My main pr=
oblem
> >> with this is how an application can discover that not everything is on=
line?
> >> And which parts are offline?
> >
> > Via the media controller? It should be possible for an application to s=
ee
> > if a videonode is missing using it.
> >
> >> Perhaps a car with 10 cameras can function with 9, but not with 8. How=
 would
> >> userspace know?
> >
> > I guess this is not the only case where someone submitted a patch for
> > a driver that would keep working if some device node registration fails=
.
> >
> > It could be just d=C3=A9j=C3=A0 vu, but I have a vague sensation that I=
 merged something
> > similar to it in the past on another driver, but I can't remember any d=
etails.
> >
> >>
> >> I completely agree that we need to support these advanced scenarios (i=
ncluding
> >> what happens when a camera suddenly fails), but it is the userspace as=
pects
> >> for which I would like to see an RFC first before you can do these thi=
ngs.
> >
> > Dynamic runtime fails should likely rise some signal. Perhaps a sort of
> > media controller event?
>
> See this old discussion: https://patchwork.kernel.org/patch/9849317/
>
> My point is that someone needs to think about this and make a proposal.
> There may well be a simple approach, but it needs to be specced first.

In that thread, you seem to have mentioned that having a Kconfig
option, disabled by default, to allow registering an incomplete media
topology would be an acceptable option. Do you think we could revive
that idea?

Quoting some of the discussion points you mentioned:

Some discussion points:

> 1) What about adding time-out support? Today we wait forever until all co=
mponents
>    are found, but wouldn't it make sense to optionally time-out? And if s=
o, then
>    we can keep most of the code the same and decide in the complete() cal=
lback
>   whether or not we accept missing components. And decide how badly 'impa=
ired'
>   the system is. We can also still bring up all the devices in the comple=
te rather
>   than one-by-one as you proposed (and which I am not sure I like).

It sounds like an interesting extension, not a must have for handling
incomplete topologies.

I can also imagine the timeout handling introducing a lot of confusion
to the userspace, for example, with a long timeout, the whole
initialization would have to wait for the timeout to elapse, which for
a smartphone user could mean that they can't start the camera
application (or it times out on its own and fails) until then.

> 2) This can be hard to test, so perhaps we should support some form of er=
ror
>   injection to easily test what happens if something doesn't come up.

This is a very good point, but I think we should be able to do away
with something simpler, just blacklist particular device from being
bound to a driver. How to do it, is another question, though... (I can
imagine binding a dummy driver to the device as an example solution.)

Best regards,
Tomasz
