Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:44357 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbZCXBfs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2009 21:35:48 -0400
Subject: Re: Bug in  mxl5005s driver
From: Andy Walls <awalls@radix.net>
To: Jose Alberto Reguero <jareguero@telefonica.net>
Cc: linux-media@vger.kernel.org
In-Reply-To: <200903222231.12769.jareguero@telefonica.net>
References: <200903222231.12769.jareguero@telefonica.net>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 21:37:08 -0400
Message-Id: <1237858628.3312.33.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-03-22 at 22:31 +0100, Jose Alberto Reguero wrote:
> In line 3992:
> 
>         if (fe->ops.info.type == FE_ATSC) {
>                 switch (params->u.vsb.modulation) {
>                 case VSB_8:
>                         req_mode = MXL_ATSC; break;
>                 default:
>                 case QAM_64:
>                 case QAM_256:
>                 case QAM_AUTO:
>                         req_mode = MXL_QAM; break;
>                 }
>         } else
>                 req_mode = MXL_DVBT;
> 
> req_mode is filled with MXL_ATSC, MXL_QAM, or MXL_DVBT
> 
> and in line 4007 req_mode is used like params->u.vsb.modulation
> 
>                 switch (req_mode) {
>                 case VSB_8:
>                 case QAM_64:
>                 case QAM_256:
>                 case QAM_AUTO:
>                         req_bw  = MXL5005S_BANDWIDTH_6MHZ;
>                         break;
>                 default:
>                         /* Assume DVB-T */
>                         switch (params->u.ofdm.bandwidth) {
>                         case BANDWIDTH_6_MHZ:
>                                 req_bw  = MXL5005S_BANDWIDTH_6MHZ;
>                                 break;
>                         case BANDWIDTH_7_MHZ:
>                                 req_bw  = MXL5005S_BANDWIDTH_7MHZ;
>                                 break;
>                         case BANDWIDTH_AUTO:
>                         case BANDWIDTH_8_MHZ:
> 
> 
> Jose Alberto Reguero

Easy enough.  Please try the patch here:

http://linuxtv.org/hg/~awalls/v4l-dvb



Sorry I forgot to add a

Reported-by: Jose Alberto Reguero <jareguero@telefonica.net>

in the commit.  I can fix that if things work out.


Regards,
Andy

