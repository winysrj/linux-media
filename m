Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751200AbeASMLV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Jan 2018 07:11:21 -0500
Received: from mail-qt0-f172.google.com (mail-qt0-f172.google.com [209.85.216.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8854521719
        for <linux-media@vger.kernel.org>; Fri, 19 Jan 2018 12:11:20 +0000 (UTC)
Received: by mail-qt0-f172.google.com with SMTP id f4so3224718qtj.6
        for <linux-media@vger.kernel.org>; Fri, 19 Jan 2018 04:11:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1516196123-24327-1-git-send-email-pochun.lin@mediatek.com>
References: <1516196123-24327-1-git-send-email-pochun.lin@mediatek.com>
From: Josh Boyer <jwboyer@kernel.org>
Date: Fri, 19 Jan 2018 07:11:19 -0500
Message-ID: <CA+5PVA6np4ZCCxE6Qk9s7UpN3By-3g1sqSg90xrD7BVjKu8ubw@mail.gmail.com>
Subject: Re: pull request: linux-firmware: Update Mediatek MT8173 VPU firmware
To: pochun.lin@mediatek.com
Cc: Linux Firmware <linux-firmware@kernel.org>,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        tiffany.lin@mediatek.com, eddie.huang@mediatek.com,
        wuchengli@google.com, srv_heupstream@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 17, 2018 at 8:35 AM,  <pochun.lin@mediatek.com> wrote:
> The following changes since commit 65b1c68c63f974d72610db38dfae49861117cae2:
>
>   wl18xx: update firmware file 8.9.0.0.76 (2018-01-04 10:06:01 -0500)
>
> are available in the git repository at:
>
>   https://github.com/pochun-lin/linux_fw_vpu_v1.0.8.git v1.0.8
>
> for you to fetch changes up to e72c23c9ff2ceeb3509cb6441cc81f0227edf06d:
>
>   mediatek: update MT8173 VPU firmware to 1.0.8 (2018-01-17 20:19:56 +0800)
>
> ----------------------------------------------------------------
> pochun.lin (1):
>       mediatek: update MT8173 VPU firmware to 1.0.8

Pulled and pushed out.  If the firmware is versioned, perhaps that
version should be listed in the WHENCE file?  You might want to add
that in a future patch.

josh
