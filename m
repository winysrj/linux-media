Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:34737 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272Ab0DKNTi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Apr 2010 09:19:38 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1O0x4a-0004VE-0b
	for linux-media@vger.kernel.org; Sun, 11 Apr 2010 15:19:36 +0200
Received: from 154.139.70.115.static.exetel.com.au ([115.70.139.154])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 11 Apr 2010 15:19:36 +0200
Received: from 0123peter by 154.139.70.115.static.exetel.com.au with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 11 Apr 2010 15:19:36 +0200
To: linux-media@vger.kernel.org
From: 0123peter@gmail.com
Subject: Re: Kworld Plus TV Hybrid PCI (DVB-T 210SE)
Date: Sun, 11 Apr 2010 23:17:37 +1000
Message-ID: <iou897-qu3.ln1@psd.motzarella.org>
References: <4B94CF9B.3060000@gmail.com> <1268777563.5120.57.camel@pc07.localdom.local> <0h2e77-gjl.ln1@psd.motzarella.org> <1269298611.5158.20.camel@pc07.localdom.local> <0uh687-4c1.ln1@psd.motzarella.org> <1269895933.3176.12.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

on Tue, 30 Mar 2010 07:52 am
in the Usenet newsgroup gmane.linux.drivers.video-input-infrastructure
hermann pitton wrote:

> Hi Peter,
> 
> Am Montag, den 29.03.2010, 23:10 +1100 schrieb 0123peter@gmail.com:
> 
>> 
>> Hi Hermann,  
>> 
>> I've been "fixing" my PC to the state that it stopped working.  
>> Hence the delay.  
>> 
>> > Hi Peter,
>> > 
>> > Am Samstag, den 20.03.2010, 16:20 +1100 schrieb 0123peter@gmail.com:
> 
>> >> 
>> >> [snip]
>> >> > 
>> >> > unfortunately the problem with these cards is known, but no good
>> >> > solution for now.
>> >> > 
>> >> > Best description is from Hartmut and starts here.
>> >> > 
>> >> > http://www.spinics.net/lists/linux-dvb/msg26683.html
>> >> > 
>> >> [snip]
>> >> 
>> >> Interesting link.  I have one of the cards mentioned 
>> >> (an MSI TV(at)nywhere A/D hybrid).  I've decided not to throw it away.  
>> > 
>> > to not leave you without any response at least.
>> > 
>> > In hind sight, seeing how unfortunate using such devices can be, mainly
>> > because of being forced to try at random again with a cold boot after
>> > some i2c war brought down the tuner, we better should have such only in
>> > a still experimental league and not as supported.
>> > 
>> > This was not foreseeable in such rudeness and neither Hartmut nor me
>> > have such devices.
>> > 
>> > The Asus triple OEM 3in1 I have does not have any problems with loading
>> > firmware from file, the others do all get it from eeprom.
>> > 
>> > So, actually nobody is investigating on it with real hardware.
>> > 
>> > Maybe you can catch something with gpio_tracking and i2c_debug=1.
>> > I would expect that the complex analog tuner initialization gets broken
>> > somehow. This is at least known to be good to bring all down.
>> > 
>> > Cheers,
>> > Hermann
>> 
>> There was a patch about alignment that went through recently.  
>> Revert "V4L/DVB (11906): saa7134: Use v4l bounding/alignment function"
>> Maybe that was it.  
> 
> did not even notice a problem with Trent's prior patch.
> The same is also at vivi.
> 
>> Should I have a file called /etc/modprobe.d/TVanywhereAD 
>> that contains the line, 
>> 
>> options saa7134 card=94 gpio_tracking i2c_debug=1
>> 
>> and then watch the command line output of "kaffeine"?  

I've found a GUI that allows tweaking lots of module parameters 
that I have never heard of.  Card=94 in the config file, 
gpio_tracking and i2c_debug are set to "1" in the GUI.  

Strange things are appearing in dmesg and syslog.  I assume that 
[snip]
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
i2c-adapter i2c-0: Invalid 7-bit address 0x7a
saa7133[0]: i2c xfer: < 8e ERROR: NO_DEVICE
[snip]
is significant.  

> If you want to produce debug output for failing firmware loading from
> file after a cold boot, yes, you might eventually be able to see that
> failing tuner initialization brings down i2c.
> 
> If it is a additional new regression, then mercurial bisect can find the
> patch in question fairly quick.

That sounds like something that I should be able to do, if only 
I'd read the instructions.  

> Mauro has a MSI cardbus device using also the card=94 entry, but at home
> he has no DVB-T.
> 
> Cheers,
> Hermann

Would you like me to post a 2000 line /var/log/dmesg?  

-- 
Sig goes here...  
Peter D.  


