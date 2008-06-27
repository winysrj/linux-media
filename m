Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1KC3nn-0007lo-Dm
	for linux-dvb@linuxtv.org; Fri, 27 Jun 2008 04:35:10 +0200
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KC3ni-0007xe-Od
	for linux-dvb@linuxtv.org; Fri, 27 Jun 2008 02:35:02 +0000
Received: from gimpelevich.san-francisco.ca.us ([66.218.54.163])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Fri, 27 Jun 2008 02:35:02 +0000
Received: from daniel by gimpelevich.san-francisco.ca.us with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Fri, 27 Jun 2008 02:35:02 +0000
To: linux-dvb@linuxtv.org
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Date: Fri, 27 Jun 2008 02:10:33 +0000 (UTC)
Message-ID: <loom.20080627T014805-83@post.gmane.org>
References: <48643f7d.168.28cb.583@internode.on.net>
Mime-Version: 1.0
Subject: Re: [linux-dvb] DVICO FusionHDTV DVB-T Pro
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

Adam <sph3r3 <at> internode.on.net> writes:

> Hi,
> 
> Late last year I got my card working in a Fedora 8/2.6.24
> system (thanks Chris!).  I've now upgraded to Fedora 9
> (2.6.25) and am trying to get my card going again as magic
> didn't seem to happen with Fedora's out-of-the-box drivers.
> 
> I've noticed that my card is now listed in cardlist.cx88, so
> I've downloaded and built the latest v4l-dvb repo (#8110) in
> preference to the xc-test branch that I used last year. 
> /dev/dvb0/* is populated and dmesg shows that the card is
> correctly detected:
[snip]
> Any ideas?
> 
> Thanks,
> Adam

Looking at cx88-cards.c, I see that the definition there for your card is 
quite broken. I'm amazed it ever worked at all with such incomplete support. 
Fundamental portions of the cx88 driver need to be redone, and for your card, 
that will mean going back to Windows to see what the vendor's driver is doing 
with GPIO in response to different inputs, as well as some experimentation. If 
you're up for things like that, you can start by:
1) Gathering GPIO register values in Windows with RegSpy from dscaler.org, 
recording what they are with each card input selected (DVB, analog TV, 
composite, S-video, FM radio, SCART, etc.), as well as the values after 
closing all apps related to the card, so that the card is idle.
2) Applying this patch:
http://thread.gmane.org/gmane.comp.video.video4linux/38536
Note that with the card definition as it currently is, this patch will make 
the card stop working altogether. You will need to redo the card definition to 
include all the info gathered in #1 above.
3) Reporting your findings from #1 and #2 above. I will be submitting a patch 
to the tuner-core that will pave the way for some real fixing of cx88, and 
info on as many cx88 cards as possible will be a plus during that fixing.
4) Testing future cutting-edge patches to see how they affect the use of the 
card, before those patches make it into the tree.

Have fun!


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
