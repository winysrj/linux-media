Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34177 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab0C2JxP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Mar 2010 05:53:15 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L0100E4DFGORD@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 29 Mar 2010 10:53:12 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L0100LOIFGOQ8@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 29 Mar 2010 10:53:12 +0100 (BST)
Date: Mon, 29 Mar 2010 11:53:05 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: [PATCH/RFC 0/1] v4l: Add support for binary controls
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, k.debski@samsung.com,
	kyungmin.park@samsung.com
Message-id: <1269856386-29557-1-git-send-email-k.debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello,

This patch introduces new type of v4l2 control - the binary control. It
will be useful for exchanging raw binary data between the user space and
the driver/hardware.

The patch is pretty small – basically it adds a new control type.

1.  Reasons to include this new type
- Some devices require data which are not part of the stream, but there
are necessary for the device to work e.g. coefficients for transformation
matrices.
- String control is not suitable as it suggests that the data is a null
terminated string. This might be important when printing debug information -
one might output strings as they are and binary data in hex.

2. How does the binary control work
The binary control has been based on the string control. The principle of
use is the same. It uses v4l2_ext_control structure to pass the pointer and
size of the data. It is left for the driver to call the copy_from_user/
copy_to_user function to copy the data.

3. About the patch
The patch is pretty small – it basically adds a new control type. 

Best wishes,
-- 
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center
