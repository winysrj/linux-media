Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from host06.hostingexpert.com ([216.80.70.60])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1KOC0M-0004Z1-GW
	for linux-dvb@linuxtv.org; Wed, 30 Jul 2008 15:46:15 +0200
Message-ID: <489070A1.6060600@linuxtv.org>
Date: Wed, 30 Jul 2008 09:46:09 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: TANGAo Khaled <ktangao-neli@orange.fr>
References: <48906DCF.6020300@orange.fr>
In-Reply-To: <48906DCF.6020300@orange.fr>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] the function " int ioctl(int fd, int request =
 FE_READ_SNR, int16_t *snr); "
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

TANGAo Khaled wrote:
> Hello.
> 
>    I am working to design a software and i am using Frontend APIs. But I 
> still have a big problem witch, i do not understand. I want to know the 
> unit (linear or dB) of the value returned by this function:
> 
> int ioctl(int fd, int request = FE_READ_SNR, int16_t *snr);
> 
>  I would like to display an information to the user of my program,about 
> the quality of the signal his antenna picked up. To do this, i think the 
> best way is to display a graphic representing a percentage. But the 
> current value I read, (-258) is unusable like this. So can you please, 
> give me the unit of the value or give me a link to find what i am seeking?
> 
> Thank you
> 

Unfortunately, there is no *standard* unit of measure being used across all drivers.

It would be nice to clean this up and standardize the SNR reporting across every demod driver, but this will require some time & effort.  It will also require datasheets for all the demodulators so that we can find out what unit of measure is reported by the silicon, itself, so that it may be standardized across all drivers.

In the demodulator drivers that Steve Toth and I have been working on lately, we report the SNR in dB.  Again, not all drivers use the same units, so you cannot rely on this.

Sorry for the bad news.

HTH,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
