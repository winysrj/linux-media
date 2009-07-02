Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay01.cambriumhosting.nl ([217.19.16.173]:36393 "EHLO
	relay01.cambriumhosting.nl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751692AbZGBInw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Jul 2009 04:43:52 -0400
Received: from relay01.cambriumhosting.nl (localhost [127.0.0.1])
	by relay01.cambriumhosting.nl (Postfix) with ESMTP id 6401C60001D0
	for <linux-media@vger.kernel.org>; Thu,  2 Jul 2009 10:43:54 +0200 (CEST)
Received: from ashley.powercraft.nl (84-245-3-195.dsl.cambrium.nl [84.245.3.195])
	by relay01.cambriumhosting.nl (Postfix) with ESMTP id 4C66360001CA
	for <linux-media@vger.kernel.org>; Thu,  2 Jul 2009 10:43:54 +0200 (CEST)
Received: from [192.168.1.185] (unknown [192.168.1.185])
	by ashley.powercraft.nl (Postfix) with ESMTPSA id 13C9F23BC5E9
	for <linux-media@vger.kernel.org>; Thu,  2 Jul 2009 10:43:54 +0200 (CEST)
Message-ID: <4A4C7349.2080705@powercraft.nl>
Date: Thu, 02 Jul 2009 10:43:53 +0200
From: Jelle de Jong <jelledejong@powercraft.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Afatech AF9013 DVB-T not working with mplayer radio streams
References: <4A4481AC.4050302@powercraft.nl> <4A4A71B9.5010603@powercraft.nl>
In-Reply-To: <4A4A71B9.5010603@powercraft.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jelle de Jong wrote:
> Jelle de Jong wrote:
>> Hi all,
>>
>> Because i now use a new kernel and new mplayer versions I did some
>> testing again on one of my long standing issues.
>>
>> My Afatech AF9015 DVB-T USB2.0 stick does not work with mplayer, other
>> em28xx devices do work with mplayer.
>>
>> Would somebody be willing to do some tests and see if mplayers works on
>> your devices?
>>
>> Debian 2.6.30-1
>>
>> /usr/bin/mplayer -identify -v -dvbin timeout=10 dvb://"3FM(Digitenne)"
>>
>> See the attachments for full details.
>>
>> Best regards,
>>
>> Jelle de Jong
>>
> 
> I am going to give this thread a ping, because I believe this is one of
> the few out of the box supported usb dvb-t devices. And I would like to
> have at least one device that I can currently buy and that works. So
> could somebody with a AF9015 device test if it works with mplayer?
> 
> Also please test the stability. When I use my device with totem it has
> issues getting video, I have to replug the device to get it working
> again, no dmesg error messages and dvb-t signal is very strong.
> 
> I need to be able to just boot the system start totem or mplayer let it
> run stable until the system gets shutdown by the user. (like as a normal
> TV or a DVB-T system with Apple OSX stability)


Some extra information about the lockups of my AF9015, this is a serious
blocker issue for me. It happens when I watch a channel with totem-xine
and switch to an other channel, the device is then unable to lock to the
new channel, and totem-xine hangs. There are no messages in dmesg.

Rebooting the system does not help getting the device working again, the
only way i found is to replug the usb device and this is not an option
for my systems because the usb devices are hidden.

Is there an other USB DVB-T device that works out of the box with the
2.9.30 kernel? Could somebody show me a link or name of this device so I
can buy and test it?

Thanks in advance,

Jelle
