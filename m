Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.freakix.de ([89.238.65.154]:47309 "EHLO mail.freakix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933742AbZHWPXc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2009 11:23:32 -0400
Message-ID: <4A9158DE.9040901@freakpixel.de>
Date: Sun, 23 Aug 2009 16:57:34 +0200
From: Norbert Weinhold <linux-dvb@freakpixel.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Can't tune to DVB-S2 channels on floppydtv
References: <4A908AC6.2080701@freakpixel.de> <200908230345.14069.hftom@free.fr>
In-Reply-To: <200908230345.14069.hftom@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Christophe Thommeret schrieb:
> Le Sunday 23 August 2009 02:18:14 Norbert Weinhold, vous avez écrit :
>> Hi,
>>
>> I have a floppyDTV S2 and I can't tune to dvb-s2 channels while normal
>> dvb-s channel work.
>>
>> Does anyone have a clue where the problem is.
> 
> Are you sure the driver supports S2 at all ?

Not 100% but I thought so because i found the hardware under supported
dvb-s2 devices. I wonder what is missing, because the card is doing all
difficult stuff itself. Just send the frequency / transponder you want
to receive you get the data if there is any reception at all.

After i had a look into the driver i saw that in the caps section 8psk
is missing and there is possibly a second tune command.

Has anyone a command list for this device?

Norbert

