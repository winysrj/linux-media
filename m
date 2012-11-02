Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:2688 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757372Ab2KBNtd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2012 09:49:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Kirill Smelkov <kirr@mns.spb.ru>
Subject: Re: [PATCH 0/4] Speedup vivi
Date: Fri, 2 Nov 2012 14:48:43 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
References: <cover.1351861552.git.kirr@mns.spb.ru>
In-Reply-To: <cover.1351861552.git.kirr@mns.spb.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201211021448.43628.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri November 2 2012 14:10:29 Kirill Smelkov wrote:
> Hello up there. I was trying to use vivi to generate multiple video streams for
> my test-lab environment on atom system and noticed it wastes a lot of cpu.
> 
> Please apply some optimization patches.

Looks good!

For the whole series:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> 
> Thanks,
> Kirill
> 
> Kirill Smelkov (4):
>   [media] vivi: Optimize gen_text()
>   [media] vivi: vivi_dev->line[] was not aligned
>   [media] vivi: Move computations out of vivi_fillbuf linecopy loop
>   [media] vivi: Optimize precalculate_line()
> 
>  drivers/media/platform/vivi.c | 94 ++++++++++++++++++++++++++++++-------------
>  1 file changed, 65 insertions(+), 29 deletions(-)
> 
> 
