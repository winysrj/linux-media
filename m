Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:5252 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729021AbeKFR2t (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Nov 2018 12:28:49 -0500
Date: Tue, 6 Nov 2018 10:04:44 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: "Mani, Rajmohan" <rajmohan.mani@intel.com>
Cc: "Zhi, Yong" <yong.zhi@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>
Subject: Re: [PATCH v7 05/16] intel-ipu3: abi: Add structs
Message-ID: <20181106080444.amyq3erw3ahz7wuc@paasikivi.fi.intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <1540851790-1777-6-git-send-email-yong.zhi@intel.com>
 <20181105082755.c65oh6c2ztk34kpb@kekkonen.localdomain>
 <6F87890CF0F5204F892DEA1EF0D77A5981523D7E@fmsmsx122.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6F87890CF0F5204F892DEA1EF0D77A5981523D7E@fmsmsx122.amr.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Raj,

On Mon, Nov 05, 2018 at 07:05:53PM +0000, Mani, Rajmohan wrote:
> Hi Sakari,
> 
> > -----Original Message-----
> > From: Sakari Ailus [mailto:sakari.ailus@linux.intel.com]
> > Sent: Monday, November 05, 2018 12:28 AM
> > To: Zhi, Yong <yong.zhi@intel.com>
> > Cc: linux-media@vger.kernel.org; tfiga@chromium.org; mchehab@kernel.org;
> > hans.verkuil@cisco.com; laurent.pinchart@ideasonboard.com; Mani,
> > Rajmohan <rajmohan.mani@intel.com>; Zheng, Jian Xu
> > <jian.xu.zheng@intel.com>; Hu, Jerry W <jerry.w.hu@intel.com>; Toivonen,
> > Tuukka <tuukka.toivonen@intel.com>; Qiu, Tian Shu
> > <tian.shu.qiu@intel.com>; Cao, Bingbu <bingbu.cao@intel.com>
> > Subject: Re: [PATCH v7 05/16] intel-ipu3: abi: Add structs
> > 
> > Hi Yong,
> > 
> > On Mon, Oct 29, 2018 at 03:22:59PM -0700, Yong Zhi wrote:
> > > This add all the structs of IPU3 firmware ABI.
> > >
> > > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > > Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
> > 
> > ...
> > 
> > > +struct imgu_abi_shd_intra_frame_operations_data {
> > > +	struct imgu_abi_acc_operation
> > > +		operation_list[IMGU_ABI_SHD_MAX_OPERATIONS]
> > __attribute__((aligned(32)));
> > > +	struct imgu_abi_acc_process_lines_cmd_data
> > > +		process_lines_data[IMGU_ABI_SHD_MAX_PROCESS_LINES]
> > __attribute__((aligned(32)));
> > > +	struct imgu_abi_shd_transfer_luts_set_data
> > > +		transfer_data[IMGU_ABI_SHD_MAX_TRANSFERS]
> > > +__attribute__((aligned(32)));
> > 
> > Could you replace this wth __aligned(32), please? The same for the rest of the
> > header.
> > 
> 
> Using __aligned(32) in the uAPI header resulted in compilation errors in
> user space / camera HAL code.
> 
> e.g
> ../../../../../../../../usr/include/linux/intel-ipu3.h:464:57: error: expected ';' 
> at end of declaration list
>  __u8 bayer_table[IPU3_UAPI_AWB_FR_BAYER_TABLE_MAX_SIZE] __aligned(32);
> 
> So we ended up using __attribute__((aligned(32))) format in uAPI header and
> to be consistent, we followed the same format in ABI header as well.
> 
> Let us know if it's okay to deviate between uAPI and ABI header for this
> alignment qualifier.

There's a reason for using __attribute__((aligned(32))) in the uAPI header,
but not in the in-kernel headers where __aligned(32) is preferred.

I have a patch for addressing this for the uAPI headers as well so
__aligned(32) could be used there, too; I'll submit it soon. Let's see...
there are kerneldoc issues still in this area.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
