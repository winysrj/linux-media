Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2794 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaG0HyH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jul 2014 03:54:07 -0400
Message-ID: <53D4B013.2060404@xs4all.nl>
Date: Sun, 27 Jul 2014 09:53:55 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Isaac Nickaein <nickaein.i@gmail.com>, linux-media@vger.kernel.org
Subject: Re: "error: redefinition of 'altera_init'" during build on Kernel
 3.0.36+
References: <CA+NJmkcTpf5Xb4Z8gJFriB58Jtf85ay_jnTS-fM34gA1PBf60g@mail.gmail.com>
In-Reply-To: <CA+NJmkcTpf5Xb4Z8gJFriB58Jtf85ay_jnTS-fM34gA1PBf60g@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/27/2014 08:47 AM, Isaac Nickaein wrote:
> Hello,
> 
> I get the following error when I try to build the V4L2 on Kernel
> 3.0.36+ for ARM architecture:
> 
> /root/v4l2/media_build/v4l/altera.c:2417:5: error: redefinition of 'altera_init'
>  int altera_init(struct altera_config *config, const struct firmware *fw)
>      ^
> In file included from /root/v4l2/media_build/v4l/altera.c:32:0:
> /root/v4l2/media_build/v4l/../linux/include/misc/altera.h:41:19: note:
> previous definition of 'altera_init' was here
>  static inline int altera_init(struct altera_config *config,
>                    ^
> 
> 
> I checked the altera.h code and apparently, the IS_ENABLED macro is
> not defined and causes this problem. I have prepared kernel source at
> /lib/modules/3.0.36+/build/ and it builds successfully.
> 
> Can anyone help me on this issue?

What kernel tree are you using? There is no IS_ENABLED in 3.0, so apparently
you have a patched kernel. Do you actually need that altera driver? If not,
then why not disable it in the kernel config?

Regards,

	Hans
