Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <w3ird_n3rd@gmx.net>) id 1JaKeS-0006O9-D0
	for linux-dvb@linuxtv.org; Sat, 15 Mar 2008 01:53:37 +0100
Message-ID: <47DB1DEA.9080401@gmx.net>
Date: Sat, 15 Mar 2008 01:52:58 +0100
From: "P. van Gaans" <w3ird_n3rd@gmx.net>
MIME-Version: 1.0
To: Karim 'Kasi Mir' Senoucci <linux-dvb@tvetc.de>
References: <Pine.LNX.4.61.0803142323470.11774@jericho.melzone.de>
In-Reply-To: <Pine.LNX.4.61.0803142323470.11774@jericho.melzone.de>
Cc: LinuxTV mailing list <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Terratec Cinergy DVB C PCI CI - CI working?
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

On 03/14/2008 11:35 PM, Karim 'Kasi Mir' Senoucci wrote:
> Hello everyone,
> I've got the Terratec Cinergy C PCI HD card with the CI extension and am 
> currently trying to get this to work with Mythbuntu 7.10. So far, I've 
> got a working TV signal and a more or less complete list of the Kabel 
> Deuttschland DVB-C channels. I can even watch the free-to-air channels 
> without any problems. 
> 
> The encrypted channels (of which there are legion) are another matter, 
> though. AS I wrote above, I have the CI addon, I have a AlphaCrypt CAM 
> capable of decoding the Cable encryption, plus I've got a keycard which 
> actually can decode about 100 channels. 
> 
> But still, MythTV doesn't decode any encrypted channels - which leads me 
> to my question: is the CI supported by Linux? As far a I can see, there 
> is no line containing CI oder CAM in any logfile written by the linux 
> system. 
> 
> Can anybody help me out here? Any help is appreciated; if you need more 
> input, just ask and I will try to provide the info. 
> 
> Greetings
> Kasi Mir
> 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 

Did you get the latest v4l-dvb from http://linuxtv.org/repo/? If not, 
try that first.

When you insert your CAM, you should be able to read some message with 
dmesg about the card having been initialized or having failed. You 
should also have a /dev/dvb/adapterN/ca0.

Also check your CI cable. They fail quite often.

P.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
