Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4B4lxqC005037
	for <video4linux-list@redhat.com>; Mon, 11 May 2009 00:47:59 -0400
Received: from vms173017pub.verizon.net (vms173017pub.verizon.net
	[206.46.173.17])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n4B4kNjf029553
	for <video4linux-list@redhat.com>; Mon, 11 May 2009 00:46:23 -0400
Received: from coyote.coyote.den ([141.153.76.68]) by vms173017.mailsrvcs.net
	(Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008;
	32bit)) with ESMTPA id <0KJG00HJ7QL7LNZ5@vms173017.mailsrvcs.net> for
	video4linux-list@redhat.com; Sun, 10 May 2009 23:46:19 -0500 (CDT)
From: Gene Heskett <gene.heskett@verizon.net>
To: video4linux-list@redhat.com
Date: Mon, 11 May 2009 00:46:11 -0400
References: <1241982336.31677.0.camel@localhost.localdomain>
	<4A077247.8030305@rogers.com>
	<1242013532.3277.28.camel@localhost.localdomain>
In-reply-to: <1242013532.3277.28.camel@localhost.localdomain>
MIME-version: 1.0
Content-type: Text/Plain; charset=iso-8859-15
Content-disposition: inline
Message-id: <200905110046.12676.gene.heskett@verizon.net>
Content-Transfer-Encoding: 8bit
Subject: Re: Hauppauge WinTV-hvr-1800 PCIe won't work with tvtime or mplayer.
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

On Sunday 10 May 2009, William Case wrote:
>Hi CityK;
>
>On Sun, 2009-05-10 at 20:33 -0400, CityK wrote:
>> William Case wrote:
>>
>> Note: cx88 associated modules do NOT apply to this device (cx88 driver
>> modules are for the PCI based cx2388x chipsets, where x=0/1,2,3).  This
>> is a PCIe based device which is serviced, amongst others, by the cx23885
>> driver module.
>
>I have removed all the extra modules I have been playing with and
>removed any modprobe instructions I had been trying.
>
>> Also, have a look in the wiki for the device article which appears to
>> contain some info that would be useful for you.
>
>I re-installed v4l-dvb-4c7466ea8d64.tar.bz2, as suggested on the wiki.
>The extracted files are in /lib/modules/["kernel
>version"]/kernel/drivers/media with today's installation date. (last
>modified)
>
>> With a hardware encoding device, the /dev/video0 should be the MPEG2
>> stream whereas /dev/video1 would be the raw stream compatible with apps
>> like tvtime.  mplayer /dev/video0 should work. .... note that the node
>> number (N) of the character device (/dev/videoN) will be different if
>> you have multiple devices installed in the system, so you will have to
>> adjust accordingly.
>
>I am trying to set up analog viewing through my cable provider.
>tvtime.xml is set to video0. It still gives me an excellent picture but
>no sound. video1 just gives me a black screen - no sound.
>
>On mplayer device=/dev/video0 remains the same --terrible picture; no
>sound. mplayer device=/dev/video0 produces the error message
>'vo: x11 uninit called but X11 not initialized..' and quits.
>
>The mplayer script I am using is a slightly modified copy of the command
>suggested on the wiki.
>
>Basically the info I submitted originally remains the same except the
>cx2388x modules are gone.
>
>Usually I like to work away at these kind problems until I conquer them
>myself.  But I have been on this one for over two weeks and I am driving
>myself to distraction.  I really do appreciate your time and advice.

What kind of a card do you have again, Bill? My pcHDTV-3000 is cx88 based. 

>From lspci:
01:08.0 Multimedia video controller: Conexant Systems, Inc. CX23880/1/2/3 PCI 
Video and Audio Decoder (rev 05)
01:08.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video 
and Audio Decoder [MPEG Port] (rev 05)

Does anyone know if a digital output capability would show up in this lspci?

cx88_alsa can be loaded here but has no effect.  I shut the analog mic circuit 
down and went looking for a pci feed to the card but came up empty.

I use the mic input on my audigy2, and have, in kmix, any of the audio boosts 
available muted so the mic input isn't too much more sensitive than a line 
input might be.

And I edited the tvtime.xml file to link the tvtime volume control (the left-
right arrows on the keyboard) by way of this piece of the last option line in 
.tvtime/tvtime.xml:

<option name="MixerDevice" value="/dev/mixer:mic"/>

So that the tvtime volume control can be seen to run the mic gains in kmix and 
vice-versa.

I'm listening to it right now.  Nice and clean.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The system was down for backups from 5am to 10am last Saturday.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
