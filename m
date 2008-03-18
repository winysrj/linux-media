Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1JbfBY-0007lT-Lu
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 18:01:15 +0100
Message-ID: <47DFF536.5070802@iki.fi>
Date: Tue, 18 Mar 2008 19:00:38 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Albert Comerma <albert.comerma@gmail.com>
References: <ea4209750803180734m67c0990byabb81bb2ec52d992@mail.gmail.com>	<47DFDCC4.4090001@iki.fi>
	<20080318163812.343b0a87@slackware.it>	<20080318170134.69e40dab@slackware.it>
	<47DFEA9F.4070307@iki.fi>	<20080318171508.4c685367@slackware.it>
	<ea4209750803180931j1333c812o15cdb544a998b018@mail.gmail.com>
In-Reply-To: <ea4209750803180931j1333c812o15cdb544a998b018@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dib7770 tunner
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

Albert Comerma wrote:
> Having a look at the code I also don't see any reference to the tunner 
> with stk7070. Could you try to compile with the files I send?
>
> Albert
> 
> 2008/3/18, insomniac <insomniac@slackware.it 
> <mailto:insomniac@slackware.it>>:
> 
>     On Tue, 18 Mar 2008 18:15:27 +0200
> 
>     Antti Palosaari <crope@iki.fi <mailto:crope@iki.fi>> wrote:
> 
> 
>      > > DVB: registering frontend 0 (DiBcom 7000PC)...
>      > > mt2060 I2C read failed
>      >
>      > I don't understand how dib7070p_tuner_attach could call mt2060.
> 
> 
>     Is there anything I can do to make you debug it?


We discussed this in IRC and looks like it is now working. Errors was 
that old modules were still loaded in memory trying to attach mt2060 
tuner, number of devices was not updated correctly. After those fixes it 
  loads and detects all as should.

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
