Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51606 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752155AbZAJTkD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Jan 2009 14:40:03 -0500
From: Malte Gell <malte.gell@gmx.de>
To: linux-media@vger.kernel.org
Subject: Re: dvb-t: searching for channels
Date: Sat, 10 Jan 2009 20:40:05 +0100
References: <200901101645.51230.malte.gell@gmx.de> <4968E810.2050307@rogers.com>
In-Reply-To: <4968E810.2050307@rogers.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901102040.06001.malte.gell@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Malte Gell wrote:
> > Hello,
> >
> > I just purchased a Hauppauge Nova DVB-T USB stick and the kernel module
> > and firmware recognizes it well. I have first used Kaffeine to search for
> > channels, but it has found none.

> For answers to some of your questions, see:
> http://www.linuxtv.org/wiki/index.php/Scan

Thanks for the hint. But...:

dvbscan /usr/share/dvb/dvb-t/de-Mannheim

"Unable to query frontend status"

Why is it unable to open the device? /dev/dvb/* exists, firmware and modules 
loaded correctly...

dvbscan is from dvb-1.1.0_CVS20080331



