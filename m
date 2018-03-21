Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:36604 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751319AbeCURGg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Mar 2018 13:06:36 -0400
Date: Wed, 21 Mar 2018 19:06:30 +0200
From: "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>
To: "Yeh, Andy" <andy.yeh@intel.com>
Cc: jacopo mondi <jacopo@jmondi.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Chiang, AlanX" <alanx.chiang@intel.com>
Subject: Re: RESEND[PATCH v6 2/2] media: dw9807: Add dw9807 vcm driver
Message-ID: <20180321170629.biuwxykqsgvltull@kekkonen.localdomain>
References: <1521219926-15329-1-git-send-email-andy.yeh@intel.com>
 <1521219926-15329-3-git-send-email-andy.yeh@intel.com>
 <20180320102817.GB5372@w540>
 <8E0971CCB6EA9D41AF58191A2D3978B61D552FBD@PGSMSX111.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8E0971CCB6EA9D41AF58191A2D3978B61D552FBD@PGSMSX111.gar.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Wed, Mar 21, 2018 at 03:58:42PM +0000, Yeh, Andy wrote:
> Thanks for the comments. A quick question first. For the reset we need some time to address.
> 
> -----Original Message-----
> From: jacopo mondi [mailto:jacopo@jmondi.org]
> Sent: Tuesday, March 20, 2018 6:28 PM
> To: Yeh, Andy <andy.yeh@intel.com>
> Cc: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com; devicetree@vger.kernel.org; Chiang, AlanX <alanx.chiang@intel.com>
> Subject: Re: RESEND[PATCH v6 2/2] media: dw9807: Add dw9807 vcm driver
> 
> Hi Andy,
>    a few comments on you patch below...
> 
> On Sat, Mar 17, 2018 at 01:05:26AM +0800, Andy Yeh wrote:
> > From: Alan Chiang <alanx.chiang@intel.com> 
> > a/drivers/media/i2c/dw9807.c b/drivers/media/i2c/dw9807.c new file 
> > mode 100644 index 0000000..95626e9
> > --- /dev/null
> > +++ b/drivers/media/i2c/dw9807.c
> > @@ -0,0 +1,320 @@
> > +// Copyright (C) 2018 Intel Corporation // SPDX-License-Identifier: 
> > +GPL-2.0
> > +
> 
> Nit: my understanding is that the SPDX identifier goes first
> 
> https://lwn.net/Articles/739183/
> 
> I checked this site. And it says Copyright should be before SPDX identifier.
> ========== file01.c ==========
> // Copyright (c) 2012-2016 Joe Random Hacker // SPDX-License-Identifier: BSD-2-Clause ...
> ========== file02.c ==========
> // Copyright (c) 2017 Jon Severinsson
> // SPDX-License-Identifier: BSD-2-Clause ...
> ========== file03.c ==========
> // Copyright (c) 2008 The NetBSD Foundation, Inc.
> // SPDX-License-Identifier: BSD-2-Clause-NetBSD

This is an example which is AFAIU purported to show the problem with
various BSD licenses in a comment from someone. The order of the copyright
holder and license lines might be just random. The practice in kernel at
least appears to be SPDX license first.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
