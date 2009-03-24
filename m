Return-path: <linux-media-owner@vger.kernel.org>
Received: from outmailhost.telefonica.net ([213.4.149.242]:60431 "EHLO
	ctsmtpout2.frontal.correo" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758082AbZCXMWT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 08:22:19 -0400
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: Andy Walls <awalls@radix.net>
Subject: Re: Bug in  mxl5005s driver
Date: Tue, 24 Mar 2009 13:22:14 +0100
Cc: linux-media@vger.kernel.org
References: <200903222231.12769.jareguero@telefonica.net> <1237858628.3312.33.camel@palomino.walls.org>
In-Reply-To: <1237858628.3312.33.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903241322.14382.jareguero@telefonica.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

El Martes, 24 de Marzo de 2009, Andy Walls escribió:
> On Sun, 2009-03-22 at 22:31 +0100, Jose Alberto Reguero wrote:
> > In line 3992:
> >
> >         if (fe->ops.info.type == FE_ATSC) {
> >                 switch (params->u.vsb.modulation) {
> >                 case VSB_8:
> >                         req_mode = MXL_ATSC; break;
> >                 default:
> >                 case QAM_64:
> >                 case QAM_256:
> >                 case QAM_AUTO:
> >                         req_mode = MXL_QAM; break;
> >                 }
> >         } else
> >                 req_mode = MXL_DVBT;
> >
> > req_mode is filled with MXL_ATSC, MXL_QAM, or MXL_DVBT
> >
> > and in line 4007 req_mode is used like params->u.vsb.modulation
> >
> >                 switch (req_mode) {
> >                 case VSB_8:
> >                 case QAM_64:
> >                 case QAM_256:
> >                 case QAM_AUTO:
> >                         req_bw  = MXL5005S_BANDWIDTH_6MHZ;
> >                         break;
> >                 default:
> >                         /* Assume DVB-T */
> >                         switch (params->u.ofdm.bandwidth) {
> >                         case BANDWIDTH_6_MHZ:
> >                                 req_bw  = MXL5005S_BANDWIDTH_6MHZ;
> >                                 break;
> >                         case BANDWIDTH_7_MHZ:
> >                                 req_bw  = MXL5005S_BANDWIDTH_7MHZ;
> >                                 break;
> >                         case BANDWIDTH_AUTO:
> >                         case BANDWIDTH_8_MHZ:
> >
> >
> > Jose Alberto Reguero
>
> Easy enough.  Please try the patch here:
>
> http://linuxtv.org/hg/~awalls/v4l-dvb
>
>
>
> Sorry I forgot to add a
>
> Reported-by: Jose Alberto Reguero <jareguero@telefonica.net>
>
> in the commit.  I can fix that if things work out.
>
>
> Regards,
> Andy
>

Work well with DVB-T.

Thanks.

Jose Alberto
