Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:59902 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757389Ab0JLR5I (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Oct 2010 13:57:08 -0400
Message-ID: <4CB4A168.2060105@maxwell.research.nokia.com>
Date: Tue, 12 Oct 2010 20:56:56 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "Wang, Wen W" <wen.w.wang@intel.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Zhang, Xiaolin" <xiaolin.zhang@intel.com>,
	"Hu, Gang A" <gang.a.hu@intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: Proposal to extend V4L2 Control ID for advanced imaging processing
 features.
References: <D5AB6E638E5A3E4B8F4406B113A5A19A2A658B6D@shsmsx501.ccr.corp.intel.com>
In-Reply-To: <D5AB6E638E5A3E4B8F4406B113A5A19A2A658B6D@shsmsx501.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Wang, Wen W wrote:
> Hi all,

Hi Wang,

Thanks for the proposal!

(Cc'ing Hans Verkuil.)

> We are developing a V4L2 device driver which the ISP has many
> advanced features such as manual exposure setting, GDC (Geometric
> Distortion Correction), CAC (Chromatic Aberration Correction), video
> stabilization, false color correction, shading correction, etc. But
> to control those features, we find current v4l2 framework has limited
> CIDs and cannot support these advanced features in normal way .

Manual exposure sounds like a sensor property, not ISP's. Are the rest
implemented in the ISP or is there a user space library to support them?
I think in either case the definition will be in kernel headers.

These controls appear quite high level to me. What about the specific
parameters for the functionality, I suppose shading correction for
example has a lot more parameters than just disable/enable?

> So we propose to extend the V4L2 CIDs and add the below CIDs. Can you
> please review and feel free to give your comments?
> 
> V4L2_CID_ISO_ABSOLUTE -- This CID is used to set up manual ISO speed
> value. This CID has integer type and with as valid range or limited
> valid value, depending on the hardware. If the target value is not
> supported by hardware, a closest value will be set 
> V4L2_CID_APERTURE_ABSOLUTE -- This CID is used to set up manual
> aperture value. This CID has integer type and with as valid range or
> limited valid value, depending on the hardware. If the target value
> is not supported by hardware, a closest value will be set 

The above look like image sensor properties.

I wonder if it would make sense to create a new control class for these.

> V4L2_CID_ATOMISP_FIXED_PATTERN_NR - This CID is used to
> enable/disable Fixed pattern noise reduction. This CID has Boolean
> type and 0 indicate to disable fixed pattern NR and 1 indicate to
> enable it. V4L2_CID_ATOMISP_POSTPROCESS_XNR - This CID is used to
> enable/disable XNR. This CID has Boolean type and 0 indicate to
> disable XNR and 1 indicate to enable it. 
> V4L2_CID_ATOMISP_POSTPROCESS_GDC_CAC - Our ISP combined GDC and CAC
> together. This CID is used to enable/disable GDC and CAC. This CID
> has Boolean type and 0 indicate to disable it and 1 indicate to

What are GDC and CAC?

> enable it. V4L2_CID_ATOMISP_VIDEO_STABILIZATION -- This CID is used
> to enable/disable video stabilization capability. This CID has
> Boolean type and 0 indicate to disable it and 1 indicate to enable
> it. V4L2_CID_ATOMISP_FALSE_COLOR_CORRECTION - This CID is used to
> enable color correction capability. This CID has Boolean type and 0
> indicate to disable it and 1 indicate to enable it.

Ps. Could you wrap your lines to 80 characters, please? That makes your
messages easier to read and reply. Thank you.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
