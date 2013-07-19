Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:39224 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760368Ab3GSMKU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jul 2013 08:10:20 -0400
Received: by mail-ob0-f179.google.com with SMTP id xk17so5108411obc.38
        for <linux-media@vger.kernel.org>; Fri, 19 Jul 2013 05:10:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51E8FE15.4090604@samsung.com>
References: <1374220729-8304-1-git-send-email-ricardo.ribalda@gmail.com>
 <1374220729-8304-3-git-send-email-ricardo.ribalda@gmail.com> <51E8FE15.4090604@samsung.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Fri, 19 Jul 2013 14:09:57 +0200
Message-ID: <CAPybu_1tJUMOJJmWB6QgyUZ+51P0bnm9fuZ2_qTiT8SHDQpEyA@mail.gmail.com>
Subject: Re: [PATCH 2/4] videobuf2-dma-sg: Replace vb2_dma_sg_desc with sg_table
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sylwester

I thought I had to split the API changes. Sorry :S. I will wait for
more comments and then I will resubmit.

Thanks for you comment!


On Fri, Jul 19, 2013 at 10:51 AM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> Hi Ricardo,
>
> On 07/19/2013 09:58 AM, Ricardo Ribalda Delgado wrote:
>> Replace the private struct vb2_dma_sg_desc with the struct sg_table so
>> we can benefit from all the helping functions in lib/scatterlist.c for
>> things like allocating the sg or compacting the descriptor
>>
>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>> ---
> [...]
>> diff --git a/include/media/videobuf2-dma-sg.h b/include/media/videobuf2-dma-sg.h
>> index 0038526..7b89852 100644
>> --- a/include/media/videobuf2-dma-sg.h
>> +++ b/include/media/videobuf2-dma-sg.h
>> @@ -15,16 +15,10 @@
>>
>>  #include <media/videobuf2-core.h>
>>
>> -struct vb2_dma_sg_desc {
>> -     unsigned long           size;
>> -     unsigned int            num_pages;
>> -     struct scatterlist      *sglist;
>> -};
>
> You need to squash patches 3/4, 4/4 into this one to avoid breaking
> build and git bisection.
>
> Thanks,
> Sylwester
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Ricardo Ribalda
