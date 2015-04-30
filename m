Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:35527 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751467AbbD3GWs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 02:22:48 -0400
Message-ID: <5541CA2C.3060803@xs4all.nl>
Date: Thu, 30 Apr 2015 08:22:36 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 01/13] go7007: don't use vb before test if it is not NULL
References: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
In-Reply-To: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/29/2015 01:04 AM, Mauro Carvalho Chehab wrote:
> As reported by smatch:
> 	drivers/media/usb/go7007/go7007-driver.c:452 frame_boundary() warn: variable dereferenced before check 'vb' (see line 449)
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> diff --git a/drivers/media/usb/go7007/go7007-driver.c b/drivers/media/usb/go7007/go7007-driver.c
> index 95cffb771a62..0ab81ec8897a 100644
> --- a/drivers/media/usb/go7007/go7007-driver.c
> +++ b/drivers/media/usb/go7007/go7007-driver.c
> @@ -446,7 +446,7 @@ static void go7007_motion_regions(struct go7007 *go, struct go7007_buffer *vb)
>   */
>  static struct go7007_buffer *frame_boundary(struct go7007 *go, struct go7007_buffer *vb)
>  {
> -	u32 *bytesused = &vb->vb.v4l2_planes[0].bytesused;
> +	u32 *bytesused;
>  	struct go7007_buffer *vb_tmp = NULL;
>  
>  	if (vb == NULL) {
> @@ -458,6 +458,7 @@ static struct go7007_buffer *frame_boundary(struct go7007 *go, struct go7007_buf
>  		go->next_seq++;
>  		return vb;
>  	}
> +	bytesused = &vb->vb.v4l2_planes[0].bytesused;
>  
>  	vb->vb.v4l2_buf.sequence = go->next_seq++;
>  	if (vb->modet_active && *bytesused + 216 < GO7007_BUF_SIZE)
> 

