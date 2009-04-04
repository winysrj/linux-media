Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110810.mail.gq1.yahoo.com ([67.195.13.233]:22713 "HELO
	web110810.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754482AbZDDMrn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Apr 2009 08:47:43 -0400
Message-ID: <802860.3364.qm@web110810.mail.gq1.yahoo.com>
Date: Sat, 4 Apr 2009 05:47:40 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: Re: [PATCH - RECALL] siano: smsendian & smsdvb - binding the smsendian to smsdvb
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>




--- On Sat, 4/4/09, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> From: Mauro Carvalho Chehab <mchehab@infradead.org>
> Subject: Re: [PATCH - RECALL] siano: smsendian & smsdvb - binding the smsendian to smsdvb
> To: "Uri Shkolnik" <urishk@yahoo.com>
> Cc: linux-media@vger.kernel.org
> Date: Saturday, April 4, 2009, 12:14 AM
> On Fri, 3 Apr 2009 13:31:32 -0700
> (PDT)
> Uri Shkolnik <urishk@yahoo.com>
> wrote:
> 
> > 
> > --- On Fri, 4/3/09, Mauro Carvalho Chehab <mchehab@infradead.org>
> wrote:
> > 
> > From: Mauro Carvalho Chehab <mchehab@infradead.org>
> > Subject: Re: [PATCH - RECALL] siano: smsendian &
> smsdvb - binding the smsendian to smsdvb
> > To: "Uri Shkolnik" <urishk@yahoo.com>
> > Cc: linux-media@vger.kernel.org
> > Date: Friday, April 3, 2009, 3:15 PM
> > 
> > Uri,
> > 
> > On Fri, 3 Apr 2009 03:20:38 -0700 (PDT)
> > Uri Shkolnik <urishk@yahoo.com>
> wrote:
> > 
> > > Hi,
> > > 
> > > The last patch in the series ("siano: smsendian
> & smsdvb - binding the smsendian to smsdvb") breaks the
> driver, please ignore it.
> > > 
> > 
> > 
> > It will be very hard (again) to handle your patch
> series. Especially when
> > sending a big series of patches like this, you should
> number the patches, for
> > they to be applied at the proper order. 
> > 
> > Also, when a patch is broken, you should reply to that
> patch, without changing
> > the subject. The original message ID will be properly
> handled by patchwork, and
> > the reply message will be folded with the original
> patch.
> > 
> > In this case, this is the message ID of your patch
> message:
> > Message-ID: <622468.86074.qm@web110805.mail.gq1.yahoo.com>
> > 
> > However, your "RECALL" email doesn't contain any
> reference tag to the original
> > message (since you didn't reply to your message). So,
> emailers and patchwork
> > won't associate the reply with the patch you want to
> discard.
> > 
> > Cheers,
> > Mauro
> > 
> > Hi Mauro,
> > 
> > 
> > 
> > 
> > 1) Backport patch ("siano: smsdvb - add support for
> old dvb-core version") - If this patch causes problem,
> discard it (trashing it does not affect the other patches),
> let me know, and I'll submit only the one-line endian
> change. (We'll support old embedded devices, etc. using
> specific vendor patch from our customer support team, and
> the kernel version will not have any backport code).
> > 
> > 2) I'll add global serial indication to the patches
> from now on. Regarding the already submmited patches, is it
> OK if I'll email you a text list of patches with their
> order? 
> 
> Yes, if you provide me the patch numbers at patchwork. I
> just need a simple
> list of patchwork sequence numbers, in the expected order.
> 
> > 3) Recall message - I didn't know about the reply
> option and I'll do that from now on. (Any day you learn
> something new, and that fact distinguish you from the
> dead....:-) )
> 
> No problem.
> > 
> > 4) If it's OK with you, I'll hold further submission,
> until the already submited patches will be reviewed and
> commited.
> 
> Seems the better for me.
> 
> > 5) Some related question... I emailed all patches to
> you and CC the "linux-media@vger.kernel.org"
> ML. I can not see any post other than your replys on the ML
> and nothing on http://patchwork.kernel.org/project/linux-media/list/
> .  Any idea why?
> 
> If patchwork didn't got, then the patch is broken. You
> don't need to CC me, but you need to be sure that patchwork
> will catch they. For patchwork to do his job, you should be
> sure that your emailer won't do line wrapping, and avoid use
> attachments. Mime processing is tricky and some emailers set
> the wrong mime type for attachments.
> 
> > Have a great weekend,
> 
> Same to you.
> > 
> > Regards,
> > 
> > Uri
> > 
> >       
> 
> 
> 
> 
> Cheers,
> Mauro
> 

Hi Mauro,

I'm watching closely http://patchwork.kernel.org/project/linux-media/list/  and this ML.

Until now, none of my patches appears anywhere. It seems that either html tags or other formatting issue, prevent the robot from processing my patches (I can see submissions from today, while my two days old are absent).

I'll wait till tomorrow (just in case) and if nothing will happen, I'll re-submit my patches (and make sure they are pure text...).
If so, I'll also add patches numeration, and remove the backport one.


Regards,

Uri


      
