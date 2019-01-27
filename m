Return-Path: <SRS0=npIJ=QD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72023C282CA
	for <linux-media@archiver.kernel.org>; Sun, 27 Jan 2019 16:32:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3631F2146E
	for <linux-media@archiver.kernel.org>; Sun, 27 Jan 2019 16:32:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pdCaRJSi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfA0QcE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 27 Jan 2019 11:32:04 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43206 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbfA0QcE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Jan 2019 11:32:04 -0500
Received: by mail-lj1-f193.google.com with SMTP id q2-v6so12163410lji.10;
        Sun, 27 Jan 2019 08:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TNuGZKsr/Se4zO4haJyYSCDu8sTtvIigBOVsFMaS83U=;
        b=pdCaRJSia8DH9oSIN3SDMxF1xjzfXW5xVT//whl6ChyJ7hnqQdYLNq5CYvfcrQKVTZ
         IDD+LY6ZH0ZRF+BoLM5iRDuh0n2vQeczc7YBvBv+zOHLj19wrH05KalWqBet6FzZqexl
         spoeAbFK69P7/8qfvw1tQ0U8cSPZmV4bgfWUgLgW1GkQDOX4TjdkQxiBI6kRkxU/MAQs
         wNjzZRNdOv8IWMurMCVNqZwwL0O/xFNLq7DWD5RIvKRbVEF6ZOXbhvND9CeqzhEphXKt
         E3a1cCqUXWquXaNel4QAx4gLkXLUxdayXMf/16dinv1pFV5MKll+M0o5K5RoCxm8cXym
         JC1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TNuGZKsr/Se4zO4haJyYSCDu8sTtvIigBOVsFMaS83U=;
        b=FNkVoXXaTuO4x2cmvVnUda/MlQgg1zzkpwJPqR6kiC0LVCfqzQCqG/BagfLM/Xrnpt
         2M5vlPU7PXQlCa9yJW24bJrOw2xtlpT+0klDSQ1+HtSjHDcfmv8R0RmB+N8FVSQg8J0w
         xLe+mWA+FFgckkqm9+CWUpduv5cV2NTfPLTiyuyCyW6Qyks9OBSERqaTRlX4wSuAb7uF
         +wGASoxqSmRcu5LaNN9aQgK8EqHmkhzz98Gux2O5/TciXD58+jf4CMZHALG5VS1nmQVe
         BelQyhSYuCtOWlCOcgtrTXBYCPIlvYdmuWJDFeuPl7ArGf6YP+AKFrChinIoIhFU52qF
         XGvg==
X-Gm-Message-State: AJcUukfKaCUCbVTiT3GQxdsQubfUSpuZ2S6/ToK2/9EFL8rj2RG3BNJ3
        nXDeZdaGXp7rsmoEPg2XvVnLKJxEURG9GcdS/AY=
X-Google-Smtp-Source: AHgI3IYTelA/mDwxgSI1nVtOZSWHPwvFkDv/ks1hHs3lsBty1vY7v0F3Hc/JzZMGIRV0Xo15bof1wCVBJdLMJHZvf3k=
X-Received: by 2002:a2e:5703:: with SMTP id l3-v6mr3295856ljb.106.1548606721227;
 Sun, 27 Jan 2019 08:32:01 -0800 (PST)
MIME-Version: 1.0
References: <CGME20190111150806epcas2p4ecaac58547db019e7dc779349d495f4d@epcas2p4.samsung.com>
 <20190111151154.GA2819@jordon-HP-15-Notebook-PC> <241810e0-2288-c59b-6c21-6d853d9fe84a@samsung.com>
 <CAFqt6zbYHq-pS=rGx+3ncJ7rO-LvL5=iOou21oguKjrc=3qouA@mail.gmail.com> <febb9775-20da-69d5-4f0e-cd87253eb8f9@samsung.com>
In-Reply-To: <febb9775-20da-69d5-4f0e-cd87253eb8f9@samsung.com>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Sun, 27 Jan 2019 22:01:52 +0530
Message-ID: <CAFqt6zazAymL69a6_JHF4SjHRC_NB8zSA=E-hC-dQ71hS9mKcA@mail.gmail.com>
Subject: Re: [PATCH 7/9] videobuf2/videobuf2-dma-sg.c: Convert to use vm_insert_range_buggy
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@suse.com>, pawel@osciak.com,
        Kyungmin Park <kyungmin.park@samsung.com>, mchehab@kernel.org,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        robin.murphy@arm.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Marek,

