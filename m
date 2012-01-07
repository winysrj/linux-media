Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:45130 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758716Ab2AGArI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 19:47:08 -0500
From: Oliver Endriss <o.endriss@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] drxk: Fix regression introduced by commit '[media] Remove Annex A/C selection via roll-off factor'
Date: Sat, 7 Jan 2012 01:45:40 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <201201041945.58852@orion.escape-edv.de> <4F07477C.50900@redhat.com>
In-Reply-To: <4F07477C.50900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201201070145.40842@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 06 January 2012 20:11:56 Mauro Carvalho Chehab wrote:
> On 04-01-2012 16:45, Oliver Endriss wrote:
> > Fix regression introduced by commit '[media] Remove Annex A/C selection via roll-off factor'
> > As a result of this commit, DVB-T tuning did not work anymore.
> > 
> > Signed-off-by: Oliver Endriss <o.endriss@gmx.de>
> > 
> > diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
> > index 36e1c82..13f22a1 100644
> > --- a/drivers/media/dvb/frontends/drxk_hard.c
> > +++ b/drivers/media/dvb/frontends/drxk_hard.c
> > @@ -6235,6 +6235,8 @@ static int drxk_set_parameters(struct dvb_frontend *fe)
> >  	case SYS_DVBC_ANNEX_C:
> >  		state->m_itut_annex_c = true;
> >  		break;
> > +	case SYS_DVBT:
> > +		break;
> >  	default:
> >  		return -EINVAL;
> >  	}
> > 
> Hi Oliver,
> 
> Thanks for the patch! 
> 
> It become obsoleted by the patch that converted the driver
> to create just one frontend:
> 	http://git.linuxtv.org/media_tree.git/commitdiff/fa4b2a171d42ffc512b3a86922ad68e1355eb17a

Agreed.

> While I don't have DVB-T signal here, the logs were showing that the driver is
> switching properly between DVB-T and DVB-C.
> 
> Yet, I'd appreciate if you could test it with a real signal,
> for us to be 100% sure that everything is working as expected.

A quick test showed that switching to DVB-T works.
Sorry, I do not have a DVB-C signal here.

Btw, there are two lines, which are not harmful, but should be removed
(bad formatting/dead code).

--- drxk_hard.c.old	2012-01-07 01:40:00.000000000 +0100
+++ drxk_hard.c	2012-01-07 01:40:30.000000000 +0100
@@ -6236,8 +6236,6 @@ static int drxk_set_parameters(struct dv
 				SetOperationMode(state, OM_QAM_ITU_C);
 			else
 				SetOperationMode(state, OM_QAM_ITU_A);
-				break;
-			state->m_itut_annex_c = true;
 			break;
 		case SYS_DVBT:
 			if (!state->m_hasDVBT)


CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
