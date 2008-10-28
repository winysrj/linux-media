Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KulqW-0005y7-EC
	for linux-dvb@linuxtv.org; Tue, 28 Oct 2008 11:30:44 +0100
Message-ID: <4906E9CC.2040408@gmail.com>
Date: Tue, 28 Oct 2008 14:30:36 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: jean-paul@goedee.nl
References: <20081028111538.1yl7p80uo0cggo80@webmail.goedee.nl>
In-Reply-To: <20081028111538.1yl7p80uo0cggo80@webmail.goedee.nl>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] S2API & TT3200
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

jean-paul@goedee.nl wrote:
> Ok again.
> 
> I using now vdr 1.7.0 and multiproto from  manu to make my two tt  
> 3200-ci working with streamdev. Vdr zapper en MPC. Its working fine  
> except some judder  but its more a vdr issue.
> 
> For now I have a development system with an TT 3200 to and try to let  
> vdr run with S2API drivers.  After getting the drivers from  
> http://mercurial.intuxication.org/hg/s2-liplianin/ the compile ends  
> with a error:

You can simply clone http://jusst.de/hg/v4l-dvb
or http://linuxtv.org/hg/v4l-dvb and check

The former contains two more fixes, so better try to test with that.

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
