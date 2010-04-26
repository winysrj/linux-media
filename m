Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:56729 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118Ab0DZMBU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Apr 2010 08:01:20 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1O6N00-0004eh-Cw
	for linux-media@vger.kernel.org; Mon, 26 Apr 2010 14:01:16 +0200
Received: from 154.139.70.115.static.exetel.com.au ([115.70.139.154])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 26 Apr 2010 14:01:16 +0200
Received: from 0123peter by 154.139.70.115.static.exetel.com.au with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 26 Apr 2010 14:01:16 +0200
To: linux-media@vger.kernel.org
From: 0123peter@gmail.com
Subject: Re: Kworld Plus TV Hybrid PCI (DVB-T 210SE)
Date: Mon, 26 Apr 2010 21:51:09 +1000
Message-ID: <dabga7-50k.ln1@psd.motzarella.org>
References: <4B94CF9B.3060000@gmail.com> <1268777563.5120.57.camel@pc07.localdom.local> <0h2e77-gjl.ln1@psd.motzarella.org> <1269298611.5158.20.camel@pc07.localdom.local> <0uh687-4c1.ln1@psd.motzarella.org> <1269895933.3176.12.camel@pc07.localdom.local> <iou897-qu3.ln1@psd.motzarella.org> <1271302350.3184.16.camel@pc07.localdom.local> <g1hj97-b2a.ln1@psd.motzarella.org> <1271375445.12504.69.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

on Fri, 16 Apr 2010 09:50 am
in the Usenet newsgroup gmane.linux.drivers.video-input-infrastructure
hermann pitton wrote:


> Hi Peter,
> 
> Am Donnerstag, den 15.04.2010, 23:30 +1000 schrieb 0123peter@gmail.com:
>> on Thu, 15 Apr 2010 01:32 pm
>> in the Usenet newsgroup gmane.linux.drivers.video-input-infrastructure
>> hermann pitton wrote:
>> 
>> > Hi,
>> > 
>> > to be honest, there is a little too much delay on those reports.
>> 
>> I have been very slow, sorry.  
> 
> no problem, but it becomes also a little hard to me to recap the issues.
> 
> As said, Hartmut had the best pointers I guess.
> 
>> >> > did not even notice a problem with Trent's prior patch.
>> >> > The same is also at vivi.
>> >> > 
>> >> >> Should I have a file called /etc/modprobe.d/TVanywhereAD 
>> >> >> that contains the line, 
>> >> >> 
>> >> >> options saa7134 card=94 gpio_tracking i2c_debug=1
>> >> >> 
>> >> >> and then watch the command line output of "kaffeine"?  
>> >> 
>> >> I've found a GUI that allows tweaking lots of module parameters 
>> >> that I have never heard of.  Card=94 in the config file, 
>> >> gpio_tracking and i2c_debug are set to "1" in the GUI.  
>> >> 
>> >> Strange things are appearing in dmesg and syslog.  I assume that 
>> >> [snip]
>> >> saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> >> i2c-adapter i2c-0: Invalid 7-bit address 0x7a
>> >> saa7133[0]: i2c xfer: < 8e ERROR: NO_DEVICE
>> >> [snip]
>> >> is significant.  
>> > 
>> > No, not at all for my knowledge.
>> 
>> Unsurprisingly, that just highlights my ignorance.  
>> 
>> >> > If you want to produce debug output for failing firmware loading from
>> >> > file after a cold boot, yes, you might eventually be able to see that
>> >> > failing tuner initialization brings down i2c.
>> >> > 
>> >> > If it is a additional new regression, then mercurial bisect can find the
>> >> > patch in question fairly quick.
>> >> 
>> >> That sounds like something that I should be able to do, if only 
>> >> I'd read the instructions.  
>> > 
>> > It is totally up to you and all others with that hardware.
>> 
>> Can you provide a like for where to start reading?
> 
> README.patches.  
> 
>      Part III - Best Practices
> 	1. Community best practices
> 	2. Mercurial specific procedures
> 	3. Knowing about newer patches committed at the development repositories
> 	4. Patch submission from the community
> 	5. Identifying regressions with Mercurial

I have not found the file README.patches.  

>> > Since already in some multiple broken conditions, never working without
>> > flaws previously, I would suggest not to wait any longer, until some
>> > sort of hadron collider is available ...
>> 
>> Now I'm discouraged.  It might be a better use of my time to do 
>> something else - anything else.  Maybe I'll just put it in a box 
>> for a year and see what happens.  
> 
> I (un)fortunately ;) don't have such hardware and Hartmut did not have
> any at that time either.
> 
> Don't just wait, also no need to hurry on next day.
> 
> If the problem is described well, someone can take it as a challenge to
> work on it. We indeed had people from CERN fixing tuners.
> 
> Trying to recap.

I have allowed things to get confused.  

> You have been interested to add the card to auto detection, but firmware
> load was only successful in one of three cases only already that time
> and we have not been aware of that flaw in the beginning.

I am not the original poster.  

When a link was posted that mentioned one of my cards 
(an MSI TV@nywhere A/D) I said, "Aha".  

Because there was a different, working, card next to it, problems 
with the MSI were less obvious than they should have been.  

In retrospect, the MSI has not worked at all for a long time and 
might have always been a little bit unreliable.  

I have not noticed a one-in-three firmware load failure on the MSI.  
That would have been the original poster about his Kworld.  
Although I did post a bit of dmesg that I thought might be relevant.  

> Hartmut assumed later, on such a card is some locking protection needed
> during the firmware load, and my guess is the longish tuner
> initialization sequence gets corrupted, because of that missing locking,
> and all goes doom. (at least well known on all of such before any
> support for the tda8275a)
> 
> Now, improved, only one of ten tries loads the firmware and keeps the
> card in a responding state. That is of course also very unpleasant for
> using mercurial bisect, I really do admit.
> 
> Also, as reported too now, with two of such kind of cards in one
> machine, likely better don't try at all.

My MSI tuner is currently in a test computer with no other tuner cards.  

> OTOH, the m$ driver obviously does manage to load the firmware even for
> multiple such cards. (but maybe breaks all others ...)
> 
> Which doesn't help us, since rebooting after that only hides our
> problem.
> 
> Those cards following the Philips/NXP/Trident reference designs do not
> have it, but I don't test per day anymore. (we have problems with
> different cards with the same PCI subsystem IDs and different LNAs too,
> introduced by OEMs)
> 
> So, on some first thought, which is only as random as the card's
> behavior, debug logs from the time it was added might be useful.
> (i2c works/works not)
> 
> That it is now even worse, is still a chance to find out something more
> and not only a improved regression on something never working properly.
> 
> If the hardware is not going out of specs by will, excluding others, OEM
> engineers, having more details, can still help to improve it for us too.
> 
> Anyway, we should have start with some #ifdef 0 on it.
> 
> Cheers,
> Hermann

-- 
Sig goes here...  
Peter D.  


