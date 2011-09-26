Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:33252 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832Ab1IZLZf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 07:25:35 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Date: Mon, 26 Sep 2011 16:55:22 +0530
Subject: RE: [PATCH RESEND 1/4] davinci vpbe: remove unused macro.
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593025729ADE5@dbde02.ent.ti.com>
References: <1316410529-14744-1-git-send-email-manjunath.hadli@ti.com>
 <1316410529-14744-2-git-send-email-manjunath.hadli@ti.com>
 <4E7D1782.30209@redhat.com>
In-Reply-To: <4E7D1782.30209@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 24, 2011 at 05:04:26, Mauro Carvalho Chehab wrote:
> Em 19-09-2011 02:35, Manjunath Hadli escreveu:
> > remove VPBE_DISPLAY_SD_BUF_SIZE as it is no longer used.
> > 
> > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > ---
> >  drivers/media/video/davinci/vpbe_display.c |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/media/video/davinci/vpbe_display.c 
> > b/drivers/media/video/davinci/vpbe_display.c
> > index ae7add1..09a659e 100644
> > --- a/drivers/media/video/davinci/vpbe_display.c
> > +++ b/drivers/media/video/davinci/vpbe_display.c
> > @@ -43,7 +43,6 @@
> >  
> >  static int debug;
> >  
> > -#define VPBE_DISPLAY_SD_BUF_SIZE (720*576*2)  #define 
> > VPBE_DEFAULT_NUM_BUFS 3
> >  
> >  module_param(debug, int, 0644);
> 
> This is really trivial. I won't wait for your pull request to merge this one ;)

Thank you Mauro.

> 
> Thanks,
> Mauro
> 

Thx,
-Manju
