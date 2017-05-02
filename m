Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:42329 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750723AbdEBOnv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 May 2017 10:43:51 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Petr Cvek <petr.cvek@tul.cz>, Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/4] [media] pxa_camera: Fix incorrect test in the image size generation
References: <cover.1493612057.git.petr.cvek@tul.cz>
        <1e599794-36e7-3b26-8bb0-57c5b31d3956@tul.cz>
Date: Tue, 02 May 2017 16:43:48 +0200
In-Reply-To: <1e599794-36e7-3b26-8bb0-57c5b31d3956@tul.cz> (Petr Cvek's
        message of "Mon, 1 May 2017 06:21:10 +0200")
Message-ID: <871ss71fq3.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Petr Cvek <petr.cvek@tul.cz> writes:

> During the transfer from the soc_camera a test in pxa_mbus_image_size()
> got removed. Without it any PXA_MBUS_LAYOUT_PACKED format causes either
> the return of a wrong value (PXA_MBUS_PACKING_2X8_PADHI doubles
> the correct value) or EINVAL (PXA_MBUS_PACKING_NONE and
> PXA_MBUS_PACKING_EXTEND16). This was observed in an error from the ffmpeg
> (for some of the YUYV subvariants).
>
> This patch re-adds the same test as in soc_camera version.
>
> Signed-off-by: Petr Cvek <petr.cvek@tul.cz>
Did you test that with YUV422P format ?
If yes, then you can have my ack.

And you should add Hans to the reviewers list, it's his call ultimately, and his
tree which should carry it on.

Cheers.

--
Robert
