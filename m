Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52404 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068Ab2BWR7h (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Feb 2012 12:59:37 -0500
Message-ID: <4F467E80.4060302@iki.fi>
Date: Thu, 23 Feb 2012 19:59:28 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans-Frieder Vogt <hfvogt@gmx.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/3] Support for AF9035/AF9033
References: <201202222320.56583.hfvogt@gmx.net>
In-Reply-To: <201202222320.56583.hfvogt@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23.02.2012 00:20, Hans-Frieder Vogt wrote:
> I have written a driver for the AF9035&  AF9033 (called af903x), based on the
> various drivers and information floating around for these chips.
> Currently, my driver only supports the devices that I am able to test. These
> are
> - Terratec T5 Ver.2 (also known as T6)
> - Avermedia Volar HD Nano (A867)
>
> The driver supports:
> - diversity and dual tuner (when the first frontend is used, it is in diversity
> mode, when two frontends are used in dual tuner mode)
> - multiple devices
> - pid filtering
> - remote control in NEC and RC-6 mode (currently not switchable, but depending
> on device)
> - support for kernel 3.1, 3.2 and 3.3 series
>
> I have not tried to split the driver in a DVB-T receiver (af9035) and a
> frontend (af9033), because I do not see the sense in doing that for a
> demodulator, that seems to be always used in combination with the very same
> receiver.

That was how I originally implemented it. Reason for that is simple: 
af9033 demodulator exists as single chip. I think it is also used for 
dual tuner devices or is there 2 af9035 chips used, like one is master 
and one is slave and working as a demod?

Situation is rather same for af9005/af9003 and af9015/af9013. Search 
from the mailing list and see there is devices using af9003 demod but as 
it is not split correctly from the af9005 those devices are never 
supported (due to fact af9003 demod is not split out).

Reason behind my af9035/af9033 is not merged to the Kernel is that I 
never found people from ITE who was able to give permission to merge 
that. As it contains some vendor code I didn't want to merge it without 
permission.

It is not many day work to write all vendor code out from the driver and 
get it clean. If you want I can do it for you and merge that to the 
Kernel. You can then take whole driver and start hacking if you wish. 
What do you think? I am currently busy as hell and I don't want more 
drivers to maintain so you can take maintaining responsibility.

> The patch is split in three parts:
> Patch 1: support for tuner fitipower FC0012
> Patch 2: basic driver
> Patch 3: firmware
>
> Hans-Frieder Vogt                       e-mail: hfvogt<at>  gmx .dot. net

regards
Antti

-- 
http://palosaari.fi/
