Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt1.poste.it ([62.241.4.164])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Nicola.Sabbi@poste.it>) id 1KM0Ar-0000Up-2T
	for linux-dvb@linuxtv.org; Thu, 24 Jul 2008 14:44:03 +0200
Received: from nico2.od.loc (89.97.249.170) by relay-pt1.poste.it (7.3.122)
	(authenticated as Nicola.Sabbi@poste.it)
	id 4887C68100004FBF for linux-dvb@linuxtv.org;
	Thu, 24 Jul 2008 14:43:57 +0200
From: Nico Sabbi <Nicola.Sabbi@poste.it>
To: linux-dvb@linuxtv.org
Date: Thu, 24 Jul 2008 14:43:56 +0200
References: <48886FF0.5080206@iinet.net.au>
In-Reply-To: <48886FF0.5080206@iinet.net.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807241443.56441.Nicola.Sabbi@poste.it>
Subject: Re: [linux-dvb] [Fwd: Re:  dvb mpeg2?]
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Thursday 24 July 2008 14:05:04 Tim Farrington wrote:

>
> Yes, that first one worked fine (even with all the frame data).
> I can see that it's:
> VIDEO MPEG2(pid=3D305)AUDIO MPA(pid=3D306) NO SUBS (yet)! =A0PROGRAM N. 0
> Opened TS demuxer, audio: 50(pid 306), video: 10000002(pid
> 305)...POS=3D23688 VIDEO: =A0MPEG2 =A0720x576 =A0(aspect 2) =A025.000 fps
> =A015000.0 kbps (1875.0 kbyte/s)
>
> in mine, so that must mean that all is ok through the system - it
> is a MPEG2-TS stream
> being dumped to file.
>
> Now to figure out how to install replex!
>
> Very many thanks for your help,
> Tim Farrington


the more stuff you insert in your pipeline the higher the chance
of breaking something (especially sync)

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
