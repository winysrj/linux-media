Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:47736 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751213AbdEIE4a (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 May 2017 00:56:30 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
From: Matthias Schwarzott <zzam@gentoo.org>
Subject: Unknown symbol put_vaddr_frames when using media_build
Message-ID: <6ea4c402-9523-2345-9dd3-0fb041f07f27@gentoo.org>
Date: Tue, 9 May 2017 06:56:25 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Whenever I compile the media drivers using media_build against a recent
kernel, I get this message when loading them:

[    5.848537] media: Linux media interface: v0.10
[    5.881440] Linux video capture interface: v2.00
[    5.881441] WARNING: You are using an experimental version of the
media stack.
...
[    6.166390] videobuf2_memops: Unknown symbol put_vaddr_frames (err 0)
[    6.166394] videobuf2_memops: Unknown symbol get_vaddr_frames (err 0)
[    6.166396] videobuf2_memops: Unknown symbol frame_vector_destroy (err 0)
[    6.166398] videobuf2_memops: Unknown symbol frame_vector_create (err 0)

That means I am not able to load any drivers being based on
videobuf2_memops without manual actions.

I used kernel 4.11.0, but it does not matter which kernel version
exactly is used.

My solution for that has been to modify mm/Kconfig of my kernel like
this and then enable FRAME_VECTOR in .config

diff --git a/mm/Kconfig b/mm/Kconfig
index 9b8fccb969dc..cfa6a80d1a0a 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -701,7 +701,7 @@ config ZONE_DEVICE
          If FS_DAX is enabled, then say Y.

 config FRAME_VECTOR
-       bool
+       tristate "frame vector"

 config ARCH_USES_HIGH_VMA_FLAGS
        bool

But I do not like that solution.
I would prefer one of these solutions:

1. Have media_build apply its fallback the same way as for older kernels
that do not even have the the FRAME_VECTOR support.

2. Get the above patch merged (plus description etc.).

What do you think?

Regards
Matthias
