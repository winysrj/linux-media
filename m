Return-path: <mchehab@localhost.localdomain>
Received: from perceval.irobotique.be ([92.243.18.41]:52206 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab0IMGiQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 02:38:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Wang, Wen W" <wen.w.wang@intel.com>
Subject: Re: Linux V4L2 support dual stream video capture device
Date: Mon, 13 Sep 2010 08:38:56 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Zhang, Xiaolin" <xiaolin.zhang@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Hu, Gang A" <gang.a.hu@intel.com>
References: <D5AB6E638E5A3E4B8F4406B113A5A19A1E55D29F@shsmsx501.ccr.corp.intel.com>
In-Reply-To: <D5AB6E638E5A3E4B8F4406B113A5A19A1E55D29F@shsmsx501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009130838.56888.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@localhost.localdomain>

Hi Wen,

On Friday 07 May 2010 20:20:38 Wang, Wen W wrote:
> Hi all,
> 
> I'm wondering if V4L2 framework supports dual stream video capture device
> that transfer a preview stream and a regular stream (still capture or
> video capture) at the same time.
> 
> We are developing a device driver with such capability. Our proposal to do
> this in V4L2 framework is to have two device nodes, one as primary node
> for still/video capture and one for preview.

If the device supports multiple simultaneous video streams, multiple video 
nodes is the way to go.

> The primary still/video capture device node is used for device
> configuration which can be compatible with open sourced applications. This
> will ensure the normal V4L2 application can run without code modification.
> Device node for preview will only accept preview buffer related
> operations. Buffer synchronization for still/video capture and preview
> will be done internally in the driver.

I suspect that the preview device node will need to support more than the 
buffer-related operations, as you probably want applications to configure the 
preview video stream format and size.

> This is our initial idea about the dual stream support in V4L2. Your
> comments will be appreciated!

You should use the media controller framework. This will allow applications to 
configure all sizes in the pipeline, including the frame sizes for the two 
video nodes.

-- 
Regards,

Laurent Pinchart
