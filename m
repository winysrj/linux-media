Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:35527 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726879AbeIMQrS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 12:47:18 -0400
Date: Thu, 13 Sep 2018 14:38:09 +0300
From: "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>
To: "Mani, Rajmohan" <rajmohan.mani@intel.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        "Zhi, Yong" <yong.zhi@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Li, Chao C" <chao.c.li@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>
Subject: Re: [PATCH v1 2/2] v4l: Document Intel IPU3 meta data uAPI
Message-ID: <20180913113809.tbitfbeue735jpnw@paasikivi.fi.intel.com>
References: <1529033373-15724-1-git-send-email-yong.zhi@intel.com>
 <1529033373-15724-3-git-send-email-yong.zhi@intel.com>
 <749a58a4-24f7-672f-70a9-cfd584af0171@xs4all.nl>
 <6F87890CF0F5204F892DEA1EF0D77A598150266F@fmsmsx122.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6F87890CF0F5204F892DEA1EF0D77A598150266F@fmsmsx122.amr.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Raj,

My apologies for the delayed reply.

On Fri, Aug 31, 2018 at 11:39:54PM +0000, Mani, Rajmohan wrote:
...
> > > +struct ipu3_uapi_af_meta_data {
> > > +	__u8 y_table[IPU3_UAPI_AF_Y_TABLE_MAX_SIZE] IPU3_ALIGN;
> > 
> > Here IPU3_ALIGN is put at the end...
> > 
> > > +} __packed;
> > > +
> > > +/**
> > > + * struct ipu3_uapi_af_raw_buffer - AF raw buffer
> > > + *
> > > + * @meta_data: raw buffer &ipu3_uapi_af_meta_data for auto focus meta
> > data.
> > > + */
> > > +struct ipu3_uapi_af_raw_buffer {
> > > +	IPU3_ALIGN struct ipu3_uapi_af_meta_data meta_data;
> > 
> > ... and here at the start. Is that due to the difference between an array and a
> > struct?
> > 
> 
> No.
> 
> When preparing uAPI kernelDoc using "make htmldocs",
> the kernel-doc encounters two type of error/warnings
> caused by IPU3_ALIGN.
> 
> case 1:
> struct IPU3_ALIGN ipu3_uapi_dummy {
> 	...
> } __packed;
> 
> "error: Cannot parse struct or union!"
> 
> case 2:
> struct ipu3_uapi_dummy {
> 	struct ipu3_uapi_x x IPU3_ALIGN;
> } __packed;
> 
> "warning: Function parameter or member 'IPU3_ALIGN' not
> described in 'ipu3_uapi_dummy'"
> 
> Positioned the attribute syntax without altering the
> mem layout of the structs, while also making "make htmldocs" to
> compile fine.
> 
> Let us know if it's okay to ignore Sphinx warnings.

I looked a bit at different options for handling this in scripts/kernel-doc
but the difficulty in macro substitution comes in determining where to do
the substitution and where not to. That seems unaddressable in the kernel-doc
script; most of the time you want the definitions as-is while this is
likely the only case where something else might be appropriate. Making
IPU3_ALIGN a special case probably wouldn't really fly either.

In this particular case I'd just write open the alignment requirement so
kernel-doc can correctly parse it.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
