Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47436 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030326Ab2GFMIZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jul 2012 08:08:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Sn7Kd-00069a-0K
	for linux-media@vger.kernel.org; Fri, 06 Jul 2012 14:08:19 +0200
Received: from btm70.neoplus.adsl.tpnet.pl ([83.29.158.70])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 06 Jul 2012 14:08:18 +0200
Received: from acc.for.news by btm70.neoplus.adsl.tpnet.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 06 Jul 2012 14:08:18 +0200
To: linux-media@vger.kernel.org
From: Marx <acc.for.news@gmail.com>
Subject: Re: pctv452e
Date: Fri, 06 Jul 2012 13:04:41 +0200
Message-ID: <9btic9-vd5.ln1@wuwek.kopernik.gliwice.pl>
References: <4FF4697C.8080602@nexusuk.org> <4FF46DC4.4070204@iki.fi> <4FF4911B.9090600@web.de> <4FF4931B.7000708@iki.fi> <gjggc9-dl4.ln1@wuwek.kopernik.gliwice.pl> <4FF5A350.9070509@iki.fi> <r8cic9-ht4.ln1@wuwek.kopernik.gliwice.pl> <4FF6B121.6010105@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <4FF6B121.6010105@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06.07.2012 11:34, Antti Palosaari wrote:
> Did I missed something? PCTV device does not support CI/CAM and thus no
> support for encrypted channels. Is there still CI slot?

no, I simply use external reader with plugin in VDR. Unfortunetelly on 
Hotbird there is no unencrypted HD channel I can use to test.

>> Anyway when using card logs are full of i2c errors
>
> Argh! But this must be issue of earlier driver too.

yes, those errors were in logs earlier on previous driver. Hovewer 
previous driver allowed to play only once or two time and then was 
stopping work. And i've never played successfully HD channel on this card.

> I debug it and it seems to be totally clueless implementation of
> stb6100_read_reg() as it sets device address like "device address +
> register address". This makes stb6100 I2C address of tuner set for that
> request 0x66 whilst it should be 0x60. Is that code never tested...
>
> pctv452e DVB USB driver behaves just correctly as it says this is not
> valid and returns error.
>
> Also pctv452e I2C adapter supports only I2C operations that are done
> with repeated STOP condition - but I cannot see there is logic to sent
> STOP after last message. I suspect it is not correct as logically but
> will work - very common mistake with many I2C adapters we have.

I have second card in this computer
http://www.proftuners.com/prof8000.html
which uses STB6100 (and also STV0903 and CX23885).
I wasn't aware that both of this card uses the same chip (as I see from 
http://www.linuxtv.org/wiki/index.php/TechnoTrend_TT-connect_S2-3650_CI 
it uses STB6100 too).
Can it be a problem? Anyway i will take off this second card a test again.

> Regardless of those errors it still works?

Thank you for help. I had only a few minutes at the morning to test it 
and it partly worked. More test are planned tonight and I will write 
here outcomes.

Marx

