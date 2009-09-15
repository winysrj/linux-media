Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53775 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755AbZIOSbb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 14:31:31 -0400
Message-ID: <4AAFDD81.4000303@iki.fi>
Date: Tue, 15 Sep 2009 21:31:29 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: "Roman v. Gemmeren" <Roman@hasnoname.de>
CC: linux-media@vger.kernel.org
Subject: Re: MSI Digivox Micro HD support?
References: <200909151932.01107.Roman@hasnoname.de>
In-Reply-To: <200909151932.01107.Roman@hasnoname.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/15/2009 08:32 PM, Roman v. Gemmeren wrote:
> hi list,
>
> i just bought the above mentioned DVBT-Stick after my terratec prodigy died
> (from overheating i guess).
> I remembered sth. about digivox being supported, but i found only drivers for
> the "Digivox Mini II 3.0" which don't seem to recognize that stick at all.
>
> Anyone got that card working? If it is just the usb-id which is missing,
> how /where would i add that to the source?

Just do lsusb -vvd USB:ID and post here. From that we usually can say 
which chips are used and correct driver needed for device. Also you can 
look driver .inf file, driver filenames, look strings from driver, look 
sniff or open the box to identify chips.

Antti
-- 
http://palosaari.fi/
