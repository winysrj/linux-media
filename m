Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49195 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014Ab2FVQxa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 12:53:30 -0400
Received: by bkcji2 with SMTP id ji2so1765836bkc.19
        for <linux-media@vger.kernel.org>; Fri, 22 Jun 2012 09:53:29 -0700 (PDT)
From: Federico Vaga <federico.vaga@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Prabhakar Lad <prabhakar.lad@ti.com>,
	LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hadli Manjunath <manjunath.hadli@ti.com>
Subject: Re: [PATCH] [media] videobuf-dma-contig: restore buffer mapping for uncached bufers
Date: Fri, 22 Jun 2012 09:53:27 -0700 (PDT)
Message-ID: <3127105.r3h7rO2WIQ@harkonnen>
In-Reply-To: <201206221845.31286.hverkuil@xs4all.nl>
References: <1340360046-23429-1-git-send-email-prabhakar.lad@ti.com> <3457845.jM9enoQY42@harkonnen> <201206221845.31286.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In data venerdì 22 giugno 2012 18:45:31, Hans Verkuil ha scritto:
> On Fri June 22 2012 17:28:04 Federico Vaga wrote:
> > > from commit a8f3c203e19b702fa5e8e83a9b6fb3c5a6d1cce4
> > > restore the mapping scheme for uncached buffers,
> > > which was changed in a common scheme for cached and uncached.
> > > This apparently was wrong, and was probably intended only for
> > > cached
> > > buffers. the fix fixes the crash observed while mapping uncached
> > > buffers.
> > > 
> > > Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> > > Signed-off-by: Hadli, Manjunath <manjunath.hadli@ti.com>
> > 
> > Acked-by: Federico Vaga <federico.vaga@gmail.com>
> > 
> > I tested the patch on the STA2X11 board.
> 
> Was this patch ever posted on linux-media? I didn't see it on the
> mailinglist, nor in my personal inbox.
> 
> Perhaps something went wrong?

I recived the email as CC and linux-media was the main destination.
Davinci list was also added as CC and you can find the patch there:

http://www.mail-archive.com/davinci-linux-open-
source@linux.davincidsp.com/msg22998.html

Something went wrong.


-- 
Federico Vaga
