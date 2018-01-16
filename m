Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:45969 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750927AbeAPCkr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 21:40:47 -0500
Received: by mail-ua0-f193.google.com with SMTP id e39so9821446uae.12
        for <linux-media@vger.kernel.org>; Mon, 15 Jan 2018 18:40:46 -0800 (PST)
Received: from mail-vk0-f43.google.com (mail-vk0-f43.google.com. [209.85.213.43])
        by smtp.gmail.com with ESMTPSA id t43sm490479uah.8.2018.01.15.18.40.45
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jan 2018 18:40:45 -0800 (PST)
Received: by mail-vk0-f43.google.com with SMTP id v70so8562353vkd.8
        for <linux-media@vger.kernel.org>; Mon, 15 Jan 2018 18:40:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <C193D76D23A22742993887E6D207B54D1AEB6195@FMSMSX151.amr.corp.intel.com>
References: <1515034637-3517-1-git-send-email-yong.zhi@intel.com>
 <CAAFQd5AO4n4kge1dijXLK-Ckudd5wJnuRnNMef+H4W00G2mpwQ@mail.gmail.com> <C193D76D23A22742993887E6D207B54D1AEB6195@FMSMSX151.amr.corp.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 16 Jan 2018 11:40:24 +0900
Message-ID: <CAAFQd5AxKSphur-fqHWvK5DLhQfJ+x30UQKuEx3Xe9mjnWRh4g@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: intel-ipu3: cio2: fix a crash with
 out-of-bounds access
To: "Zhi, Yong" <yong.zhi@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Tue, Jan 16, 2018 at 2:05 AM, Zhi, Yong <yong.zhi@intel.com> wrote:
> Hi, Tomasz,
>
> Thanks for the patch review.
>
>> -----Original Message-----
>> From: Tomasz Figa [mailto:tfiga@chromium.org]
>> Sent: Friday, January 12, 2018 12:17 AM
>> To: Zhi, Yong <yong.zhi@intel.com>
>> Cc: Linux Media Mailing List <linux-media@vger.kernel.org>; Sakari Ailus
>> <sakari.ailus@linux.intel.com>; Mani, Rajmohan
>> <rajmohan.mani@intel.com>; Cao, Bingbu <bingbu.cao@intel.com>
>> Subject: Re: [PATCH 1/2] media: intel-ipu3: cio2: fix a crash with out-of-
>> bounds access
>>
>> On Thu, Jan 4, 2018 at 11:57 AM, Yong Zhi <yong.zhi@intel.com> wrote:
>> > When dmabuf is used for BLOB type frame, the frame buffers allocated
>> > by gralloc will hold more pages than the valid frame data due to
>> > height alignment.
>> >
>> > In this case, the page numbers in sg list could exceed the FBPT upper
>> > limit value - max_lops(8)*1024 to cause crash.
>> >
>> > Limit the LOP access to the valid data length to avoid FBPT
>> > sub-entries overflow.
>> >
>> > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
>> > Signed-off-by: Cao Bing Bu <bingbu.cao@intel.com>
>> > ---
>> >  drivers/media/pci/intel/ipu3/ipu3-cio2.c | 7 +++++--
>> >  1 file changed, 5 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
>> > b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
>> > index 941caa987dab..949f43d206ad 100644
>> > --- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
>> > +++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
>> > @@ -838,8 +838,9 @@ static int cio2_vb2_buf_init(struct vb2_buffer *vb)
>> >                 container_of(vb, struct cio2_buffer, vbb.vb2_buf);
>> >         static const unsigned int entries_per_page =
>> >                 CIO2_PAGE_SIZE / sizeof(u32);
>> > -       unsigned int pages = DIV_ROUND_UP(vb->planes[0].length,
>> CIO2_PAGE_SIZE);
>> > -       unsigned int lops = DIV_ROUND_UP(pages + 1, entries_per_page);
>> > +       unsigned int pages = DIV_ROUND_UP(vb->planes[0].length,
>> > +                                         CIO2_PAGE_SIZE) + 1;
>>
>> Why + 1? This would still overflow the buffer, wouldn't it?
>
> The "pages" variable is used to calculate lops which has one extra page at the end that points to dummy page.
>
>>
>> > +       unsigned int lops = DIV_ROUND_UP(pages, entries_per_page);
>> >         struct sg_table *sg;
>> >         struct sg_page_iter sg_iter;
>> >         int i, j;
>> > @@ -869,6 +870,8 @@ static int cio2_vb2_buf_init(struct vb2_buffer
>> > *vb)
>> >
>> >         i = j = 0;
>> >         for_each_sg_page(sg->sgl, &sg_iter, sg->nents, 0) {
>> > +               if (!pages--)
>> > +                       break;
>>
>> Or perhaps we should check here for (pages > 1)?
>
> This is so that the end of lop is set to the dummy_page.

How about this simple example:

vb->planes[0].length = 1023 * 4096
pages = 1023 + 1 = 1024
lops  = 1

If sg->sgl includes more than 1023 pages, the for_each_sg_page() loop
will iterate for pages from 1024 to 1 inclusive and ends up
overflowing the dummy page to next lop (i == 1 and j == 0), but we
only allocated 1 lop.

Best regards,
Tomasz
