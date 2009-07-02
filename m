Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60853 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215AbZGBWoZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Jul 2009 18:44:25 -0400
Message-ID: <4A4D384C.3090101@iki.fi>
Date: Fri, 03 Jul 2009 01:44:28 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jelle de Jong <jelledejong@powercraft.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Afatech AF9013 DVB-T not working with mplayer radio streams
References: <4A4481AC.4050302@powercraft.nl> <4A4A71B9.5010603@powercraft.nl> <4A4C7349.2080705@powercraft.nl>
In-Reply-To: <4A4C7349.2080705@powercraft.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/02/2009 11:43 AM, Jelle de Jong wrote:
> Some extra information about the lockups of my AF9015, this is a serious
> blocker issue for me. It happens when I watch a channel with totem-xine
> and switch to an other channel, the device is then unable to lock to the
> new channel, and totem-xine hangs. There are no messages in dmesg.
>
> Rebooting the system does not help getting the device working again, the
> only way i found is to replug the usb device and this is not an option
> for my systems because the usb devices are hidden.

I have seen that also with Totem-xine few times. Totem-xine hags totally 
and it must be killed. But after that my device starts working without 
replug (if I remember correctly). One thing could be power issue. If you 
have possibility to test with powered USB -hub please do.

> Is there an other USB DVB-T device that works out of the box with the
> 2.9.30 kernel? Could somebody show me a link or name of this device so I
> can buy and test it?

DibCOM based sticks are usually good choice. There is many models from 
many vendors, TerraTec, Artec (Artec T14BR is sold here in Finland 20-30e).

DibCOM also uses big USB block size which seems to reduce system load. 
Look examples from here:
http://www.linuxtv.org/wiki/index.php/User:Hlangos

Could someone explain why USB block size have so big effect to load?

regards
Antti
-- 
http://palosaari.fi/
