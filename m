Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JZrei-0005xC-WD
	for linux-dvb@linuxtv.org; Thu, 13 Mar 2008 18:55:53 +0100
Message-ID: <47D96A9A.9040204@gmail.com>
Date: Thu, 13 Mar 2008 21:55:38 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: manu <eallaud@yahoo.fr>
References: <1205324955l.5684l.1l@manu-laptop>
In-Reply-To: <1205324955l.5684l.1l@manu-laptop>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Re :  TT S2-3200 vlc streaming
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

manu wrote:
> On 03/11/2008 02:27:31 AM, Vladimir Prudnikov wrote:
>> I'm getting late buffers with vlc on some transponders (DVB-S, same  
>> parameters, good signal guaranteed) while everything is fine with  
>> others. Using multiproto and TT S2-3200.
>> Anyone having same problems?
> 
> Can you give the frequencies of the good and bad transponders, mine are 
> as follows:
> I can receive from 4 transponders (DVB-S): 11093, 11555, 11635, 11675 
> MHz.
> any channel on 11093: fast lock, perfect picture.
> any channel on 11555: lock a bit slower and corrupted stream (lots of 
> blocky artifacts, myhttv complains about corrupted stream)
> any channel on 11635,11675: no lock.

Please provide:

* parameters that you use for tuning each of these transponders
* logs from the stb0899 and stb6100 modules both loaded with verbose=5,
for each of these transponders

Hope it might shed some light into your problems.

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
