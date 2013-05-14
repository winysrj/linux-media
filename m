Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:63008 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab3ENGPK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 May 2013 02:15:10 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MMR0098NYOWS090@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 May 2013 07:15:07 +0100 (BST)
Message-id: <5191D661.6030408@samsung.com>
Date: Tue, 14 May 2013 08:14:57 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: pawel@osciak.com, kyungmin.park@samsung.com, mchehab@redhat.com,
	yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] v4l: vb2: fix error return code in
 __vb2_init_fileio()
References: <CAPgLHd9ydkkQ_yOmhnU1awN08kBhiM-ZryGBqq8S0qisHkYvqA@mail.gmail.com>
In-reply-to: <CAPgLHd9ydkkQ_yOmhnU1awN08kBhiM-ZryGBqq8S0qisHkYvqA@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2013-05-13 07:48, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fix to return -EINVAL in the get kernel address error handling
> case instead of 0, as done elsewhere in this function.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/media/v4l2-core/videobuf2-core.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 7d833ee..7bd3ee6 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -2193,8 +2193,10 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
>   	 */
>   	for (i = 0; i < q->num_buffers; i++) {
>   		fileio->bufs[i].vaddr = vb2_plane_vaddr(q->bufs[i], 0);
> -		if (fileio->bufs[i].vaddr == NULL)
> +		if (fileio->bufs[i].vaddr == NULL) {
> +			ret = -EINVAL;
>   			goto err_reqbufs;
> +		}
>   		fileio->bufs[i].size = vb2_plane_size(q->bufs[i], 0);
>   	}
>   
>
>

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


