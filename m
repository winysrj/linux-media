Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:37900 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030383AbeCANYw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2018 08:24:52 -0500
Received: by mail-qk0-f195.google.com with SMTP id s198so7462192qke.5
        for <linux-media@vger.kernel.org>; Thu, 01 Mar 2018 05:24:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOcJUbzpbxtNGVrNepp_mhmC0XDtFv9324EqSTFyCGG0pv+J7Q@mail.gmail.com>
References: <CAOcJUbzpbxtNGVrNepp_mhmC0XDtFv9324EqSTFyCGG0pv+J7Q@mail.gmail.com>
From: Michael Ira Krufky <mkrufky@linuxtv.org>
Date: Thu, 1 Mar 2018 08:24:51 -0500
Message-ID: <CAOcJUbzP9WiSqw4NQOv4+atjL=Ea5=-2WfMy=OYqjXeDvpgMvA@mail.gmail.com>
Subject: Re: [PULL] DVB-mmap Kconfig typo fix
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 1, 2018 at 7:55 AM, Michael Ira Krufky <mkrufky@linuxtv.org> wrote:
> Please pull the following typo fix in the Kconfig for dvb-mmap:
>
> The following changes since commit 4df7ac5f42087dc9bcbed04b5cada0f025fbf9ef:
>
>   drivers/media/Kconfig: typo: replace `with` with `which` (2018-02-15
> 08:01:22 -0500)
>
> are available in the git repository at:
>
>   git://linuxtv.org/mkrufky/dvb.git dvb-mmap-v3
>
> for you to fetch changes up to 4df7ac5f42087dc9bcbed04b5cada0f025fbf9ef:
>
>   drivers/media/Kconfig: typo: replace `with` with `which` (2018-02-15
> 08:01:22 -0500)

I realize I never sent the actual patch to the list.  inline below:

Author: Michael Ira Krufky <mkrufky@linuxtv.org>
Date:   Tue Jan 16 22:16:12 2018 -0500

    drivers/media/Kconfig: typo: replace `with` with `which`

    Signed-off-by: Michael Ira Krufky <mkrufky@linuxtv.org>

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 372c074bb1b9..86c1a190d946 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -151,7 +151,7 @@ config DVB_MMAP
        select VIDEOBUF2_VMALLOC
        default n
        help
-         This option enables DVB experimental memory-mapped API, with
+         This option enables DVB experimental memory-mapped API, which
          reduces the number of context switches to read DVB buffers, as
          the buffers can use mmap() syscalls.
