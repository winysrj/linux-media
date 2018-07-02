Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41124 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752183AbeGBHtx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jul 2018 03:49:53 -0400
Date: Mon, 2 Jul 2018 10:49:51 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Yong Zhi <yong.zhi@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        niklas.soderlund@ragnatech.se, Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v3 03/13] media: v4l2: async: Add
 v4l2_async_notifier_add_subdev
Message-ID: <20180702074951.4dxk2xumikbkgdq7@valkosipuli.retiisi.org.uk>
References: <1521592649-7264-1-git-send-email-steve_longerbeam@mentor.com>
 <1521592649-7264-4-git-send-email-steve_longerbeam@mentor.com>
 <20180420122450.j3wkyoardgpyzbh2@paasikivi.fi.intel.com>
 <854dab64-caf7-be8e-e5b6-10ff78aa811a@gmail.com>
 <20180508101235.wctorewkzt3jgxnh@kekkonen.localdomain>
 <90f52736-1a4d-f409-c553-d59901e413fa@gmail.com>
 <20180626071229.syph6yzwjzkbmht6@kekkonen.localdomain>
 <34b9ef01-5519-8d71-ebf4-e001cf09eb99@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <34b9ef01-5519-8d71-ebf4-e001cf09eb99@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 26, 2018 at 01:47:45PM -0700, Steve Longerbeam wrote:
