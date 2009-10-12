Return-path: <linux-media-owner@vger.kernel.org>
Received: from rouge.crans.org ([138.231.136.3]:46326 "EHLO rouge.crans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736AbZJLM5g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2009 08:57:36 -0400
Received: from localhost (localhost.crans.org [127.0.0.1])
	by rouge.crans.org (Postfix) with ESMTP id D11FC808D
	for <linux-media@vger.kernel.org>; Mon, 12 Oct 2009 14:56:59 +0200 (CEST)
Received: from rouge.crans.org ([10.231.136.3])
	by localhost (rouge.crans.org [10.231.136.3]) (amavisd-new, port 10024)
	with LMTP id dBd4-GKODRR8 for <linux-media@vger.kernel.org>;
	Mon, 12 Oct 2009 14:56:59 +0200 (CEST)
Received: from [192.168.1.10] (64.pool85-50-72.dynamic.orange.es [85.50.72.64])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by rouge.crans.org (Postfix) with ESMTP id 889CC807D
	for <linux-media@vger.kernel.org>; Mon, 12 Oct 2009 14:56:59 +0200 (CEST)
Message-ID: <4AD3279A.6030907@crans.ens-cachan.fr>
Date: Mon, 12 Oct 2009 14:56:58 +0200
From: DUBOST Brice <dubost@crans.ens-cachan.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: S2API and DVB-T tuning
References: <4AD30DFD.8080800@crans.ens-cachan.fr>
In-Reply-To: <4AD30DFD.8080800@crans.ens-cachan.fr>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DUBOST Brice a écrit :
> Hello,
> 
> I have some problems with DVB-T tuning under s2-api/DVB API 5
> 
> To run these tests I use scan-s2-7effc68db255
> 
> My machine runs the following kernel (uname -a)
> Linux fixe_barcelone 2.6.31-13-generic #42-Ubuntu SMP Thu Oct 8 20:03:54
> UTC 2009 x86_64 GNU/Linux
> 
> And I own 3 DVB-T devices :
> 1:
> 01:00.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
> 	Subsystem: Technotrend Systemtechnik GmbH Device 1012
> 	Flags: bus master, medium devsel, latency 64, IRQ 21
> 	Memory at fa6ffc00 (32-bit, non-prefetchable) [size=512]
> 	Kernel driver in use: budget_ci dvb
> 	Kernel modules: budget-ci
> 2:
> Bus 001 Device 010: ID 2040:7070 Hauppauge
> 
> 3:
> Bus 001 Device 011: ID 07ca:a815 AVerMedia Technologies, Inc.
> 
> All three devices tune well and work flawlessly with scan (dvb api v3)
> But when I use scan-s2, only the AVerMedia is able to lock
> 
> I use the dvb-t/es-Collserola as an initial tuning file.
> 
> I thought the S2API shouldn't change the tuning behavior.
> 
> I tried to search the Mailing list archives via google I unfortunately
> found nothing. I'm sorry if this subject was discussed before.
> 
> What can I do to investigate more on this issue ?
> 

Hello

One more information, if I change

514000000 8MHz 2/3 AUTO QAM64 8k 1/4 NONE

by

514000000 8MHz 2/3 AUTO AUTO 8k 1/4 NONE

it works with scan-s2

With "old" scan it works for both

Hope this will help to find the issue

Regards

-- 
Brice

A: Yes.
>Q: Are you sure?
>>A: Because it reverses the logical flow of conversation.
>>>Q: Why is top posting annoying in email?
