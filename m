Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from v1696.ncsrv.de ([89.110.150.180] helo=duerrhauer.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christian@duerrhauer.de>) id 1JNsle-0003Ub-AT
	for linux-dvb@linuxtv.org; Sat, 09 Feb 2008 17:41:30 +0100
Message-ID: <47ADD7AD.40009@duerrhauer.de>
Date: Sat, 09 Feb 2008 17:41:17 +0100
From: =?ISO-8859-1?Q?Christian_D=FCrrhauer?= <christian@duerrhauer.de>
MIME-Version: 1.0
To: Jose Alberto Reguero <jareguero@telefonica.net>
References: <47AD998C.8090809@duerrhauer.de> <47ADBE15.1040908@duerrhauer.de>
	<47ADBF84.60006@duerrhauer.de>
	<200802091613.08130.jareguero@telefonica.net>
In-Reply-To: <200802091613.08130.jareguero@telefonica.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] gentoo: v4l-dvb-hg doesn't compile with kernel
	2.6.24-gentoo
Reply-To: christian@duerrhauer.de
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

Jose Alberto Reguero wrote:

>> Christian
> 
> I have the same problem with kernel 2.6.24 and current HG. The attached patch 
> solve the problem for me.
> 

Hi Jose,

thank you. Your patch did the trick.

Can it be put into the next version of bt87x.c in the v4l-dvb-test?

Kind regards,

Christian

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
