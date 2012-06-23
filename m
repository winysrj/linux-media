Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4240 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab2FWJUM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jun 2012 05:20:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Federico Vaga <federico.vaga@gmail.com>
Subject: Re: [PATCH] [media] videobuf-dma-contig: restore buffer mapping for uncached bufers
Date: Sat, 23 Jun 2012 11:19:24 +0200
Cc: Prabhakar Lad <prabhakar.lad@ti.com>,
	LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hadli Manjunath <manjunath.hadli@ti.com>
References: <1340360046-23429-1-git-send-email-prabhakar.lad@ti.com> <201206221845.31286.hverkuil@xs4all.nl> <3127105.r3h7rO2WIQ@harkonnen>
In-Reply-To: <3127105.r3h7rO2WIQ@harkonnen>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201206231119.24537.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri June 22 2012 18:53:27 Federico Vaga wrote:
> In data venerdì 22 giugno 2012 18:45:31, Hans Verkuil ha scritto:
> > On Fri June 22 2012 17:28:04 Federico Vaga wrote:
> > > > from commit a8f3c203e19b702fa5e8e83a9b6fb3c5a6d1cce4
> > > > restore the mapping scheme for uncached buffers,
> > > > which was changed in a common scheme for cached and uncached.
> > > > This apparently was wrong, and was probably intended only for
> > > > cached
> > > > buffers. the fix fixes the crash observed while mapping uncached
> > > > buffers.
> > > > 
> > > > Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> > > > Signed-off-by: Hadli, Manjunath <manjunath.hadli@ti.com>
> > > 
> > > Acked-by: Federico Vaga <federico.vaga@gmail.com>
> > > 
> > > I tested the patch on the STA2X11 board.
> > 
> > Was this patch ever posted on linux-media? I didn't see it on the
> > mailinglist, nor in my personal inbox.
> > 
> > Perhaps something went wrong?
> 
> I recived the email as CC and linux-media was the main destination.
> Davinci list was also added as CC and you can find the patch there:
> 
> http://www.mail-archive.com/davinci-linux-open-
> source@linux.davincidsp.com/msg22998.html
> 
> Something went wrong.

Weird, it never ended up at the linux-media mailinglist (not just me, it's
not in the linux-media archives either).

Anyway, I'll test this on Monday and if it works fine for me as well I'll Ack it.

Regards,

	Hans
