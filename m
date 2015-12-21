Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:55996 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbbLUGym (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2015 01:54:42 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NZP000YG4J38080@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Dec 2015 06:54:39 +0000 (GMT)
Subject: Re: [PATCH] [media] videobuf2: avoid memory leak on errors
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <b62ef37c6e2f30d1b5ce3889212050d738c04885.1450455268.git.mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <5677A22D.4010908@samsung.com>
Date: Mon, 21 Dec 2015 07:54:37 +0100
MIME-version: 1.0
In-reply-to: <b62ef37c6e2f30d1b5ce3889212050d738c04885.1450455268.git.mchehab@osg.samsung.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2015-12-18 17:14, Mauro Carvalho Chehab wrote:
> As reported by smatch:
> 	drivers/media/v4l2-core/videobuf2-core.c:2415 __vb2_init_fileio() warn: possible memory leak of 'fileio'
>
> While here, avoid the usage of sizeof(struct foo_struct).
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/media/v4l2-core/videobuf2-core.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index e6890d47cdcb..c5d49d7a0d76 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -2406,13 +2406,15 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
>   		(read) ? "read" : "write", count, q->fileio_read_once,
>   		q->fileio_write_immediately);
>   
> -	fileio = kzalloc(sizeof(struct vb2_fileio_data), GFP_KERNEL);
> +	fileio = kzalloc(sizeof(*fileio), GFP_KERNEL);
>   	if (fileio == NULL)
>   		return -ENOMEM;
>   
>   	fileio->b = kzalloc(q->buf_struct_size, GFP_KERNEL);
> -	if (fileio->b == NULL)
> +	if (fileio->b == NULL) {
> +		kfree(fileio);
>   		return -ENOMEM;
> +	}
>   
>   	fileio->read_once = q->fileio_read_once;
>   	fileio->write_immediately = q->fileio_write_immediately;

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

