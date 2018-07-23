Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:57265 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387981AbeGWS1V (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 14:27:21 -0400
Date: Mon, 23 Jul 2018 20:24:58 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 16/17] media: v4l2: async: Remove notifier subdevs
 array
Message-ID: <20180723172458.iejfac4pamev25sw@paasikivi.fi.intel.com>
References: <1531175957-1973-1-git-send-email-steve_longerbeam@mentor.com>
 <1531175957-1973-17-git-send-email-steve_longerbeam@mentor.com>
 <20180723123557.bfxxsqqhlaj3ccwc@valkosipuli.retiisi.org.uk>
 <a040c77f-2bee-5d0d-57ec-852ff30448e9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a040c77f-2bee-5d0d-57ec-852ff30448e9@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 23, 2018 at 09:44:57AM -0700, Steve Longerbeam wrote:
> 
> 
> On 07/23/2018 05:35 AM, Sakari Ailus wrote:
> > Hi Steve,
> > 
> > Thanks for the update.
> > 
> > On Mon, Jul 09, 2018 at 03:39:16PM -0700, Steve Longerbeam wrote:
> > > All platform drivers have been converted to use
> > > v4l2_async_notifier_add_subdev(), in place of adding
> > > asd's to the notifier subdevs array. So the subdevs
> > > array can now be removed from struct v4l2_async_notifier,
> > > and remove the backward compatibility support for that
> > > array in v4l2-async.c.
> > > 
> > > Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> > This set removes the subdevs and num_subdevs fieldsfrom the notifier (as
> > discussed previously) but it doesn't include the corresponding
> > driver changes. Is there a patch missing from the set?
> 
> Hi Sakari, yes somehow patch 15/17 (the large patch to all drivers)
> got dropped by the ML, maybe because the cc-list was too big?
> 
> I will resend with only linux-media and cc: you.

I noticed the patch in my inbox and I re-pushed my v4l2-fwnode branch,
including that patch. Please still resend to the list. Thanks.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
