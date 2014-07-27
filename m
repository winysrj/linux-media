Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:42104 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaG0GrV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jul 2014 02:47:21 -0400
Received: by mail-ie0-f169.google.com with SMTP id rd18so5454441iec.28
        for <linux-media@vger.kernel.org>; Sat, 26 Jul 2014 23:47:21 -0700 (PDT)
MIME-Version: 1.0
From: Isaac Nickaein <nickaein.i@gmail.com>
Date: Sun, 27 Jul 2014 11:17:00 +0430
Message-ID: <CA+NJmkcTpf5Xb4Z8gJFriB58Jtf85ay_jnTS-fM34gA1PBf60g@mail.gmail.com>
Subject: "error: redefinition of 'altera_init'" during build on Kernel 3.0.36+
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I get the following error when I try to build the V4L2 on Kernel
3.0.36+ for ARM architecture:

/root/v4l2/media_build/v4l/altera.c:2417:5: error: redefinition of 'altera_init'
 int altera_init(struct altera_config *config, const struct firmware *fw)
     ^
In file included from /root/v4l2/media_build/v4l/altera.c:32:0:
/root/v4l2/media_build/v4l/../linux/include/misc/altera.h:41:19: note:
previous definition of 'altera_init' was here
 static inline int altera_init(struct altera_config *config,
                   ^


I checked the altera.h code and apparently, the IS_ENABLED macro is
not defined and causes this problem. I have prepared kernel source at
/lib/modules/3.0.36+/build/ and it builds successfully.

Can anyone help me on this issue?

Bests,
Isaac
