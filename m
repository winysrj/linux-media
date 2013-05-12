Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:64013 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab3ELKeq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 May 2013 06:34:46 -0400
Received: by mail-ob0-f180.google.com with SMTP id xk17so3518693obc.11
        for <linux-media@vger.kernel.org>; Sun, 12 May 2013 03:34:45 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 12 May 2013 14:34:45 +0400
Message-ID: <CAK3bHNUXdh+c=vEO1z2f1xZUTnpqV5fZzZ7LGQiuNv_4XAMc6w@mail.gmail.com>
Subject: V4L read I&Q data and constellation visualization added
From: Abylay Ospan <aospan1@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Reading I&Q data from frontend and generation PNG image was added.
Linux kernel (v4l subsystem) should be patched. DTV_READ_IQ and
.read_iq added.

Here is a description with some images obtained from real environment:
http://www.linuxtv.org/wiki/index.php/Dvb_constellation

Currently .read_iq implemented for NetUP's cards only (T/C and S2
card). Other developers can implement read_iq for another cards.

Reading I&Q data and visualization tools was added into v4l-utils package.

Here is a patches:
Patch for Linux kernel: http://stand.netup.tv/downloads/iq_constellation.patch
Patch for v4l-utils:
http://stand.netup.tv/downloads/iq_constellation_v4l-utils.patch

Mauro, please apply this patches if they are ok ?

--
Abylay Ospan
