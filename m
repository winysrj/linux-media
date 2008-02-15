Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1F0X0Sr016275
	for <video4linux-list@redhat.com>; Thu, 14 Feb 2008 19:33:00 -0500
Received: from mailout03.sul.t-online.com (mailout03.sul.t-online.de
	[194.25.134.81])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1F0WcIl016762
	for <video4linux-list@redhat.com>; Thu, 14 Feb 2008 19:32:38 -0500
Message-ID: <47B4DDB3.5010904@t-online.de>
Date: Fri, 15 Feb 2008 01:32:51 +0100
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <47B392A5.2030908@t-online.de>	
	<1202986913.5036.3.camel@pc08.localdom.local>	
	<1203005937.5871.12.camel@pc08.localdom.local>	
	<47B4B9AE.5010907@t-online.de>
	<1203029639.6805.66.camel@pc08.localdom.local>
In-Reply-To: <1203029639.6805.66.camel@pc08.localdom.local>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	LInux DVB <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Mdeion / Creatix CTX948 DVB-S driver is ready	for
 testing
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi, again

<snip>

>> So this one works as well, great! But which one is it?
>> Please tell me the minor device id. I need to use it to separate the 2 sections.
>> i will need to control the other one in a very different way.
> 
> Seems default is some RF loopthrough.
> 
> I'll need to measure too against loopthrough conditions, but for sure
> voltage is only on the upper connector and previously with the RF feed
> from the external receiver the lower connector was fine enough.
> 
> No voltage in any previous testing and the 12Volts were always
> connected.
> 
> Both slightly different Quads from different fabs work as well as the
> CTX948. In my case it is the 16be:0007 and to the 16be:0008 I have no
> access.
> 
Perfect, that's what i needed to know.

<snip>
> 
> We might be already through here and you might like to commit first ;)
> 
Indeed. I should also announce this status for the md8800...

What's your opinion on this:
According to the hints i got, the isl6405 is visible only on one section
of the md8800. The other section has control over the voltage through
a GPIO port. So unless i do something very dirty, there will either be the
restriction
- that the DVB-S decoder of the  16be:0007 section needs to be selected first.
  Otherwise the other DVB-S part will not work
- or i will need to always fire up the LNB supply of the 0008 section as soon
  as DVB is initialized.
The second approach has the advantage that it has little effect for the end
user while the first needs to be explained.
But i am not sure whether the isl6405 is fully short circuit proof. I will read
the datasheet again...

Best regards
  Hartmut



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
