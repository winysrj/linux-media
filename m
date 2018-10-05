Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:58022 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727735AbeJEReE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 13:34:04 -0400
Date: Fri, 5 Oct 2018 13:35:40 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH v2 1/3] media: v4l2-core: cleanup coding style at V4L2
 async/fwnode
Message-ID: <20181005103540.c4fhr47gvzqjwlyc@paasikivi.fi.intel.com>
References: <cover.1538735151.git.mchehab+samsung@kernel.org>
 <71ca73888758656e7c19dd683a0a9840facce371.1538735151.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71ca73888758656e7c19dd683a0a9840facce371.1538735151.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Fri, Oct 05, 2018 at 06:29:36AM -0400, Mauro Carvalho Chehab wrote:
> There are several coding style issues at those definitions,
> and the previous patchset added even more.
> 
> Address the trivial ones by first calling:
> 
> 	./scripts/checkpatch.pl --strict --fix-inline include/media/v4l2-async.h include/media/v4l2-fwnode.h include/media/v4l2-mediabus.h drivers/media/v4l2-core/v4l2-async.c drivers/media/v4l2-core/v4l2-fwnode.c
> 
> and then manually adjusting the style where needed.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

For patches 1 and 2:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
