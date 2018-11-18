Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:60725 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbeKRKbT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Nov 2018 05:31:19 -0500
Date: Sun, 18 Nov 2018 01:12:41 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        tfiga@chromium.org, mchehab@kernel.org, hans.verkuil@cisco.com,
        laurent.pinchart@ideasonboard.com, rajmohan.mani@intel.com,
        jian.xu.zheng@intel.com, jerry.w.hu@intel.com,
        tuukka.toivonen@intel.com, tian.shu.qiu@intel.com,
        bingbu.cao@intel.com
Subject: Re: [PATCH v7 00/16] Intel IPU3 ImgU patchset
Message-ID: <20181118001241.GJ19257@w540>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <20181114002511.GD19257@w540>
 <20181114074050.76kv5ygqvt7h2l2p@kekkonen.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="NPWyolIJAVLYbHY6"
Content-Disposition: inline
In-Reply-To: <20181114074050.76kv5ygqvt7h2l2p@kekkonen.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--NPWyolIJAVLYbHY6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Sakari,

On Wed, Nov 14, 2018 at 09:40:50AM +0200, Sakari Ailus wrote:
> Hi Jacopo,
>
> On Wed, Nov 14, 2018 at 01:25:11AM +0100, jacopo mondi wrote:
> > On Mon, Oct 29, 2018 at 03:22:54PM -0700, Yong Zhi wrote:
> > > Hi,
> > >
> > > This series adds support for the Intel IPU3 (Image Processing Unit)
> > > ImgU which is essentially a modern memory-to-memory ISP. It implements
> > > raw Bayer to YUV image format conversion as well as a large number of
> > > other pixel processing algorithms for improving the image quality.
> > >
> > > Meta data formats are defined for image statistics (3A, i.e. automatic
> > > white balance, exposure and focus, histogram and local area contrast
> > > enhancement) as well as for the pixel processing algorithm parameters.
> > > The documentation for these formats is currently not included in the
> > > patchset but will be added in a future version of this set.
> > >
> > > The algorithm parameters need to be considered specific to a given frame
> > > and typically a large number of these parameters change on frame to frame
> > > basis. Additionally, the parameters are highly structured (and not a flat
> > > space of independent configuration primitives). They also reflect the
> > > data structures used by the firmware and the hardware. On top of that,
> > > the algorithms require highly specialized user space to make meaningful
> > > use of them. For these reasons it has been chosen video buffers to pass
> > > the parameters to the device.
> > >
> > > On individual patches:
> > >
> > > The heart of ImgU is the CSS, or Camera Subsystem, which contains the
> > > image processors and HW accelerators.
> > >
> > > The 3A statistics and other firmware parameter computation related
> > > functions are implemented in patch 11.
> > >
> > > All IPU3 pipeline default settings can be found in patch 10.
> > >
> >
> > Seems to me that patch 10 didn't make it to the mailing list, am I
> > wrong?
> >
> > I'm pointing it out as the same happened on your v6.
>
> Thanks for pointing this out. I've uploaded the entire set here:
>
> <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=ipu3-v7>
>
> including the 10th patch:
>
> <URL:https://git.linuxtv.org/sailus/media_tree.git/commit/?h=ipu3-v7&id=41e2f0d114dbc195efed079202d22748ddedbe83>
>
> It's too big to get through the list server. :-(
>
> Luckily, it's mostly tables so there's not much to review there. Default
> settings, effectively.

Thanks, I've now received all patches.

Thanks
   j

>
> --
> Regards,
>
> Sakari Ailus
> sakari.ailus@linux.intel.com

--NPWyolIJAVLYbHY6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJb8K55AAoJEHI0Bo8WoVY80YwQALGAsXLaV9hPqdU7zIoLhQzf
dyM5O9RMmVaLS+tYPEQtF2xv7UstzzNqlCn7/0V3B13SLYiHAIXnNgt8D/0vUJQs
hYA1CgB0JPc4h4i/ofVq4HxvGJ/QtsnV9+XcId9ZKmYZ3Twd/eqnR87jiYo6dbUF
RY5CInvKcQCHK/EWLbFfPcW2I01mwyDmuGHvrVKnu9pHNYRM/I6vUyKTZ2wPmGY+
vlD19YFTjVyVkkdLltw+c/QDTA9qvEB2inwlhGan4+AZlqogUWCSKGPut5SCdnYG
zRfXvREvDqenI2UJKrxoOBy9DjGkECyImlFimNQleugcdABy3p7JioSP8Z8Aezsh
Z+43zEs9QHprda0wnIFArC2+3wqHSHyCFxIFYVax9B+oKhdSliJf1MS6xWO2Fuqq
eBzGgFDg7CRSXlC/WgCw9AUFoR+EdFZAeAx0ostc1zkkXqOQ4hfHZxNw0OtPHmwB
gPls0aq7C9zwSqyYRMd1UOOoPGm0dzUOCupJoa1LsPJ13ton6e1RG6f2vT5K2VBZ
k8SNyakmS56p1fPfvsjaS9fBrLhrpu4LJPKcTFwcILmg7BLACjNXb6bm/KOK83HC
0sxYP4rnhn16bfrxP65EGd5O2f059XJmY5X5C7Gmpr98JdvkmGFHF2/GiQrMPr9/
7fA5R6MURG38eJ3qOnWt
=G3nm
-----END PGP SIGNATURE-----

--NPWyolIJAVLYbHY6--
