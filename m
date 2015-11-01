Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:36191 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752549AbbKATju (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Nov 2015 14:39:50 -0500
Message-ID: <56366A80.5090001@xs4all.nl>
Date: Sun, 01 Nov 2015 20:39:44 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ran Shalit <ranshalit@gmail.com>, linux-media@vger.kernel.org
Subject: Re: videobuf & read/write operation
References: <CAJ2oMhJOu8Ltra-bbb6FW3gLrCab1yKKu_zdSTNmqT5ecMkELQ@mail.gmail.com>
In-Reply-To: <CAJ2oMhJOu8Ltra-bbb6FW3gLrCab1yKKu_zdSTNmqT5ecMkELQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/01/2015 08:21 PM, Ran Shalit wrote:
> Hello,
> 
> I'm trying to understand how to imeplement v4l driver using videobuf.
> The videobuf documentation if very helpful.

Don't use videobuf! Use videobuf2, just like the skeleton driver.

The old videobuf framework is deprecated and you shouldn't use it as it is
horrible.

Why on earth are you trying to use videobuf if the skeleton driver clearly
uses vb2?

Regards,

	Hans

> When the documentation refers to " I/O stream" , does it also include
> the read/write operation or only streaming I/O method ?
> 
> In case I am using only read/write, do I need to implement all these 4  APIs:
> 
> struct videobuf_queue_ops {
>  int (*buf_setup)(struct videobuf_queue *q,
>  unsigned int *count, unsigned int *size);
>  int (*buf_prepare)(struct videobuf_queue *q,
>  struct videobuf_buffer *vb,
> enum v4l2_field field);
>  void (*buf_queue)(struct videobuf_queue *q,
>  struct videobuf_buffer *vb);
>  void (*buf_release)(struct videobuf_queue *q,
>  struct videobuf_buffer *vb);
> };
> 
> Are these APIs relevant for both read/write and streaminf I/O ?
> 
> Best Regards,
> Ran
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

