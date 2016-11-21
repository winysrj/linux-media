Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37253
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753636AbcKUOIl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Nov 2016 09:08:41 -0500
Date: Mon, 21 Nov 2016 12:08:36 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] v4l: videodev2: Include linux/time.h for timeval
 and timespec structs
Message-ID: <20161121120836.638ea7c3@vento.lan>
In-Reply-To: <5832FBFC.6070004@linux.intel.com>
References: <1477565451-3621-1-git-send-email-sakari.ailus@linux.intel.com>
        <20161121113311.0ec196f7@vento.lan>
        <5832FBFC.6070004@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 21 Nov 2016 15:51:56 +0200
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> Hi Mauro,
> 
> On 11/21/16 15:33, Mauro Carvalho Chehab wrote:
> > Em Thu, 27 Oct 2016 13:50:51 +0300
> > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> >   
> >> struct timeval and struct timespec are defined in linux/time.h. Explicitly
> >> include the header if __KERNEL__ is defined.  
> > 
> > The patch below doesn't do what you're mentioned above. It unconditionally
> > include linux/time.h, and, for userspace, it will *also* include
> > sys/time.h...  
> 
> My bad... I thought writing a single line patch would be easy. ;-) Will fix.
> 
> > 
> > I suspect that this would cause problems on userspace.
> > 
> > Btw, you didn't mention on your description what's the bug you're
> > trying to fix.  
> 
> The problem is a compiler error due to lacking defition for a struct.
> I'll add that to v2.

On userspace or Kernelspace? Please be clear at version 2, adding the
relevant info about how you got it.


Thanks,
Mauro
