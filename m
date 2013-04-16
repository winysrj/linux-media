Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:57976 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab3DPLl2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 07:41:28 -0400
Received: by mail-lb0-f171.google.com with SMTP id v10so447752lbd.2
        for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 04:41:27 -0700 (PDT)
Message-ID: <516D38A6.9040306@cogentembedded.com>
Date: Tue, 16 Apr 2013 15:40:22 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Prabhakar lad <prabhakar.csengg@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] media: davinci: vpbe: align the buffers size to page
 page size boundary
References: <1366110601-18424-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1366110601-18424-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16-04-2013 15:10, Prabhakar lad wrote:

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


