Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KQTtx-0003jg-5e
	for linux-dvb@linuxtv.org; Tue, 05 Aug 2008 23:17:06 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta2.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K55005BDCFAF811@mta2.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Tue, 05 Aug 2008 17:16:24 -0400 (EDT)
Date: Tue, 05 Aug 2008 17:16:21 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <1217969890.6864.11.camel@bonnie>
To: Chris Proctor <chrisp_42@bigpond.com>
Message-id: <4898C325.9090207@linuxtv.org>
MIME-version: 1.0
References: <20080801034025.C0EC947808F@ws1-5.us4.outblaze.com>
	<4897AC24.3040006@linuxtv.org> <1217969890.6864.11.camel@bonnie>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO FusionHDTV
 DVB-T Dual Express
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

Chris Proctor wrote:
> On Mon, 2008-08-04 at 21:25 -0400, Steven Toth wrote:
>> Stephen / Anton,
>>
>> http://linuxtv.org/hg/~stoth/v4l-dvb
>>
>> This has Anton's patches and a subsequent cleanup patch to merge the 
>> single tune callback functions into a single entity. A much better 
>> solution all-round.
>>
>> I've tested with the HVR1500Q (xc5000 based) and I'm happy with the 
>> results. Can you both try the DViCO board?
>>
>> Thanks,
>>
>> Steve
>>
> 
> Steven,
> 
> I have tested this in a machine with two DViCOs and all appears to work
> well.
> 
> I have been running these cards with a slightly modified version of the
> other Stephen's patches.  It will be good to finally get this driver
> into the tree.

Noted.

Thanks Chris.

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
