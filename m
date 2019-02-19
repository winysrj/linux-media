Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C416AC43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 19:02:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83F1021773
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 19:02:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S7Uq0Ju9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfBSTCD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 14:02:03 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34290 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbfBSTCD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 14:02:03 -0500
Received: by mail-pg1-f193.google.com with SMTP id i130so10572315pgd.1
        for <linux-media@vger.kernel.org>; Tue, 19 Feb 2019 11:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gtsKzGZqZcEeqCtrlGrKFSS3Xlk4GR0b9j+cV2Z6OlM=;
        b=S7Uq0Ju9LGIVvcWpuHguWFswOzlT1EJlhWdUHNB3rZVHqNVE8CNd4u2+v6cx/5XMtk
         dKoIk/LTUylF49758DJaO7zJGwCWZsEJgmBxpavyc2zCWMckA8rNThJ+/qg+Gc/BD6v3
         BH42RgVnZ402ngYOm7a0RyUEq6+hr1jbhcAMQrFYKCIHLzJnX5orblSKiXVoMchRlPD0
         mfoUjorp3lOLsyG/68vnjkRWJzpnkKthXVzo5qoKdOOwtG1Idjf16ufMivedjKep05Gq
         lzeLHXSWCQzwzaqp52fzTGrQ7oPCM65L2qPW1CKzljNHfNLKTNVxK5co44pHM3VQzYCn
         fRyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gtsKzGZqZcEeqCtrlGrKFSS3Xlk4GR0b9j+cV2Z6OlM=;
        b=sO0oar5AX5WwG24qzSK1TjkD/V/d1c2dI0YXpRnyyGevi/oQyPGFWFzn8ZVgFv534+
         7qOZPbIwV01FGQAzeOEgq8kJq5yGaWGzhoj21oH3ca1VGlxUvwcYiHel6Rww1Zwet2Rg
         NmJsDGV/w0xxJLqdDGwikrfy6YFAHTXzf54esgilfkEIjq6+xHypzdVKGgeftnZAVLSw
         IWWHqaauSp9a4ICiYCKkI8bW03XzmglCN1vc3IX+9HsPlSjbZR1C9BTUc6+x614b9YXL
         UwrFVdSmcnYz0hIAW7dscmuVovkJzSREFmQhHWMnCgvDs1xEX5zgaNo+2Z2xK1uHOHID
         yGDw==
X-Gm-Message-State: AHQUAuafoPWUulFZtq+AHT2Mf/COeLVUbRD23yEF0nSGTvNdeYX1qna7
        QlMTWV8GWIwv1MkJosnTlYFri6mwSJVJzak4jIjJ6w==
X-Google-Smtp-Source: AHgI3Iaw9XKzZ6dSlNBhxHpitiL5p+wxw8gzwI1SHLaZWKil29RltCemISNvIm3D0lTzkmBFh28EGjEl24VOOZG872k=
X-Received: by 2002:aa7:8249:: with SMTP id e9mr30849734pfn.93.1550602922228;
 Tue, 19 Feb 2019 11:02:02 -0800 (PST)
MIME-Version: 1.0
References: <20190219170209.4180739-1-arnd@arndb.de> <20190219170209.4180739-2-arnd@arndb.de>
In-Reply-To: <20190219170209.4180739-2-arnd@arndb.de>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 19 Feb 2019 11:01:51 -0800
Message-ID: <CAKwvOdm2fr6Xh9Tezexq4RGinkJy6P0_L6jQOMoZfArbgmaKJQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] media: vicodec: avoic clang frame size warning
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Dafna Hirschfeld <dafna3@gmail.com>,
        Tom aan de Wiel <tom.aandewiel@gmail.com>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Feb 19, 2019 at 9:02 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> Clang-9 makes some different inlining decisions compared to gcc, which
