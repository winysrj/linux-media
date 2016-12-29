Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:33044 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750886AbcL2VXO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Dec 2016 16:23:14 -0500
MIME-Version: 1.0
In-Reply-To: <20161229202952.27448-1-colin.king@canonical.com>
References: <20161229202952.27448-1-colin.king@canonical.com>
From: VDR User <user.vdr@gmail.com>
Date: Thu, 29 Dec 2016 13:23:13 -0800
Message-ID: <CAA7C2qjAk6LqTru2zimRr4_JUYXK+4d8VENpyYXjyE0-eJ+RKQ@mail.gmail.com>
Subject: Re: [PATCH] [media] gp8psk: fix spelling mistake: "firmare" -> "firmware"
To: Colin King <colin.king@canonical.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        "mailing list: linux-media" <linux-media@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -                       err("firmare chunk size bigger than 64 bytes.");
> +                       err("firmware chunk size bigger than 64 bytes.");

Yup.

> -                        "HW don't support CMAC encrypiton, use software CMAC encrypiton\n");
> +                        "HW don't support CMAC encryption, use software CMAC encryption\n");

Should be: "HW doesn't support CMAC encryption, use software CMAC
encryption\n");
