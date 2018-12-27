Return-Path: <SRS0=HJwa=PE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C4EEC43387
	for <linux-media@archiver.kernel.org>; Thu, 27 Dec 2018 03:48:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F7DB21479
	for <linux-media@archiver.kernel.org>; Thu, 27 Dec 2018 03:48:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbeL0Dr7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 26 Dec 2018 22:47:59 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38948 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbeL0Dr7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Dec 2018 22:47:59 -0500
Received: by mail-qk1-f193.google.com with SMTP id q70so10268403qkh.6;
        Wed, 26 Dec 2018 19:47:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=flBSzbI1OYoZW+Hfqe5p4rOykPnXqU7IxxbXr//JY3U=;
        b=egybJQAtYgc5U/rl6b1M3T0es1pBgoXI1z6ZLWDrpWxY3FcOTFdRAdZ/hLhAyg9hiD
         Hq5D9Tgh44+YGcMn7qhPGTrOkgBIsX9LaOb5fEBdPaS1DSZz/9WYBiDT9EOtHDqyXV7U
         QBh+ky9D9+vb25vNiNDUG2xfvYjiJ+bdFaHBNvzAq4zES8j+40FOZvPuhLr/MVfqi5nY
         pzADgNeGCK4NwkbdjULPE8KygdscoAyMviwOT5uAY7seTwpWk3EKE7ck8kOZ2YS0L26i
         Vr6lW2b6pBgAk7G9Ter4BP71gLAx1AUTHZsZ3G/vNNUdwwE2ol6drwGhjul5xz/xjw1S
         th1Q==
X-Gm-Message-State: AJcUukeXEmqmLoZJ9yRRL6FK6NLuycCiPeEZhWR3MdK3J+Ykr9r30t5f
        aTQtl1omy4HW0Hy3Jpd/PoOtQQkQ3NATrds9Fw0=
X-Google-Smtp-Source: ALg8bN5rhvknZBezQAC985fWjmYM5DUZsu0cl2BfGcKp3HcNpRczUwi7R9pDHnliTQ5Rm5lYbTNRqOHVb2lHbIV9sGA=
X-Received: by 2002:ae9:dc43:: with SMTP id q64mr19584970qkf.223.1545882478316;
 Wed, 26 Dec 2018 19:47:58 -0800 (PST)
MIME-Version: 1.0
References: <20181226055809.74979-1-kjlu@umn.edu>
In-Reply-To: <20181226055809.74979-1-kjlu@umn.edu>
From:   Michael Ira Krufky <mkrufky@linuxtv.org>
Date:   Wed, 26 Dec 2018 22:47:46 -0500
Message-ID: <CAOcJUbzr+cQ-Dk4HrYEgkRhgRPMeXAc_ZrXkp1ChKHAW5Rw+Tg@mail.gmail.com>
Subject: Re: [PATCH] usb: dvb: check status of mxl111sf_read_reg
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Kangjie,

On Wed, Dec 26, 2018 at 12:59 AM Kangjie Lu <kjlu@umn.edu> wrote:
>
> When mxl111sf_read_reg fails, we shouldn't use "mode". The fix checks
> its return value using mxl_fail
>
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
>  drivers/media/usb/dvb-usb-v2/mxl111sf-phy.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-phy.c b/drivers/media/usb/dvb-usb-v2/mxl111sf-phy.c
> index ffb6e7c72f57..aecc3d02fc1e 100644
> --- a/drivers/media/usb/dvb-usb-v2/mxl111sf-phy.c
> +++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-phy.c
> @@ -130,7 +130,8 @@ int mxl111sf_config_mpeg_in(struct mxl111sf_state *state,
>         mxl_fail(ret);
>
>         /* Configure MPEG Clock phase */
> -       mxl111sf_read_reg(state, V6_MPEG_IN_CLK_INV_REG, &mode);
> +       ret = mxl111sf_read_reg(state, V6_MPEG_IN_CLK_INV_REG, &mode);
> +       mxl_fail(ret);
>
>         if (clock_phase == TSIF_NORMAL)
>                 mode &= ~V6_INVERTED_CLK_PHASE;
> --
> 2.17.2 (Apple Git-113)

It *looks* correct, however....

If I recall correctly, this chip will often fail when reading
registers.   Notice, `mode` is initialized to zero at first, and not
again touched before being passed to the readreg function - this is on
purpose.   The value remains untouched if the read fails. ....and the
read _wil_ fail.  Maybe not always, but sometimes.

When you run with the patch applied, does it just spew errors?

-Mike
