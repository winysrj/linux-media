Return-path: <mchehab@pedra>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:38484 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757756Ab1DHThM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2011 15:37:12 -0400
Message-ID: <4D9F63E1.6060808@kolumbus.fi>
Date: Fri, 08 Apr 2011 22:37:05 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Marko Ristola <marko.ristola@kolumbus.fi>
CC: Andreas Oberritter <obi@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Speed up DVB TS stream delivery from DMA buffer into
 dvb-core's buffer
References: <4D9F2C83.6070401@kolumbus.fi>
In-Reply-To: <4D9F2C83.6070401@kolumbus.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Here is some statistics without likely and with likely functions.

It seems that using likely() gives better performance with Phenom I too.

	%	Plain knl %	No likely	%	With likely	%
dvb_ringbuffer_write	5,9	62,8	8,7	81,3	5,7	79,2
dvb_dmx_swfilter_packet	1,2	12,8	0,7	6,5	0,8	11,1
dvb_dmx_swfilter_204	2,3	24,5	1,3	12,1	0,7	9,7


Here "Plain knl %" is "perf top -d 30" percentage.
24,5 12,1 and 9,7 are percentages without a patch, with basic patch
and last is with "likely" functions using patch.

Regards,
Marko Ristola


08.04.2011 18:40, Marko Ristola kirjoitti:
> Avoid unnecessary DVB TS 188 sized packet copying from DMA buffer into stack.
> Backtrack one 188 sized packet just after some garbage bytes when possible.
> This obsoletes patch https://patchwork.kernel.org/patch/118147/
> 
> Signed-off-by: Marko Ristola marko.ristola@kolumbus.fi
> diff --git a/drivers/media/dvb/dvb-core/dvb_demux.c b/drivers/media/dvb/dvb-core/dvb_demux.c
> index 4a88a3e..faa3671 100644
> --- a/drivers/media/dvb/dvb-core/dvb_demux.c
> +++ b/drivers/media/dvb/dvb-core/dvb_demux.c
> @@ -478,97 +478,94 @@ void dvb_dmx_swfilter_packets(struct dvb_demux *demux, const u8 *buf,
>  
>  EXPORT_SYMBOL(dvb_dmx_swfilter_packets);
>  
