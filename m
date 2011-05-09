Return-path: <mchehab@gaivota>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:39432 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab1EIHE5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 May 2011 03:04:57 -0400
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "'Issa Gorissen'" <flop.m@usa.net>,
	"'Ralph Metzler'" <rjkm@metzlerbros.de>
Cc: "'Linux Media Mailing List'" <linux-media@vger.kernel.org>,
	"'Oliver Endriss'" <o.endriss@gmx.de>,
	"'Martin Vidovic'" <xtronom@gmail.com>
References: <004f01cc0981$2d371ec0$87a55c40$@coexsi.fr>	<4DC5622A.9040403@usa.net> <19909.47855.351946.831380@morden.metzler> <4DC73854.7090104@usa.net>
In-Reply-To: <4DC73854.7090104@usa.net>
Subject: RE: DVB nGene CI : TS Discontinuities issues
Date: Mon, 9 May 2011 09:04:51 +0200
Message-ID: <000901cc0e17$65fc4510$31f4cf30$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-language: fr
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>



> -----Original Message-----
> From: Issa Gorissen [mailto:flop.m@usa.net]
> Sent: lundi 9 mai 2011 02:42
> To: Ralph Metzler
> Cc: Linux Media Mailing List; "Sébastien RAILLARD (COEXSI)"; Oliver
> Endriss; Martin Vidovic
> Subject: Re: DVB nGene CI : TS Discontinuities issues
> 
> On 07/05/11 23:34, Ralph Metzler wrote:
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
> Ralph,
> 
> As mentioned earlier, the warning message in tsin_exchange() is somewhat
> useless because it is printed endlessly at module start.
> 
> However, I've written the small test (attached) and took care to not
> write more than read (not taking account of null packets).
> 
> I still cannot descrambled channels. I'm using the source from 2.6.39 rc
> 5 with the fix from Oliver
> [http://linuxtv.org/hg/~endriss/v4l-dvb/rev/3d3e6ec2d0a7].  I launched
> gnutv with output to dvr, and launched my tool to read from dvr,
> write/read from sec0, write to a file.
> 
> The end result is a file which is clean of null packets, but cannot be
> played by mplayer (no audio, or no video, or both...)
> 
> I don't know if CAT needs to be in the stream passed through sec0 as
> Sebastien mentioned, so I modified gnutv to add it to dvr.
> 

Yes, the CAT table is mandatory, it must be sent to the CAM, as well as :
* the EMM PID referenced in the CAT
* all the private descriptors (binary blobs) in the PMT and, of course
* the ECM PID referenced in the PMT

Of course, the CAM must be initialized, all the necessary CAM resources must
be initialized and a CA_PMT object must be sent through the CAM command
channel to ask for unscrambling of needed channels.

That why it's better to send directly the raw TS output of the demodulator
directly in the CAM.
And then doing the demux filtering stuff on the TS stream coming from the
CAM (once unscrambled).

> Sebastien, Martin, could you try Ralph suggestion and post results as
> well. Thx.
> 
> 
> Please also find an update of ngene-dvb.c, the sec device now handles
> blocking/non blocking access.
> 
> --
> Issa

