Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:38414 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754250AbdKGJCh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Nov 2017 04:02:37 -0500
Date: Tue, 7 Nov 2017 07:02:30 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Colin King <colin.king@canonical.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Antti Palosaari <crope@iki.fi>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] au0828: fix spelling mistake: "synchronuously" ->
 "synchronously"
Message-ID: <20171107070230.0440bec2@vento.lan>
In-Reply-To: <20171102101153.18225-1-colin.king@canonical.com>
References: <20171102101153.18225-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu,  2 Nov 2017 10:11:47 +0000
Colin King <colin.king@canonical.com> escreveu:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Trivial fix to spelling mistake in error message text
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/media/usb/au0828/au0828-video.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Colin,

Patches fold and applied.

For trivial changes like that, please group them per drivers/media
subdir.

Regards,
Mauro

Thanks,
Mauro
