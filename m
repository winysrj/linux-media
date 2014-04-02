Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1539 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932633AbaDBSSK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Apr 2014 14:18:10 -0400
Message-ID: <533C5454.5060107@xs4all.nl>
Date: Wed, 02 Apr 2014 20:17:56 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: m silverstri <michael.j.silverstri@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: How to enable debug statements in v4l2 framework
References: <CABMudhSFxsW6YZRCt9BohPOatcZiZck9KYnF9BkiCUsvsqy0Ug@mail.gmail.com>
In-Reply-To: <CABMudhSFxsW6YZRCt9BohPOatcZiZck9KYnF9BkiCUsvsqy0Ug@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/02/2014 07:27 PM, m silverstri wrote:
> Hi,
> 
> In drivers/media/v4l2-core/videobuf2-core.c, I see debug printfs ilke this.
> I want to know how can I enable debug statements in v42l framework?
> 
>  #define dprintk(level, fmt, arg...)                                    \
>         do {                                                            \
>                if (debug >= level)                                     \
>                        printk(KERN_DEBUG "vb2: " fmt, ## arg);         \
>         } while (0)

echo 1 >/sys/module/videobuf2_core/parameters/debug

Regards,

	Hans
