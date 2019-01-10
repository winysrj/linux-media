Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F3F4C43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 08:19:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F3EA20657
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 08:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbfAJITy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 03:19:54 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:53203 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727556AbfAJITy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 03:19:54 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 05236C0004;
        Thu, 10 Jan 2019 08:19:48 +0000 (UTC)
Date:   Thu, 10 Jan 2019 09:19:55 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     "Mani, Rajmohan" <rajmohan.mani@intel.com>
Cc:     Tomasz Figa <tfiga@chromium.org>, "Zhi, Yong" <yong.zhi@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>
Subject: Re: [PATCH v7 00/16] Intel IPU3 ImgU patchset
Message-ID: <20190110081955.uuevbwgdlo7xr6gi@uno.localdomain>
References: <2135468.G1bK1392oW@avalon>
 <3475971.piroVKfGO7@avalon>
 <CAAFQd5CN3dhTviSnFbzSOjkMTQqUyOajYv+CVxSLLAih522CgQ@mail.gmail.com>
 <CAAFQd5AWLi=UD+LtuiQdc5QD8v5B1WX0Jcoe6=QUy+392FSeng@mail.gmail.com>
 <20190109164037.yvtluixvua7cm2tl@uno.localdomain>
 <6F87890CF0F5204F892DEA1EF0D77A599B321599@fmsmsx122.amr.corp.intel.com>
 <20190109172553.lrnwxuy3x4drk6af@uno.localdomain>
 <6F87890CF0F5204F892DEA1EF0D77A599B3215DA@fmsmsx122.amr.corp.intel.com>
 <20190109182028.l6dopz5k75w3u3t4@uno.localdomain>
 <6F87890CF0F5204F892DEA1EF0D77A599B321627@fmsmsx122.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sxmjs6z7vsobca4q"
Content-Disposition: inline
In-Reply-To: <6F87890CF0F5204F892DEA1EF0D77A599B321627@fmsmsx122.amr.corp.intel.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--sxmjs6z7vsobca4q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Raj,

On Wed, Jan 09, 2019 at 06:36:02PM +0000, Mani, Rajmohan wrote:
> Hi Jacopo,
>
> > Subject: Re: [PATCH v7 00/16] Intel IPU3 ImgU patchset
> >
> > Hi Raj,
> >
> > On Wed, Jan 09, 2019 at 06:01:39PM +0000, Mani, Rajmohan wrote:
> > > Hi Jacopo,
> > >
> > > > Subject: Re: [PATCH v7 00/16] Intel IPU3 ImgU patchset
> > > >
> > > > Hello Raj,
> > > >
> > > > On Wed, Jan 09, 2019 at 05:00:21PM +0000, Mani, Rajmohan wrote:
> > > > > Hi Laurent, Tomasz, Jacopo,
> > > > >
> > > > > > Subject: Re: [PATCH v7 00/16] Intel IPU3 ImgU patchset
> > > > > >
> > > > > > Hello,
> > > > > >
> > > > > > On Tue, Jan 08, 2019 at 03:54:34PM +0900, Tomasz Figa wrote:
> > > > > > > Hi Raj, Yong, Bingbu, Tianshu,
> > > > > > >
> > > > > > > On Fri, Dec 21, 2018 at 12:04 PM Tomasz Figa
> > > > > > > <tfiga@chromium.org>
> > > > wrote:
> > > > > > > >
> > > > > > > > On Fri, Dec 21, 2018 at 7:24 AM Laurent Pinchart
> > > > > > > > <laurent.pinchart@ideasonboard.com> wrote:
> > > > > > > > >
> > > > > > > > > Hellon
> > > > > > > > >
> > > > > > > > > On Sunday, 16 December 2018 09:26:18 EET Laurent Pinchart
> > wrote:
> > > > > > > > > > Hello Yong,
> > > > > > > > > >
> > > > > > > > > > Could you please have a look at the crash reported below ?
> > > > > > > > >
> > > > > > > > > A bit more information to help you debugging this. I've
> > > > > > > > > enabled KASAN in the kernel configuration, and get the
> > > > > > > > > following use-after-free
> > > > > > reports.
> > > > > >
> > > > > > I tested as well using the ipu-process.sh script shared by
> > > > > > Laurent, with the following command line:
> > > > > > ./ipu3-process.sh --out 2560x1920 --vf 1920x1080
> > > > > > frame-2592x1944.cio2
> > > > > >
> > > > > > and I got a very similar trace available at:
> > > > > > https://paste.debian.net/hidden/5855e15a/
> > > > > >
> > > > > > Please note I have been able to process a set of images (with
> > > > > > KASAN enabled the machine does not freeze) but the kernel log
> > > > > > gets flooded and it is not possible to process any other frame after this.
> > > > > >
> > > > > > The issue is currently quite annoying and it's a blocker for
> > > > > > libcamera development on IPU3. Please let me know if I can
> > > > > > support with
> > > > more testing.
> > > > > >
> > > > > > Thanks
> > > > > >    j
> > > > > >
> > > > > > > > >
> > > > > > > > > [  166.332920]
> > > > > > > > >
> > > > > >
> > > >
> > ================================================================
> > > > > > ==
> > > > > > > > > [  166.332937] BUG: KASAN: use-after-free in
> > > > > > > > > __cached_rbnode_delete_update+0x36/0x202
> > > > > > > > > [  166.332944] Read of size 8 at addr ffff888133823718 by
> > > > > > > > > task
> > > > > > > > > yavta/1305
> > > > > > > > >
> > > > > > > > > [  166.332955] CPU: 3 PID: 1305 Comm: yavta Tainted: G         C
> > > > 4.20.0-
> > > > > > rc6+ #3
> > > > > > > > > [  166.332958] Hardware name: HP Soraka/Soraka, BIOS
> > > > > > > > > 08/30/2018 [ 166.332959] Call Trace:
> > > > > > > > > [  166.332967]  dump_stack+0x5b/0x81 [  166.332974]
> > > > > > > > > print_address_description+0x65/0x227
> > > > > > > > > [  166.332979]  ? __cached_rbnode_delete_update+0x36/0x202
> > > > > > > > > [  166.332983]  kasan_report+0x247/0x285 [  166.332989]
> > > > > > > > > __cached_rbnode_delete_update+0x36/0x202
> > > > > > > > > [  166.332995]  private_free_iova+0x57/0x6d [  166.332999]
> > > > > > > > > __free_iova+0x23/0x31 [  166.333011]
> > > > > > > > > ipu3_dmamap_free+0x118/0x1d6 [ipu3_imgu]
> > > > > > > >
> > > > > > > > Thanks Laurent, I think this is a very good hint. It looks
> > > > > > > > like we're basically freeing and already freed IOVA and
> > > > > > > > corrupting some allocator state?
> > > > > > >
> > > > > > > Did you have any luck in reproducing and fixing this double free
> > issue?
> > > > > > >
> > > > >
> > > > > This issue is either hard to reproduce or comes with different
> > > > > signatures with the updated yavta (that now supports meta output)
> > > > > with the 4.4 kernel that I have been using.
> > > > > I am switching to 4.20-rc6 for better reproducibility.
> > > > > Enabling KASAN also results in storage space issues on my Chrome
> > device.
> > > > > Will enable this just for ImgU to get ahead and get back with more
> > updates.
> > > > >
> > > >
> > > > Thanks for testing this.
> > > >
> > > > For your informations I'm using the following branch, from Sakari's
> > > > tree: git://linuxtv.org/sailus/media_tree.git ipu3
> > > >
> > > > Although it appears that the media tree master branch has everything
> > > > that is there, with a few additional patches on top. I should move
> > > > to use media tree master as well...
> > > >
> > > > I have here attached 2 configuration files for v4.20-rc5 I am using
> > > > on Soraka, in case they might help you. One has KASAN enabled with
> > > > an increased kernel log size, the other one is the one we use for daily
> > development.
> > >
> > > I think I am missing a trick here to override the default chrome os
> > > kernel config with the one that you supplied.
> > >
> > > In particular I am looking for steps to build the upstream kernel
> > > within chrome os build environment using your config, so I can update my
> > Soraka device.
> >
> > I'm sorry I can not help much building 'withing chrome os build environment'.
> > Care to explain what you mean?
> >
>
> This is part of the Chromium OS build environment and development workflow.
> https://chromium.googlesource.com/chromiumos/docs/+/master/kernel_faq.md
>
> No worries.
> I will sync up with Tomasz, as he managed to get this working with 4.20 kernel.
>

