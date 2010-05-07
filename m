Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:31363 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754847Ab0EGSUo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 May 2010 14:20:44 -0400
From: "Wang, Wen W" <wen.w.wang@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Hu, Gang A" <gang.a.hu@intel.com>,
	"Wang, Wen W" <wen.w.wang@intel.com>
Date: Sat, 8 May 2010 02:20:38 +0800
Subject: Linux V4L2 support dual stream video capture device
Message-ID: <D5AB6E638E5A3E4B8F4406B113A5A19A1E55D29F@shsmsx501.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi all,

I'm wondering if V4L2 framework supports dual stream video capture device that transfer a preview stream and a regular stream (still capture or video capture) at the same time.

We are developing a device driver with such capability. Our proposal to do this in V4L2 framework is to have two device nodes, one as primary node for still/video capture and one for preview. 

The primary still/video capture device node is used for device configuration which can be compatible with open sourced applications. This will ensure the normal V4L2 application can run without code modification. Device node for preview will only accept preview buffer related operations. Buffer synchronization for still/video capture and preview will be done internally in the driver.

This is our initial idea about the dual stream support in V4L2. Your comments will be appreciated!

Thanks
Wen
