Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:41328 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbZL2S0K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2009 13:26:10 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NPglS-0001ly-PN
	for linux-media@vger.kernel.org; Tue, 29 Dec 2009 19:25:50 +0100
Received: from upc.si.94.140.72.111.dc.cable.static.telemach.net ([94.140.72.111])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 29 Dec 2009 19:25:50 +0100
Received: from prusnik by upc.si.94.140.72.111.dc.cable.static.telemach.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 29 Dec 2009 19:25:50 +0100
To: linux-media@vger.kernel.org
From: =?UTF-8?Q?Alja=C5=BE?= Prusnik <prusnik@gmail.com>
Subject: Re: Which modules for the VP-2033? Where is the module "mantis.ko"?
Date: Tue, 29 Dec 2009 19:25:13 +0100
Message-ID: <1262111113.3489.17.camel@slash.doma>
References: <4B1D6194.4090308@freenet.de>
	 <1261578615.8948.4.camel@slash.doma> <200912231753.28988.liplianin@me.by>
	 <1261586462.8948.23.camel@slash.doma> <4B3269AE.6080602@freenet.de>
	 <1a297b360912231124v6e31c9e6ja24d205f6b5dc39@mail.gmail.com>
	 <1261611901.8948.37.camel@slash.doma> <4B339A8F.8020201@freenet.de>
	 <1261673477.2119.1.camel@slash.doma>
	 <1a297b360912271423x2f5b48caw7b2adad8849280ee@mail.gmail.com>
	 <1262028495.3489.10.camel@slash.doma> <1262030776.3489.12.camel@slash.doma>
Reply-To: abraham.manu@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1262030776.3489.12.camel@slash.doma>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On pon, 2009-12-28 at 21:06 +0100, Aljaž Prusnik wrote:
> On pon, 2009-12-28 at 20:28 +0100, Aljaž Prusnik wrote:
> > On pon, 2009-12-28 at 02:23 +0400, Manu Abraham wrote:
> > > Can you please do a lspci -vn for the Mantis card you have ? Also try
> > > loading the mantis.ko module with verbose=5 module parameter, to get
> > > more debug information.
> > 
> 
> To continue, it seems the module is registering the remote commands, but
> dunno, why irw shows nothing:

Well - to answer myself on this one, it doesn't because there is no
input device registered. I used to have this under input devices
(cat /proc/bus/input/devices):

I: Bus=0001 Vendor=0000 Product=0000 Version=0001
N: Name="Mantis VP-2040 IR Receiver"
P: Phys=pci-0000:03:06.0/ir0
S: Sysfs=/devices/virtual/input/input5
U: Uniq=
H: Handlers=kbd event5
B: EV=100003
B: KEY=108fc330 284204100000000 0 2000000018000 218040000801
9e96c000000000 ffc

So the question is, why is it not registered as an input anymore?

Regards,
Aljaz


