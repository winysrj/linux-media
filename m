Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f194.google.com ([209.85.217.194]:43664 "EHLO
        mail-ua0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751017AbeAPCmi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 21:42:38 -0500
Received: by mail-ua0-f194.google.com with SMTP id i5so701009uai.10
        for <linux-media@vger.kernel.org>; Mon, 15 Jan 2018 18:42:38 -0800 (PST)
Received: from mail-vk0-f47.google.com (mail-vk0-f47.google.com. [209.85.213.47])
        by smtp.gmail.com with ESMTPSA id v39sm224593uav.47.2018.01.15.18.42.36
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jan 2018 18:42:37 -0800 (PST)
Received: by mail-vk0-f47.google.com with SMTP id n4so8556619vkd.6
        for <linux-media@vger.kernel.org>; Mon, 15 Jan 2018 18:42:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <C193D76D23A22742993887E6D207B54D1AEB61AE@FMSMSX151.amr.corp.intel.com>
References: <1515034637-3517-1-git-send-email-yong.zhi@intel.com>
 <1515034637-3517-2-git-send-email-yong.zhi@intel.com> <CAAFQd5AaOSQ_wcA_w5vBufVk5FfLPe6x9BnS=hcShv_asf3Cyw@mail.gmail.com>
 <C193D76D23A22742993887E6D207B54D1AEB61AE@FMSMSX151.amr.corp.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 16 Jan 2018 11:42:16 +0900
Message-ID: <CAAFQd5AAmMtdu-cYHpGjB+LO+ZKqyLrqySv7RfohHgq-Ngc+YQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] media: intel-ipu3: cio2: fix for wrong vb2buf state warnings
To: "Zhi, Yong" <yong.zhi@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 16, 2018 at 2:07 AM, Zhi, Yong <yong.zhi@intel.com> wrote:
> Hi, Tomasz,
>
> Thanks for reviewing the patch.
>
>> -----Original Message-----
>> From: Tomasz Figa [mailto:tfiga@chromium.org]
>> Sent: Friday, January 12, 2018 12:19 AM
>> To: Zhi, Yong <yong.zhi@intel.com>
>> Cc: Linux Media Mailing List <linux-media@vger.kernel.org>; Sakari Ailus
>> <sakari.ailus@linux.intel.com>; Mani, Rajmohan
>> <rajmohan.mani@intel.com>; Cao, Bingbu <bingbu.cao@intel.com>
>> Subject: Re: [PATCH 2/2] media: intel-ipu3: cio2: fix for wrong vb2buf state
>> warnings
>>
>> On Thu, Jan 4, 2018 at 11:57 AM, Yong Zhi <yong.zhi@intel.com> wrote:
>> > cio2 driver should release buffer with QUEUED state when start_stream
>> > op failed, wrong buffer state will cause vb2 core throw a warning.
>> >
>> > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
>> > Signed-off-by: Cao Bing Bu <bingbu.cao@intel.com>
>> > ---
>> >  drivers/media/pci/intel/ipu3/ipu3-cio2.c | 9 +++++----
>> >  1 file changed, 5 insertions(+), 4 deletions(-)
>> >
>> > diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
>> > b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
>> > index 949f43d206ad..106d04306372 100644
>> > --- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
>> > +++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
>> > @@ -785,7 +785,8 @@ static irqreturn_t cio2_irq(int irq, void
>> > *cio2_ptr)
>> >
>> >  /**************** Videobuf2 interface ****************/
>> >
>> > -static void cio2_vb2_return_all_buffers(struct cio2_queue *q)
>> > +static void cio2_vb2_return_all_buffers(struct cio2_queue *q,
>> > +                                       enum vb2_buffer_state state)
>> >  {
>> >         unsigned int i;
>> >
>> > @@ -793,7 +794,7 @@ static void cio2_vb2_return_all_buffers(struct
>> cio2_queue *q)
>> >                 if (q->bufs[i]) {
>> >                         atomic_dec(&q->bufs_queued);
>> >                         vb2_buffer_done(&q->bufs[i]->vbb.vb2_buf,
>> > -                                       VB2_BUF_STATE_ERROR);
>> > +                                       state);
>>
>> nit: Does it really exceed 80 characters after folding into previous line?
>>
>
> Thanks for catching this, seems this patch was merged, may I fix it in future patch?

It's just a nit that I was hoping to be fixed at patch applying time.
Otherwise just never mind.

Best regards,
Tomasz
