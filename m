Return-Path: <SRS0=A0HE=OJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDDA9C04EB8
	for <linux-media@archiver.kernel.org>; Fri, 30 Nov 2018 20:34:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92D1920660
	for <linux-media@archiver.kernel.org>; Fri, 30 Nov 2018 20:34:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nvHyrZ6U"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 92D1920660
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbeLAHpO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 1 Dec 2018 02:45:14 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41815 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbeLAHpN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 1 Dec 2018 02:45:13 -0500
Received: by mail-pl1-f196.google.com with SMTP id u6so3333236plm.8;
        Fri, 30 Nov 2018 12:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=fqocuYl+0LrdrpO1WvgSdniQsZOr8FgSdBEE+BVBUyY=;
        b=nvHyrZ6UrLcwVouz1iJrFydVO7Kk9CpMSzB50cCu3Lr6lh9eYGkWJfHnNy8cXM0ixG
         Fqki+TVHOqmFXhRwKNGKvbC3yFK8UPkQKpif0q9dV8EnMgCHkJtEBp9oLlxUUbvea34c
         USXS2aPfD5Yf2zjkSACriiqSAZi191NtglnztTJOHhr6HhMJwS4r0xwQH2J39FKcSNfY
         EXpSNZCZCerR1/gOzOgOhzEXKu5861MjxWNBXOILSoBalR6ybYuyUby5kz8FNQG2JwYX
         3A65mahIWcm58fo1segACSJcI9M1ysyeNwt0eZPPUZTV7K/zm4UnM3vuzADTAjSob08S
         FHJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=fqocuYl+0LrdrpO1WvgSdniQsZOr8FgSdBEE+BVBUyY=;
        b=br61H/9vYY75PS5UzwK/zWNzftLay11ICOFmSabTabT7mfG1fStU3rG+exm+Y9bD3m
         WQivXwFp0OOz3eo3L+/8YFsaxAnT562FXgWeX0Qgd79DGDW8TSk3zU7fzWX9homZSV3K
         yMCRuWDo6hZKXCsJ+/xx9mmIduakUOKyQyzsmLiE0o2NK8oZ7I/WKdtEgdGVD2OcqteQ
         mQSdhOZGG0EyD0bms3YvaD/fgCvvjHbj13mvMpobh7PkRVnCgd7O0LxRywW42q+hPS3i
         6l/JJ/dXTAj8e4qm/eec0zF0+7mjSTcGmQ/c7HCV2cckw05XfJflIXYem6SeRaDv2Fv7
         4etA==
X-Gm-Message-State: AA+aEWY/+sqmk3+1ujfLn8MKjMUIINwBc4+ALxJjy/B6aR9dbRXWI+Kp
        yJvtx03Y4M6a26HiiSF+LW8=
X-Google-Smtp-Source: AFSGD/Xf7gJxzxuPAXJ3L4o8oga+CF+XvRzVhQ4p2u3tl5ffcoek1Qlo6Syc/qMuA73YtrJpeGcmkQ==
X-Received: by 2002:a17:902:7005:: with SMTP id y5mr2638491plk.7.1543610084139;
        Fri, 30 Nov 2018 12:34:44 -0800 (PST)
Received: from [192.168.1.101] (122-58-176-92-adsl.sparkbb.co.nz. [122.58.176.92])
        by smtp.gmail.com with ESMTPSA id y6sm19658999pfd.104.2018.11.30.12.34.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Nov 2018 12:34:43 -0800 (PST)
Subject: Re: [PATCH RFC 00/15] Zero ****s, hugload of hugs <3
To:     Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>,
        Kees Cook <keescook@chromium.org>
References: <20181130192737.15053-1-jarkko.sakkinen@linux.intel.com>
 <CAGXu5j+jBNBsD3pvUSfEh6Lc5T1YMpbM0HeG1c6BHiJe+cKVOQ@mail.gmail.com>
 <20181130195652.7syqys76646kpaph@linux-r8p5>
 <d7c34289-f03a-b641-cc9c-00395306511d@kernel.dk>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Axtens <dja@axtens.net>,
        "David S. Miller" <davem@davemloft.net>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>,
        Eric Dumazet <edumazet@google.com>, federico.vaga@vaga.pv.it,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Helge Deller <deller@gmx.de>, Jonathan Corbet <corbet@lwn.net>,
        Joshua Kinard <kumba@gentoo.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-ide@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Linux mtd <linux-mtd@lists.infradead.org>,
        linux-parisc <linux-parisc@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-scsi@vger.kernel.org, matthias.bgg@gmail.com,
        Network Development <netdev@vger.kernel.org>,
        nouveau <nouveau@lists.freedesktop.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Burton <paul.burton@mips.com>,
        Petr Mladek <pmladek@suse.com>, Rob Herring <robh@kernel.org>,
        sean.wang@mediatek.com,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        shannon.nelson@oracle.com, Stefano Brivio <sbrivio@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Tobin C. Harding" <me@tobin.cc>, makita.toshiaki@lab.ntt.co.jp,
        Willem de Bruijn <willemb@google.com>,
        Yonghong Song <yhs@fb.com>, yanjun.zhu@oracle.com
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <f5d88887-6c72-2e95-bd93-b49d8a04e2b0@gmail.com>
Date:   Sat, 1 Dec 2018 09:34:18 +1300
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <d7c34289-f03a-b641-cc9c-00395306511d@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org
Message-ID: <20181130203418.xP537oBn58-lWC6wIilt7015BKVF3Tq4gyA9OzPyDhU@z>

Am 01.12.2018 um 09:12 schrieb Jens Axboe:
> On 11/30/18 12:56 PM, Davidlohr Bueso wrote:
>> On Fri, 30 Nov 2018, Kees Cook wrote:
>>
>>> On Fri, Nov 30, 2018 at 11:27 AM Jarkko Sakkinen
>>> <jarkko.sakkinen@linux.intel.com> wrote:
>>>>
>>>> In order to comply with the CoC, replace **** with a hug.
>>
>> I hope this is some kind of joke. How would anyone get offended by reading
>> technical comments? This is all beyond me...
>
> Agree, this is insanity.

Irony? Parody?

That's what crossed my mind, to be brutally honest. Group hug, anyone?

For the VME vectors case: no need to hug, just don't mess with them.

Cheers,

	Michael

(Waiting for Adrian's ticket machines to swoop down and take me out now 
... in 24 hours ...)

