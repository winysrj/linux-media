Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:39785 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753567Ab0DONbv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Apr 2010 09:31:51 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1O2PAZ-0006xQ-W8
	for linux-media@vger.kernel.org; Thu, 15 Apr 2010 15:31:48 +0200
Received: from 154.139.70.115.static.exetel.com.au ([115.70.139.154])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 15 Apr 2010 15:31:47 +0200
Received: from 0123peter by 154.139.70.115.static.exetel.com.au with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 15 Apr 2010 15:31:47 +0200
To: linux-media@vger.kernel.org
From: 0123peter@gmail.com
Subject: Re: Kworld Plus TV Hybrid PCI (DVB-T 210SE)
Date: Thu, 15 Apr 2010 23:30:55 +1000
Message-ID: <g1hj97-b2a.ln1@psd.motzarella.org>
References: <4B94CF9B.3060000@gmail.com> <1268777563.5120.57.camel@pc07.localdom.local> <0h2e77-gjl.ln1@psd.motzarella.org> <1269298611.5158.20.camel@pc07.localdom.local> <0uh687-4c1.ln1@psd.motzarella.org> <1269895933.3176.12.camel@pc07.localdom.local> <iou897-qu3.ln1@psd.motzarella.org> <1271302350.3184.16.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

on Thu, 15 Apr 2010 01:32 pm
in the Usenet newsgroup gmane.linux.drivers.video-input-infrastructure
hermann pitton wrote:

> Hi,
> 
> to be honest, there is a little too much delay on those reports.

I have been very slow, sorry.  
 
>> > did not even notice a problem with Trent's prior patch.
>> > The same is also at vivi.
>> > 
>> >> Should I have a file called /etc/modprobe.d/TVanywhereAD 
>> >> that contains the line, 
>> >> 
>> >> options saa7134 card=94 gpio_tracking i2c_debug=1
>> >> 
>> >> and then watch the command line output of "kaffeine"?  
>> 
>> I've found a GUI that allows tweaking lots of module parameters 
>> that I have never heard of.  Card=94 in the config file, 
>> gpio_tracking and i2c_debug are set to "1" in the GUI.  
>> 
>> Strange things are appearing in dmesg and syslog.  I assume that 
>> [snip]
>> saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> i2c-adapter i2c-0: Invalid 7-bit address 0x7a
>> saa7133[0]: i2c xfer: < 8e ERROR: NO_DEVICE
>> [snip]
>> is significant.  
> 
> No, not at all for my knowledge.

Unsurprisingly, that just highlights my ignorance.  

>> > If you want to produce debug output for failing firmware loading from
>> > file after a cold boot, yes, you might eventually be able to see that
>> > failing tuner initialization brings down i2c.
>> > 
>> > If it is a additional new regression, then mercurial bisect can find the
>> > patch in question fairly quick.
>> 
>> That sounds like something that I should be able to do, if only 
>> I'd read the instructions.  
> 
> It is totally up to you and all others with that hardware.

Can you provide a like for where to start reading?  

> Since already in some multiple broken conditions, never working without
> flaws previously, I would suggest not to wait any longer, until some
> sort of hadron collider is available ...

Now I'm discouraged.  It might be a better use of my time to do 
something else - anything else.  Maybe I'll just put it in a box 
for a year and see what happens.  

> First try in all known ways.
> 
> We likely don't have the budget for anything else that soon ;)
> 
> Cheers,
> Hermann

-- 
Sig goes here...  
Peter D.  


