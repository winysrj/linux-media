Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:60313 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932234Ab0AFOjO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Jan 2010 09:39:14 -0500
Date: Wed, 6 Jan 2010 15:39:09 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Daro <ghost-rider@aster.pl>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: IR device at I2C address 0x7a
Message-ID: <20100106153909.6bce3183@hyperion.delvare>
In-Reply-To: <4B324EF0.7090606@aster.pl>
References: <4B324EF0.7090606@aster.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Darek,

Adding LMML to Cc.

On Wed, 23 Dec 2009 18:10:08 +0100, Daro wrote:
> I have the problem you described at the mailing list with Asus 
> MyCinema-P7131/P/FM/AV/RC Analog TV Card:
> IR remote control is not detected and "i2c-adapter i2c-3: Invalid 7-bit 
> address 0x7a" error occurs.
> lspci gives the following output:
> 04:00.0 Multimedia controller: Philips Semiconductors 
> SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d1)
> dmesg output I enclose in the attachment.
> I use:
> Linux DOMOWY 2.6.31-16-generic #53-Ubuntu SMP Tue Dec 8 04:02:15 UTC 
> 2009 x86_64 GNU/Linux
> 
> I would be gratefull for the help on that.
> (...)
> subsystem: 1043:4845, board: ASUS TV-FM 7135 [card=53,autodetected]
> (...)
> i2c-adapter i2c-3: Invalid 7-bit address 0x7a
> saa7133[0]: P7131 analog only, using entry of ASUSTeK P7131 Analog

This error message will show on virtually every SAA713x-based board
with no known IR setup. It doesn't imply your board has any I2C device
at address 0x7a. So chances are that the message is harmless and you
can simply ignore it.

-- 
Jean Delvare
