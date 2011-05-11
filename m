Return-path: <mchehab@gaivota>
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:41684 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757226Ab1EKQNd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2011 12:13:33 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	by slow3-v.mail.gandi.net (Postfix) with ESMTP id 63B10865D2
	for <linux-media@vger.kernel.org>; Wed, 11 May 2011 15:35:32 +0200 (CEST)
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "'Issa Gorissen'" <flop.m@usa.net>,
	"'Ralph Metzler'" <rjkm@metzlerbros.de>
Cc: "'Linux Media Mailing List'" <linux-media@vger.kernel.org>,
	"'Oliver Endriss'" <o.endriss@gmx.de>
References: <501PekNLl1856S04.1305119557@web04.cms.usa.net>
In-Reply-To: <501PekNLl1856S04.1305119557@web04.cms.usa.net>
Subject: RE: DVB nGene CI : TS Discontinuities issues
Date: Wed, 11 May 2011 15:35:11 +0200
Message-ID: <004d01cc0fe0$41554520$c3ffcf60$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Language: fr
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>



> -----Original Message-----
> From: Issa Gorissen [mailto:flop.m@usa.net]
> Sent: mercredi 11 mai 2011 15:13
> To: Ralph Metzler
> Cc: Linux Media Mailing List; S-bastien RAILLARD; Oliver Endriss
> Subject: Re: DVB nGene CI : TS Discontinuities issues
> 
> From: Ralph Metzler <rjkm@metzlerbros.de>
> > Issa Gorissen writes:
> >  > Could you please take a look at the cxd2099 issues ?
> >  >
> >  > I have attached a version with my changes. I have tested a lot of
> > > different settings with the help of the chip datasheet.
> >  >
> >  > Scrambled programs are not handled correctly. I don't know if it is
> > the  > TICLK/MCLKI which is too high or something, or the sync
> > detector ? Also,  > as we have to set the TOCLK to max of 72MHz, there
> > are way too much null  > packets added. Is there a way to solve this ?
> >
> > I do not have any cxd2099 issues.
> > I have a simple test program which includes a 32bit counter as payload
> > and can pump data through the CI with full speed and have no packet
> > loss. I only tested decoding with an ORF stream and an Alphacrypt CAM
> > but also had no problems with this.
> >
> > Please take care not to write data faster than it is read. Starting
> > two dds will not guarantee this. To be certain you could write a small
> > program which never writes more packets than input buffer size minus
> > the number of read packets (and minus the stuffing null packets on
> ngene).
> >
> > Before blaming packet loss on the CI data path also please make
> > certain that you have no buffer overflows in the input part of the sec
> > device.
> > In the ngene driver you can e.g. add a printk in tsin_exchange():
> >
> > if (dvb_ringbuffer_free(&dev->tsin_rbuf) > len) { ...
> > } else
> >     printk ("buffer overflow !!!!\n");
> >
> >
> > Regards,
> > Ralph
> 
> 
> Ralph,
> 
> Please find my testing tool for the decryption attached. The idea is to
> write
> 5 packets and read them back from the CAM.
> 
> My input is a raw ts captured with a gnutv I modified with a demux
> filter of 0x2000. Gnutv outputs at dvr and dvbloop reads from it,
> process via sec0 and writes output to a file.
> 
> The channel I selected has been decrypted. Only problem is I have
> artifacts in the image and the sound.
> 
> Do you have any idea of what I should improve from my test tool to fix
> that issue ?
> 
> 

Good news, it seems that you managed to get it working!
You can check that your input and output TS files doesn't have issues or
discontinuities.

If you have access to a Windows running computer, you can test your TS files
with a small analyzer I wrote:
http://www.coexsi.fr/publications/mpegts-analyzer/


> Thx,
> --
> Issa


