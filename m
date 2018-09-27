Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58874 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726991AbeI0Qb3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Sep 2018 12:31:29 -0400
Date: Thu, 27 Sep 2018 07:13:30 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Javier Martinez Canillas <javierm@redhat.com>,
        linux-kernel@vger.kernel.org,
        Tian Shu Qiu <tian.shu.qiu@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jian Xu Zheng <jian.xu.zheng@intel.com>,
        Yong Zhi <yong.zhi@intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/2] media: intel-ipu3: allow the media graph to be used
 even if a subdev fails
Message-ID: <20180927071330.1fa3cfdd@coco.lan>
In-Reply-To: <0e31ae40-276e-22be-c6aa-b62f8dbea79e@xs4all.nl>
References: <20180904113018.14428-1-javierm@redhat.com>
        <0e31ae40-276e-22be-c6aa-b62f8dbea79e@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 27 Sep 2018 11:52:35 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi Javier,
>=20
> On 09/04/2018 01:30 PM, Javier Martinez Canillas wrote:
> > Hello,
> >=20
> > This series allows the ipu3-cio2 driver to properly expose a subset of =
the
> > media graph even if some drivers for the pending subdevices fail to pro=
be.
> >=20
> > Currently the driver exposes a non-functional graph since the pad links=
 are
> > created and the subdev dev nodes are registered in the v4l2 async .comp=
lete
> > callback. Instead, these operations should be done in the .bound callba=
ck.
> >=20
> > Patch #1 just adds a v4l2_device_register_subdev_node() function to all=
ow
> > registering a single device node for a subdev of a v4l2 device.
> >=20
> > Patch #2 moves the logic of the ipu3-cio2 .complete callback to the .bo=
und
> > callback. The .complete callback is just removed since is empy after th=
at. =20
>=20
> Sorry, I missed this series until you pointed to it on irc just now :-)
>=20
> I have discussed this topic before with Sakari and Laurent. My main probl=
em
> with this is how an application can discover that not everything is onlin=
e?
> And which parts are offline?

Via the media controller? It should be possible for an application to see
if a videonode is missing using it.

> Perhaps a car with 10 cameras can function with 9, but not with 8. How wo=
uld
> userspace know?

I guess this is not the only case where someone submitted a patch for
a driver that would keep working if some device node registration fails.

It could be just d=C3=A9j=C3=A0 vu, but I have a vague sensation that I mer=
ged something=20
similar to it in the past on another driver, but I can't remember any detai=
ls.

>=20
> I completely agree that we need to support these advanced scenarios (incl=
uding
> what happens when a camera suddenly fails), but it is the userspace aspec=
ts
> for which I would like to see an RFC first before you can do these things.

Dynamic runtime fails should likely rise some signal. Perhaps a sort of
media controller event?

>=20
> Regards,
>=20
> 	Hans
>=20
> >=20
> > Best regards,
> > Javier
> >=20
> >=20
> > Javier Martinez Canillas (2):
> >   [media] v4l: allow to register dev nodes for individual v4l2 subdevs
> >   media: intel-ipu3: create pad links and register subdev nodes at bound
> >     time
> >=20
> >  drivers/media/pci/intel/ipu3/ipu3-cio2.c | 66 ++++++-----------
> >  drivers/media/v4l2-core/v4l2-device.c    | 90 ++++++++++++++----------
> >  include/media/v4l2-device.h              | 10 +++
> >  3 files changed, 85 insertions(+), 81 deletions(-)
> >  =20
>=20



Thanks,
Mauro
