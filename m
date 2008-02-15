Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1JQAAC-0005J1-Nh
	for linux-dvb@linuxtv.org; Sat, 16 Feb 2008 00:40:16 +0100
From: hermann pitton <hermann-pitton@arcor.de>
To: Hartmut Hackmann <hartmut.hackmann@t-online.de>
In-Reply-To: <47B617F1.30006@t-online.de>
References: <47B5A504.9080400@kliese.wattle.id.au> <47B617F1.30006@t-online.de>
Date: Sat, 16 Feb 2008 00:35:06 +0100
Message-Id: <1203118506.7303.63.camel@pc08.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] MSI TV@nywhere A/D v1.1 patch
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

Am Freitag, den 15.02.2008, 23:53 +0100 schrieb Hartmut Hackmann:
> Hi, Russell
> 
> Russell Kliese schrieb:
> > Hi,
> > 
> > I've created a patch to support the MSI TV@nywhere A/D v1.1 card. This
> > card previously had firmware upload issues when using card=109. With
> > this patch, it's auto-detected and I haven't experienced any firmware
> > upload problems (although my testing hasn't been exhaustive, but I have
> > tried a couple of cold boots).
> > 
> > I've tested both analog and digital TV. I haven't yet tested S-Video or
> > composite inputs, so these might need to be tweaked.
> > 
> > It would be great if this patch could be merged into the main
> > repository. If there are any special requirements to allow this to be
> > done, please let me know.
> > 
> > Cheers,
> > 
> > Russell Kliese
> > 
> 
> You were able to help yourself, good!
> Few questions / commments:
> - Does the board support FM Radio?
> - Can you test the composite / S-Video inputs somehow?
>   We already have boards with wrong configurations here but i would
>   like to minimize the number ;-)
> - The code fragment in saa7134-cards.c from line 5479 on should not be
>   necessary. Can you please cross check?

please also drop the duplicate code in saa7134-dvb and just use
&philips_tiger_s_config.

> When i integrate the patch, i would like to mention you as the patch author.
> For this, i will need a signature from you:
> Signed-off-by: Your Name <your email address>

Thanks,
Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
