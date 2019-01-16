Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 091FFC43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 21:43:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDA4420652
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 21:43:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iAO3Atbc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731167AbfAPVnA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 16:43:00 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55266 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730413AbfAPVnA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 16:43:00 -0500
Received: by mail-wm1-f68.google.com with SMTP id a62so3659919wmh.4
        for <linux-media@vger.kernel.org>; Wed, 16 Jan 2019 13:42:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2WVRY8GKXyY3QSuzj2BhlBqQ2Wh93Dwb8Cj9TnwPPRs=;
        b=iAO3AtbcO/S32PhQODDtrMbMitAshpjsXz45U08P8cLrGmeO23DtDyHeRzKqlZwPYT
         q7Ncyyy6EipCmGC6UVXqHv3PDkyxLsq4nrecdwhMATO02UuIXSnzRLnI7tk2pRHUihTq
         APMlnz9eBzNFp+/QIRe01MSDcvhd+f/pNETkviV6VNiIT2XxF3jZ5Sk9IAwA3jc9MqAQ
         yeaMrdYVFLQBDM3x5FznqP0yrYoq33IlBQHUPlyAr1pOnsX3yp6r+Fd/DGYSH34bP4UF
         9bLi3PrKPqANHuwpkux+lXPgNXhtkParL8+2NjzpHXWcaIVH0iD0kF+EMHWzAQ2TifGZ
         lc6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2WVRY8GKXyY3QSuzj2BhlBqQ2Wh93Dwb8Cj9TnwPPRs=;
        b=ivT44WzLHLON1SqUhW+1vN36Msy9+JLc56sBCLE9vKnoEKQcSWqdyi/P0mRypymWcp
         8Jqef5tOyovhPn9sOjnMJ+ScFXcPz/XzfYM7gE59R1APIblcJIya6u8zBpnevFIZgYX0
         U8TxY5nNZM8kHfTN0apHG8EibioB+rcpbv9D6ps3+vhAHpgf2IepD5X5lKo4d8W4aLfX
         rQTt/88Ui/dHBYephipi/xUB9FmyvuGAB/8qNHJevNErjTA9nssJ3NK8mMwI5wUB6ITD
         M92PruTW9tqtc6zpwQfd4dUVo65/RVFWimKiILtjsFnru85QCRjKHfI7Uj6H0n5Dp2t1
         Wibg==
X-Gm-Message-State: AJcUukeK2cTN4ono689TY1AUm4hxSLPKhFcAzJiWlJqiOMkcwZ+opSVQ
        F5DGJdg4Wj+z8/OUKohUIId2i1CS5xguotlGs1Rc/w==
X-Google-Smtp-Source: ALg8bN6zSiEbhePhE1BAchqskkfEYEvZW++g2NTEASH65JFRhQIEwIL1/9ITmIZ+ig7nUhgMPJ644dRp+hi9tRHRuUg=
X-Received: by 2002:a7b:c5d1:: with SMTP id n17mr9157519wmk.152.1547674978050;
 Wed, 16 Jan 2019 13:42:58 -0800 (PST)
MIME-Version: 1.0
References: <1547616190-24085-1-git-send-email-james.hilliard1@gmail.com>
 <20190116122409.0968a154@coco.lan> <CADvTj4q=6mYR0Fo3e2Met9yNxmyy8z_a7bbzxfgPMY63ZF4g1A@mail.gmail.com>
 <20190116190802.05dbffa5@coco.lan>
In-Reply-To: <20190116190802.05dbffa5@coco.lan>
From:   James Hilliard <james.hilliard1@gmail.com>
Date:   Wed, 16 Jan 2019 14:42:45 -0700
Message-ID: <CADvTj4pk_znY1zxJqf0a23kry_4b_rWMY57k1ftfwjn8wUKp2A@mail.gmail.com>
Subject: Re: [PATCH zbar 1/1] v4l2: add fallback for systems without V4L2_CTRL_WHICH_CUR_VAL
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Jan 16, 2019 at 2:08 PM Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
>
> Em Wed, 16 Jan 2019 13:34:29 -0700
> James Hilliard <james.hilliard1@gmail.com> escreveu:
>
> > > See the enclosed patch. I tested it here with Kernel 4.20 and works
> > > fine.
> > I'll test it on the system I had which needed the fallback.
>
> Ok. Please let me know once you test it.
Tested now, looks good to me.
>
>
> Thanks,
> Mauro
