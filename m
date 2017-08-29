Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:57622 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753825AbdH2NUp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 09:20:45 -0400
Date: Tue, 29 Aug 2017 16:20:10 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 1/5] v4l: fwnode: Move KernelDoc documentation to the
 header
Message-ID: <20170829132010.nfofeofidvpipw4h@paasikivi.fi.intel.com>
References: <20170829110313.19538-1-sakari.ailus@linux.intel.com>
 <20170829110313.19538-2-sakari.ailus@linux.intel.com>
 <2676284.rKR023OhTM@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2676284.rKR023OhTM@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Aug 29, 2017 at 04:15:22PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Tuesday, 29 August 2017 14:03:09 EEST Sakari Ailus wrote:
> > In V4L2 the practice is to have the KernelDoc documentation in the header
> > and not in .c source code files. This consequientally makes the V4L2
> > fwnode function documentation part of the Media documentation build.
> > 
> > Also correct the link related function and argument naming in
> > documentation.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> I prefer documenting functions in the C file. Documentation in header files 
> will get out-of-sync with the implementation much more easily.

The fact is that there's very little KernelDoc documentation left in the .c
files in V4L2. This actually appears to be the only exception. And it seems
to have been in the Sphinx build; I missed that earlier, so that part of
the commit message doesn't apply.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