> 
> 
> On 06/26/2018 12:12 AM, Sakari Ailus wrote:
> > On Wed, May 09, 2018 at 04:06:32PM -0700, Steve Longerbeam wrote:
> > > 
> > > On 05/08/2018 03:12 AM, Sakari Ailus wrote:
> > > > On Fri, Apr 20, 2018 at 10:12:33AM -0700, Steve Longerbeam wrote:
> > > > > Hi Sakari,
> > > > > 
> > > > > 
> > > > > On 04/20/2018 05:24 AM, Sakari Ailus wrote:
> > > > > > Hi Steve,
> > > > > > 
> > > > > > Thanks for the patchset.
> > > > > > 
> > > > > > On Tue, Mar 20, 2018 at 05:37:19PM -0700, Steve Longerbeam wrote:
> > > > > > > v4l2_async_notifier_add_subdev() adds an asd to the notifier. It checks
> > > > > > > that the asd's match_type is valid and that no other equivalent asd's
> > > > > > > have already been added to this notifier's asd list, or to other
> > > > > > > registered notifier's waiting or done lists, and increments num_subdevs.
> > > > > > > 
> > > > > > > v4l2_async_notifier_add_subdev() does not make use of the notifier subdevs
> > > > > > > array, otherwise it would have to re-allocate the array every time the
> > > > > > > function was called. In place of the subdevs array, the function adds
> > > > > > > the asd to a new master asd_list. The function will return error with a
> > > > > > > WARN() if it is ever called with the subdevs array allocated.
> > > > > > > 
> > > > > > > In v4l2_async_notifier_has_async_subdev(), __v4l2_async_notifier_register(),
> > > > > > > and v4l2_async_notifier_cleanup(), alternatively operate on the subdevs
> > > > > > > array or a non-empty notifier->asd_list.
> > > > > > I do agree with the approach, but this patch leaves the remaining users of
> > > > > > the subdevs array in the notifier intact. Could you rework them to use the
> > > > > > v4l2_async_notifier_add_subdev() as well?
> > > > > > 
> > > > > > There seem to be just a few of them --- exynos4-is and rcar_drif.
> > > > > I count more than a few :)
> > > > > 
> > > > > % cd drivers/media && grep -l -r --include "*.[ch]"
> > > > > 'notifier[\.\-]>*subdevs[   ]*='
> > > > > v4l2-core/v4l2-async.c
> > > > > platform/pxa_camera.c
> > > > > platform/ti-vpe/cal.c
> > > > > platform/exynos4-is/media-dev.c
> > > > > platform/qcom/camss-8x16/camss.c
> > > > > platform/soc_camera/soc_camera.c
> > > > > platform/atmel/atmel-isi.c
> > > > > platform/atmel/atmel-isc.c
> > > > > platform/stm32/stm32-dcmi.c
> > > > > platform/davinci/vpif_capture.c
> > > > > platform/davinci/vpif_display.c
> > > > > platform/renesas-ceu.c
> > > > > platform/am437x/am437x-vpfe.c
> > > > > platform/xilinx/xilinx-vipp.c
> > > > > platform/rcar_drif.c
> > > > > 
> > > > > 
> > > > > So not including v4l2-core, the list is:
> > > > > 
> > > > > pxa_camera
> > > > > ti-vpe
> > > > > exynos4-is
> > > > > qcom
> > > > > soc_camera
> > > > > atmel
> > > > > stm32
> > > > > davinci
> > > > > renesas-ceu
> > > > > am437x
> > > > > xilinx
> > > > > rcar_drif
> > > > > 
> > > > > 
> > > > > Given such a large list of the users of the notifier->subdevs array,
> > > > > I think this should be done is two steps: submit this patchset first,
> > > > > that keeps the backward compatibility, and then a subsequent patchset
> > > > > that converts all drivers to use v4l2_async_notifier_add_subdev(), at
> > > > > which point the subdevs array can be removed from struct
> > > > > v4l2_async_notifier.
> > > > > 
> > > > > Or, do you still think this should be done all at once? I could add a
> > > > > large patch to this patchset that does the conversion and removes
> > > > > the subdevs array.
> > > > Sorry for the delay. I grepped for this, too, but I guess I ended up using
> > > > an expression that missed most of the users. :-(
> > > > 
> > > > I think it'd be very good to perform that conversion --- the code in the
> > > > framework would be quite a bit cleaner and easier to maintain whereas the
> > > > per-driver conversions seem pretty simple, such as this on in
> > > > drivers/media/platform/atmel/atmel-isi.c :
> > > > 
> > > > 	/* Register the subdevices notifier. */
> > > > 	subdevs = devm_kzalloc(isi->dev, sizeof(*subdevs), GFP_KERNEL);
> > > > 	if (!subdevs) {
> > > > 	        of_node_put(isi->entity.node);
> > > > 		return -ENOMEM;
> > > > 	}
> > > > 
> > > > 	subdevs[0] = &isi->entity.asd;
> > > > 
> > > > 	isi->notifier.subdevs = subdevs;
> > > > 	isi->notifier.num_subdevs = 1;
> > > > 	isi->notifier.ops = &isi_graph_notify_ops;
> > > 
> > > Yes, the conversions are fairly straightforward. I've completed that work,
> > > but it was a very manual conversion, every platform is different and needed
> > > careful study.
> > > 
> > > Although I was careful about getting the error-out paths correct, there
> > > could
> > > be mistakes there, which would result in memory leaks. And obviously I can't
> > > re-test all these platforms. So this patch is very high-risk. More eyes are
> > > needed on it, ideally the maintainer(s) of each affected platform.
> > > 
> > > I just submitted v4 of this series, but did not include this large un-tested
> > > patch in v4 for those reasons.
> > > 
> > > Instead, this patch, and follow-up patches that strips support for subdevs
> > > array altogether from v4l2-async.c, and updates rst docs, are available at
> > > my
> > > media-tree mirror on github:
> > > 
> > > git@github.com:slongerbeam/mediatree.git
> > > 
> > > in the branch 'remove-subdevs-array'. The branch is based off this series
> > > (branch 'imx-subdev-notifiers.6').
> > Would you be able to post these to the list? I'd really like this being
> > done as part of the related patchset, rather than leaving the mess in the
> > framework.
> 
> Backward compatibility can look messy.
> 
> I can include the patch that converts all platforms at once. But as I
> said it is completely untested.
> 
> So I'm curious, what is the policy in V4L2 community regarding
> merging untested patches? Do we go ahead and merge and then
> fixup errors as they are discovered, or should the patch get basic
> validation by everyone who has access to the affected hardware
> first?

Good question. You can't always have all the hardware of the drivers you
end up having to change. We've had quite a few such changes to the
frameworks; the patches are still reviewed and hopefully the maintainer of
the relevant driver reviews and tests the patches. Not everything has been
always tested though. Still, I don't remember any of such (mostly trivial)
framework-wide changes having been a noteworty source of bugs.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
