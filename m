Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:43610 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbaENLap (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 May 2014 07:30:45 -0400
Received: by mail-we0-f177.google.com with SMTP id x48so1727327wes.8
        for <linux-media@vger.kernel.org>; Wed, 14 May 2014 04:30:43 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 14 May 2014 21:30:43 +1000
Message-ID: <CAEsFdVN5MJQnb9+ZoagMOLpLYTJVYjjqQid9NrhU_Q8HfrtjAg@mail.gmail.com>
Subject: regression: firmware loading for dvico dual digital 4
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: multipart/mixed; boundary=f46d040fa03ccc998604f95a826a
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--f46d040fa03ccc998604f95a826a
Content-Type: text/plain; charset=UTF-8

Hi,

Antti asked me to report this.

I built the latest media_build git on Ubuntu 12.04, with 3.8.0 kernel,
using './build --main-git'.
The attached tarball has the relvant info.

Without the media_build modules, firmware loads fine (file dmesg.1)
Once I build and install the media_build modules, the firmware no
longer loads. (dmesg.2)

The firmware loading issue appears to have been reported to ubuntu (a
later kernel, 3.11)  with a possible fix proposed, see
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1291459

I can post lspci etc details if people want.

Kind regards
VInce

--f46d040fa03ccc998604f95a826a
Content-Type: application/octet-stream; name="dmesg.tar.xz"
Content-Disposition: attachment; filename="dmesg.tar.xz"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

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
--f46d040fa03ccc998604f95a826a--
