Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:38387 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbZL1UGp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Dec 2009 15:06:45 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NPLrW-0006Z1-Qs
	for linux-media@vger.kernel.org; Mon, 28 Dec 2009 21:06:42 +0100
Received: from upc.si.94.140.72.111.dc.cable.static.telemach.net ([94.140.72.111])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 28 Dec 2009 21:06:42 +0100
Received: from prusnik by upc.si.94.140.72.111.dc.cable.static.telemach.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 28 Dec 2009 21:06:42 +0100
To: linux-media@vger.kernel.org
From: =?UTF-8?Q?Alja=C5=BE?= Prusnik <prusnik@gmail.com>
Subject: Re: Which modules for the VP-2033? Where is the module "mantis.ko"?
Date: Mon, 28 Dec 2009 21:06:16 +0100
Message-ID: <1262030776.3489.12.camel@slash.doma>
References: <4B1D6194.4090308@freenet.de>
	 <1261578615.8948.4.camel@slash.doma> <200912231753.28988.liplianin@me.by>
	 <1261586462.8948.23.camel@slash.doma> <4B3269AE.6080602@freenet.de>
	 <1a297b360912231124v6e31c9e6ja24d205f6b5dc39@mail.gmail.com>
	 <1261611901.8948.37.camel@slash.doma> <4B339A8F.8020201@freenet.de>
	 <1261673477.2119.1.camel@slash.doma>
	 <1a297b360912271423x2f5b48caw7b2adad8849280ee@mail.gmail.com>
	 <1262028495.3489.10.camel@slash.doma>
Reply-To: Manu Abraham <abraham.manu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1262028495.3489.10.camel@slash.doma>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On pon, 2009-12-28 at 20:28 +0100, Aljaž Prusnik wrote:
> On pon, 2009-12-28 at 02:23 +0400, Manu Abraham wrote:
> > Can you please do a lspci -vn for the Mantis card you have ? Also try
> > loading the mantis.ko module with verbose=5 module parameter, to get
> > more debug information.
> 

To continue, it seems the module is registering the remote commands, but
dunno, why irw shows nothing:

dmesg of typing on remote:
[ 4854.805594] mantis_uart_read (0): Reading ... <3d>
[ 4854.805605] mantis_uart_work (0): UART BUF:0 <3d> 
[ 4854.805609] 
[ 4854.805615] mantis_uart_read (0): Reading ... <3d>
[ 4854.805621] mantis_uart_work (0): UART BUF:0 <3d> 
[ 4854.805624] 
[ 4895.266923] 
[ 4895.266926] -- Stat=<4000800> Mask=<800> --<IRQ-1>
[ 4895.266956] 
[ 4895.266958] -- Stat=<4000800> Mask=<800> --<IRQ-1>
[ 4895.266979] 
[ 4895.266981] -- Stat=<4000800> Mask=<800> --<IRQ-1>
[ 4895.266999] 
[ 4895.267000] -- Stat=<4000800> Mask=<800> --<IRQ-1>
[ 4895.267015] 
[ 4895.267016] -- Stat=<4000800> Mask=<800> --<IRQ-1>
[ 4895.267031] 
[ 4895.267032] -- Stat=<4000800> Mask=<800> --<IRQ-1>
[ 4895.267043] mantis_uart_read (0): Reading ... <3e>
[ 4895.267054] mantis_uart_work (0): UART BUF:0 <3e> 
[ 4895.267058] 
[ 4895.267065] mantis_uart_read (0): Reading ... <3e>
[ 4895.267070] mantis_uart_work (0): UART BUF:0 <3e> 


