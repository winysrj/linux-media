Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f47.google.com ([209.85.216.47]:55866 "EHLO
	mail-qw0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab1IMJ43 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 05:56:29 -0400
Received: by qwh5 with SMTP id 5so295784qwh.20
        for <linux-media@vger.kernel.org>; Tue, 13 Sep 2011 02:56:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1109130943021.17902@axis700.grange>
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com>
	<1315938892-20243-4-git-send-email-scott.jiang.linux@gmail.com>
	<Pine.LNX.4.64.1109130943021.17902@axis700.grange>
Date: Tue, 13 Sep 2011 17:56:28 +0800
Message-ID: <CAHG8p1AYXg9zHjoYk6H1pGwUnSzmBTvazWDJuco8nQbFkHOtuw@mail.gmail.com>
Subject: Re: [PATCH 4/4] v4l2: add blackfin capture bridge driver
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> +
>> +struct bcap_format {
>> +     u8 *desc;
>> +     u32 pixelformat;
>> +     enum v4l2_mbus_pixelcode mbus_code;
>> +     int bpp; /* bytes per pixel */
>
> Don't you think you might have to process 12 bpp formats at some point,
> like YUV 4:2:0, or NV12? Maybe better calculate in bits from the beginning?
>
sounds good, changed in v2

>
> Does it really have to be fixed 32 bits? Seems a plane simple int would do
> just fine.
>
users can't be negative, so I used u32

>> +struct bcap_fh {
>> +     struct v4l2_fh fh;
>> +     struct bcap_device *bcap_dev;
>> +     /* indicates whether this file handle is doing IO */
>> +     u8 io_allowed;
>
> bool
>
does kernel prefer bool now?

>> +     if (!bcap_dev->started)
>> +             complete(&bcap_dev->comp);
>> +     else {
>> +             if (!list_empty(&bcap_dev->dma_queue)) {
>> +                     bcap_dev->next_frm = list_entry(bcap_dev->dma_queue.next,
>> +                                             struct bcap_buffer, list);
>> +                     list_del(&bcap_dev->next_frm->list);
>> +                     addr = vb2_plane_cookie(&bcap_dev->next_frm->vb, 0);
>
> I think, the direct use of vb2_plane_cookie() is discouraged.
> vb2_dma_contig_plane_dma_addr() should work for you.
>
I guess you mean vb2_dma_contig_plane_paddr

>> +
>> +     for (i = 0; i < BCAP_MAX_FMTS; i++) {
>> +             if (mbus_fmt.code == bcap_formats[i].mbus_code) {
>> +                     bcap_fmt = &bcap_formats[i];
>> +                     v4l2_fill_pix_format(pixfmt, &mbus_fmt);
>> +                     pixfmt->bytesperline = pixfmt->width * bcap_fmt->bpp;
>> +                     pixfmt->sizeimage = pixfmt->bytesperline
>> +                                             * pixfmt->height;
>
> It seems to me, you're forgetting to fill in ->pixelformat?
>
yes, add in v2
