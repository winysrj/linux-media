Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:56161 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758775AbZAQNh5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jan 2009 08:37:57 -0500
Received: by fg-out-1718.google.com with SMTP id 19so996890fgg.17
        for <linux-media@vger.kernel.org>; Sat, 17 Jan 2009 05:37:55 -0800 (PST)
Message-ID: <4971DF2F.5010902@googlemail.com>
Date: Sat, 17 Jan 2009 14:37:51 +0100
From: e9hack <e9hack@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: BUG in videobuf_reqbufs()
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

it seems there is a bug in videobuf_reqbufs(). Depend on the spec
(http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec-single/v4l2.html#VIDIOC-REQBUFS),
it should be possible to deallocate all buffers. This doesn't work, because
videobuf_reqbufs() bails out with EINVAL, if the function is called with a count lower
than 1 (videobuf-core.c, line #399). Deallocate should be done with count set to 0.

Regards,
Hartmut
