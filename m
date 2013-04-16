Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:38369 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab3DPLkv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 07:40:51 -0400
Received: by mail-lb0-f181.google.com with SMTP id r11so440299lbv.26
        for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 04:40:49 -0700 (PDT)
Message-ID: <516D3880.7080400@cogentembedded.com>
Date: Tue, 16 Apr 2013 15:39:44 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Prabhakar lad <prabhakar.csengg@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v2] media: davinci: vpif: align the buffers size to page
 page size boundary
References: <1366109670-28030-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1366109670-28030-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 16-04-2013 14:54, Prabhakar lad wrote:

> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

> with recent commit with id 068a0df76023926af958a336a78bef60468d2033

   Please also specify the summary line of that commit in parens (or however 
you like).

> which adds add length check for mmap, the application were failing to
> mmap the buffers.

> This patch aligns the the buffer size to page size boundary for both
> capture and display driver so the it pass the check.

> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>

WBR, Sergei

