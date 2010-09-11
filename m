Return-path: <mchehab@pedra>
Received: from mga02.intel.com ([134.134.136.20]:23335 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab0IKKkc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Sep 2010 06:40:32 -0400
From: "Wang, Wen W" <wen.w.wang@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>,
	"Hu, Gang A" <gang.a.hu@intel.com>
Date: Sat, 11 Sep 2010 18:40:27 +0800
Subject: Proposal to extend V4L2 Control ID for advanced imaging processing
 features.
Message-ID: <D5AB6E638E5A3E4B8F4406B113A5A19A2A658B6D@shsmsx501.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi all,

We are developing a V4L2 device driver which the ISP has many advanced features such as manual exposure setting, GDC (Geometric Distortion Correction), CAC (Chromatic Aberration Correction), video stabilization, false color correction, shading correction, etc. But to control those features, we find current v4l2 framework has limited CIDs and cannot support these advanced features in normal way . 

So we propose to extend the V4L2 CIDs and add the below CIDs. Can you please review and feel free to give your comments?

V4L2_CID_ISO_ABSOLUTE -- This CID is used to set up manual ISO speed value. This CID has integer type and with as valid range or limited valid value, depending on the hardware. If the target value is not supported by hardware, a closest value will be set
V4L2_CID_APERTURE_ABSOLUTE -- This CID is used to set up manual aperture value. This CID has integer type and with as valid range or limited valid value, depending on the hardware. If the target value is not supported by hardware, a closest value will be set
V4L2_CID_ATOMISP_FIXED_PATTERN_NR - This CID is used to enable/disable Fixed pattern noise reduction. This CID has Boolean type and 0 indicate to disable fixed pattern NR and 1 indicate to enable it.
V4L2_CID_ATOMISP_POSTPROCESS_XNR - This CID is used to enable/disable XNR. This CID has Boolean type and 0 indicate to disable XNR and 1 indicate to enable it.
V4L2_CID_ATOMISP_POSTPROCESS_GDC_CAC - Our ISP combined GDC and CAC together. This CID is used to enable/disable GDC and CAC. This CID has Boolean type and 0 indicate to disable it and 1 indicate to enable it.
V4L2_CID_ATOMISP_VIDEO_STABILIZATION -- This CID is used to enable/disable video stabilization capability. This CID has Boolean type and 0 indicate to disable it and 1 indicate to enable it.
V4L2_CID_ATOMISP_FALSE_COLOR_CORRECTION - This CID is used to enable color correction capability. This CID has Boolean type and 0 indicate to disable it and 1 indicate to enable it.

Thanks,
Wen
