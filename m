Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41433 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381Ab0GHHUV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Jul 2010 03:20:21 -0400
Message-ID: <4C357C5C.8010602@gmail.com>
Date: Thu, 08 Jul 2010 00:21:00 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: linux-media@vger.kernel.org, mchehab@infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH]video:gspca.c Fix  warning: case value '7' not in enumerated
 type 'enum v4l2_memory'
References: <1278564378-19855-1-git-send-email-justinmattock@gmail.com> <20100708084010.6a15f8c3@tele>
In-Reply-To: <20100708084010.6a15f8c3@tele>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/07/2010 11:40 PM, Jean-Francois Moine wrote:
> On Wed,  7 Jul 2010 21:46:18 -0700
> "Justin P. Mattock"<justinmattock@gmail.com>  wrote:
>
>> This fixes a warning I'm seeing when building:
>>    CC [M]  drivers/media/video/gspca/gspca.o
>> drivers/media/video/gspca/gspca.c: In function 'vidioc_reqbufs':
>> drivers/media/video/gspca/gspca.c:1508:2: warning: case value '7' not
>> in enumerated type 'enum v4l2_memory'
>
> Hi Justin,
>
> I don't agree with your patch: the value GSPCA_MEMORY_READ must not be
> seen by user applications.
>
> The warning may be simply fixed by (change the line numbers):
>
> --- gspca.c~	2010-07-08 08:15:14.000000000 +0200
> +++ gspca.c	2010-07-08 08:28:52.000000000 +0200
> @@ -1467,7 +1467,8 @@ static int vidioc_reqbufs(struct file *f
>   	struct gspca_dev *gspca_dev = priv;
>   	int i, ret = 0, streaming;
>
> -	switch (rb->memory) {
> +	i = rb->memory;			/* (avoid compilation warning) */
> +	switch (i) {
>   	case GSPCA_MEMORY_READ:			/* (internal call) */
>   	case V4L2_MEMORY_MMAP:
>   	case V4L2_MEMORY_USERPTR:
>
> Cheers.
>


o.k. buddy.. make sense with the userspace etc..
Anyways looks good, builds without a warning..

Tested-By: Justin P. Mattock <justinmattock@gmail.com>

cheers as well,

Justin P. Mattock