I'm sorry I can't help much here. I suggest to work with mainline (or
better, media master) and install a GNU/Linux distro on the chromebook so
you can easily update your kernel.

I personally used https://chrx.org/ that makes installing gallium (or
else) very easy. Once you get that running, I find easy enough to
update the kernel installing a .deb package.

--sxmjs6z7vsobca4q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlw3ACsACgkQcjQGjxah
VjzXSQ/+Mj4GL9I9asyA50pgy6DTrEhIzva7fufmUah7nQgxSFcYoOs/Fc3NfE6b
FvYj+1rQCv27OKlg/nApvUIcG+SDWPQXPq/gwkx9i8/ybdJmHM4S/YG7BhkCOtF1
ure7jlVtqo9ud6soH6o7MZ6sOwD9yALZqcx7aXj0u0T1N4ElFL7NjB/oHdiI69sN
WCuDq/sSLaoebtrXWv8ThgM9NnyKVK/RX+2Yygt+cb1cY1Yi4uQlik2WeQTK3UuO
OCq8SjFzuQHrspzpRiicjccODN3kAOZG5JnMmMqHMecSj2FFN/17SdAIqtVBz+4w
afTWZIBTQOsn7GTgrxWeYyYShSRiGCyggpsUKckK+e+hlxT2tR9pnFMFkA4kO3iD
PWLuI7WbpOhRWKk5QnTNzUU5r5o73kYH0mkts4XL4kwDu16pS8+oWvRl8zJpki+0
SgH/drwOzV6P/Mlh9Kn+8ufBwyUQ3DC41EG6CUCgS5KRzVWN8tDix2HsrgYSnf1M
mmqf5RTq7KFwjX2qUfrDGDtZ2wFcFF7B1fDkkJ3cW5CvCxSJb7AVaN5/ZG8WxMnO
2MtJCtv1bfr2kbkvMjISqkCsP1NlPj3o+FTLunvKI0hLYWEJUjqOMDcxLx8ObL2V
Ijr/GPLFc+2ENvVEcveKQQ3asEZy4MdRyZqOppLi7NRxoKPnBps=
=rkgF
-----END PGP SIGNATURE-----

--sxmjs6z7vsobca4q--
