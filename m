Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:15392 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1423659AbeBOQzR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Feb 2018 11:55:17 -0500
From: "Zhi, Yong" <yong.zhi@intel.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>
Subject: RE: [PATCH] media: intel-ipu3: cio2: Use SPDX license headers
Date: Thu, 15 Feb 2018 16:55:15 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D1AEE67F4@ORSMSX106.amr.corp.intel.com>
References: <1517890793-9360-1-git-send-email-yong.zhi@intel.com>
 <20180207223605.jhun55osbpxmnzpz@kekkonen.localdomain>
In-Reply-To: <20180207223605.jhun55osbpxmnzpz@kekkonen.localdomain>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Sakari,

Sorry for the late response, somehow, I missed this email in my Inbox.

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Sakari Ailus
> Sent: Wednesday, February 7, 2018 2:36 PM
> To: Zhi, Yong <yong.zhi@intel.com>
> Cc: linux-media@vger.kernel.org; Zheng, Jian Xu <jian.xu.zheng@intel.com>;
> Mani, Rajmohan <rajmohan.mani@intel.com>
> Subject: Re: [PATCH] media: intel-ipu3: cio2: Use SPDX license headers
> 
> Hi Yong,
> 
> Thanks for the patch.
> 
> On Mon, Feb 05, 2018 at 08:19:53PM -0800, Yong Zhi wrote:
> > Adopt SPDX license headers and update year to 2018.
> >
> > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > ---
> >  drivers/media/pci/intel/ipu3/ipu3-cio2.c | 12 ++----------
> > drivers/media/pci/intel/ipu3/ipu3-cio2.h | 14 ++------------
> >  2 files changed, 4 insertions(+), 22 deletions(-)
> >
> > diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> > b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> > index 6c4444b..725973f 100644
> > --- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> > +++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> > @@ -1,14 +1,6 @@
> > +// SPDX-License-Identifier: GPL-2.0
> >  /*
> > - * Copyright (c) 2017 Intel Corporation.
> > - *
> > - * This program is free software; you can redistribute it and/or
> > - * modify it under the terms of the GNU General Public License
> > version
> > - * 2 as published by the Free Software Foundation.
> > - *
> > - * This program is distributed in the hope that it will be useful,
> > - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > - * GNU General Public License for more details.
> > + * Copyright (C) 2018 Intel Corporation
> >   *
> >   * Based partially on Intel IPU4 driver written by
> >   *  Sakari Ailus <sakari.ailus@linux.intel.com> diff --git
> > a/drivers/media/pci/intel/ipu3/ipu3-cio2.h
> > b/drivers/media/pci/intel/ipu3/ipu3-cio2.h
> > index 78a5799..6a11051 100644
> > --- a/drivers/media/pci/intel/ipu3/ipu3-cio2.h
> > +++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.h
> > @@ -1,15 +1,5 @@
> > -/*
> > - * Copyright (c) 2017 Intel Corporation.
> > - *
> > - * This program is free software; you can redistribute it and/or
> > - * modify it under the terms of the GNU General Public License
> > version
> > - * 2 as published by the Free Software Foundation.
> > - *
> > - * This program is distributed in the hope that it will be useful,
> > - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > - * GNU General Public License for more details.
> > - */
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/* Copyright (C) 2018 Intel Corporation */
> 
> Should this be:
> 
> /* Copyright (C) 2017 -- 2018 Intel Corporation */
> 
> ?
> 
> Same for the one above.
> 

Sure, will send an update. Thanks!!

> >
> >  #ifndef __IPU3_CIO2_H
> >  #define __IPU3_CIO2_H
> > --
> > 1.9.1
> >
> 
> --
> Sakari Ailus
> sakari.ailus@linux.intel.com
