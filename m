Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37201 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757053AbZAQRlh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jan 2009 12:41:37 -0500
Message-ID: <4972184D.3000709@iki.fi>
Date: Sat, 17 Jan 2009 19:41:33 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jochen Friedrich <jochen@scram.de>
CC: Detlef Rohde <rohde.d@t-online.de>,
	Roberto Ragusa <mail@robertoragusa.it>,
	linux-media@vger.kernel.org
Subject: Re: MC44S803 frontend (it works)
References: <4936FF66.3020109@robertoragusa.it> <494C0002.1060204@scram.de> <49623372.90403@robertoragusa.it> <4965327A.5000605@t-online.de> <496CD4C8.50004@t-online.de> <496E2C6B.3050607@scram.de> <496E2FB5.4080406@scram.de> <4971367E.90504@iki.fi> <4971AE26.9070901@t-online.de> <4971B278.8010804@iki.fi> <4971B4F6.1020407@scram.de>
In-Reply-To: <4971B4F6.1020407@scram.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jochen,

Jochen Friedrich wrote:
> This version works OK for me :-). The old version also worked, but was very insensitive (i only received one
> transponder instead of 6, i guess this GPIO must switch on some RF-amplifyer or so).

Yes, you are correct. I also ensured that from TerraTec provided driver.

I moved af9015_i2c_xfer() things back as I now think those are enough 
general. If driver now works, and you are also happy for af9015 changes 
I did, af9015 changes are fine for me too.
Could you look and make fast test all are ok?

PS.
If you want remote working then send AF15IRTBL.bin (or USB-sniff) to me. 
 From file I can look correct IR-codes for your remote control and after 
those are set it is rather easy to add key bindings for button events. 
This same apply all AF9015 devices, I am happy to add remotes too.

regards
Antti
-- 
http://palosaari.fi/
