Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36732 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751061AbdEHVdT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 May 2017 17:33:19 -0400
Date: Tue, 9 May 2017 00:32:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, jian.xu.zheng@intel.com,
        rajmohan.mani@intel.com, hyungwoo.yang@intel.com
Subject: Re: [PATCH 3/3] [media] intel-ipu3: cio2: Add new MIPI-CSI2 driver
Message-ID: <20170508213246.GN7456@valkosipuli.retiisi.org.uk>
References: <cover.1493479141.git.yong.zhi@intel.com>
 <9cf19d01f6f85ac0e5969a2b2fcd5ad5ef8c1e22.1493479141.git.yong.zhi@intel.com>
 <a33ac20c-5a72-3e6e-c55c-78bdb46449a5@xs4all.nl>
 <20170508121003.GJ7456@valkosipuli.retiisi.org.uk>
 <8dbaa458-6476-ac3b-daf3-785b0f591a69@xs4all.nl>
 <20170508125620.GK7456@valkosipuli.retiisi.org.uk>
 <1b0cde5d-37a9-2274-43a2-c242e2b944f5@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b0cde5d-37a9-2274-43a2-c242e2b944f5@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, May 08, 2017 at 03:08:26PM +0200, Hans Verkuil wrote:
> On 05/08/2017 02:56 PM, Sakari Ailus wrote:
...
> >> The USERPTR mode is more dubious. Has this been tested? Can the DMA handle partially
> >> filled pages? (I.e. there must be no requirements such as that the DMA has to start
> >> at a page boundary, since that's not the case with USERPTR).
> > 
> > I rememeber this has been discussed before. :-)
> > 
> > Most hardware has some limitations on the granularity of the buffer start
> > address, and the drivers still support USERPTR memory. In practice the C
> > library allocated memory is always page aligned if the size is large enough,
> > which is in practice the case for video buffers.
> 
> That was not true the last time I checked. I can't remember what the exact
> alignment was, although I do remember that it was different for 32 and 64 bit.

Hmm. This just shows how little I really know about user space. :-I

I just tested this to see how it really works out, and there doesn't seem to
be much alignment at all. I believe my earlier recollection was likely
related to a non-GNU C library (huh!).

> 
> I am also pretty sure it was less than 64 bytes. It's been 2 years ago since
> I last looked at this, though.

As in here:

00:26:02 lanttu sailus [~]cat /tmp/foo.c
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

void main() {
	unsigned int i;

	for (i=0; i < 16; i++)
		printf("%x\n",malloc(1024*768*i));
}
00:26:03 lanttu sailus [~]gcc -o /tmp/foo /tmp/foo.c
00:26:06 lanttu sailus [~]/tmp/foo
8604008
f7525008
f73a4008
f7163008
f6e62008
f6aa1008
f6620008
f60df008
f5ade008
f541d008
f4c9c008
f445b008
f3b5a008
f3199008
f2718008
f1bd7008

So posix_memalign() (or memalign()) is needed to allocate page aligned
memory. At least on GNU libc.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