> leads to a warning about a possible stack overflow problem when building
> with CONFIG_KASAN, including when setting asan-stack=0, which avoids
> most other frame overflow warnings:
>
> drivers/media/platform/vicodec/codec-fwht.c:673:12: error: stack frame size of 2224 bytes in function 'encode_plane'
>
> Manually adding noinline_for_stack annotations in those functions

Thanks for the fix! In general, for -Wstack-frame-larger-than=
warnings, is it possible that these sets of stack frames are already
too large if entered?  Sure, inlining was a little aggressive, causing
more stack space use than maybe otherwise necessary at runtime, but
isn't it also possible that "no inlining" a stack frame can still be a
problem should the stack frame be entered?  Doesn't the kernel have a
way of estimating the stack depth for any given frame?  I guess I was
always curious if the best fix for these kind of warnings was to
non-stack allocate (kmalloc) certain locally allocated structs, or
no-inline the function.  Surely there's cases where no-inlining is
safe, but I was curious if it's still maybe dangerous to enter the
problematic child most stack frame?

> called by encode_plane() or decode_plane() that require a significant
> amount of kernel stack makes this impossible to happen with any
> compiler.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/platform/vicodec/codec-fwht.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/media/platform/vicodec/codec-fwht.c b/drivers/media/platform/vicodec/codec-fwht.c
> index d1d6085da9f1..135d56bcc2c5 100644
> --- a/drivers/media/platform/vicodec/codec-fwht.c
> +++ b/drivers/media/platform/vicodec/codec-fwht.c
> @@ -47,7 +47,7 @@ static const uint8_t zigzag[64] = {
>  };
>
>
> -static int rlc(const s16 *in, __be16 *output, int blocktype)
> +static int noinline_for_stack rlc(const s16 *in, __be16 *output, int blocktype)
>  {
>         s16 block[8 * 8];
>         s16 *wp = block;
> @@ -106,8 +106,8 @@ static int rlc(const s16 *in, __be16 *output, int blocktype)
>   * This function will worst-case increase rlc_in by 65*2 bytes:
>   * one s16 value for the header and 8 * 8 coefficients of type s16.
>   */
> -static u16 derlc(const __be16 **rlc_in, s16 *dwht_out,
> -                const __be16 *end_of_input)
> +static noinline_for_stack u16
> +derlc(const __be16 **rlc_in, s16 *dwht_out, const __be16 *end_of_input)
>  {
>         /* header */
>         const __be16 *input = *rlc_in;
> @@ -373,7 +373,8 @@ static void fwht(const u8 *block, s16 *output_block, unsigned int stride,
>   * Furthermore values can be negative... This is just a version that
>   * works with 16 signed data
>   */
> -static void fwht16(const s16 *block, s16 *output_block, int stride, int intra)
> +static void noinline_for_stack
> +fwht16(const s16 *block, s16 *output_block, int stride, int intra)
>  {
>         /* we'll need more than 8 bits for the transformed coefficients */
>         s32 workspace1[8], workspace2[8];
> @@ -456,7 +457,8 @@ static void fwht16(const s16 *block, s16 *output_block, int stride, int intra)
>         }
>  }
>
> -static void ifwht(const s16 *block, s16 *output_block, int intra)
> +static noinline_for_stack void
> +ifwht(const s16 *block, s16 *output_block, int intra)
>  {
>         /*
>          * we'll need more than 8 bits for the transformed coefficients
> @@ -604,9 +606,9 @@ static int var_inter(const s16 *old, const s16 *new)
>         return ret;
>  }
>
> -static int decide_blocktype(const u8 *cur, const u8 *reference,
> -                           s16 *deltablock, unsigned int stride,
> -                           unsigned int input_step)
> +static noinline_for_stack int
> +decide_blocktype(const u8 *cur, const u8 *reference, s16 *deltablock,
> +                unsigned int stride, unsigned int input_step)
>  {
>         s16 tmp[64];
>         s16 old[64];
> --
> 2.20.0
>


-- 
Thanks,
~Nick Desaulniers
