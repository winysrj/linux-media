Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35F69C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 19:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00F9621738
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 19:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfBST4d (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 14:56:33 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:38475 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725807AbfBST4d (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 14:56:33 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id wBVBgleFzLMwIwBVEgqtzT; Tue, 19 Feb 2019 20:56:31 +0100
Subject: Re: [PATCH 2/3] media: vicodec: avoic clang frame size warning
To:     Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Mark Brown <broonie@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Dafna Hirschfeld <dafna3@gmail.com>,
        Tom aan de Wiel <tom.aandewiel@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190219170209.4180739-1-arnd@arndb.de>
 <20190219170209.4180739-2-arnd@arndb.de>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <eaf45207-2741-2e0d-4ae4-aabb36e4417d@xs4all.nl>
Date:   Tue, 19 Feb 2019 20:56:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190219170209.4180739-2-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfB8XEDPigTwbqan9jvvIRl53y+bOjIGampXSDthERoMDOuK1YH07MaVhxIMTMHjxVCI8rbf2HPXJ0+/ODoWfj43k7km5czVmyt2y/EMb3x5MCzo4TQGT
 X3xeViJ3fSFseZONrwqy+e0epVG6AsYXlJ9/qArzlXIBXQ5S9QFnq9cbTYRSNdfBm6fe0RmhA/jyAx8W6HQGG0sJmg3mh/Zf1zwmWLN2/lNHW1Vs7FqCwUaK
 pNHAgfCEopUzP9Dxcs6+VGQBAxZfyQgQQEMkqaNtXCJQ+bXaRWexV5CRzIJnwu15OgiXz7d4dQ6pKSfADPB4sqIo7i1dRH25C2+TJLSKAaz9IByOCWjIDCpU
 Q9L2kdwCgM4a8lLpDFyIVcCT6Y6fyImK+Cx9aPyR6Nh2pJuTK9kzjDzxZuTWWDSQPk9d7iSsbkC7ygQOgVOKLKJsFL9DXh/+NxM7cwtAQU78dq1H7jLCHKnO
 uGdG48Fj+eBRjjVP
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/19/19 6:01 PM, Arnd Bergmann wrote:
> Clang-9 makes some different inlining decisions compared to gcc, which
> leads to a warning about a possible stack overflow problem when building
> with CONFIG_KASAN, including when setting asan-stack=0, which avoids
> most other frame overflow warnings:
> 
> drivers/media/platform/vicodec/codec-fwht.c:673:12: error: stack frame size of 2224 bytes in function 'encode_plane'
> 
> Manually adding noinline_for_stack annotations in those functions
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
>  	s16 block[8 * 8];
>  	s16 *wp = block;
> @@ -106,8 +106,8 @@ static int rlc(const s16 *in, __be16 *output, int blocktype)
>   * This function will worst-case increase rlc_in by 65*2 bytes:
>   * one s16 value for the header and 8 * 8 coefficients of type s16.
>   */
> -static u16 derlc(const __be16 **rlc_in, s16 *dwht_out,
> -		 const __be16 *end_of_input)
> +static noinline_for_stack u16
> +derlc(const __be16 **rlc_in, s16 *dwht_out, const __be16 *end_of_input)
>  {
>  	/* header */
>  	const __be16 *input = *rlc_in;
> @@ -373,7 +373,8 @@ static void fwht(const u8 *block, s16 *output_block, unsigned int stride,
>   * Furthermore values can be negative... This is just a version that
>   * works with 16 signed data
>   */
> -static void fwht16(const s16 *block, s16 *output_block, int stride, int intra)
> +static void noinline_for_stack
> +fwht16(const s16 *block, s16 *output_block, int stride, int intra)
>  {
>  	/* we'll need more than 8 bits for the transformed coefficients */
>  	s32 workspace1[8], workspace2[8];
> @@ -456,7 +457,8 @@ static void fwht16(const s16 *block, s16 *output_block, int stride, int intra)
>  	}
>  }
>  
> -static void ifwht(const s16 *block, s16 *output_block, int intra)
> +static noinline_for_stack void
> +ifwht(const s16 *block, s16 *output_block, int intra)
>  {

Please add it for fwht as well. It makes no sense to have it for fwht16, ifwht
but not the fwht function.

Got to say this is all very magic...

I think it would be good to perhaps have a comment at the start of the source
that explains why noinline_for_stack is added to selected functions.

Patches 1 & 3 are fine, BTW.

Regards,

	Hans

>  	/*
>  	 * we'll need more than 8 bits for the transformed coefficients
> @@ -604,9 +606,9 @@ static int var_inter(const s16 *old, const s16 *new)
>  	return ret;
>  }
>  
> -static int decide_blocktype(const u8 *cur, const u8 *reference,
> -			    s16 *deltablock, unsigned int stride,
> -			    unsigned int input_step)
> +static noinline_for_stack int
> +decide_blocktype(const u8 *cur, const u8 *reference, s16 *deltablock,
> +		 unsigned int stride, unsigned int input_step)
>  {
>  	s16 tmp[64];
>  	s16 old[64];
> 

