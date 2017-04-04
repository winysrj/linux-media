Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:38593 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752227AbdDDCak (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Apr 2017 22:30:40 -0400
Date: Tue, 04 Apr 2017 11:30:38 +0900
From: Andi Shyti <andi.shyti@samsung.com>
To: Alexey Ignatov <lexszero@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>
Subject: Re: [PATCH] [media] lirc_dev: fix regression in feature check logic in
 ioctl
Message-id: <20170404022951.6sjwgobn3jl6bwxr@gangnam.samsung>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <20170403231916.22881-1-lexszero@gmail.com>
References: <CGME20170403232013epcas5p29f40704fb57de62bf45369d5b6442a88@epcas5p2.samsung.com>
 <20170403231916.22881-1-lexszero@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alexey,

this has been already fixed in commit bd291208d7f5 ("[media]
lirc_dev: LIRC_{G,S}ET_REC_MODE do not work") by Sean.

You need to update your kernel or cherry-pick this patch.

In any case, for future patches of this kind, some notes through
the lines:

On Tue, Apr 04, 2017 at 02:19:16AM +0300, Alexey Ignatov wrote:
> Commit 273b902a5b1bfd6977a73c4de3eb96db3cb103cb removed inversion in

References to commit should be of the kind:

Commit 273b902a5b1b ("[media] lirc_dev: use LIRC_CAN_REC() define
to check if the device can receive")

Please run checkpatch.pl before sending the patch.

> features check conditionals (by accident, perhaps). That change resulted
> in erroneous reporting that device can't receive while actually it can.
> Fix this.
> 
> Signed-off-by: Alexey Ignatov <lexszero@gmail.com>

Here goes:

Fixes: 273b902a5b1b ("[media] lirc_dev: use LIRC_CAN_REC() define to check if the device can receive")
Cc: <stable@vger.kernel.org>

because it fixes a bug (check Sean's patch).

Thanks,
Andi
