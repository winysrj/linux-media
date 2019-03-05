Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC198C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 20:48:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD85D2075B
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 20:48:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfCEUst (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 15:48:49 -0500
Received: from mga04.intel.com ([192.55.52.120]:4296 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726296AbfCEUst (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Mar 2019 15:48:49 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2019 12:48:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,445,1544515200"; 
   d="scan'208";a="138321679"
Received: from schmiger-mobl3.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.249.45.12])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Mar 2019 12:48:47 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id A712F21E54; Tue,  5 Mar 2019 22:48:44 +0200 (EET)
Date:   Tue, 5 Mar 2019 22:48:44 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Benoit Parrot <bparrot@ti.com>
Cc:     linux-media@vger.kernel.org, akinobu.mita@gmail.com,
        robert.jarzmik@free.fr, hverkuil@xs4all.nl
Subject: Re: [PATCH v1.1 4/4] ti-vpe: Parse local endpoint for properties,
 not the remote one
Message-ID: <20190305204844.pkusug2b37oxw7fm@kekkonen.localdomain>
References: <20190305135602.24199-5-sakari.ailus@linux.intel.com>
 <20190305140224.25889-1-sakari.ailus@linux.intel.com>
 <20190305143409.yzmusyvuaab5ap4w@ti.com>
 <20190305163239.23qfa3o4utolln6f@kekkonen.localdomain>
 <20190305173842.fiwxqaujxlvybbty@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190305173842.fiwxqaujxlvybbty@ti.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Mar 05, 2019 at 11:38:42AM -0600, Benoit Parrot wrote:
> Sakari Ailus <sakari.ailus@linux.intel.com> wrote on Tue [2019-Mar-05 18:32:40 +0200]:
> > Hi Benoit,
> > 
> > On Tue, Mar 05, 2019 at 08:34:09AM -0600, Benoit Parrot wrote:
> > > Sakari,
> > > 
> > > Thank you for the patch.
> > > 
> > > Sakari Ailus <sakari.ailus@linux.intel.com> wrote on Tue [2019-Mar-05 16:02:24 +0200]:
> > > > ti-vpe driver parsed the remote endpoints for properties but ignored the
> > > > local ones. Fix this by parsing the local endpoint properties instead.
> > > 
> > > I am not sure I understand the logic here.  For CSI2 sensor as far as I
> > > understand the lane mapping (clock and data) is driven from the sensor
> > > side. The bridge driver (in this case CAL) needs to setup the receiver side
> > > based on what the sensor (aka remote endpoint) can provide.
> > > 
> > > I failed to see how this fixes things here.
> > > 
> > > Are you suggesting that sensor relevant properties be set (and effectively
> > > duplicated) on the bridge/receiver side?
> > 
> > Yes. The endpoint configuration in general is local to the device and
> > should not be accessed from other device drivers.
> > 
> > The lane mapping, for instance, is specific to a given device --- and may
> > differ even between for two connected endpoints. It's used to reorder the
> > PHY lanes (if the device supports that). Same goes for the clock lane.
> 
> I did not see omap3isp having lane reorder capability, but I guess it would
> be possible for instance, that a sensor uses clock lane 0 and data lane 1
> & 2 but the way it is wired on the board makes it that the receiver would see
> sensor lane 0 on device lane 2 and so on... Not sure why you would wire it
> up that way but who knows...

I presume the feature is there to ease PCB design.

> 
> > 
> > See e.g. arch/arm/boot/dts/omap3-n9.dts .

	     ^

There it is.

> > 
> > > 
> > > Some sensor can and do handle multiple data lanes configuration so the
> > > sensor driver also needs to use those properties at probe time, duplicating
> > > the lane data is just asking for a mismatch to happen, no?
> > 
> > It's a different configuration on the sensor side. We currently have no
> > checks in place to verify that the two would match. I haven't heard of this
> > would have really been a problem though.
> 
> I had just never thought about this cases, to me a single source of
> information is better than 2. But anyhow I guess I'll have to update all of
> my relevant dts files in the near future.

Do you have in-kernel dts files using this? I presume the driver should
then figure out whether the local endpoint has a configuration and if it
doesn't, then look it up from the remote one. Otherwise old dts binaries
will break. :-(

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
