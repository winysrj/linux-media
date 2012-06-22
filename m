Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34972 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762322Ab2FVPYd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 11:24:33 -0400
Received: by bkcji2 with SMTP id ji2so1670972bkc.19
        for <linux-media@vger.kernel.org>; Fri, 22 Jun 2012 08:24:32 -0700 (PDT)
From: Federico Vaga <federico.vaga@gmail.com>
To: Prabhakar Lad <prabhakar.lad@ti.com>
Cc: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hadli Manjunath <manjunath.hadli@ti.com>
Subject: Re: [PATCH] [media] videobuf-dma-contig: restore buffer mapping for uncached bufers
Date: Fri, 22 Jun 2012 17:28:04 +0200
Message-ID: <3457845.jM9enoQY42@harkonnen>
In-Reply-To: <1340360046-23429-1-git-send-email-prabhakar.lad@ti.com>
References: <1340360046-23429-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> from commit a8f3c203e19b702fa5e8e83a9b6fb3c5a6d1cce4
> restore the mapping scheme for uncached buffers,
> which was changed in a common scheme for cached and uncached.
> This apparently was wrong, and was probably intended only for cached
> buffers. the fix fixes the crash observed while mapping uncached
> buffers.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Signed-off-by: Hadli, Manjunath <manjunath.hadli@ti.com>

Acked-by: Federico Vaga <federico.vaga@gmail.com>

I tested the patch on the STA2X11 board.

-- 
Federico Vaga
