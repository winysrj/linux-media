Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1JNrmY-0008Bb-Aa
	for linux-dvb@linuxtv.org; Sat, 09 Feb 2008 16:38:23 +0100
Received: by fg-out-1718.google.com with SMTP id 22so3122193fge.25
	for <linux-dvb@linuxtv.org>; Sat, 09 Feb 2008 07:38:21 -0800 (PST)
Message-ID: <47ADC81B.4050203@gmail.com>
Date: Sat, 09 Feb 2008 16:34:51 +0100
From: Eduard Huguet <eduardhc@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org, Matthias Schwarzott <zzam@gentoo.org>
Subject: [linux-dvb] Some tests on Avermedia A700
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi, Matthias
    I've been performing some tests using your patch for this card. 
Right now neither dvbscan nor kaffeine are able to find any channel on 
Astra (the sat. my dish points to).

However, Kaffeine has been giving me some interesting results: with your 
driver "as is" it's getting me a 13-14% signal level and ~52% SNR when 
scanning. Then, thinking that the problem is related to the low signal I 
have I've changed the gain levels used to program the tuner: you were 
using default values of 0 for all (in zl1003x_set_gain_params() 
function, variables "rfg", "ba" and "bg"), and I've changed them top the 
maximum (according to the documentation: rfg=1, ba=bg=3). With that, I'm 
getting a 18% signal level, which is higher but still too low apparently 
to get a lock.

I've stopped here, because I really don't have the necessary background 
to keep tweaking the driver. I just wanted to share it with you, as 
maybe you have some idea on how to continue or what else could be done.

Best regards,
  Eduard

PD: the satelite dish is on the top of the building and it's shared 
(this is a 15-floor building). This is probably the reason I get a 
signal that low. Anyway, I think I still should be able to use the card, 
but maybe I'm wrong and I need to pre-amplify the signal.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
