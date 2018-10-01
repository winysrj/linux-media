Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48800 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729045AbeJAQ3Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2018 12:29:24 -0400
Date: Mon, 1 Oct 2018 12:52:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrey Abramov <st5pub@yandex.ru>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: media: replaced deprecated probe method
Message-ID: <20181001095214.pjp7cshbi3nxq6w5@mwanda>
References: <20181001094229.9148-1-st5pub@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181001094229.9148-1-st5pub@yandex.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 01, 2018 at 12:42:29PM +0300, Andrey Abramov wrote:
> Replaced i2c_driver::probe with i2c_driver::probe_new,
> 	because documentation says that probe method is "soon to be deprecated".
> And fixed problems of the previous attempt.

I'm sorry to complain again...  Please, don't reference the "previous
attempt" in the commit message.  The previous attempt is gone so no one
will remember what you are talking about after tomorrow.  This is how
you resend a patch.

Change the subject to:

Subject: [PATCH v3] Staging: media: replace deprecated probe method

> 
> Signed-off-by: Andrey Abramov <st5pub@yandex.ru>
> ---
>  drivers/staging/media/bcm2048/radio-bcm2048.c | 5 ++---

Then right after the --- line put:

v3:  fix commit message

That part of the commit message will be removed when we apply the patch.

regards,
dan carpenter
