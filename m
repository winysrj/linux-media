Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpout09-01.prod.mesa1.secureserver.net ([64.202.165.14]:39895
	"HELO smtpout09.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932134AbZHYVGY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 17:06:24 -0400
Message-ID: <4A945126.5070102@Emel-Harrington.net>
Date: Tue, 25 Aug 2009 14:01:26 -0700
From: Steve Harrington <steve@Emel-Harrington.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Hauppauge 2250 - second tuner is only half working
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have the same problem as Seth.  My system will tune RF channel 85 and 
below will not tune RF channel 91 and above on the second tuner only.  
First tuner works fine on all channels as does the PC HDTV 5500 also in 
the system.  My normal configuration is a 4-way splitter from the cable 
into the house.  One leg goes to a 2-way that feeds the two cards in the 
system.  With this configuration the normal result is:

Frontend /dev/dvb/adapter2/frontend0 tuned in 1 seconds.
Channel 80:    Standard=ATSC, Modulation=QAM_256
       SNR=0X0172, SIGNAL=0X0172

for channel 80 and:

Unable to set frontend /dev/dvb/adapter2/frontend0:frequency=669000000, 
modulation=QAM_256

for channel 103.

After reading Steven Toth's reply I tried adding 1 and then 2 2-way 
splitters before the 2250 input. No joy.  I also tried feeding the cable 
directly into the 2250 with no splitters.  Again - no joy.
Any other ideas?
