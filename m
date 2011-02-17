Return-path: <mchehab@pedra>
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5479 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab1BQDMC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Feb 2011 22:12:02 -0500
From: Andrew Chew <AChew@nvidia.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 16 Feb 2011 19:12:00 -0800
Subject: soc-camera and videobuf2
Message-ID: <643E69AA4436674C8F39DCC2C05F763816BD96CFB8@HQMAIL03.nvidia.com>
References: <643E69AA4436674C8F39DCC2C05F763816BD96CFB7@HQMAIL03.nvidia.com>
In-Reply-To: <643E69AA4436674C8F39DCC2C05F763816BD96CFB7@HQMAIL03.nvidia.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Reposting.  Sorry for the rich text in my previous email.

I'm looking at the videobuf2 stuff, and would like to use it because it solves a bunch of problems for me that were in videobuf (for example, I'm writing a variant of videobuf-dma-contig, and there's some private memory allocator state I needed to track, but the videobuf stuff didn't seem to let you do that).

But I'm also using soc_camera.  I was wondering if there's a time estimate for soc_camera to be converted over to the videobuf2 framework.

Also, are SoC camera host drivers expected to call the methods in the videobuf2 ops table directly (as in, vb2_ops->alloc())?  Or will there be wrappers around these in the future (the wrappers can take the videobuf2's alloc_ctx as a parameter and thereby figure out which method to call).
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
