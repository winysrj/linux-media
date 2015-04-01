Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:33039 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbbDAQpR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Apr 2015 12:45:17 -0400
Received: by qcrf4 with SMTP id f4so33522446qcr.0
        for <linux-media@vger.kernel.org>; Wed, 01 Apr 2015 09:45:16 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 1 Apr 2015 12:45:16 -0400
Message-ID: <CALzAhNWSH9Y8Zepn4BpbDJ14cr5+KjhWbWwqDKoVQWs6g0zxvQ@mail.gmail.com>
Subject: v4l2-compliance question
From: Steven Toth <stoth@kernellabs.com>
To: Linux-Media <linux-media@vger.kernel.org>,
	"Jacob Johan (Hans) Verkuil" <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

struct v4l2_capability has a version field described as:

__u32version

"Version number of the driver.

Starting on kernel 3.1, the version reported is provided per V4L2
subsystem, following the same Kernel numberation scheme. However, it
should not always return the same version as the kernel, if, for
example, an stable or distribution-modified kernel uses the V4L2 stack
from a newer kernel.

The version number is formatted using the KERNEL_VERSION() macro..."

fail_on_test((vcap.version >> 16) < 3);

I have a driver that returns 0x00010703 and thus fails v4l2-compliance.

My read on the documentation is that the major doesn't have to be 3 or
higher, it doesn't specially call that out.

Thoughts?

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
