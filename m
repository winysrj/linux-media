Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:32351 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387462AbeKFE07 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Nov 2018 23:26:59 -0500
From: "Mani, Rajmohan" <rajmohan.mani@intel.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zhi, Yong" <yong.zhi@intel.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
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
Subject: RE: [PATCH v7 05/16] intel-ipu3: abi: Add structs
Date: Mon, 5 Nov 2018 19:05:53 +0000
Message-ID: <6F87890CF0F5204F892DEA1EF0D77A5981523D7E@fmsmsx122.amr.corp.intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <1540851790-1777-6-git-send-email-yong.zhi@intel.com>
 <20181105082755.c65oh6c2ztk34kpb@kekkonen.localdomain>
In-Reply-To: <20181105082755.c65oh6c2ztk34kpb@kekkonen.localdomain>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

> -----Original Message-----
> From: Sakari Ailus [mailto:sakari.ailus@linux.intel.com]
> Sent: Monday, November 05, 2018 12:28 AM
> To: Zhi, Yong <yong.zhi@intel.com>
> Cc: linux-media@vger.kernel.org; tfiga@chromium.org; mchehab@kernel.org;
> hans.verkuil@cisco.com; laurent.pinchart@ideasonboard.com; Mani,
> Rajmohan <rajmohan.mani@intel.com>; Zheng, Jian Xu
> <jian.xu.zheng@intel.com>; Hu, Jerry W <jerry.w.hu@intel.com>; Toivonen,
> Tuukka <tuukka.toivonen@intel.com>; Qiu, Tian Shu
> <tian.shu.qiu@intel.com>; Cao, Bingbu <bingbu.cao@intel.com>
> Subject: Re: [PATCH v7 05/16] intel-ipu3: abi: Add structs
> 
> Hi Yong,
> 
> On Mon, Oct 29, 2018 at 03:22:59PM -0700, Yong Zhi wrote:
> > This add all the structs of IPU3 firmware ABI.
> >
> > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
> 
> ...
> 
> > +struct imgu_abi_shd_intra_frame_operations_data {
> > +	struct imgu_abi_acc_operation
> > +		operation_list[IMGU_ABI_SHD_MAX_OPERATIONS]
> __attribute__((aligned(32)));
> > +	struct imgu_abi_acc_process_lines_cmd_data
> > +		process_lines_data[IMGU_ABI_SHD_MAX_PROCESS_LINES]
> __attribute__((aligned(32)));
> > +	struct imgu_abi_shd_transfer_luts_set_data
> > +		transfer_data[IMGU_ABI_SHD_MAX_TRANSFERS]
> > +__attribute__((aligned(32)));
> 
> Could you replace this wth __aligned(32), please? The same for the rest of the
> header.
> 

Using __aligned(32) in the uAPI header resulted in compilation errors in
user space / camera HAL code.

e.g
../../../../../../../../usr/include/linux/intel-ipu3.h:464:57: error: expected ';' 
at end of declaration list
 __u8 bayer_table[IPU3_UAPI_AWB_FR_BAYER_TABLE_MAX_SIZE] __aligned(32);

So we ended up using __attribute__((aligned(32))) format in uAPI header and
to be consistent, we followed the same format in ABI header as well.

Let us know if it's okay to deviate between uAPI and ABI header for this
alignment qualifier.

> --
> Regards,
> 
> Sakari Ailus
> sakari.ailus@linux.intel.com
