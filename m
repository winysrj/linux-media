Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:33177 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758627AbcCVL02 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2016 07:26:28 -0400
MIME-Version: 1.0
In-Reply-To: <1458603130-6158-1-git-send-email-colin.king@canonical.com>
References: <1458603130-6158-1-git-send-email-colin.king@canonical.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Tue, 22 Mar 2016 11:25:57 +0000
Message-ID: <CA+V-a8sARRBC5XnXpK-Pzv2e_xx9XoazhBx=C0gM5uV4_izuOg@mail.gmail.com>
Subject: Re: [PATCH] [media] media: am437x-vpfe: ensure ret is initialized
To: Colin King <colin.king@canonical.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Colin,

On Mon, Mar 21, 2016 at 11:32 PM, Colin King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> ret should be initialized to 0; for example if pfe->fmt.fmt.pix.field
> is V4L2_FIELD_NONE then ret will contain garbage from the
> uninitialized state causing garbage to be returned if it is non-zero.
>
Thanks for the patch, patch [1] fixing this issue is already posted in ML.

[1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg95562.html

Cheers,
--Prabhakar Lad
