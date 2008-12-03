Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bobrnet.cust.inethome.cz ([88.146.180.6]
	helo=mailserver.bobrnet.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <pavel.hofman@insite.cz>) id 1L814l-0004oz-DB
	for linux-dvb@linuxtv.org; Thu, 04 Dec 2008 00:24:15 +0100
Message-ID: <49371511.1060703@insite.cz>
Date: Thu, 04 Dec 2008 00:24:01 +0100
From: Pavel Hofman <pavel.hofman@insite.cz>
MIME-Version: 1.0
To: Alex Betis <alex.betis@gmail.com>
References: <49346726.7010303@insite.cz> <4934D218.4090202@verbraak.org>	
	<4935B72F.1000505@insite.cz>	
	<c74595dc0812022332s2ef51d1cn907cbe5e4486f496@mail.gmail.com>
	<c74595dc0812022347j37e83279mad4f00354ae0e611@mail.gmail.com>
In-Reply-To: <c74595dc0812022347j37e83279mad4f00354ae0e611@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Technisat HD2 cannot szap/scan
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

Alex Betis napsal(a):
> On Wed, Dec 3, 2008 at 9:32 AM, Alex Betis <alex.betis@gmail.com 
> <mailto:alex.betis@gmail.com>> wrote:
> 
> 
>     On Wed, Dec 3, 2008 at 12:31 AM, Pavel Hofman
>     <pavel.hofman@insite.cz <mailto:pavel.hofman@insite.cz>> wrote:
> 
>         pavel@htpc:~/project/satelit2/szap-s2$
>         <mailto:pavel@htpc:~/project/satelit2/szap-s2$> ./szap-s2 -x
>         EinsFestival
>         reading channels from file '/home/pavel/.szap/channels.conf'
>         zapping to 5 'EinsFestival':
>         delivery DVB-S, modulation QPSK
>         sat 0, frequency 12110 MHz H, symbolrate 27500000, coderate auto,
> 
>     I don't think there is 12110 channel on Astra 19.2, at least not
>     accirding to lyngsat.
> 
> My bad, there is such channel... I somehow got to Astra 1G only page 
> instead of all Atras in that position.
> Try other frequencies anyway.
>  
> Maybe you have diseqc problems?
> 

Alex,

Thanks a lot for your help. I tested the card on a different computer 
with Windows and I could scan and view both Astra 19.2E and Astra 23.5E 
free-to-air programs through A and B parts of the dual LNB. I have no 
decoding card yet, nor any adapter.

Since the computer was different, I will test my final computer/setup in 
windows (just have to install them first here :) ). Nevertheless I think 
it will work in windows.

I will get back with result.

Regards,

Pavel.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
