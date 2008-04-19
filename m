Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n15a.bullet.mail.mud.yahoo.com ([68.142.207.125])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1JnHDE-0006bP-R1
	for linux-dvb@linuxtv.org; Sat, 19 Apr 2008 19:51:00 +0200
Date: Sat, 19 Apr 2008 13:48:31 -0400
From: manu <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
In-Reply-To: <200804190101.14457.dkuhlen@gmx.net> (from dkuhlen@gmx.net on
	Fri Apr 18 19:01:14 2008)
Message-Id: <1208627311l.18445l.0l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re : Pinnacle PCTV Sat HDTV Pro USB (PCTV452e) and
 TT-Connect-S2-3600 final version
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On 04/18/2008 07:01:14 PM, Dominik Kuhlen wrote:
> Hi,
> =

> Here is my current version after quite a while of testing and tuning:
> I stripped the stb0899 tuning/searching algo to speed up tuning a bit
> now I have very fast and reliable locks (no failures, no errors)
> =

> I have also merged the TT-S2-3600 patch from Andr=E9. (I cannot test it
> though.)
> =

> the attached patch applies to jusst.de multiproto rev 7213
> the simpledvbtune application is for tuning tests: it does only open =

> the frontend and tunes. no data reading/section parsing.
> compile with:
> gcc -I/YOUR_MP_PATH/linux/include simpledvbtune.c -o simpletune
> and tune to (if you have Astra 19.2 as first satellite)
> ZDF DVB-S transponder
> ./simpledvbtune -f 11954 =

> Astra demo DVB-S2 transponder
> ./simpledvbtune -f 11915 -d 2

I patched stb988*.c to see if it immproved my reception, but so far it =

looks pretty much the same: transponder on 11093 is always perfect and =

all others are unreliable (meaning: going from no lock to perfect image =

between times, and if I get no lock tuning to the good transponder on =

11093 MHz and tuning back to where it did not work will give me a lock =

in general), so... I was lost.
I also tried to substract 4 Mhz to the tuning frequency even up to 10 =

MHz but with the same symptoms.
BUT the good news is : ADDING 4MHz gives good results: perfect picture =

on every transponders!
Bye
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
