Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58624 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752808AbeD0M1I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Apr 2018 08:27:08 -0400
Date: Fri, 27 Apr 2018 15:27:06 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Yong Zhi <yong.zhi@intel.com>,
        linux-media@vger.kernel.org, jian.xu.zheng@intel.com,
        tfiga@chromium.org, rajmohan.mani@intel.com,
        tuukka.toivonen@intel.com, mchehab@s-opensource.com
Subject: Re: [PATCH 04/12] intel-ipu3: Add user space ABI definitions
Message-ID: <20180427122705.yq44kci54wgnjnls@valkosipuli.retiisi.org.uk>
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
 <1496695157-19926-5-git-send-email-yong.zhi@intel.com>
 <32e8b3e1-f5b2-5add-6060-928e2609b326@xs4all.nl>
 <20170607222259.GB21034@kekkonen.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170607222259.GB21034@kekkonen.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 08, 2017 at 01:22:59AM +0300, Sakari Ailus wrote:
> Hi Hans,
> 
> On Tue, Jun 06, 2017 at 10:28:26AM +0200, Hans Verkuil wrote:
> > On 05/06/17 22:39, Yong Zhi wrote:
> > 
> > Commit message missing.
> > 
> > > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > > ---
> > >  include/uapi/linux/intel-ipu3.h | 2182 +++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 2182 insertions(+)
> > >  create mode 100644 include/uapi/linux/intel-ipu3.h
> > > 
> > > diff --git a/include/uapi/linux/intel-ipu3.h b/include/uapi/linux/intel-ipu3.h
> > > new file mode 100644
> > > index 0000000..9e90aec
> > > --- /dev/null
> > > +++ b/include/uapi/linux/intel-ipu3.h
> > > @@ -0,0 +1,2182 @@
> > > +/*
> > > + * Copyright (c) 2017 Intel Corporation.
> > > + *
> > > + * This program is free software; you can redistribute it and/or
> > > + * modify it under the terms of the GNU General Public License version
> > > + * 2 as published by the Free Software Foundation.
> > > + *
> > > + * This program is distributed in the hope that it will be useful,
> > > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > + * GNU General Public License for more details.
> > > + */
> > > +
> > > +#ifndef __IPU3_UAPI_H
> > > +#define __IPU3_UAPI_H
> > > +
> > > +#include <linux/types.h>
> > > +
> > > +#define IPU3_UAPI_ISP_VEC_ELEMS				64
> > > +
> > > +#define IMGU_ABI_PAD	__aligned(IPU3_UAPI_ISP_WORD_BYTES)
> > > +#define IPU3_ALIGN	__attribute__((aligned(IPU3_UAPI_ISP_WORD_BYTES)))
> > > +
> > > +#define IPU3_UAPI_ISP_WORD_BYTES			32
> > > +#define IPU3_UAPI_MAX_STRIPES				2
> > > +
> > > +/******************* ipu3_uapi_stats_3a *******************/
> > > +
> > > +#define IPU3_UAPI_MAX_BUBBLE_SIZE			10
> > > +
> > > +#define IPU3_UAPI_AE_COLORS				4
> > > +#define IPU3_UAPI_AE_BINS				256
> > > +
> > > +#define IPU3_UAPI_AWB_MD_ITEM_SIZE			8
> > > +#define IPU3_UAPI_AWB_MAX_SETS				60
> > > +#define IPU3_UAPI_AWB_SET_SIZE				0x500
> > > +#define IPU3_UAPI_AWB_SPARE_FOR_BUBBLES \
> > > +		(IPU3_UAPI_MAX_BUBBLE_SIZE * IPU3_UAPI_MAX_STRIPES * \
> > > +		 IPU3_UAPI_AWB_MD_ITEM_SIZE)
> > > +#define IPU3_UAPI_AWB_MAX_BUFFER_SIZE \
> > > +		(IPU3_UAPI_AWB_MAX_SETS * \
> > > +		 (IPU3_UAPI_AWB_SET_SIZE + IPU3_UAPI_AWB_SPARE_FOR_BUBBLES))
> > > +
> > > +#define IPU3_UAPI_AF_MAX_SETS				24
> > > +#define IPU3_UAPI_AF_MD_ITEM_SIZE			4
> > > +#define IPU3_UAPI_AF_SPARE_FOR_BUBBLES \
> > > +		(IPU3_UAPI_MAX_BUBBLE_SIZE * IPU3_UAPI_MAX_STRIPES * \
> > > +		 IPU3_UAPI_AF_MD_ITEM_SIZE)
> > > +#define IPU3_UAPI_AF_Y_TABLE_SET_SIZE			0x80
> > > +#define IPU3_UAPI_AF_Y_TABLE_MAX_SIZE \
> > > +	(IPU3_UAPI_AF_MAX_SETS * \
> > > +	 (IPU3_UAPI_AF_Y_TABLE_SET_SIZE + IPU3_UAPI_AF_SPARE_FOR_BUBBLES) * \
> > > +	 IPU3_UAPI_MAX_STRIPES)
> > > +
> > > +#define IPU3_UAPI_AWB_FR_MAX_SETS			24
> > > +#define IPU3_UAPI_AWB_FR_MD_ITEM_SIZE			8
> > > +#define IPU3_UAPI_AWB_FR_BAYER_TBL_SIZE			0x100
> > > +#define IPU3_UAPI_AWB_FR_SPARE_FOR_BUBBLES \
> > > +		(IPU3_UAPI_MAX_BUBBLE_SIZE * IPU3_UAPI_MAX_STRIPES * \
> > > +		IPU3_UAPI_AWB_FR_MD_ITEM_SIZE)
> > > +#define IPU3_UAPI_AWB_FR_BAYER_TABLE_MAX_SIZE \
> > > +	(IPU3_UAPI_AWB_FR_MAX_SETS * \
> > > +	(IPU3_UAPI_AWB_FR_BAYER_TBL_SIZE + \
> > > +	 IPU3_UAPI_AWB_FR_SPARE_FOR_BUBBLES) * \
> > > +	IPU3_UAPI_MAX_STRIPES)
> > > +
> > > +struct ipu3_uapi_grid_config {
> > > +	__u8 width;				/* 6 or 7 (rgbs_grd_cfg) bits */
> > > +	__u8 height;
> > > +	__u16 block_width_log2:3;
> > > +	__u16 block_height_log2:3;
> > > +	__u16 height_per_slice:8;			/* default value 1 */
> > > +	__u16 x_start;					/* 12 bits */
> > > +	__u16 y_start;
> > > +#define IPU3_UAPI_GRID_START_MASK			((1 << 12) - 1)
> > > +#define IPU3_UAPI_GRID_Y_START_EN			(1 << 15)
> > > +	__u16 x_end;					/* 12 bits */
> > > +	__u16 y_end;
> > > +};
> > 
> > You can't use bitfields in a public API. It is up to the compiler to
> > decide how to place bitfields, so this is not a stable API.
> 
> We-ell --- it's ABI dependent, yes. The sheer number of structs with bit
> fields in the header will make using the definitions rather cumbersome if
> not unwieldy. Therefore it'd be very nice to continue using bit fields.
> 
> There are certainly caveats with bit fields but using them in the user
> space interface is certainly not unforeseen. Just grep under
> /usr/include/linux .
> 
> Endianness is a major factor here. That said, the Intel x86 / x86-64
> systems this driver works with are almost as certainly little endian as
> the world is round. It'd still be good to fail compilation if anyone
> attempts using the header in a big endian system.

Replying to myself:

<URL:https://github.com/hjl-tools/x86-psABI/wiki/x86-64-psABI-1.0.pdf>

Bit fields are described on pages 15 and 16. From what can I tell from
this, the endianness is a major factor here but other than that, it seems
to me that this is fixed in ABI. Even if you wouldn't be dealing with bit
fields and you'd have this device on a BE machine, I expect you'd need to
make changes: the firmware in the device is still little endian.

Cc Mauro, too.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
