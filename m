Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C143C43381
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 15:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B46F20652
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 15:55:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbfCGPz0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 10:55:26 -0500
Received: from mga01.intel.com ([192.55.52.88]:27082 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbfCGPz0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Mar 2019 10:55:26 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Mar 2019 07:55:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,451,1544515200"; 
   d="scan'208";a="152932135"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga001.fm.intel.com with ESMTP; 07 Mar 2019 07:55:24 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 5F243204CC; Thu,  7 Mar 2019 17:55:23 +0200 (EET)
Date:   Thu, 7 Mar 2019 17:55:23 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Benoit Parrot <bparrot@ti.com>
Cc:     linux-media@vger.kernel.org, akinobu.mita@gmail.com,
        robert.jarzmik@free.fr, hverkuil@xs4all.nl
Subject: Re: [PATCH v1.1 4/4] ti-vpe: Parse local endpoint for properties,
 not the remote one
Message-ID: <20190307155523.nmimw4c3rbqvmdeu@paasikivi.fi.intel.com>
References: <20190305135602.24199-5-sakari.ailus@linux.intel.com>
 <20190305140224.25889-1-sakari.ailus@linux.intel.com>
 <20190305143409.yzmusyvuaab5ap4w@ti.com>
 <20190305163239.23qfa3o4utolln6f@kekkonen.localdomain>
 <20190305173842.fiwxqaujxlvybbty@ti.com>
 <20190305204844.pkusug2b37oxw7fm@kekkonen.localdomain>
 <20190307153412.fdva7pvjxtv2p2b4@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190307153412.fdva7pvjxtv2p2b4@ti.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Mar 07, 2019 at 09:34:12AM -0600, Benoit Parrot wrote:
> Sakari Ailus <sakari.ailus@linux.intel.com> wrote on Tue [2019-Mar-05 22:48:44 +0200]:
> > On Tue, Mar 05, 2019 at 11:38:42AM -0600, Benoit Parrot wrote:
> > > Sakari Ailus <sakari.ailus@linux.intel.com> wrote on Tue [2019-Mar-05 18:32:40 +0200]:
> > > > Hi Benoit,
> > > > 
> > > > On Tue, Mar 05, 2019 at 08:34:09AM -0600, Benoit Parrot wrote:
> > > > > Sakari,
> > > > > 
> > > > > Thank you for the patch.
> > > > > 
> > > > > Sakari Ailus <sakari.ailus@linux.intel.com> wrote on Tue [2019-Mar-05 16:02:24 +0200]:
> > > > > > ti-vpe driver parsed the remote endpoints for properties but ignored the
> > > > > > local ones. Fix this by parsing the local endpoint properties instead.
> > > > > 
> > > > > I am not sure I understand the logic here.  For CSI2 sensor as far as I
> > > > > understand the lane mapping (clock and data) is driven from the sensor
> > > > > side. The bridge driver (in this case CAL) needs to setup the receiver side
> > > > > based on what the sensor (aka remote endpoint) can provide.
> > > > > 
> > > > > I failed to see how this fixes things here.
> > > > > 
> > > > > Are you suggesting that sensor relevant properties be set (and effectively
> > > > > duplicated) on the bridge/receiver side?
> > > > 
> > > > Yes. The endpoint configuration in general is local to the device and
> > > > should not be accessed from other device drivers.
> > > > 
> > > > The lane mapping, for instance, is specific to a given device --- and may
> > > > differ even between for two connected endpoints. It's used to reorder the
> > > > PHY lanes (if the device supports that). Same goes for the clock lane.
> > > 
> > > I did not see omap3isp having lane reorder capability, but I guess it would
> > > be possible for instance, that a sensor uses clock lane 0 and data lane 1
> > > & 2 but the way it is wired on the board makes it that the receiver would see
> > > sensor lane 0 on device lane 2 and so on... Not sure why you would wire it
> > > up that way but who knows...
> > 
> > I presume the feature is there to ease PCB design.
> > 
> > > 
> > > > 
> > > > See e.g. arch/arm/boot/dts/omap3-n9.dts .
> > 
> > 	     ^
> > 
> > There it is.
> 
> Yes I saw that the sensor describes its clock-lanes as 0 and data-lanes as
> 1 & 2. And that the OMAP3ISP receiver describes its clock-lanes as 2 and
> data-lanes as 1 & 3.
> 
> But when I looked at the driver code itself it just uses those lane config
> without doing anything else, so to me that just point to the way it's wired up
> on the board, nothing more. (although I have not looked into any schematics
> so I am just guessing here)

It is wired on the board... and that's the point here indeed. The register
configured based on this is ISPCSI2_PHY_CFG (driver name, I don't know what
the datasheet uses).

> 
> > 
> > > > 
> > > > > 
> > > > > Some sensor can and do handle multiple data lanes configuration so the
> > > > > sensor driver also needs to use those properties at probe time, duplicating
> > > > > the lane data is just asking for a mismatch to happen, no?
> > > > 
> > > > It's a different configuration on the sensor side. We currently have no
> > > > checks in place to verify that the two would match. I haven't heard of this
> > > > would have really been a problem though.
> > > 
> > > I had just never thought about this cases, to me a single source of
> > > information is better than 2. But anyhow I guess I'll have to update all of
> > > my relevant dts files in the near future.
> > 
> > Do you have in-kernel dts files using this? I presume the driver should
> > then figure out whether the local endpoint has a configuration and if it
> > doesn't, then look it up from the remote one. Otherwise old dts binaries
> > will break. :-(
> 
> No I do not currently have any dts in mainline using this feature as of
> yet. It is used in several DT file in our own kernel tree so I'll have to
> update those for sure. But between our major releases we do not guarantee
> DTBs backward compatibility, so depending on when I merge this we may not
> need to add backward compat code.
> 
> I guess you are free to augment the patch to add backward support since this
> patch is changing the current DT parsing behavior for this driver.
> 
> I do have a backlog of patches for this driver I need to up-stream.
> If you prefer you can drop this patch from the series then I can include a
> version of it with my set. Up to you.

I have an upcoming patch that changes the code again. :-) So I'll keep it
in my set.

Btw. I checked Documentation/devicetree/bindings/media/ti-cal.txt and it
seems a bit incomplete. There is no endpoint configuration on CAL side
(which is understandable now), but there's also the "slave-mode" property
which looks just inapplicable for this type or hardware.

Also "reg = <0>" can be omitted on ar0330 side. Is this btw. an Aptina
image sensor or some lesser known TI chip with somewhat similar properties?
:-) The binding file should describe relevant properties for the device as
well as the valid values for them. (Excluding graph etc. documentation
which already exists elsewhere.)

Would you like to address these? :-)

Thanks.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
