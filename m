Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx27.mail.ru ([194.67.23.23])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1Ky5WL-0003CJ-17
	for linux-dvb@linuxtv.org; Thu, 06 Nov 2008 15:07:38 +0100
Received: from [92.101.156.232] (port=43552 helo=localhost.localdomain)
	by mx27.mail.ru with asmtp id 1Ky5Vm-000724-00
	for linux-dvb@linuxtv.org; Thu, 06 Nov 2008 17:07:02 +0300
Date: Thu, 6 Nov 2008 17:07:58 +0300
From: Goga777 <goga777@bk.ru>
To: linux-dvb@linuxtv.org
Message-ID: <20081106170758.24e6c963@bk.ru>
In-Reply-To: <BLU126-W6957B65360F3DA0A48FDEAF1E0@phx.gbl>
References: <BLU126-W211E02BF45832661F2020BAF1F0@phx.gbl>
	<14964.1225909409@kewl.org>
	<BLU126-W1455E0B6279BBF11D1BDD4AF1F0@phx.gbl>
	<15308.1225910609@kewl.org>
	<BLU126-W53DD1C6541585D37293AC1AF1F0@phx.gbl>
	<15933.1225913396@kewl.org>
	<BLU126-W6957B65360F3DA0A48FDEAF1E0@phx.gbl>
Mime-Version: 1.0
Subject: Re: [linux-dvb] no lock on 3/4 with cx24116
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

> >>There are some difference between your output and mine:
> >>yours:
> >>rolloff 0.35
> >>sid 0x0edb
> >>
> >>mine=3B
> >>rolloff auto
> >>sid 0x0000
> >>
> 
> It's locking now changing the rolloff value from 0 to 35
> 
> Discovery HD;BSkyB:12324:VC34M2O35S1:S28.2E:29500:514=27:0;662=eng:0:0:3803:2:2032:0
> 
> Thanks Darron for the patch,

with xmldvb from Darron I could find dvb-s and dvb-s2 channels with my hvr4000
I use the driver from him too 
http://hg.kewl.org/v4l-dvb/


3801=HD Retail Info;BSkyB:12324:VC34S1M2:0:29500:512:640:3801
3803=Discovery HD;BSkyB:12324:VC34S1M2:0:29500:514:0:3803
3863=Sky Arts HD;BSkyB:12324:VC34S1M2:0:29500:513:0:3863
3811=SBO HD2;BSkyB:12324:VC34S1M2:0:29500:0:0:3811
3823=FX HD;BSkyB:12324:VC34S1M2:0:29500:0:0:3823
4141=Sky Box Office;BSkyB:12324:VC34S1M2:0:29500:0:0:4141


Goga



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
