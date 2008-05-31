Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1K2EX9-00083a-4z
	for linux-dvb@linuxtv.org; Sat, 31 May 2008 02:01:21 +0200
Received: from [212.12.32.49] (helo=smtp.work.de)
	by mail.work.de with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1K2EX5-0005LO-MS
	for linux-dvb@linuxtv.org; Sat, 31 May 2008 02:01:15 +0200
Received: from [86.97.137.166] (helo=[192.168.1.101])
	by smtp.work.de with esmtpa (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1K2EX5-0004IE-DL
	for linux-dvb@linuxtv.org; Sat, 31 May 2008 02:01:15 +0200
Message-ID: <48409549.2000501@gmail.com>
Date: Sat, 31 May 2008 04:01:13 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <482560EB.2000306@gmail.com>
	<200805310146.30798@orion.escape-edv.de>
In-Reply-To: <200805310146.30798@orion.escape-edv.de>
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

Oliver Endriss wrote:
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
> Agreed?
> 

ACK

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
