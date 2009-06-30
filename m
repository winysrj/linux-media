Return-path: <linux-media-owner@vger.kernel.org>
Received: from node04.cambriumhosting.nl ([217.19.16.165]:60446 "EHLO
	node04.cambriumhosting.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756901AbZF3UMn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jun 2009 16:12:43 -0400
Received: from localhost (localhost [127.0.0.1])
	by node04.cambriumhosting.nl (Postfix) with ESMTP id 14204B0000C9
	for <linux-media@vger.kernel.org>; Tue, 30 Jun 2009 22:12:46 +0200 (CEST)
Received: from node04.cambriumhosting.nl ([127.0.0.1])
	by localhost (node04.cambriumhosting.nl [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ONMTqcij1HfA for <linux-media@vger.kernel.org>;
	Tue, 30 Jun 2009 22:12:44 +0200 (CEST)
Received: from ashley.powercraft.nl (84-245-3-195.dsl.cambrium.nl [84.245.3.195])
	by node04.cambriumhosting.nl (Postfix) with ESMTP id 68E25B0000AE
	for <linux-media@vger.kernel.org>; Tue, 30 Jun 2009 22:12:44 +0200 (CEST)
Received: from [192.168.1.185] (unknown [192.168.1.185])
	by ashley.powercraft.nl (Postfix) with ESMTPSA id BC5AA23BC40C
	for <linux-media@vger.kernel.org>; Tue, 30 Jun 2009 22:12:43 +0200 (CEST)
Message-ID: <4A4A71B9.5010603@powercraft.nl>
Date: Tue, 30 Jun 2009 22:12:41 +0200
From: Jelle de Jong <jelledejong@powercraft.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Afatech AF9013 DVB-T not working with mplayer radio streams
References: <4A4481AC.4050302@powercraft.nl>
In-Reply-To: <4A4481AC.4050302@powercraft.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jelle de Jong wrote:
> Hi all,
> 
> Because i now use a new kernel and new mplayer versions I did some
> testing again on one of my long standing issues.
> 
> My Afatech AF9015 DVB-T USB2.0 stick does not work with mplayer, other
> em28xx devices do work with mplayer.
> 
> Would somebody be willing to do some tests and see if mplayers works on
> your devices?
> 
> Debian 2.6.30-1
> 
> /usr/bin/mplayer -identify -v -dvbin timeout=10 dvb://"3FM(Digitenne)"
> 
> See the attachments for full details.
> 
> Best regards,
> 
> Jelle de Jong
> 

I am going to give this thread a ping, because I believe this is one of
the few out of the box supported usb dvb-t devices. And I would like to
have at least one device that I can currently buy and that works. So
could somebody with a AF9015 device test if it works with mplayer?

Also please test the stability. When I use my device with totem it has
issues getting video, I have to replug the device to get it working
again, no dmesg error messages and dvb-t signal is very strong.

I need to be able to just boot the system start totem or mplayer let it
run stable until the system gets shutdown by the user. (like as a normal
TV or a DVB-T system with Apple OSX stability)

Best regards,

Jelle
