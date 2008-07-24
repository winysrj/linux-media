Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dyn60-31.dsl.spy.dnainternet.fi ([83.102.60.31]
	helo=shogun.pilppa.org) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lamikr@pilppa.org>) id 1KLxUq-0002eM-U4
	for linux-dvb@linuxtv.org; Thu, 24 Jul 2008 11:52:29 +0200
Date: Thu, 24 Jul 2008 12:52:17 +0300 (EEST)
From: Mika Laitio <lamikr@pilppa.org>
To: Goga777 <goga777@bk.ru>
In-Reply-To: <20080724132047.10c6688d@bk.ru>
Message-ID: <Pine.LNX.4.64.0807241246570.18781@shogun.pilppa.org>
References: <Pine.LNX.4.64.0807240030280.20479@shogun.pilppa.org>
	<20080724132047.10c6688d@bk.ru>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] latest hvr-4000 driver patches
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
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Thanks I will try that once I get back to home.
Before leaving I was just shotyly testing by applying the patch

http://dev.kewl.org/hauppauge/v4l-dvb-hg-sfe-latest.diff
to
revision 7285 of vnl-dvb. Build of that against the 2.6.26 kernel headers
had some compile problems due to changed structures and after the boot the 
driver recogniced the card but then crashed for some buffer error.

Any idea whether some of these drivers (single frontend, multifrontend, 
multiproto) will be applied to v4l-dvb in near future?

If help is needed, I could try to help.

Mika


>> And what about vdr-1.7.0, is the multi frontend driver install
>> procedure mentioned in wiki ok for that one?
>> (http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-4000#Drivers)
>> or is there awailable some other patch set for that?
>
> I have vdr 170 , hvr4000 and fresh drivers form "Igor M. Liplianin's repo (repo includes hg multiproto + hvr4000 patch +
> some fixes)
> http://liplianindvb.sourceforge.net/cgi-bin/hgwebdir.cgi/liplianindvb/
> It works well. I recommend it for your case
> Of course it's not multifrontend drivers
>
> Goga
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
