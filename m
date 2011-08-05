Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35578 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab1HEIzH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Aug 2011 04:55:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
Subject: Possible issue in videobuf2 with buffer length check at QBUF time
Date: Fri, 5 Aug 2011 10:55:08 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108051055.08641.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marek and Pawel,

While reviewing an OMAP3 ISP patch, I noticed that videobuf2 doesn't verify 
the buffer length field value when a new USERPTR buffer is queued.

The length given by userspace is copied to the internal buffer length field. 
It seems to be up to drivers to verify that the value is equal to or higher 
than the minimum required to store the image, but that's not clearly 
documented. Should the buf_init operation be made mandatory for drivers that 
support USERPTR, and documented as required to implement a length check ?

Alternatively the check could be performed in videobuf2-core, which would 
probably make sense as the check is required. videobuf2 doesn't store the 
minimum size for USERPTR buffers though (but that can of course be changed).

-- 
Regards,

Laurent Pinchart
