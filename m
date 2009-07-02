Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57226 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755536AbZGBW3H (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Jul 2009 18:29:07 -0400
Message-ID: <4A4D34B3.8050605@iki.fi>
Date: Fri, 03 Jul 2009 01:29:07 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jelle de Jong <jelledejong@powercraft.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Afatech AF9013 DVB-T not working with mplayer radio streams
References: <4A4481AC.4050302@powercraft.nl>
In-Reply-To: <4A4481AC.4050302@powercraft.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/26/2009 11:07 AM, Jelle de Jong wrote:
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

For me, this works. I tested this with MT2060 tuner device, as you have 
also. If I remember correctly it worked for you also when channel is 
selected by using tzap. I don't know what mplayer does differently.

Do the television channels in that same multiplex work with mplayer?
/usr/bin/mplayer -identify -v -dvbin timeout=10 dvb://"TELEVISION CHANNEL"

I added some delay for demod to wait lock. Could you try if this helps?
http://linuxtv.org/hg/~anttip/af9015_delay/

regards
Antti
-- 
http://palosaari.fi/
