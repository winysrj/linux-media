Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86AC1C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 17:42:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 463FD20842
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 17:42:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="AQuMCFZf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbfCERmY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 12:42:24 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:40366 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728108AbfCERmY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 12:42:24 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id x25HgI2F118223;
        Tue, 5 Mar 2019 11:42:18 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1551807738;
        bh=rUMhExXIQ4qZN0kalC3Px4UzrPG1vQhkDhB7AOcPnpQ=;
        h=Date:From:To:CC:Subject:References:In-Reply-To;
        b=AQuMCFZfFZ9Nbw0x56Xs/lGn4OfQlYB4uDxXOzfBmjQCnD57YRhynQAY4kTj2modJ
         pNFtKvpkC2c/5L0/4N/PqjLPKneOB7UI7GljV3D4P3WHCwLHPdyxpd2yjilaAAezh2
         xYEdHrJ05CNY7srD5wR5aY96IrlR+ymhEfk/BpZk=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x25HgIIG031811
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 5 Mar 2019 11:42:18 -0600
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Tue, 5
 Mar 2019 11:42:17 -0600
Received: from dflp33.itg.ti.com (10.64.6.16) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_0,
 cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.1.1591.10 via Frontend Transport;
 Tue, 5 Mar 2019 11:42:17 -0600
Received: from ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by dflp33.itg.ti.com (8.14.3/8.13.8) with SMTP id x25HgH06025483;
        Tue, 5 Mar 2019 11:42:17 -0600
Date:   Tue, 5 Mar 2019 11:38:42 -0600
From:   Benoit Parrot <bparrot@ti.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
CC:     <linux-media@vger.kernel.org>, <akinobu.mita@gmail.com>,
        <robert.jarzmik@free.fr>, <hverkuil@xs4all.nl>
Subject: Re: [PATCH v1.1 4/4] ti-vpe: Parse local endpoint for properties,
 not the remote one
Message-ID: <20190305173842.fiwxqaujxlvybbty@ti.com>
References: <20190305135602.24199-5-sakari.ailus@linux.intel.com>
 <20190305140224.25889-1-sakari.ailus@linux.intel.com>
 <20190305143409.yzmusyvuaab5ap4w@ti.com>
 <20190305163239.23qfa3o4utolln6f@kekkonen.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190305163239.23qfa3o4utolln6f@kekkonen.localdomain>
User-Agent: NeoMutt/20171215
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Sakari Ailus <sakari.ailus@linux.intel.com> wrote on Tue [2019-Mar-05 18:32:40 +0200]:
> Hi Benoit,
> 
> On Tue, Mar 05, 2019 at 08:34:09AM -0600, Benoit Parrot wrote:
> > Sakari,
> > 
> > Thank you for the patch.
> > 
> > Sakari Ailus <sakari.ailus@linux.intel.com> wrote on Tue [2019-Mar-05 16:02:24 +0200]:
> > > ti-vpe driver parsed the remote endpoints for properties but ignored the
> > > local ones. Fix this by parsing the local endpoint properties instead.
> > 
> > I am not sure I understand the logic here.  For CSI2 sensor as far as I
> > understand the lane mapping (clock and data) is driven from the sensor
> > side. The bridge driver (in this case CAL) needs to setup the receiver side
> > based on what the sensor (aka remote endpoint) can provide.
> > 
> > I failed to see how this fixes things here.
> > 
> > Are you suggesting that sensor relevant properties be set (and effectively
> > duplicated) on the bridge/receiver side?
> 
> Yes. The endpoint configuration in general is local to the device and
> should not be accessed from other device drivers.
> 
> The lane mapping, for instance, is specific to a given device --- and may
> differ even between for two connected endpoints. It's used to reorder the
> PHY lanes (if the device supports that). Same goes for the clock lane.

I did not see omap3isp having lane reorder capability, but I guess it would
be possible for instance, that a sensor uses clock lane 0 and data lane 1
& 2 but the way it is wired on the board makes it that the receiver would see
sensor lane 0 on device lane 2 and so on... Not sure why you would wire it
up that way but who knows...

> 
> See e.g. arch/arm/boot/dts/omap3-n9.dts .
> 
> > 
> > Some sensor can and do handle multiple data lanes configuration so the
> > sensor driver also needs to use those properties at probe time, duplicating
> > the lane data is just asking for a mismatch to happen, no?
> 
> It's a different configuration on the sensor side. We currently have no
> checks in place to verify that the two would match. I haven't heard of this
> would have really been a problem though.

I had just never thought about this cases, to me a single source of
information is better than 2. But anyhow I guess I'll have to update all of
my relevant dts files in the near future.

Benoit

> 
> The frame descriptors should be used for runtime configuration. Niklas and
> more recently Jacopo have been working on that.
> 
> -- 
> Kind regards,
> 
> Sakari Ailus
> sakari.ailus@linux.intel.com
