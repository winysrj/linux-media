Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KnEAo-0003Ka-NI
	for linux-dvb@linuxtv.org; Tue, 07 Oct 2008 17:08:31 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K8D00L7KJBT5CR1@mta3.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Tue, 07 Oct 2008 11:07:56 -0400 (EDT)
Date: Tue, 07 Oct 2008 11:07:04 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48EB5A9D.1090609@jcz.nl>
To: Jaap Crezee <jaap@jcz.nl>
Message-id: <48EB7B18.50703@linuxtv.org>
MIME-version: 1.0
References: <44838.194.48.84.1.1223383227.squirrel@webmail.dark-green.com>
	<48EB5A9D.1090609@jcz.nl>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] S2API vs Multiproto vs TT 3200
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

Jaap Crezee wrote:
> Hello everyone,
> 
> gimli wrote:
>> Hi All,
>>
> 
> <snip>
> 
>> was made. Please cool down and bring the pieces together to give the
>> user the widest driver base and support for S2API.
> 
> With this in mind, I would like to work on porting the TT S2-3200 driver stuff to S2API. I have done a little bit of 
> research and found out that it is hard to find what the differences are between both API's on a source/technical level.
> Can anyone offer some insight into differences or give some starting point (or maybe even an example) of how to port 
> Multiproto drivers to the S2API?

Great!

Check the cx24116.c inkernel driver, see the set_frontend callback. 
You'll see how it queries a dtv_property_cache held in the frontend.

This is the best place to begin.

Let me know if you have any other questions. If you do plan to port the 
drivers, I suggest you create another thread with an appropriate subject 
"porting TT3200 to S2API" or something similar, if you want people to 
comment and help.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
