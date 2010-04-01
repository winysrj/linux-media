Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:45679 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754193Ab0DAIUY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Apr 2010 04:20:24 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Pawel Osciak <p.osciak@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Date: Thu, 1 Apr 2010 13:50:01 +0530
Subject: RE: [PATCH v3 0/2] Mem-to-mem device framework
Message-ID: <19F8576C6E063C45BE387C64729E7394044DF7EE68@dbde02.ent.ti.com>
References: <1269848207-2325-1-git-send-email-p.osciak@samsung.com>
In-Reply-To: <1269848207-2325-1-git-send-email-p.osciak@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Pawel Osciak [mailto:p.osciak@samsung.com]
> Sent: Monday, March 29, 2010 1:07 PM
> To: linux-media@vger.kernel.org
> Cc: p.osciak@samsung.com; m.szyprowski@samsung.com;
> kyungmin.park@samsung.com; Hiremath, Vaibhav
> Subject: [PATCH v3 0/2] Mem-to-mem device framework
> 
> Hello,
> 
> this is the third version of the mem-to-mem memory device framework.
> It addresses previous comments and issues raised in Norway as well.
> 
> It is rather independent from videobuf so I believe it can be merged
> separately.
> 
> Changes in v3:
> - streamon, streamoff now have to be called for both queues separately
> - added automatic rescheduling of an instance after finish (if ready)
> - tweaked up locking
> - addressed Andy Walls' comments
> 
> We have been using v2 for three different devices on an embedded system.
> I did some additional testing of v3 on a 4-core SMP as well.
> 
> The series contains:
> 
> [PATCH v3 1/2] v4l: Add memory-to-memory device helper framework for
> videobuf.
> [PATCH v3 2/2] v4l: Add a mem-to-mem videobuf framework test device.
> 
[Hiremath, Vaibhav] I have reviewed the changes and also tested it here at my end, even I have tested it with real hardware module (OMAP3 Resizer driver) so I think we can merge these patches now.

I have cleanup patch (Submitting shortly), I just changed while reviewing/testing the code. So you can directly merge the patch into your next version.

Also it would be really great if we could add documentation for this.

You can also add,

Reviewed-by: Hiremath Vaibhav <hvaibhav@ti.com>
Tested-by: Hiremath Vaibhav <hvaibhav@ti.com>

Thanks,
Vaibhav
> 
> Best regards
> --
> Pawel Osciak
> Linux Platform Group
> Samsung Poland R&D Center

