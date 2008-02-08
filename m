Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from smtp100.rog.mail.re2.yahoo.com ([206.190.36.78])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <CityK@rogers.com>) id 1JNU9d-0000PG-QL
	for linux-dvb@linuxtv.org; Fri, 08 Feb 2008 15:24:38 +0100
Message-ID: <47AC65FE.8080005@rogers.com>
Date: Fri, 08 Feb 2008 09:23:58 -0500
From: CityK <CityK@rogers.com>
MIME-Version: 1.0
To: Nicolas Will <nico@youplala.net>
References: <1202466494.6667.18.camel@acropora>
In-Reply-To: <1202466494.6667.18.camel@acropora>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] TM6000 status
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

Nicolas Will wrote:
> Hello all,
>
> I've been talking with Michel Ludwig about the ADSTech Mini Dual TV
> (PTV-339) USB stick.
>
> It needs the xc2028/3028 module (in the main tree currently?) as well as
> the tm6000 module (and firmware).
>
> I see that these two hg branches exist:
>
> http://linuxtv.org/hg/~mchehab/tm6000/
> http://linuxtv.org/hg/~mchehab/tm6010/
>
> This wiki page exists, but look very outdated:
>
> http://linuxtv.org/v4lwiki/index.php/Trident_TM6000
>
> What's the status of all this ? What works?, What doesn't work? What is
> needed? Bugs, problems, show-stoppers? (no pressure, yet ;o), this is
> just for documentation's sake)
>
> I'm willing to clean-up/update the wiki when given information.
>
> Michel has my ADSTeck stick, and soon the remote as well, with him.
>
> Nico/camelreef

Hi Nico,

Mauro will definitely best know the answers to the status questions. I 
will only note that if your ADS device is similar to Mauro's 10moons 
device (which is also TM6000 & XC based) then you might require an older 
firmware for the XC tuner --- see Mauro's comment about it as 
encapsulated here:

http://www.linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028#About_the_Xceive_firmware


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
