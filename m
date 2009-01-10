Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp111.rog.mail.re2.yahoo.com ([206.190.37.1]:48269 "HELO
	smtp111.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752543AbZAJScK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Jan 2009 13:32:10 -0500
Message-ID: <4968E810.2050307@rogers.com>
Date: Sat, 10 Jan 2009 13:25:20 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Malte Gell <malte.gell@gmx.de>
CC: linux-media@vger.kernel.org
Subject: Re: dvb-t: searching for channels
References: <200901101645.51230.malte.gell@gmx.de>
In-Reply-To: <200901101645.51230.malte.gell@gmx.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Malte Gell wrote:
> Hello,
>
> I just purchased a Hauppauge Nova DVB-T USB stick and the kernel module and 
> firmware recognizes it well. I have first used Kaffeine to search for channels, 
> but it has found none. 
>
> To be sure I even bought a better, an active dvb-t antenna with a 20dB 
> amplifier. And now I used dvbscan to scan for channels, I invoked it like this:
>
> dvbscan -out channels /usr/share/dvb/dvb-t/de-Mannheim
>
> Is this the better way? It takes now longer than 15 minutes, is this normal? 
> Is dvbscan more reliable than kaffeine for searching for channels? If I still 
> find no channels, what could be the cause? In my region dvb-t signals are said 
> to be not too well.
>   

For answers to some of your questions, see:
http://www.linuxtv.org/wiki/index.php/Scan
