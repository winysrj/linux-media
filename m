Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f18.google.com ([209.85.218.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christian.lammers@gmail.com>) id 1LKXyu-0001St-5k
	for linux-dvb@linuxtv.org; Wed, 07 Jan 2009 13:57:56 +0100
Received: by bwz11 with SMTP id 11so18347825bwz.17
	for <linux-dvb@linuxtv.org>; Wed, 07 Jan 2009 04:57:22 -0800 (PST)
Message-ID: <4964A5DB.6050305@gmail.com>
Date: Wed, 07 Jan 2009 13:53:47 +0100
From: Christian Lammers <christian.lammers@gmail.com>
MIME-Version: 1.0
CC: linux-dvb@linuxtv.org
References: <4964989C.6000506@gmail.com> <20090107122820.151430@gmx.net>
In-Reply-To: <20090107122820.151430@gmx.net>
Subject: Re: [linux-dvb] Compiling mantis driver on 2.6.28
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

Hello Hans,

Hans Werner wrote:
>> Hi,
>>
>> i'm new to this mailinglist, so 'Hello' to all :)
>>
>> My first problem, cause of bleeding edge hardware, intels gem, hdmi,
>> experimental xorg and so on, i've problems to compile the mantis driver
>> from http://jusst.de/hg/mantis on 2.6.28.
>>
>> I'm getting the following:
>>
>> .... ....
>>
>> Is there a patch or something else to get this driver working on 2.6.28
> 
> Use the s2-liplianin repository.  It contains an up-to-date mantis driver.
> 
> hg clone http://mercurial.intuxication.org/hg/s2-liplianin
> cd s2-liplianin
> make
> sudo make install
> sudo reboot
> 

I've commented out the irrelevant modules and this works fine for my
Cinergy C Card. Thanks a lot.

Christian



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
