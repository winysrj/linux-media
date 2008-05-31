Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.157])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <e9hack@googlemail.com>) id 1K2LMx-0005lg-TW
	for linux-dvb@linuxtv.org; Sat, 31 May 2008 09:19:18 +0200
Received: by fg-out-1718.google.com with SMTP id e21so295227fga.25
	for <linux-dvb@linuxtv.org>; Sat, 31 May 2008 00:19:12 -0700 (PDT)
Message-ID: <4840FBED.3050902@gmail.com>
Date: Sat, 31 May 2008 09:19:09 +0200
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <482560EB.2000306@gmail.com>
	<200805310146.30798@orion.escape-edv.de>
In-Reply-To: <200805310146.30798@orion.escape-edv.de>
From: e9hack <e9hack@googlemail.com>
Subject: Re: [linux-dvb] [PATCH] Fix the unc for the frontends tda10021 and
 stv0297
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

Oliver Endriss schrieb:
> Hi,
> 
> I just wanted to commit this changeset when I spotted this:
> 
> e9hack wrote:
>> @@ -266,6 +268,10 @@ static int tda10021_set_parameters (stru
>>  
>>         tda10021_setup_reg0 (state, reg0x00[qam], p->inversion);
>>  
>> +       /* reset uncorrected block counter */
>> +       state->last_lock = 0;
>> +       state->ucblocks = 0;
> 
> Note that UCB must count the number of uncorrected blocls during the
> lifetime of the driver. So it must not be reset during tuning.

I've add this reset for two reasons:

1) My second card uses a stv0297. The UCB value is always reset during the tuning, because 
the stv0297 is completely reinitialized. This occurs, if the frequency is changed or if 
the frontend lost the lock. I've add the reset to see the same behavior within the 
femon-plugin for both cards.

2) Above 650MHz, the signal strength of my cable is very low. It isn't usable. I get high 
BER and UCB values. The card with the tda10021 is a budget one. It is used for epg 
scanning in the background. It isn't possible to compare the UCB values of both cards, if 
the cards are tuned to the same frequency/channel and if the tda10021 was previous tuned 
to a frequency with a low signal.

-Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
