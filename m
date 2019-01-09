Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD42C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:27:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C914214C6
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfAIS1U (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 13:27:20 -0500
Received: from mslow2.mail.gandi.net ([217.70.178.242]:35372 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbfAIS1U (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 13:27:20 -0500
Received: from relay9-d.mail.gandi.net (unknown [217.70.183.199])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 0E06A3A4E26
        for <linux-media@vger.kernel.org>; Wed,  9 Jan 2019 19:20:25 +0100 (CET)
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id B9E86FF808;
        Wed,  9 Jan 2019 18:20:21 +0000 (UTC)
Date:   Wed, 9 Jan 2019 19:20:28 +0100
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
Message-ID: <20190109182028.l6dopz5k75w3u3t4@uno.localdomain>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <1819843.KIqgResAvh@avalon>
 <2135468.G1bK1392oW@avalon>
 <3475971.piroVKfGO7@avalon>
 <CAAFQd5CN3dhTviSnFbzSOjkMTQqUyOajYv+CVxSLLAih522CgQ@mail.gmail.com>
 <CAAFQd5AWLi=UD+LtuiQdc5QD8v5B1WX0Jcoe6=QUy+392FSeng@mail.gmail.com>
 <20190109164037.yvtluixvua7cm2tl@uno.localdomain>
 <6F87890CF0F5204F892DEA1EF0D77A599B321599@fmsmsx122.amr.corp.intel.com>
 <20190109172553.lrnwxuy3x4drk6af@uno.localdomain>
 <6F87890CF0F5204F892DEA1EF0D77A599B3215DA@fmsmsx122.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="27ihjddkqb567ax6"
Content-Disposition: inline
In-Reply-To: <6F87890CF0F5204F892DEA1EF0D77A599B3215DA@fmsmsx122.amr.corp.intel.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--27ihjddkqb567ax6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Raj,

On Wed, Jan 09, 2019 at 06:01:39PM +0000, Mani, Rajmohan wrote:
> Hi Jacopo,
>
> > Subject: Re: [PATCH v7 00/16] Intel IPU3 ImgU patchset
> >
> > Hello Raj,
> >
> > On Wed, Jan 09, 2019 at 05:00:21PM +0000, Mani, Rajmohan wrote:
> > > Hi Laurent, Tomasz, Jacopo,
> > >
> > > > Subject: Re: [PATCH v7 00/16] Intel IPU3 ImgU patchset
> > > >
> > > > Hello,
> > > >
> > > > On Tue, Jan 08, 2019 at 03:54:34PM +0900, Tomasz Figa wrote:
> > > > > Hi Raj, Yong, Bingbu, Tianshu,
> > > > >
> > > > > On Fri, Dec 21, 2018 at 12:04 PM Tomasz Figa <tfiga@chromium.org>
> > wrote:
> > > > > >
> > > > > > On Fri, Dec 21, 2018 at 7:24 AM Laurent Pinchart
> > > > > > <laurent.pinchart@ideasonboard.com> wrote:
> > > > > > >
> > > > > > > Hellon
> > > > > > >
> > > > > > > On Sunday, 16 December 2018 09:26:18 EET Laurent Pinchart wrote:
> > > > > > > > Hello Yong,
> > > > > > > >
> > > > > > > > Could you please have a look at the crash reported below ?
> > > > > > >
> > > > > > > A bit more information to help you debugging this. I've
> > > > > > > enabled KASAN in the kernel configuration, and get the
> > > > > > > following use-after-free
> > > > reports.
> > > >
> > > > I tested as well using the ipu-process.sh script shared by Laurent,
> > > > with the following command line:
> > > > ./ipu3-process.sh --out 2560x1920 --vf 1920x1080
> > > > frame-2592x1944.cio2
> > > >
> > > > and I got a very similar trace available at:
> > > > https://paste.debian.net/hidden/5855e15a/
> > > >
> > > > Please note I have been able to process a set of images (with KASAN
> > > > enabled the machine does not freeze) but the kernel log gets flooded
> > > > and it is not possible to process any other frame after this.
> > > >
> > > > The issue is currently quite annoying and it's a blocker for
> > > > libcamera development on IPU3. Please let me know if I can support with
> > more testing.
> > > >
> > > > Thanks
> > > >    j
> > > >
> > > > > > >
> > > > > > > [  166.332920]
> > > > > > >
> > > >
> > ================================================================
> > > > ==
> > > > > > > [  166.332937] BUG: KASAN: use-after-free in
> > > > > > > __cached_rbnode_delete_update+0x36/0x202
> > > > > > > [  166.332944] Read of size 8 at addr ffff888133823718 by task
> > > > > > > yavta/1305
> > > > > > >
> > > > > > > [  166.332955] CPU: 3 PID: 1305 Comm: yavta Tainted: G         C
> > 4.20.0-
> > > > rc6+ #3
> > > > > > > [  166.332958] Hardware name: HP Soraka/Soraka, BIOS
> > > > > > > 08/30/2018 [ 166.332959] Call Trace:
> > > > > > > [  166.332967]  dump_stack+0x5b/0x81 [  166.332974]
> > > > > > > print_address_description+0x65/0x227
> > > > > > > [  166.332979]  ? __cached_rbnode_delete_update+0x36/0x202
> > > > > > > [  166.332983]  kasan_report+0x247/0x285 [  166.332989]
> > > > > > > __cached_rbnode_delete_update+0x36/0x202
> > > > > > > [  166.332995]  private_free_iova+0x57/0x6d [  166.332999]
> > > > > > > __free_iova+0x23/0x31 [  166.333011]
> > > > > > > ipu3_dmamap_free+0x118/0x1d6 [ipu3_imgu]
> > > > > >
> > > > > > Thanks Laurent, I think this is a very good hint. It looks like
> > > > > > we're basically freeing and already freed IOVA and corrupting
> > > > > > some allocator state?
> > > > >
> > > > > Did you have any luck in reproducing and fixing this double free issue?
> > > > >
> > >
> > > This issue is either hard to reproduce or comes with different
> > > signatures with the updated yavta (that now supports meta output) with
> > > the 4.4 kernel that I have been using.
> > > I am switching to 4.20-rc6 for better reproducibility.
> > > Enabling KASAN also results in storage space issues on my Chrome device.
> > > Will enable this just for ImgU to get ahead and get back with more updates.
> > >
> >
> > Thanks for testing this.
> >
> > For your informations I'm using the following branch, from Sakari's
> > tree: git://linuxtv.org/sailus/media_tree.git ipu3
> >
> > Although it appears that the media tree master branch has everything that is
> > there, with a few additional patches on top. I should move to use media tree
> > master as well...
> >
> > I have here attached 2 configuration files for v4.20-rc5 I am using on Soraka, in
> > case they might help you. One has KASAN enabled with an increased kernel
> > log size, the other one is the one we use for daily development.
>
> I think I am missing a trick here to override the default chrome os kernel
> config with the one that you supplied.
>
> In particular I am looking for steps to build the upstream kernel within chrome os
> build environment using your config, so I can update my Soraka device.

I'm sorry I can not help much building 'withing chrome os build
environment'. Care to explain what you mean?

What I usually do, provided you're running a debian-based Linux distro
on your Soraka device, is compile the kernel on host with 'make bindeb-pkg'
and then upload and install the resulting .deb package on the
Soraka chromebook.

If that might work for you, we can share more details on how to do so
(tomorrow maybe :p )

Thanks
   j

>
> >
> > Also, please make sure to use (the most) recent media-ctl and yavta utilities, as
> > the ones provided by most distros are usually not recent enough to work with
> > IPU3, but I'm sure you know that already ;)
>
> Ack
>
> >
> > Thanks
> >   j
> >
>
> [snip]

--27ihjddkqb567ax6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlw2O2wACgkQcjQGjxah
Vjy00hAAsBod2gtxIg9pA5pSHSXmYYt+FL9fETyxugPdhDk164XrtK5lxwrH0krg
kf40HWIlSWJlHZdM2tNkMFWN9MfwC3kE0nrAxzK41c7NToe3ZF4xaxuYVfMX+h/v
+PF4JO0S1tJur1HsyiNvp0oKqpyzg3I1jqOvTIu5/HDrfa1Fd+BBwsvalkBLSKQ4
e2/iH6h3XRNtGta/wTKuNqBGm/QwPGh5ntbQpzvI6lthsXse3p2eSBBWvET+aJlj
gaVqtFabyM8ptzGxy+Ro+eTY9ZILgb2z/au4CNbukPv/SOP2gMHdI3B3UgDkiFqy
R6u2GIaw8kBNwS9GvU7BLStfEu6xLCpqkdXTHxpW2Y+jju/tlOQuhSgPtJ+BFzHq
nrQjhB/RkYwet7kFWRqVahWJaTVnNrYP+8G4KfBwMbGCVsi9sivmcuYt5f4zIHVo
KE1Pjl9R/axvYIDbGYOIsE8mmBi+5sXICGbQ/6okheRz9u9g5x7KDVaR4OUuX1OO
71ujqg+iKicKY0CbgITe8qja7qz3B7JzM7VYPykAk4aESCwi4M2w6EHf9bM3FSJN
Us/Hg62EKxkMFyWx7wNT8v1LIpnUocz2vZY8lAcvaY7Zjd0di2VuZ4k425zKf+Wf
Tqgi+nGNC31m0A8wVH7Gkb7wgF6yhiIyAQpVnVZBa4P1Ljt10gg=
=Gly1
-----END PGP SIGNATURE-----

--27ihjddkqb567ax6--
