Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:35564 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751886AbdF3JvU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 05:51:20 -0400
MIME-Version: 1.0
In-Reply-To: <1498726284-10182-1-git-send-email-bhumirks@gmail.com>
References: <1498726284-10182-1-git-send-email-bhumirks@gmail.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Fri, 30 Jun 2017 10:50:48 +0100
Message-ID: <CA+V-a8sYavDCd3zajLYXzeom-PvBrpBDVTEVmQUBM=NoYZuS2w@mail.gmail.com>
Subject: Re: [PATCH] [media] media/platform: add const to v4l2_file_operations structures
To: Bhumika Goyal <bhumirks@gmail.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>,
        Scott Jiang <scott.jiang.linux@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        adi-buildroot-devel@lists.sourceforge.net,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for the patch.

On Thu, Jun 29, 2017 at 9:51 AM, Bhumika Goyal <bhumirks@gmail.com> wrote:
> Declare v4l2_file_operations structures as const as they are only stored
> in the fops field of video_device structures. This field is of type
> const, so declare v4l2_file_operations structures with similar properties
> as const.
>
> Cross compiled bfin_capture.o for blackfin arch. vpbe_display.o file did
> not cross compile for arm. Could not find any architecture matching the
> configuraion symbol for fsl-viu.c file.
>
s/configuraion/configuration

Ideally the above statement should go below  --- (after the signoff) so that
its not the part of commit message.

> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
> ---
>  drivers/media/platform/davinci/vpbe_display.c  | 2 +-
>  drivers/media/platform/davinci/vpif_capture.c  | 2 +-

For above:
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad
