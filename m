Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KZUDe-00085l-CK
	for linux-dvb@linuxtv.org; Sat, 30 Aug 2008 19:26:40 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6F00362CFGGQ90@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Sat, 30 Aug 2008 13:26:04 -0400 (EDT)
Date: Sat, 30 Aug 2008 13:26:03 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <200808301730.09135.janne-dvb@grunau.be>
To: Janne Grunau <janne-dvb@grunau.be>
Message-id: <48B982AB.8010304@linuxtv.org>
MIME-version: 1.0
References: <48B8400A.9030409@linuxtv.org>
	<200808301730.09135.janne-dvb@grunau.be>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-S2 / Multiproto and future modulation support
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
> On Friday 29 August 2008 20:29:30 Steven Toth wrote:
>> Mauro Chehab, Michael Krufky, Patrick Boettcher and myself are hereby
>> announcing that we no longer support multiproto and are forming a
>> smaller dedicated project group which is focusing on adding next
>> generation S2/ISDB-T/DVB-H/DVB-T2/DVB-SH support to the kernel
>> through a different and simpler API.
>>
>> Basic patches and demo code for this API is currently available here.
>>
>> http://www.steventoth.net/linux/s2
> 
> Overall API looks good.
> 
> I have also a slightly preference for DTV/dtv as prefix but it's not 
> really important. 

Changing the namespace is a common message, I hear this a lot. This will 
  probably be one of the first things to change.

> 
> 16 properties per ioctl are probably enough but a variable-length 
> property array would be safe. I'm unsure if this justifies a more 
> complicate copy from/to userspace in the ioctls.

Johannes suggested we lose the fixed length approach and instead pass in 
struct containing the number of elements... I happen to like this, and 
it removed an unnecessary restriction.

So if 16 feels odd, we're soon not going to have any practical limit.


> 
>> Importantly, this project group seeks your support.
>>
>> If you also feel frustrated by the multiproto situation and agree in
>> principle with this new approach, and the overall direction of the
>> API changes, then we welcome you and ask you to help us.
>>
>> Growing the list of supporting names by 100%, and allowing us to
>> publish your name on the public mailing list, would show the
>> non-maintainer development community that we recognize the problem
>> and we're taking steps to correct the problem. We want to make
>> LinuxTV a perfect platform for S2, ISDB-T and other advanced
>> modulation types, without using the multiproto patches.
>>
>> We're not asking you for technical help, although we'd like that  :)
>> , we're just asking for your encouragement to move away from
>> multiproto.
>>
>> If you feel that you want to support our movement then please help us
>> by acking this email.
> 
> Acked-by: Janne Grunau <janne-dvb@grunau.be>

Janne, thank you for your support.

Regards,

Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
