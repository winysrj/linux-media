Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ombos.raceme.org ([212.85.152.43])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tof+linux-dvb@raceme.org>) id 1JTlaY-0002IH-B2
	for linux-dvb@linuxtv.org; Mon, 25 Feb 2008 23:14:22 +0100
Received: from localhost (mail.raceme.org [192.168.1.17])
	by ombos.raceme.org (Postfix) with ESMTP id AD5DF1442C0
	for <linux-dvb@linuxtv.org>; Mon, 25 Feb 2008 23:14:18 +0100 (CET)
Received: from ombos.raceme.org ([192.168.1.17])
	by localhost (ombos.raceme.org [192.168.1.17]) (amavisd-new, port 10024)
	with ESMTP id PXsuQ-yeGQDa for <linux-dvb@linuxtv.org>;
	Mon, 25 Feb 2008 23:14:12 +0100 (CET)
Received: from [192.168.1.4] (abidos.raceme.org [81.57.143.226])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by ombos.raceme.org (Postfix) with ESMTP id B0D1F144231
	for <linux-dvb@linuxtv.org>; Mon, 25 Feb 2008 23:14:12 +0100 (CET)
Message-ID: <47C33DB4.7010408@raceme.org>
Date: Mon, 25 Feb 2008 23:14:12 +0100
From: Christophe Boyanique <tof+linux-dvb@raceme.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <47A98F3D.9070306@raceme.org> <47C3161F.4020802@raceme.org>
	<2A6A7C5A-0D64-4E79-9CAF-4CA5FD8412C4@firshman.co.uk>
In-Reply-To: <2A6A7C5A-0D64-4E79-9CAF-4CA5FD8412C4@firshman.co.uk>
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
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

Hello Ben Firshman you wrote :
> Which one disables the remote? I don't use the remote, so I could try  
> disabling it and see if I get any problems.
>   
This one disables the remote:

options dvb_usb disable_rc_polling=1

Christophe.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