On Fri, Jan 25, 2019 at 5:58 PM Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
>
> Hi Souptick,
>
> On 2019-01-25 05:55, Souptick Joarder wrote:
> > On Tue, Jan 22, 2019 at 8:37 PM Marek Szyprowski
> > <m.szyprowski@samsung.com> wrote:
> >> On 2019-01-11 16:11, Souptick Joarder wrote:
> >>> Convert to use vm_insert_range_buggy to map range of kernel memory
> >>> to user vma.
> >>>
> >>> This driver has ignored vm_pgoff. We could later "fix" these drivers
> >>> to behave according to the normal vm_pgoff offsetting simply by
> >>> removing the _buggy suffix on the function name and if that causes
> >>> regressions, it gives us an easy way to revert.
> >> Just a generic note about videobuf2: videobuf2-dma-sg is ignoring vm_p=
goff by design. vm_pgoff is used as a 'cookie' to select a buffer to mmap a=
nd videobuf2-core already checks that. If userspace provides an offset, whi=
ch doesn't match any of the registered 'cookies' (reported to userspace via=
 separate v4l2 ioctl), an error is returned.
> > Ok, it means once the buf is selected, videobuf2-dma-sg should always
> > mapped buf->pages[i]
> > from index 0 ( irrespective of vm_pgoff value). So although we are
> > replacing the code with
> > vm_insert_range_buggy(), *_buggy* suffix will mislead others and
> > should not be used.
> > And if we replace this code with  vm_insert_range(), this will
> > introduce bug for *non zero*
> > value of vm_pgoff.
> >
> > Please correct me if my understanding is wrong.
>
> You are correct. IMHO the best solution in this case would be to add
> following fix:
>
>
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c
> b/drivers/media/common/videobuf2/videobuf2-core.c
> index 70e8c3366f9c..ca4577a7d28a 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -2175,6 +2175,13 @@ int vb2_mmap(struct vb2_queue *q, struct
> vm_area_struct *vma)
>          goto unlock;
>      }
>
> +    /*
> +     * vm_pgoff is treated in V4L2 API as a 'cookie' to select a buffer,
> +     * not as a in-buffer offset. We always want to mmap a whole buffer
> +     * from its beginning.
> +     */
> +    vma->vm_pgoff =3D 0;
> +
>      ret =3D call_memop(vb, mmap, vb->planes[plane].mem_priv, vma);
>
>  unlock:
> diff --git a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
> b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
> index aff0ab7bf83d..46245c598a18 100644
> --- a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
> +++ b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
> @@ -186,12 +186,6 @@ static int vb2_dc_mmap(void *buf_priv, struct
> vm_area_struct *vma)
>          return -EINVAL;
>      }
>
> -    /*
> -     * dma_mmap_* uses vm_pgoff as in-buffer offset, but we want to
> -     * map whole buffer
> -     */
> -    vma->vm_pgoff =3D 0;
> -
>      ret =3D dma_mmap_attrs(buf->dev, vma, buf->cookie,
>          buf->dma_addr, buf->size, buf->attrs);
>
> --
>
> Then you can simply use non-buggy version of your function in
> drivers/media/common/videobuf2/videobuf2-dma-sg.c.
>
> I can send above as a formal patch if you want.

Thanks for the patch.
I will fold this changes along with current patch in v2.

>
> > So what your opinion about this patch ? Shall I drop this patch from
> > current series ?
> > or,
> > There is any better way to handle this scenario ?
> >
> >
> >>> There is an existing bug inside gem_mmap_obj(), where user passed
> >>> length is not checked against buf->num_pages. For any value of
> >>> length > buf->num_pages it will end up overrun buf->pages[i],
> >>> which could lead to a potential bug.
> > It is not gem_mmap_obj(), it should be vb2_dma_sg_mmap().
> > Sorry about it.
> >
> > What about this issue ? Does it looks like a valid issue ?
>
> It is already handled in vb2_mmap(). Such call will be rejected.
>
>
> > ...
>
> Best regards
> --
> Marek Szyprowski, PhD
> Samsung R&D Institute Poland
>
