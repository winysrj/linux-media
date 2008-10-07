Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [85.17.51.120] (helo=master.jcz.nl)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jaap@jcz.nl>) id 1KnC09-000165-LU
	for linux-dvb@linuxtv.org; Tue, 07 Oct 2008 14:49:22 +0200
Message-ID: <48EB5A9D.1090609@jcz.nl>
Date: Tue, 07 Oct 2008 14:48:29 +0200
From: Jaap Crezee <jaap@jcz.nl>
MIME-Version: 1.0
To: gimli@dark-green.com
References: <44838.194.48.84.1.1223383227.squirrel@webmail.dark-green.com>
In-Reply-To: <44838.194.48.84.1.1223383227.squirrel@webmail.dark-green.com>
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

Hello everyone,

gimli wrote:
> Hi All,
> 

<snip>

> was made. Please cool down and bring the pieces together to give the
> user the widest driver base and support for S2API.

With this in mind, I would like to work on porting the TT S2-3200 driver stuff to S2API. I have done a little bit of 
research and found out that it is hard to find what the differences are between both API's on a source/technical level.
Can anyone offer some insight into differences or give some starting point (or maybe even an example) of how to port 
Multiproto drivers to the S2API?

I own a TT S2-3200 card and would like to see it supported by kernel.org vanille kernel... For now, everything works 
fine (Scanning, tuning, CAM module, Diseq), except I haven't tried S2 channels yet.

Regards,

Jaap Crezee

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
