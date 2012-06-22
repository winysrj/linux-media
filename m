Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2326 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab2FVQqN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 12:46:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH] [media] videobuf-dma-contig: restore buffer mapping for uncached bufers
Date: Fri, 22 Jun 2012 18:45:31 +0200
Cc: Federico Vaga <federico.vaga@gmail.com>,
	LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hadli Manjunath <manjunath.hadli@ti.com>
References: <1340360046-23429-1-git-send-email-prabhakar.lad@ti.com> <3457845.jM9enoQY42@harkonnen>
In-Reply-To: <3457845.jM9enoQY42@harkonnen>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206221845.31286.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri June 22 2012 17:28:04 Federico Vaga wrote:
> > from commit a8f3c203e19b702fa5e8e83a9b6fb3c5a6d1cce4
> > restore the mapping scheme for uncached buffers,
> > which was changed in a common scheme for cached and uncached.
> > This apparently was wrong, and was probably intended only for cached
> > buffers. the fix fixes the crash observed while mapping uncached
> > buffers.
> > 
> > Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> > Signed-off-by: Hadli, Manjunath <manjunath.hadli@ti.com>
> 
> Acked-by: Federico Vaga <federico.vaga@gmail.com>
> 
> I tested the patch on the STA2X11 board.
> 
> 

Was this patch ever posted on linux-media? I didn't see it on the mailinglist,
nor in my personal inbox.

Perhaps something went wrong?

Regards,

	Hans
