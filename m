Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924Ab1KGNqQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Nov 2011 08:46:16 -0500
Message-ID: <4EB7E11D.4060709@redhat.com>
Date: Mon, 07 Nov 2011 11:46:05 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Pawel Osciak <pawel@osciak.com>
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
	Angela Wan <angela.j.wan@gmail.com>,
	linux-media@vger.kernel.org, leiwen@marvell.com,
	ytang5@marvell.com, qingx@marvell.com, jwan@marvell.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] media: vb2: reset queued list on REQBUFS(0) call
References: <CABbt3s68q_jKf9bHPT8kuaB6donrAzmucJJseWNiX88qud273g@mail.gmail.com> <4EA66C5F.8080202@samsung.com> <CAMm-=zBt9HufMLpvcDBfD3qS1vL+zwm77APcfVcPQst1zqEyPw@mail.gmail.com>
In-Reply-To: <CAMm-=zBt9HufMLpvcDBfD3qS1vL+zwm77APcfVcPQst1zqEyPw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 25-10-2011 06:11, Pawel Osciak escreveu:
> On Tue, Oct 25, 2011 at 00:59, Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
>> Queued list was not reset on REQBUFS(0) call. This caused enqueuing
>> a freed buffer to the driver.
>>
>> Reported-by: Angela Wan <angela.j.wan@gmail.com>
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/media/video/videobuf2-core.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/media/video/videobuf2-core.c
>> b/drivers/media/video/videobuf2-core.c
>> index 3015e60..5722b81 100644
>> --- a/drivers/media/video/videobuf2-core.c
>> +++ b/drivers/media/video/videobuf2-core.c
>> @@ -254,6 +254,7 @@ static void __vb2_queue_free(struct vb2_queue *q)
>>
>>        q->num_buffers = 0;
>>        q->memory = 0;
>> +       INIT_LIST_HEAD(&q->queued_list);
>>  }
>>
>>  /**
>> --
>> 1.7.1
>>
>>
>>
> 
> Acked-by: Pawel Osciak <pawel@osciak.com>
> 

This patch doesn't apply anymore. Is it still needed? If so, please rebase.

Thanks!
Mauro
