Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mout-bounce.kundenserver.de ([212.227.17.1])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <holger@rusch.name>) id 1LEQJL-0001SY-GM
	for linux-dvb@linuxtv.org; Sun, 21 Dec 2008 16:33:44 +0100
Message-ID: <494E61B4.2040006@rusch.name>
Date: Sun, 21 Dec 2008 16:33:08 +0100
From: Holger Rusch <holger@rusch.name>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <cae4ceb0812091511s668dcc5fj793e7efc113fedfd@mail.gmail.com>
	<493F8A81.7040802@rusch.name>
In-Reply-To: <493F8A81.7040802@rusch.name>
Subject: [linux-dvb] TerraTec Cinergy DT USB XS Diversity (Quality with
 linux worse then with Windows)
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

Shameless repost. No idea? Anybody?

Holger Rusch schrieb:
> Hi,
> 
> i got a
> 
> TerraTec Cinergy DT USB XS Diversity
> http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_DT_USB_XS_Diversity
> 
> Running well with v4l (except the problems with the SB700 USB ports of 
> my MB (disconnects here and then) => I am using a PCI USB Card with NEC 
> Chipset and everything works well).
> 
> One thing that bugs me:
> 
> The recording/reception quality is much worse that with windows.
> 
> Using the Terratec Software i get 100% signal and 100% quality in 
> check-mode and i NEVER got any frameloss or other picture/sound errors.
> 
> Using v4l and vdr i get mpeg-blocks here and then (5 minutes) and even 
> soundloss or complete frame loss.
> 
> Femon-Plugin for VDR shows me STR/SNR/BNR values which are in the lower 
> orange area, really close to red. => BAD!
> 
> What may be the cause?
> 
> This is set:
> options dvb_usb_dib0700 force_lna_activation=1
> 
> Would be nice to see help to get 100% signal back.
> 
> Tu-Tu Yu schrieb:
>> Hi Sirs:
>> I am working on the Dvico HDTV7 Dual Express TV tuner card under Linux
>> environment with kernel (2.6.26).
>> When I check the snr value and signal status about every 10 seconds,
>> it works fine in first few hours, but it will stop after about 12 - 24
>> hours.
>> I found out if i check the snr and signal status every second. It will
>> stop after 5 hours.
>> If I check the snr and siganl status every time it read PES, it will
>> stop in few minutes.
>> And it will show the message==> value too large for defined data type,
>> Read -1 byte from DVR.
>> Do you think it because the driver is not compatible with my Desktop?
>> Or I shouldnt check the snr value?
>> Thank you so much
>> Tu Tu Yu
>> tutuyu@usc.edu
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 
> 


-- 
+ Contact? => http://site.rusch.name/ +


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
