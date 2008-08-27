Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KYN82-0001Ds-DA
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 17:40:16 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6900HPRNI0OEX0@mta3.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Wed, 27 Aug 2008 11:39:38 -0400 (EDT)
Date: Wed, 27 Aug 2008 11:39:35 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <ed347ce40808270827g5c0aaf3em2157d40cfed8a779@mail.gmail.com>
To: David Schollmeyer <dschollmeyer@gmail.com>
Message-id: <48B57537.6070506@linuxtv.org>
MIME-version: 1.0
References: <ed347ce40808262255s6bfc4f58ne2c8c00f56f95e44@mail.gmail.com>
	<48B4FD13.9030703@linuxtv.org>
	<ed347ce40808270827g5c0aaf3em2157d40cfed8a779@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-1800 DVB Configuration
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

David Schollmeyer wrote:
> On Wed, Aug 27, 2008 at 12:06 AM, Steven Toth <stoth@linuxtv.org> wrote:
>> I assume the channel names, pid values and service numbers in your
>> channels.conf are accurate. Did this come as a result of running the scan
>> app, or something else?
>>
>> - Steve
>>
> 
> I used the values from a mythtv-users posting from a couple of years
> ago so I'm not sure if it is up-to-date. I also tried ascan but the
> output from that did not have any channel names (they were all of the
> format "[000x]") so I'm not sure if that worked correctly. The
> mythtv-users posting said that Cox does not transmit pids.

Given that this is working fine for a number of people it's more likely 
a Cox related problem. You should try running:

scan -A2 US-Cable_Center-Frequencies (google the exact center 
frequencies filename or look in /usr/share/doc/dvb-utils/something....) 
at the scanning files.

Also try the IRC/HRC equivalent frequency tables.

If you're lucky 'scan' will generate a new channels.conf for you, and 
the world will be a happy shiny Digital Cable loving place.

- Steve



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
