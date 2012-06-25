Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:49892 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab2FYL5M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jun 2012 07:57:12 -0400
From: "Lad, Prabhakar" <prabhakar.lad@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Federico Vaga <federico.vaga@gmail.com>,
	LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Hadli, Manjunath" <manjunath.hadli@ti.com>
Subject: RE: [PATCH] [media] videobuf-dma-contig: restore buffer mapping for
 uncached bufers
Date: Mon, 25 Jun 2012 11:56:53 +0000
Message-ID: <4665BC9CC4253445B213A010E6DC7B35CDCEAC@DBDE01.ent.ti.com>
References: <1340360046-23429-1-git-send-email-prabhakar.lad@ti.com>
 <3127105.r3h7rO2WIQ@harkonnen> <201206231119.24537.hverkuil@xs4all.nl>
 <201206251343.39919.hverkuil@xs4all.nl>
In-Reply-To: <201206251343.39919.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Jun 25, 2012 at 17:13:39, Hans Verkuil wrote:
> On Sat 23 June 2012 11:19:24 Hans Verkuil wrote:
> > On Fri June 22 2012 18:53:27 Federico Vaga wrote:
> > > In data venerdì 22 giugno 2012 18:45:31, Hans Verkuil ha scritto:
> > > > On Fri June 22 2012 17:28:04 Federico Vaga wrote:
> > > > > > from commit a8f3c203e19b702fa5e8e83a9b6fb3c5a6d1cce4
> > > > > > restore the mapping scheme for uncached buffers,
> > > > > > which was changed in a common scheme for cached and uncached.
> > > > > > This apparently was wrong, and was probably intended only for
> > > > > > cached
> > > > > > buffers. the fix fixes the crash observed while mapping uncached
> > > > > > buffers.
> > > > > > 
> > > > > > Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> > > > > > Signed-off-by: Hadli, Manjunath <manjunath.hadli@ti.com>
> > > > > 
> > > > > Acked-by: Federico Vaga <federico.vaga@gmail.com>
> > > > > 
> > > > > I tested the patch on the STA2X11 board.
> > > > 
> > > > Was this patch ever posted on linux-media? I didn't see it on the
> > > > mailinglist, nor in my personal inbox.
> > > > 
> > > > Perhaps something went wrong?
> > > 
> > > I recived the email as CC and linux-media was the main destination.
> > > Davinci list was also added as CC and you can find the patch there:
> > > 
> > > http://www.mail-archive.com/davinci-linux-open-
> > > source@linux.davincidsp.com/msg22998.html
> > > 
> > > Something went wrong.
> > 
> > Weird, it never ended up at the linux-media mailinglist (not just me, it's
> > not in the linux-media archives either).
> > 
> > Anyway, I'll test this on Monday and if it works fine for me as well I'll Ack it.
> 
> I've tested this patch, and it looks good:
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Prabhakar: Please post this again with all acks and marked as [PATCH for v3.5] to the
> linux-media mailinglist asap. This patch never made it to this list for some reason,
> so make sure it gets there this time.
>  
  Ok. Thanks for the review.

Thx,
--Prabhakar Lad

> Regards,
> 
> 	Hans
> 
> > 
> > Regards,
> > 
> > 	Hans
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 

