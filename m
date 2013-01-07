Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48428 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab3AGOXy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2013 09:23:54 -0500
Received: from avalon.localnet (unknown [91.178.39.38])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id D127A359DC
	for <linux-media@vger.kernel.org>; Mon,  7 Jan 2013 15:23:52 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: Fwd: [Bug 51991] ioctl(VIDIOC_QUERYCAP) may return non-ASCII characters
Date: Mon, 07 Jan 2013 15:25:30 +0100
Message-ID: <3413534.jxGpuKhLTn@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Any opinion on this ?

----------  Forwarded Message  ----------

Subject: [Bug 51991] ioctl(VIDIOC_QUERYCAP) may return non-ASCII characters
Date: Wednesday 02 January 2013, 14:45:48
From: bugzilla-daemon@bugzilla.kernel.org
To: laurent.pinchart+bugzilla-kernel@ideasonboard.com

https://bugzilla.kernel.org/show_bug.cgi?id=51991


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk




--- Comment #2 from Alan <alan@lxorguk.ukuu.org.uk>  2013-01-02 14:45:48 ---
It should probably be documented as UTF-8 IMHO

-----------------------------------------

-- 
Regards,

Laurent Pinchart

