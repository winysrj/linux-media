Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:50431 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507Ab3BTFjK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Feb 2013 00:39:10 -0500
Date: Tue, 19 Feb 2013 23:09:16 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mr Goldcove <goldcove@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Wrongly identified easycap em28xx
In-Reply-To: <20130219170343.00b92d18@redhat.com>
Message-ID: <alpine.LNX.2.02.1302192234130.27265@banach.math.auburn.edu>
References: <512294CA.3050401@gmail.com> <51229C2D.8060700@googlemail.com> <5122ACDF.1020705@gmail.com> <5123ACA0.2060503@googlemail.com> <20130219153024.6f468d43@redhat.com> <5123C849.6080207@googlemail.com> <20130219155303.25c5077a@redhat.com>
 <5123D651.1090108@googlemail.com> <20130219170343.00b92d18@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tue, 19 Feb 2013, Mauro Carvalho Chehab wrote:

> Em Tue, 19 Feb 2013 20:45:21 +0100
> Frank Sch?fer <fschaefer.oss@googlemail.com> escreveu:
> 
> > Am 19.02.2013 19:53, schrieb Mauro Carvalho Chehab:
> > > Em Tue, 19 Feb 2013 19:45:29 +0100
> > > Frank Sch?fer <fschaefer.oss@googlemail.com> escreveu:
> > >
> > >>> I don't like the idea of merging those two entries. As far as I remember
> > >>> there are devices that works out of the box with
> > >>> EM2860_BOARD_SAA711X_REFERENCE_DESIGN. A change like that can break
> > >>> the driver for them.
> > >> As described above, there is a good chance to break devices with both
> > >> solutions.
> > >>
> > >> What's your suggestion ? ;-)
> > >>
> > > As I said, just leave it as-is (documenting at web) 
> > 
> > That seems to be indeed the only 100%-regression-safe solution.
> > But also _no_ solution for this device.
> > A device which works only with a special module parameter passed on
> > driver loading isn't much better than an unsupported device.
> 
> That's not true. There are dozens of devices that only work with
> modprobe parameter (even ones with their own USB or PCI address). The thing
> is that crappy vendors don't provide any way for a driver to detect what's
> there, as their driver rely on some *.inf config file with those parameters
> hardcoded.
> 
> We can't do any better than what's provided by the device.
> 
> > 
> > It comes down to the following question:
> > Do we want to refuse fixing known/existing devices for the sake of
> > avoiding regression for unknown devices which even might not exist ? ;-)
> 
> HUH? As I said: there are devices that work with the other board entry.
> If you remove the other entry, _then_ you'll be breaking the driver.
> 
> > I have no strong and final opinion yet. Still hoping someone knows how
> > the Empia driver handles these cases...
> 
> What do you mean? The original driver? The parameters are hardcoded at the
> *.inf file. Once you get the driver, the *.inf file contains all the
> parameters for it to work there. If you have two empia devices with
> different models, you can only use the second one after removing the
> install for the first one.
> 
> > > or to use the AC97
> > > chip ID as a hint. This works fine for devices that don't come with
> > > Empiatech em202, but with something else, like the case of the Realtek
> > > chip found on this device. The reference design for sure uses em202.
> > 
> > How could the AC97 chip ID help us in this situation ?
> > As far as I understand, it doesn't matter which AC97 IC is used.
> > They are all compatible and at least our driver uses the same code for
> > all of them.
> 
> The em28xx Kernel driver uses a hint code to try to identify the device
> model. That hint code is not perfect, but it is the better we can do.
> 
> There are two hint codes there, currently: 
> 1) device's eeprom hash, used when the device has an eeprom, but the
>    USB ID is not unique;
> 
> 2) I2C scan bus hash: sometimes, different devices use different I2C
> addresses.
> 
> > 
> > So even if you are are right and the Empia reference design uses an EMP202,
> > EM2860_BOARD_SAA711X_REFERENCE_DESIGN might work for devices with other
> > AC97-ICs, too.
> 
> The vast majority of devices use emp202. There are very few ones using
> different models.
> 
> The proposal here is to add a third hint code, that would distinguish
> the devices based on the ac97 ID.
> 
> > We should also expect manufacturers to switch between them whenever they
> > want (e.g. because of price changes).
> 
> Yes, and then we'll need other entries at the hint table.
> 
> Regards
> Mauro

I see the dilemma. Devices which are not uniquely identifiable. Mauro is 
right in pinpointing the problem, and he is also right that one can not 
expect the manufacturers to pay any attention. Mauro is also absolutely 
right that it is not good to break what works already for some people, 
hoping to please some others who are presently unhappy. A better solution 
needs to be found.

Could I make a suggestion?

Sometimes it is possible to find some undocumented way to identify 
uniquely which one of two devices you have. As an example, look in 
mr97310a.c, where there is a detection routine for several devices which 
all have the same USB vendor:product code but are different inside. 

Indeed, back when lots of those mr97310a cameras were on the market, the 
"manufacturers" were supposed to be sending out the cameras with the 
"right" windows driver. Except the situation was actually so bad that 
quite often some of the manufacturers were grabbing the wrong driver CD 
off the shelf and putting it with the wrong cameras! You can do a Google 
search for the Windows driver for some of those cameras and find web pages 
full of complaints from disgruntled users who got the wrong CD in the 
package with the camera, frantically looking for the right driver CD. It 
was that bad. Now to top that off, think of some poor guy having a Windows 
computer and wanting to have two cameras of the same brand and make, with 
identical cases on the outside, but which needed different versions of the 
driver CD. And whichever driver is installed one of the two cameras will 
not work. Proof, BTW, that neither of those Windows drivers contains any 
detection routine.

The gspca_mr97310a module for Linux is the only support for those cameras 
for any operating system that I know of, which actually can tell one of 
those cameras from the other and apply the right initialiation to it when 
it is hooked up -- unless somebody has copied us since then.

The situation here looks to me similar. What someone needs to do is to 
find some kind of "read" command or sequence of commands (probably to the 
sensor, not to the controller) which will report a distinct answer for 
each of the various different cameras. Almost certainly, it will not be 
documented, but it almost certainly has to exist -- if for no other 
reason, because something is obviously different about the two pieces of 
hardware. So in my opinion the thing to do is to try to find that magic 
command. By a combination of educated guessing and trial and error. This 
needs for someone to have both cameras, or for two or more people who have 
the different cameras to cooperate together and hunt for the right command 
which unlocks the mystery.

I am out of this one because I don't have one of the cameras currently in 
question. But I did have a big pile of mr97310a cameras, and that is 
exactly what I did. Started sending various commands and checking whether 
or not I got different results until I found what works.

So, good luck. The answer is probably there if one looks for it.

My two cents,

Theodore Kilgore
