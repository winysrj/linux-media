Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ctb-mesg5.saix.net ([196.25.240.75])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jd.louw@mweb.co.za>) id 1JpnRc-0000TE-Qy
	for linux-dvb@linuxtv.org; Sat, 26 Apr 2008 18:40:17 +0200
Received: from Core2Duo (dsl-244-50-140.telkomadsl.co.za [41.244.50.140])
	by ctb-mesg5.saix.net (Postfix) with ESMTP id 0528021FC
	for <linux-dvb@linuxtv.org>; Sat, 26 Apr 2008 18:39:36 +0200 (SAST)
Message-ID: <003501c8a7bc$1b324a30$0500000a@Core2Duo>
From: "Jan Louw" <jd.louw@mweb.co.za>
To: <linux-dvb@linuxtv.org>
References: <20080412150444.987445669@gentoo.org>
	<200804121737.28314.zzam@gentoo.org>
Date: Sat, 26 Apr 2008 18:39:32 +0200
MIME-Version: 1.0
Subject: Re: [linux-dvb] [patch 0/5] mt312: Add support for zl10313 demod
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

Hi Matthias,

It still works. I combined your zl10313 modulator patch  with my earlier 
zl10039 frontend patch. The additional modifications necesary are in (see 
previous patch):

~/schwarzottv4l/v4l-dvb $ hg status
M linux/drivers/media/dvb/frontends/Kconfig
M linux/drivers/media/dvb/frontends/Makefile
M linux/drivers/media/video/saa7134/Kconfig
M linux/drivers/media/video/saa7134/saa7134-cards.c
M linux/drivers/media/video/saa7134/saa7134-dvb.c
M linux/drivers/media/video/saa7134/saa7134.h
A linux/drivers/media/dvb/frontends/zl10039.c
A linux/drivers/media/dvb/frontends/zl10039.h
A linux/drivers/media/dvb/frontends/zl10039_priv.h

To keep it simple I omitted the previous remote control code.

Regards
JD

----- Original Message ----- 
From: "Matthias Schwarzott" <zzam@gentoo.org>
To: "Jan D. Louw" <myvonkpos@mweb.co.za>
Cc: <linux-dvb@linuxtv.org>
Sent: Saturday, April 12, 2008 5:37 PM
Subject: Re: [linux-dvb] [patch 0/5] mt312: Add support for zl10313 demod


> On Samstag, 12. April 2008, Matthias Schwarzott wrote:
>> mt312: Cleanup driver and add support for zl10313.
>>
>> These patches add support for the Zarlink zl10313 demod to mt312 driver.
>> This chip is used at least on Avermedia A700 DVB-S and
>> Compro VideoMate S300/S350 DVB-S cards.
>>
> Hi Jan!
> 
> Could you please try to use this driver with your Compro card.
> 
> Regards
> Matthias
> 
> -- 
> Matthias Schwarzott (zzam)

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
