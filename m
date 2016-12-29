Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:56708 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751843AbcL2Vg0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Dec 2016 16:36:26 -0500
Subject: Re: [PATCH] [media] gp8psk: fix spelling mistake: "firmare" ->
 "firmware"
To: VDR User <user.vdr@gmail.com>
References: <20161229202952.27448-1-colin.king@canonical.com>
 <CAA7C2qjAk6LqTru2zimRr4_JUYXK+4d8VENpyYXjyE0-eJ+RKQ@mail.gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        "mailing list: linux-media" <linux-media@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From: Colin Ian King <colin.king@canonical.com>
Message-ID: <4ebb4c2e-2adc-d54c-69ce-fee427f0cb48@canonical.com>
Date: Thu, 29 Dec 2016 21:35:37 +0000
MIME-Version: 1.0
In-Reply-To: <CAA7C2qjAk6LqTru2zimRr4_JUYXK+4d8VENpyYXjyE0-eJ+RKQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 29/12/16 21:23, VDR User wrote:
>> -                       err("firmare chunk size bigger than 64 bytes.");
>> +                       err("firmware chunk size bigger than 64 bytes.");
> 
> Yup.
> 
>> -                        "HW don't support CMAC encrypiton, use software CMAC encrypiton\n");
>> +                        "HW don't support CMAC encryption, use software CMAC encryption\n");
> 
> Should be: "HW doesn't support CMAC encryption, use software CMAC
> encryption\n");
> 
Very true, I was so focused on the spelling I overlooked the grammar.
I'll re-send with that fixed.

Colin
