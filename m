Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:35243 "EHLO
        mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752164AbdCOLhA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 07:37:00 -0400
Received: by mail-vk0-f50.google.com with SMTP id x75so6799515vke.2
        for <linux-media@vger.kernel.org>; Wed, 15 Mar 2017 04:36:59 -0700 (PDT)
MIME-Version: 1.0
From: Marian Mihailescu <mihailescu2m@gmail.com>
Date: Wed, 15 Mar 2017 22:06:58 +1030
Message-ID: <CAM3PiRyZ6y5=D-O2z39qoqNAXkkEROwZ3_g9gctrVqF-Gd+Ysg@mail.gmail.com>
Subject: [PATCH v2 00/15] Exynos MFC v6+ - remove the need for the reserved memory
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

After testing these patches, encoding using MFC fails when requesting
buffers for capture (it works for output) with ENOMEM (it complains it
cannot allocate memory on bank1).
Did anyone else test encoding?

Thanks,
Marian

Either I've been missing something or nothing has been going on. (K. E. Gordon)
