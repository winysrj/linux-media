Return-Path: <SRS0=A18R=PL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D05AC43387
	for <linux-media@archiver.kernel.org>; Thu,  3 Jan 2019 15:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73B572070D
	for <linux-media@archiver.kernel.org>; Thu,  3 Jan 2019 15:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730371AbfACPXj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 3 Jan 2019 10:23:39 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:45201 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728208AbfACPXi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Jan 2019 10:23:38 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id f4qLgSHvyHD0Df4qOggFN5; Thu, 03 Jan 2019 16:23:36 +0100
Subject: Re: [PATCH v5] media: vicodec: add support for CROP and COMPOSE
 selection
To:     Dafna Hirschfeld <dafna3@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20181229152009.130656-1-dafna3@gmail.com>
 <d7ea78de-136a-0a5b-d6dd-3ecc1b7ac1ad@xs4all.nl>
 <CAJ1myNRbLDKTAZPq5f45p2uzWTg7qBVNYBZPfc3d1WYJNHCN2Q@mail.gmail.com>
 <e814d5fe-ded2-8e3a-bd57-88cf266d14d9@xs4all.nl>
 <CAJ1myNT2nd=WejDWZV6PKamg5Y1wgZbHr8sDohtbQLA3DPQxrQ@mail.gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <352e3c03-7492-46c4-17d8-87f29026d7d1@xs4all.nl>
Date:   Thu, 3 Jan 2019 16:23:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <CAJ1myNT2nd=WejDWZV6PKamg5Y1wgZbHr8sDohtbQLA3DPQxrQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfJ3Z6JMZ5sE+37rzkQMVqgW8abVChjXLLJrxwmcvCLraWdQpMw16ajcNXqEYV4Z/IXsNVkGK8aHHKBCQqru1g3wmiHWnxG9Tp77gyRZBWY1pgVPVlffS
 7IP97wFhob7dxpI8OGV5z9SZzZOZIClqSpBF2v2DWy1mS3g2Vpsfl62wPkNq0SxCewKGR0NEDat/IEjKJn9MuFsJqjoW5q58IiA=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 01/03/2019 04:15 PM, Dafna Hirschfeld wrote:
> On Wed, Jan 2, 2019 at 12:22 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:

<snip>

>>>     >       if (frm->components_num >= 3) {
>>>     > -             u32 chroma_h = frm->height / frm->height_div;
>>>     > -             u32 chroma_w = frm->width / frm->width_div;
>>>     > +             u32 chroma_h = height / frm->height_div;
>>>     > +             u32 chroma_w = width / frm->width_div;
>>>     > +             u32 chroma_coded_width = frm->coded_width / frm->width_div;
>>>
>>>     chroma_stride = frm->stride / frm->width_div;
> 
> This calculation of chroma_stride does not work for formats such as
> YUYV where  frm->width_div = 2 but the chromas are not in separate
> planes.
> How do I calculate the stride in general ?

For interleaved formats like YUYV the stride is equal to bytesperline.
To be more precise: bytesperline is the stride for the first plane. Since YUYV
formats have only one plane, that stride is valid for all color components.

> For yuv420 for example, where the chromas are in separate planes, is
> 'chroma_stride = stride / 2' ?

Yes.

> 
>>>
>>>     >               unsigned int chroma_size = chroma_h * chroma_w;
>>>     >
>>>     >               rlco_max = rlco + chroma_size / 2 - 256;
>>>     >               encoding |= encode_plane(frm->cb, ref_frm->cb, &rlco, rlco_max,
>>>     >                                        cf, chroma_h, chroma_w,
>>>     > -                                      frm->chroma_step,
>>>     > +                                      chroma_coded_width, frm->chroma_step,
>>>     >                                        is_intra, next_is_intra);
>>>     >               if (encoding & FWHT_FRAME_UNENCODED)
>>>     >                       encoding |= FWHT_CB_UNENCODED;
>>>     > @@ -778,7 +784,7 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
>>>     >               rlco_max = rlco + chroma_size / 2 - 256;
>>>     >               encoding |= encode_plane(frm->cr, ref_frm->cr, &rlco, rlco_max,
>>>     >                                        cf, chroma_h, chroma_w,
>>>     > -                                      frm->chroma_step,
>>>     > +                                      chroma_coded_width, frm->chroma_step,
>>>     >                                        is_intra, next_is_intra);
>>>     >               if (encoding & FWHT_FRAME_UNENCODED)
>>>     >                       encoding |= FWHT_CR_UNENCODED;
>>>     > @@ -788,8 +794,8 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
>>>     >       if (frm->components_num == 4) {
>>>     >               rlco_max = rlco + size / 2 - 256;
>>>     >               encoding |= encode_plane(frm->alpha, ref_frm->alpha, &rlco,
>>>     > -                                      rlco_max, cf, frm->height, frm->width,
>>>     > -                                      frm->luma_alpha_step,
>>>     > +                                      rlco_max, cf, height, width,
>>>     > +                                      frm->coded_width, frm->luma_alpha_step,
>>>     >                                        is_intra, next_is_intra);
>>>     >               if (encoding & FWHT_FRAME_UNENCODED)
>>>     >                       encoding |= FWHT_ALPHA_UNENCODED;
>>>     > @@ -801,7 +807,7 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
>>>     >  }
>>>     >
>>>     >  static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
>>>     > -                      u32 height, u32 width, bool uncompressed)
>>>     > +                      u32 height, u32 width, u32 coded_width, bool uncompressed)
>>>
>>>     coded_width is OK here since you are writing into 'ref' and not the vb2 capture buffer.
> 
> 
> Actually I think coded_width is not needed at all for the decoder
> because it only use the internal ref_frame buffer.
> So the width and height are enough.

I'm not 100% certain. Specifically for 4:2:0 formats where the width/height
has to be a multiple of 16 instead of 8. So you might need the coded_width/height
to handle that correctly. You would have to check this carefully.

Regards,

	Hans
