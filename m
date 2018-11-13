Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:34201 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731259AbeKNCy4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 21:54:56 -0500
Date: Tue, 13 Nov 2018 17:55:58 +0100
From: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Subject: Re: [PATCH 0/5] media: Allwinner A10 CSI support
Message-ID: <20181113175558.3bfa3e8d@windsurf>
In-Reply-To: <cb504ffc-b74c-d6e3-7bde-6c5840c87997@cisco.com>
References: <cover.71b0f9855c251f9dc389ee77ee6f0e1fad91fb0b.1542097288.git-series.maxime.ripard@bootlin.com>
        <df54f2e6-e207-92de-767a-e356345a1a56@xs4all.nl>
        <20181113135259.onutfjtoi25afnfe@flea>
        <f07a0460-cdba-c1a5-acfd-66a39f447a5a@cisco.com>
        <20181113155227.62jjs3mpomwgr7xd@flea>
        <cb504ffc-b74c-d6e3-7bde-6c5840c87997@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tue, 13 Nov 2018 17:00:25 +0100, Hans Verkuil wrote:

> Weird, if I build directly from that tarball, then v4l2-compliance should say:
> 
> v4l2-compliance SHA: not available, 64 bits
> 
> So that's what I expect to see from buildroot as well.

Indeed, that's strange, I see that the v4l2-compliance Makefile does:

version.h:
        @if git -C $(srcdir) rev-parse HEAD >/dev/null 2>&1; then \
                echo -n "#define SHA " >$@ ; \
                git -C $(srcdir) rev-parse HEAD >>$@ ; \
        else \
                touch $@ ; \
        fi

which correctly uses $(srcdir), so it shouldn't go "up" the libv4l
build folder and pick up the latest Buildroot commit SHA1. I'll have a
quick look.

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
