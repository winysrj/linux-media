Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:33996 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752942AbZAQRTN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jan 2009 12:19:13 -0500
Subject: Re: eMPIA camera support?
From: hermann pitton <hermann-pitton@arcor.de>
To: CityK <cityk@rogers.com>
Cc: video4linux-list@redhat.com,
	Linux-media <linux-media@vger.kernel.org>
In-Reply-To: <496FDE1C.4080004@rogers.com>
References: <4956E4C6.8040506@popdial.com>
	 <20081228183433.1b35c464@gmail.com>  <495811FB.2060904@rogers.com>
	 <1230517784.2695.16.camel@pc10.localdom.local>
	 <49583BD5.9040505@rogers.com>
	 <1230522632.2695.32.camel@pc10.localdom.local>
	 <496FDE1C.4080004@rogers.com>
Content-Type: text/plain
Date: Sat, 17 Jan 2009 18:19:28 +0100
Message-Id: <1232212768.2702.62.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Am Donnerstag, den 15.01.2009, 20:08 -0500 schrieb CityK:
> hermann pitton wrote:
> > Am Sonntag, den 28.12.2008, 21:54 -0500 schrieb CityK:
> >   
> >> hermann pitton wrote:
> >>> schrieb CityK:
> >>>> While the bttv gallery remains a very useful resource, I don't believe that Gunther is maintaining it any more. In any regard
> >>>> let s use the V4L-DVB wiki (http://www.linuxtv.org/wiki/index.php/Main_Page), as it is best to keep the information all in one
> >>>> place (i.e. a centralized repository of knowledge and information), as opposed to spread out across multiple 3rd party sources.  
> >>> let's see. It still has lots of advantages.
> >>> Hacking of hundreds of tuners and advanced gpio and eeprom detection was
> >>> coordinated there on requests for research coming up on the lists and it
> >>> has several thousand contributors. A wiki was not even in sight then.
> >>>
> >>> I would prefer to see it further maintained for easy searching on hard
> >>> facts.
> >>>
> >>> At least don't call it third party.
> >>>
> >>> That is as mad as if you would call the video4linux-list or bytesex.org
> >>> third party.
> >>>
> >>> It is/was to that point the official hardware resource and Gunther a
> >>> leading tuner/hardware developer and nothing else.
> >>>       
> >> This is true, and I don't mean to offend anyone's sensibilities about
> >> it.  Likewise, I did state that it remains a very useful resource.
> >>
> >> However, I haven't seen a word of boo from Gunther in probably two years
> >> time.  Secondly, some of those users that I had, in the past, requested
> >> that they submit material to the bttv-gallery have later written/replied
> >> to me that their submissions went unanswered/unacknowledged.  Thirdly,
> >> despite Gunther's distinguished history and involvement, it is likely
> >> unclear to an unassuming end user that there is anything other then a
> >> passing relation between the project and the "bttv-gallery".
> >>     
> >
> > That is all OK so far.
> >
> > But it is not about sensibilities, but usability in the first place.
> >   
> 
> Your points are duly noted ... and I have attempted to convey the crux
> of your message in the note provided here: 
> http://www.linuxtv.org/wiki/index.php/Development:_How_to_add_support_for_a_device#Don.27t_forget_to_send_info_to_the_Wiki_.21

thanks! It reflects the current situation quite well.

> > I give an example in short.
> >
> > http://linuxtv.org/wiki/index.php/DVB-T_PCI_Cards
> >
> > This starts with some ASUS My Cinema P7131-Dual model and the photos are
> > taken from there. But that user had a P7131 Hybrid and he was the only
> > one ever reporting problems like this,
> >
> > DVB, VDR, (***unstable*** causes random memory corruption and crashes),
> >
> > but stays on top of all recent PCI cards with hybrid tuners and speaks
> > for all Asus saa713x ...
> >
> > This should be meanwhile eight different cards including the not yet
> > externally documented Asus Tiger 3in1 I guess.
> >
> > It of cause continues here.
> > http://linuxtv.org/wiki/index.php/ASUS_My_Cinema-P7131_Hybrid
> >
> > Almost all is wrong or at least not differentiated enough.
> >
> > If you look at the bttv-gallery for the related cards,
> > there is at least _nothing_ wrong.
> >   
> 
> Well, in these particular regards, I can only reply with what I have
> previously noted in the wiki in several places, such as:
> - from the Main page "welcome" message:   "Like all other wikis, the
> V4L-DVB wiki relies upon the contributions of its users. Hence, it will
> only be as useful as we make it!"
> - from the DVB-T PCI Cards' note entitled "Please be aware that":  "The
> information contained here is likely non-exhaustive and, despite best
> efforts to do otherwise, may contain errors. (Please help to keep these
> lists up-to-date so that they are useful for everyone!)"
> 

Gunther's listing about what a report for a new card should contain is
still fine and might be a guideline on the wiki too.

Luckily we get the eeprom content of most drivers these days in dmesg.
How much we can do already with it then is another question, but in most
cases we get already hints about the tuner type and address, both are
most often vendor specific, also about addresses of analog and digital
demods, there is duplicate stuff for different devices, and also second
digital tuners and demods.

Many drivers have an i2cscan=1 option, "modinfo" driver module, which
can discover some chips, as long they are not behind i2c gates, but such
chips are often visible in the eeprom. The i2c_scan should be enabled
for a report.

How to open a can tuner was also important for the flood of unknown and
undocumented such tuners in the past. This is still an issue with
current silicon devices, since some RF shielding is often soldered
around them, but most manufacturers make the top cover removable now,
what unfortunately was not possible in the past and did set the users at
high risk to destroy their devices upon discovering what is hidden.

The bttv-gallery was more an information collection for hackers, the
actual status of a device then you got on the lists and with the code.
Most of the time it should just work from a given point, but there are
always ongoing changes, new bugs and minor corrections, which makes it
really a pain to keep documentation always up to date.

We need for sure all the details for new unsupported/buggy devices and I
think they should be still posted to the list too. I would not even mind
high resolution photos there, but I know what it means for others and
traffic load.

The more locations you have to look up for details, the worse it is.

Would you really like to have also all supported devices at the wiki?
That was my nightmare when David started with it, since you were done
previously with a mail to Gunther.

I still have several hundred mails in my backlash, but found at least
this one now ;)

Cheers,
Hermann





