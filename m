Return-Path: <SRS0=dTbi=OK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC456C04EB9
	for <linux-media@archiver.kernel.org>; Sat,  1 Dec 2018 20:57:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 815C32146D
	for <linux-media@archiver.kernel.org>; Sat,  1 Dec 2018 20:57:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 815C32146D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725767AbeLBIKs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 2 Dec 2018 03:10:48 -0500
Received: from mga07.intel.com ([134.134.136.100]:56013 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725726AbeLBIKs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 2 Dec 2018 03:10:48 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Dec 2018 12:57:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,303,1539673200"; 
   d="scan'208";a="120892630"
Received: from uwah-mobl.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.249.44.18])
  by fmsmga004.fm.intel.com with ESMTP; 01 Dec 2018 12:57:21 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id 27C1721DBC; Sat,  1 Dec 2018 22:57:19 +0200 (EET)
Date:   Sat, 1 Dec 2018 22:57:18 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     "Zhi, Yong" <yong.zhi@intel.com>
Cc:     "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "laurent.pinchart@ideasonboard.com" 
        <laurent.pinchart@ideasonboard.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>,
        "Li, Chao C" <chao.c.li@intel.com>
Subject: Re: [PATCH v7 03/16] v4l: Add Intel IPU3 meta data uAPI
Message-ID: <20181201205717.2q3u6qf576zhmynj@kekkonen.localdomain>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <1540851790-1777-4-git-send-email-yong.zhi@intel.com>
 <20181102130237.yotr2y7ddrrzqphn@paasikivi.fi.intel.com>
 <C193D76D23A22742993887E6D207B54D3DB3111C@ORSMSX106.amr.corp.intel.com>
 <20181129224548.qwbkau6suipt2veq@kekkonen.localdomain>
 <C193D76D23A22742993887E6D207B54D3DB335C2@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C193D76D23A22742993887E6D207B54D3DB335C2@ORSMSX106.amr.corp.intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org
Message-ID: <20181201205718.ExW_z2QkXlNW-j0IfTlEbuupxo3IcT5DftzgH7XZCF8@z>

Hi Yong,

On Thu, Nov 29, 2018 at 11:06:23PM +0000, Zhi, Yong wrote:
> Hi, Sakari,
> 
> > -----Original Message-----
> > From: Sakari Ailus [mailto:sakari.ailus@linux.intel.com]
> > Sent: Thursday, November 29, 2018 4:46 PM
> > To: Zhi, Yong <yong.zhi@intel.com>
> > Cc: linux-media@vger.kernel.org; tfiga@chromium.org;
> > mchehab@kernel.org; hans.verkuil@cisco.com;
> > laurent.pinchart@ideasonboard.com; Mani, Rajmohan
> > <rajmohan.mani@intel.com>; Zheng, Jian Xu <jian.xu.zheng@intel.com>; Hu,
> > Jerry W <jerry.w.hu@intel.com>; Toivonen, Tuukka
> > <tuukka.toivonen@intel.com>; Qiu, Tian Shu <tian.shu.qiu@intel.com>; Cao,
> > Bingbu <bingbu.cao@intel.com>; Li, Chao C <chao.c.li@intel.com>
> > Subject: Re: [PATCH v7 03/16] v4l: Add Intel IPU3 meta data uAPI
> > 
> > Hi Yong,
> > 
> > On Fri, Nov 16, 2018 at 10:37:00PM +0000, Zhi, Yong wrote:
> > ...
> > > > > +/**
> > > > > + * struct ipu3_uapi_shd_grid_config - Bayer shading(darkening)
> > > > > +correction
> > > > > + *
> > > > > + * @width:	Grid horizontal dimensions, u8, [8, 128], default 73
> > > > > + * @height:	Grid vertical dimensions, u8, [8, 128], default 56
> > > > > + * @block_width_log2:	Log2 of the width of the grid cell in pixel
> > > > count
> > > > > + *			u4, [0, 15], default value 5.
> > > > > + * @__reserved0:	reserved
> > > > > + * @block_height_log2:	Log2 of the height of the grid cell in pixel
> > > > count
> > > > > + *			u4, [0, 15], default value 6.
> > > > > + * @__reserved1:	reserved
> > > > > + * @grid_height_per_slice:	SHD_MAX_CELLS_PER_SET/width.
> > > > > + *				(with SHD_MAX_CELLS_PER_SET =
> > 146).
> > > > > + * @x_start:	X value of top left corner of sensor relative to ROI
> > > > > + *		u12, [-4096, 0]. default 0, only negative values.
> > > > > + * @y_start:	Y value of top left corner of sensor relative to ROI
> > > > > + *		u12, [-4096, 0]. default 0, only negative values.
> > > >
> > > > I suppose u12 is incorrect here, if the value is signed --- and
> > > > negative (sign bit) if not 0?
> > > >
> > >
> > > The value will be written to 13 bit register, should use s12.0.
> > 
> > If you have s12, that means the most significant bit is the sign bit. So if the
> > smallest value is -4096, you'd need s13.
> > 
> > But where is the sign bit, i.e. is this either s13 or s16?
> > 
> 
> The notation of s12.0 means 13 bit with fraction bit as 0 right? 

In s12.0, bit 11 is the sign bit, and bits 10--0 are the integer part. The
smallest number that can be represented is thus -2048 (not -4096).

> 
> > >
> > > > > + */
> > > > > +struct ipu3_uapi_shd_grid_config {
> > > > > +	/* reg 0 */
> > > > > +	__u8 width;
> > > > > +	__u8 height;
> > > > > +	__u8 block_width_log2:3;
> > > > > +	__u8 __reserved0:1;
> > > > > +	__u8 block_height_log2:3;
> > > > > +	__u8 __reserved1:1;
> > > > > +	__u8 grid_height_per_slice;
> > > > > +	/* reg 1 */
> > > > > +	__s16 x_start;
> > > > > +	__s16 y_start;
> > > > > +} __packed;
> > 
> > ...
> > 
> > > > > +/**
> > > > > + * struct ipu3_uapi_iefd_cux2_1 - Calculate power of non-directed
> > denoise
> > > > > + *				  element apply.
> > > > > + * @x0: X0 point of Config Unit, u9.0, default 0.
> > > > > + * @x1: X1 point of Config Unit, u9.0, default 0.
> > > > > + * @a01: Slope A of Config Unit, s4.4, default 0.
> > > >
> > > > The field is marked unsigned below. Which one is correct?
> > > >
> > >
> > > They are both correct, however, s4.4 is the internal representation
> > > used by CU, the inputs are unsigned, I will add a note in v8, same
> > > applies to the few other places as you commented.
> > 
> > I still find this rather confusing. Is there a sign bit or is there not?
> > 
> 
> It's unsigned number from driver perspective, all CU inputs are unsigned,
> however, they will be "converted" to signed for FW/HW to use. I have to
> consult FW expert if more clarification is needed.

I think that would be good to have; if you somehow convert an unsigned
integer to a negative number, there's more than just the type cast there.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
