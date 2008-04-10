Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from host06.hostingexpert.com ([216.80.70.60])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1JjlTx-00031J-V4
	for linux-dvb@linuxtv.org; Thu, 10 Apr 2008 03:21:49 +0200
Message-ID: <47FD6B9C.2000303@linuxtv.org>
Date: Wed, 09 Apr 2008 21:21:32 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Janne Grunau <janne-dvb@grunau.be>
References: <200803292240.25719.janne-dvb@grunau.be>	<200804080213.26671.linuxdreas@launchnet.com>	<37219a840804080818x729fd503ka3ba048c46169bcb@mail.gmail.com>
	<200804092128.24588.janne-dvb@grunau.be>
In-Reply-To: <200804092128.24588.janne-dvb@grunau.be>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Add driver specific module option to choose
 dvb adapter numbers, second try
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

Janne Grunau wrote:
> On Tuesday 08 April 2008 17:18:10 Michael Krufky wrote:
>> I would really like to see this patch get merged.
>>
>> If nobody has an issue with this, I plan to push this into a
>> mercurial tree at the end of the week and request that it be merged
>> into the master branch.
> 
> updated patch attached:
> -resolved a reject in the ttusb2 driver
> -changed type of the adapter num array from int to short
> 
> I didn't changed the module option name since to me consistency with the 
> V4L options is more important.
> 
> Janne

I've pushed the current patch to my mercurial repository 
at the following location:

http://linuxtv.org/hg/~mkrufky/dvb

...anybody that wishes to try it out should feel free to pull 
from this tree or apply Janne's patch manually.

Likewise, anybody that wishes to add their ack / reviewed-by 
tag has the opportunity to reply with it to this thread -- I 
will add it to the changeset inside the repository.

I intend to issue a pull request to Mauro for this patch to
be merged on Friday morning, before I leave for the office.

-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
