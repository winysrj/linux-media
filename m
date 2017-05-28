Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38843 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750768AbdE1ApK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 27 May 2017 20:45:10 -0400
Received: by mail-wm0-f44.google.com with SMTP id e127so20586498wmg.1
        for <linux-media@vger.kernel.org>; Sat, 27 May 2017 17:45:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAML3znFcKR9wx3wvjBDeQLn7mbtkhU0Knn56cMrXek6H-mTUjQ@mail.gmail.com>
References: <CAML3znFcKR9wx3wvjBDeQLn7mbtkhU0Knn56cMrXek6H-mTUjQ@mail.gmail.com>
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
Date: Sun, 28 May 2017 10:45:08 +1000
Message-ID: <CAEsFdVPHs++F3w2MgkLMW0cwo4KxF4evcEV2dPcubWZeoupRaw@mail.gmail.com>
Subject: Re: Build fails Ubuntu 17.04 / "error: implicit declaration of function"
To: Karl Wallin <karl.wallin.86@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I saw this too, ([regression] Build failure on ubuntu 16.04 LTS)

857313e51006ff51524579bcd8808b70f9a80812
media: utilize new cdev_device_add helper function

introduced these in March this year. More backport patches are needed.
