Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:49964 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758471Ab2EKJQX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 05:16:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v3 1/1] v4l2: use __u32 rather than enums in ioctl() structs
Date: Fri, 11 May 2012 09:16:10 +0000
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, remi@remlab.net, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
References: <1336629727-11111-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1336629727-11111-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205110916.11308.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 10 May 2012, Sakari Ailus wrote:
> The issue boils down to whether enums are fundamentally different from __u32
> or not, and can the former be substituted by the latter. During the
> discussion it was concluded that the __u32 has the same size as enums on all
> archs Linux is supported: it has not been shown that replacing those enums
> in IOCTL arguments would break neither source or binary compatibility. If no
> such reason is found, just replacing the enums with __u32s is the way to go.

Well, ARM Android was building stuff with short enums for a while, but it
seems that was corrected now, and using __u32 would in this case only
help maintain compatibility when mixing android kernels with regular
user space or vice versa.

	Arnd
