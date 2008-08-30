Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1KZOS4-00068P-Mb
	for linux-dvb@linuxtv.org; Sat, 30 Aug 2008 13:17:11 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sat, 30 Aug 2008 13:16:05 +0200
References: <48B8400A.9030409@linuxtv.org>
In-Reply-To: <48B8400A.9030409@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808301316.05526@orion.escape-edv.de>
Cc: VDR mailing list <vdr@linuxtv.org>
Subject: Re: [linux-dvb] DVB-S2 / Multiproto and future modulation support
Reply-To: linux-dvb@linuxtv.org
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

Steven Toth wrote:
> Regarding the multiproto situation:
> 
> A number of developers, maintainers and users are unhappy with the
> multiproto situation, actually they've been unhappy for a considerable
> amount of time. The linuxtv developer community (to some degree) is seen
> as a joke and a bunch in-fighting people. Multiproto is a great
> demonstration of this. [1] The multiproto project has gone too far, for
> too long and no longer has any credibility in the eyes of many people.
> 
> In response, a number developers have agreed that "enough is enough" and
> "it's time to take a new direction", for these developers the technical,
> political and personal cost of multiproto is too high. These developers
> have decided to make an announcement.
> 
> Mauro Chehab, Michael Krufky, Patrick Boettcher and myself are hereby
> announcing that we no longer support multiproto and are forming a
> smaller dedicated project group which is focusing on adding next
> generation S2/ISDB-T/DVB-H/DVB-T2/DVB-SH support to the kernel through a 
> different and simpler API.
>
> Basic patches and demo code for this API is currently available here.
> 
> http://www.steventoth.net/linux/s2
> 
> Does it even work? Yes
> Is this new API complete? No
> Is it perfect? No, we've already had feedback on structural and
> namingspace changes that people would like to see.
> Does it have bugs? Of course, we have a list of things we already know
> we want to fix.
> 
> but ...
> 
> Is the new approach flexible? Yes, we're moving away from passing fixed
> modulation structures into the kernel.
> Can we add to it without breaking the future ABI when unforseen
> modulations types occur? Yes
> Does it preserve backwards compatibility? Yes
> Importantly, is the overall direction correct? Yes
> Does it impact existing frontend drivers? No.
> What's the impact to dvb-core? Small.
> What's the impact to application developers? None, unless an application 
> developer wants to support the new standards - binary compatibility!
> 
> We want feedback and we want progress, we aim to achieve it.
> 
> Importantly, this project group seeks your support.
> 
> If you also feel frustrated by the multiproto situation and agree in
> principle with this new approach, and the overall direction of the API
> changes, then we welcome you and ask you to help us.
> 
> Growing the list of supporting names by 100%, and allowing us to publish
> your name on the public mailing list, would show the non-maintainer
> development community that we recognize the problem and we're taking
> steps to correct the problem. We want to make LinuxTV a perfect platform
> for S2, ISDB-T and other advanced modulation types, without using the
> multiproto patches.
> 
> We're not asking you for technical help, although we'd like that  :) ,
> we're just asking for your encouragement to move away from multiproto.
> 
> If you feel that you want to support our movement then please help us by
> acking this email.
> 
> Regards - Steve, Mike, Patrick and Mauro.
> 
> Acked-by: Patrick Boettcher <pb@linuxtv.org>
> Acked-by: Michael Krufky <mkrufky@linuxtv.org>
> Acked-by: Steven Toth <stoth@linuxtv.org>
> Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>
> 
> * [1]. Rather than point out the issues with multiproto here, take a
> look at the patches and/or read the comments on the mailing lists.

Guys, I don't like the way you do this. ;-(

Why didn't you propose this API when we reviewed multiproto?
Meanwhile there are applications (vdr, others?) which implement the
multiproto API.

As I am not willing to spend a single minute of my time with API wars,
I will ack this API only if the multiproto developer and the users agree
with this approach.

Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
