Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1JMAto-0002Y4-1G
	for linux-dvb@linuxtv.org; Tue, 05 Feb 2008 00:38:52 +0100
Received: from steven-toths-macbook-pro.local
	(ool-18bac60f.dyn.optonline.net [24.186.198.15]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JVQ004RLMZU6ND1@mta1.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Mon, 04 Feb 2008 18:38:19 -0500 (EST)
Date: Mon, 04 Feb 2008 18:38:17 -0500
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <!&!AAAAAAAAAAAYAAAAAAAAACQaAAE2cqNLuI5vSe3nryTCgAAAEAAAAGiow9eC/plOkJFZOiAHb4MBAAAAAA==@stahurabrenner.com>
To: "Timothy E. Krantz" <tkrantz@stahurabrenner.com>
Message-id: <47A7A1E9.4050605@linuxtv.org>
MIME-version: 1.0
References: <20080128172009.GA15773@gauss.marywood.edu>
	<!&!AAAAAAAAAAAYAAAAAAAAACQaAAE2cqNLuI5vSe3nryTCgAAAEAAAAGiow9eC/plOkJFZOiAHb4MBAAAAAA==@stahurabrenner.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] XC5000 tuner improvement/clean up
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

Timothy E. Krantz wrote:
>> On Jan 27, 2008 6:50 PM, Chaogui Zhang <czhang1974@gmail.com> wrote:
>>> Download the newest v4l-dvb tree from http://linuxtv.org/hg/v4l-dvb 
>>> and apply the patch against it.
>>>
>> I just noticed that the previous patch that fixed the kernel 
>> oops has been merged into the master tree, which conflicts 
>> with the patch for tuner performance improvement(which 
>> contains the oops fixes too). I regenerated the patch against 
>> the master tree and it is below. Please use this one instead.
>>
>> --
>> Chaogui Zhang
> 
> 
> Any idea when this will me merged with the main tree?
> 
> It is working great for me.

Soon, after I've tested it with various other XC5000 products.

This week.

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
