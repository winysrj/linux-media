Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:56814 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134Ab0C2ML1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Mar 2010 08:11:27 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1NwDoU-0000fK-FB
	for linux-media@vger.kernel.org; Mon, 29 Mar 2010 14:11:26 +0200
Received: from 154.139.70.115.static.exetel.com.au ([115.70.139.154])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 29 Mar 2010 14:11:26 +0200
Received: from 0123peter by 154.139.70.115.static.exetel.com.au with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 29 Mar 2010 14:11:26 +0200
To: linux-media@vger.kernel.org
From: 0123peter@gmail.com
Subject: Re: Kworld Plus TV Hybrid PCI (DVB-T 210SE)
Date: Mon, 29 Mar 2010 23:10:08 +1100
Message-ID: <0uh687-4c1.ln1@psd.motzarella.org>
References: <4B94CF9B.3060000@gmail.com> <1268777563.5120.57.camel@pc07.localdom.local> <0h2e77-gjl.ln1@psd.motzarella.org> <1269298611.5158.20.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

on Tue, 23 Mar 2010 09:56 am
in the Usenet newsgroup gmane.linux.drivers.video-input-infrastructure
hermann pitton wrote:

Hi Hermann,  

I've been "fixing" my PC to the state that it stopped working.  
Hence the delay.  

> Hi Peter,
> 
> Am Samstag, den 20.03.2010, 16:20 +1100 schrieb 0123peter@gmail.com:
>> on Wed, 17 Mar 2010 09:12 am
>> in the Usenet newsgroup gmane.linux.drivers.video-input-infrastructure
>> hermann pitton wrote:
>> 
>> [snip]
>> > 
>> > unfortunately the problem with these cards is known, but no good
>> > solution for now.
>> > 
>> > Best description is from Hartmut and starts here.
>> > 
>> > http://www.spinics.net/lists/linux-dvb/msg26683.html
>> > 
>> [snip]
>> 
>> Interesting link.  I have one of the cards mentioned 
>> (an MSI TV(at)nywhere A/D hybrid).  I've decided not to throw it away.  
> 
> to not leave you without any response at least.
> 
> In hind sight, seeing how unfortunate using such devices can be, mainly
> because of being forced to try at random again with a cold boot after
> some i2c war brought down the tuner, we better should have such only in
> a still experimental league and not as supported.
> 
> This was not foreseeable in such rudeness and neither Hartmut nor me
> have such devices.
> 
> The Asus triple OEM 3in1 I have does not have any problems with loading
> firmware from file, the others do all get it from eeprom.
> 
> So, actually nobody is investigating on it with real hardware.
> 
> Maybe you can catch something with gpio_tracking and i2c_debug=1.
> I would expect that the complex analog tuner initialization gets broken
> somehow. This is at least known to be good to bring all down.
> 
> Cheers,
> Hermann

There was a patch about alignment that went through recently.  
Revert "V4L/DVB (11906): saa7134: Use v4l bounding/alignment function"
Maybe that was it.  

Should I have a file called /etc/modprobe.d/TVanywhereAD 
that contains the line, 

options saa7134 card=94 gpio_tracking i2c_debug=1

and then watch the command line output of "kaffeine"?  

-- 
Sig goes here...  
Peter D.  


