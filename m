Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bobrnet.cust.inethome.cz ([88.146.180.6]
	helo=mailserver.bobrnet.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <pavel.hofman@insite.cz>) id 1L9lFR-0005Lq-M5
	for linux-dvb@linuxtv.org; Mon, 08 Dec 2008 19:54:26 +0100
Message-ID: <493D6D58.8010704@insite.cz>
Date: Mon, 08 Dec 2008 19:54:16 +0100
From: Pavel Hofman <pavel.hofman@insite.cz>
MIME-Version: 1.0
To: Michel Verbraak <michel@verbraak.org>
References: <49346726.7010303@insite.cz>	<4934D218.4090202@verbraak.org>		<4935B72F.1000505@insite.cz>		<c74595dc0812022332s2ef51d1cn907cbe5e4486f496@mail.gmail.com>	<c74595dc0812022347j37e83279mad4f00354ae0e611@mail.gmail.com>	<49371511.1060703@insite.cz>
	<493BE666.8030007@insite.cz> <493CC447.8030606@verbraak.org>
In-Reply-To: <493CC447.8030606@verbraak.org>
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

Michel Verbraak napsal(a):
>>   
> Pavel,
> 
> The reason why you probably do not get picture on LNB1 is because you 
> are still getting a stream from LNB0. Probably there is a transponder on 
> LNB0 with the same frequency and symbolrate as on LNB1 (frequency 11515 
> MHz H, symbolrate 27500000) but the specified PIDs (vpid 0x0947, apid 
> 0x0948) do not exist. Therefore you do not get a picture.
> 
> Have a look at http://nl.kingofsat.net/pos-19.2E.php. Find the 
> transponder for LNB0 with the same frequency and symbolrate (frequency 
> 11515 MHz H, symbolrate 27500000) as tried on LNB1 but with a set of 
> PIDs that exist on LNB0. Change the channels.conf file and szap again to 
> LNB1 with these parameters. If you do get picture you are sure that the 
> diseqc switch is not switching but stays on LNB0.
> 
> Please report your result to the list.
> 
> Regards,
> 
> Michel.

Hi Michel,

I appreciate your help a lot. Fortunately I can tune the second LNB now. 
  I got caught by the scan/mplayer LNB numbering inconsistency too.

Regards,

Pavel.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
