Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JT1wC-0006Si-0w
	for linux-dvb@linuxtv.org; Sat, 23 Feb 2008 22:29:40 +0100
Message-ID: <47C0903B.70606@gmail.com>
Date: Sun, 24 Feb 2008 01:29:31 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Artem Makhutov <artem@makhutov.org>
References: <32245669.2613.1203594791803.JavaMail.tomcat@dali.otenet.gr>
	<47C01325.10407@otenet.gr>
	<20080223174406.GB30387@moelleritberatung.de>
	<47C0803D.2020504@gmail.com>
	<20080223212013.GD30387@moelleritberatung.de>
In-Reply-To: <20080223212013.GD30387@moelleritberatung.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TechniSat SkyStar HD: Problems scaning and zaping
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

Artem Makhutov wrote:
> Hi,
> 
> On Sun, Feb 24, 2008 at 12:21:17AM +0400, Manu Abraham wrote:
>> [...]
>> Can you guys please update from the multiproto tree and test again at
>> the earliest and give me your feedback ?
> 
> No, still the same:
> 
> Try: 50
> Failes: 37
> Tunes: 13
> 
> Maybe the problem is in the szap.c and not in the driver, as Reinhard
> Nissl had no problems while tuning channels with VDR?
> 
> An other thing that I noticed is that only first tunes are successful.
> I continued the same tuning test to 100, but I got no more successfull locks.
> The last successfull lock was try 20:
> 
> Try: 100
> Failes: 87
> Tunes: 13
> 
> I am running a new test with a 15 seconds break after each tune now and
> will mail you the results when the test finises.

Are you sure that you got the top level 2 changes changeset 7204 and 7203
respectively ?

Regards,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
