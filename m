Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110804.mail.gq1.yahoo.com ([67.195.13.227]:43275 "HELO
	web110804.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753804AbZDTSIF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 14:08:05 -0400
Message-ID: <66643.35699.qm@web110804.mail.gq1.yahoo.com>
Date: Mon, 20 Apr 2009 11:07:57 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: Re: [PATCH] [0904_13] Siano: move DVB_API and remove redundant code
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>




--- On Mon, 4/20/09, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> From: Mauro Carvalho Chehab <mchehab@infradead.org>
> Subject: Re: [PATCH] [0904_13] Siano: move DVB_API and remove redundant code
> To: "Uri Shkolnik" <urishk@yahoo.com>
> Cc: "LinuxML" <linux-media@vger.kernel.org>
> Date: Monday, April 20, 2009, 9:02 PM
> On Sun, 5 Apr 2009 03:31:32 -0700
> (PDT)
> Uri Shkolnik <urishk@yahoo.com>
> wrote:
> 
> > 
> > # HG changeset patch
> > # User Uri Shkolnik <uris@siano-ms.com>
> > # Date 1238755204 -10800
> > # Node ID f65a29f0f9a66f82a91525ae0085a15f00ac91c2
> > # Parent 
> 897669fdeb3be75a2bde978557b5398a4a7d8914
> > [PATCH] [0904_13] Siano: move DVB_API and remove
> redundant code
> > 
> > From: Uri Shkolnik <uris@siano-ms.com>
> > 
> > The DVB-API related information has been moved from
> the core header
> > to the smsdvb, and the redundant code has been removed
> from the
> > core header.
> > 
> > This code has been moved since it is used only by
> > the smsdvb client component.
> 
> This patch depends on the previous patches that I asked
> some changes. Please
> re-submit it together with the other patches that weren't
> committed. It is
> probably not much valuable to commit the later patches, so
> I'll stop analysing
> the code here.
> 
> The patch itself looks sane to my eyes.
> > 
> > Priority: normal
> > 
> > Signed-off-by: Uri Shkolnik <uris@siano-ms.com>
> > 
> > diff -r 897669fdeb3b -r f65a29f0f9a6
> linux/drivers/media/dvb/siano/smscoreapi.h
> > ---
> a/linux/drivers/media/dvb/siano/smscoreapi.h   
> Fri Apr 03 13:31:13 2009 +0300
> > +++
> b/linux/drivers/media/dvb/siano/smscoreapi.h   
> Fri Apr 03 13:40:04 2009 +0300
> > @@ -36,15 +36,6 @@ along with this program.  If
> not, see <h
> >  #include <asm/page.h>
> >  
> >  /* #include "smsir.h" */
> > -
> > -#define SMS_DVB3_SUBSYS
> > -#ifdef SMS_DVB3_SUBSYS
> > -#include "dmxdev.h"
> > -#include "dvbdev.h"
> > -#include "dvb_demux.h"
> > -#include "dvb_frontend.h"
> > -
> > -#endif
> >  
> >  #define kmutex_init(_p_) mutex_init(_p_)
> >  #define kmutex_lock(_p_) mutex_lock(_p_)
> > diff -r 897669fdeb3b -r f65a29f0f9a6
> linux/drivers/media/dvb/siano/smsdvb.c
> > ---
> a/linux/drivers/media/dvb/siano/smsdvb.c   
> Fri Apr 03 13:31:13 2009 +0300
> > +++
> b/linux/drivers/media/dvb/siano/smsdvb.c   
> Fri Apr 03 13:40:04 2009 +0300
> > @@ -22,6 +22,11 @@ along with this program.  If
> not, see <h
> >  #include <linux/module.h>
> >  #include <linux/init.h>
> >  #include <asm/byteorder.h>
> > +
> > +#include "dmxdev.h"
> > +#include "dvbdev.h"
> > +#include "dvb_demux.h"
> > +#include "dvb_frontend.h"
> >  
> >  #include "smscoreapi.h"
> >  /*#include "smsendian.h"*/
> > @@ -52,7 +57,7 @@ struct smsdvb_client_t {
> >      fe_status_t fe_status;
> >      int fe_ber, fe_snr, fe_unc,
> fe_signal_strength;
> >  
> > -    struct completion tune_done,
> stat_done;
> > +    struct completion tune_done;
> >  
> >      /* todo: save freq/band
> instead whole struct */
> >      struct
> dvb_frontend_parameters fe_params;
> > 
> > 
> > 
> >       
> > --
> > To unsubscribe from this list: send the line
> "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> 
> Cheers,
> Mauro
> 

OK

I'll submit patches to fix the various rejects on the coming Wednesday (I'm ooo tomorrow).

BTW - is it possible for me to clone the current tree you currently have? (after applying the approved patches), it will help me for future patches.


Regards,

Uri


      
