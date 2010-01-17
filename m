Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpq4.tb.mail.iss.as9143.net ([212.54.42.167]:48739 "EHLO
	smtpq4.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751354Ab0AQQtZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jan 2010 11:49:25 -0500
Received: from [212.54.42.142] (helo=smtp11.tb.mail.iss.as9143.net)
	by smtpq4.tb.mail.iss.as9143.net with esmtp (Exim 4.69)
	(envelope-from <joep@groovytunes.nl>)
	id 1NWXya-0002S5-Nb
	for linux-media@vger.kernel.org; Sun, 17 Jan 2010 17:27:44 +0100
Received: from 84-105-5-223.cable.quicknet.nl ([84.105.5.223] helo=werkstation.localnet)
	by smtp11.tb.mail.iss.as9143.net with esmtp (Exim 4.69)
	(envelope-from <joep@groovytunes.nl>)
	id 1NWXya-0004QU-AZ
	for linux-media@vger.kernel.org; Sun, 17 Jan 2010 17:27:44 +0100
From: joep admiraal <joep@groovytunes.nl>
To: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: prof 7300
Date: Sun, 17 Jan 2010 17:27:44 +0100
References: <201001171542.27314.joep@groovytunes.nl> <201001171742.54145.liplianin@me.by>
In-Reply-To: <201001171742.54145.liplianin@me.by>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Message-Id: <201001171727.44188.joep@groovytunes.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Do/did you have another TV tuner?
> Please check file /etc/modprobe.conf or files in /etc/modprobe.d/ for line
>  like this options cx88xx card=n
> Then remove the line
> 
> You can try to check your card
> 	modprobe cx88xx card=75
 
Hi Igor,

I used to have a Hauppauge card in this system.
It is not my own system so I will have a look at it when I am in front of it.
Thanks for the quick reply.

Joep
