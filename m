Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6UIc4bI005783
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 14:38:04 -0400
Received: from web63003.mail.re1.yahoo.com (web63003.mail.re1.yahoo.com
	[69.147.96.214])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6UIbPl1006381
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 14:37:25 -0400
Date: Wed, 30 Jul 2008 11:37:19 -0700 (PDT)
From: Fritz Katz <frtzkatz@yahoo.com>
To: video4linux-list@redhat.com, Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200807301813.30670.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <505955.90581.qm@web63003.mail.re1.yahoo.com>
Cc: 
Subject: Re: What info does V-4-L expect to be in the "Identifier EEprom"?
Reply-To: frtzkatz@yahoo.com
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


--- On Wed, 7/30/08, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
> It is likely you will choose your own format, but it is
> very useful if the eeprom has information like:
> 
> - model number/type of the card
> - what tuner chip(s) is/are used (tuners tend to be 
>     swapped for different models quite often).
> - whether there is a radio supported
> - IR support (none, just a receiver, both receiver 
>     and transmitter)
> - Any encoder/decoder chips (unless that can be derived
>   from the model number).
> 
> In general: anything you need to determine which chips are
> on the board and on which i2c address. And how external 
> connectors are hooked up to those chips (if that can vary).
> 

  So it would be sufficient to just include an ASCII string containing the above information?  

Then I could send it to this list, and the board could be recognized in the next release of V-4-L?

> Of course, if all this can be directly determined by the
> PCI (sub)vendor/device IDs, then there is no need for an
> eeprom. 

I'm assuming that the list of PCI (sub)vendor/device IDs is here:

http://www.pcidatabase.com/pci_c_header.php

and that the Video-4-Linux references pcihdr.h:
"PCI_DEVTABLE	PciDevTable [] = {..."
to determine the vendor/device ID.

Should those two hex numbers should be the first 32 bytes in the EEPROM?

Unfortunately, the company I'm consulting for is not in the list. I suppose we can submit an unused vendor ID to the site.

> Sadly, my experience is that the PCI IDs tend to be insufficient 
> or plain wrong, especially by cheap cards based on a reference 
> design from another company. 

Here's my sad story attempting to bring the board up on Linux:

____________

When I install one of the pci cards in the Linux box, and boot, an 
actual 'rant' appears in the dmesg:

	saa7130/34: v4l2 driver version 0.2.14 loaded
	phy0: hwaddr 00:40:f4:f8:83:e4, RTL8185vD + rtl8225z2
	ACPI: PCI Interrupt 0000:00:09.0[A] -> GSI 17 (level, low) -> IRQ 17
	saa7130[0]: found at 0000:00:09.0, rev: 1, irq: 17, latency: 32, mmio: 0xe2000000
	saa7134: <rant>
	saa7134:  Congratulations!  Your TV card vendor saved a few
	saa7134:  cents for a eeprom, thus your pci board has no
	saa7134:  subsystem ID and I can't identify it automatically
	saa7134: </rant>

and, when it sees the Philips decoder chip it says:

	saa7130[0]: Huh, no eeprom present (err=-5)?

I suppose the 5 line <rant> is useful if it shames companies 
into including the ID eeprom. But the <rant> then goes on to 
spew into dmesg and /var/log/messages a list 144 different 
cards. A more helpful suggestion might be to print a URL 
to a trouble-shooting webpage to help people determine 
which card they have. I have found this page to be helpful:

http://www.de.gentoo-wiki.com/HARDWARE_saa7134

Apparently it's necessary to cycle through rmmod/modprobe/watchTV 
to see which combo works. Here's the simple script:
 -----------------------
 #/bin/sh
 MAXCARD=144
 MAXTUNER=69
 for i in $(seq 0 $MAXCARD);
 do
   for j in $(seq 0 $MAXTUNER);
   do
     rmmod tuner saa7134
     modprobe saa7134 card=$i tuner=$j
     echo "Is TVtime working with card=" $i " and tuner=" $j " ? "
     sleep 1 # make sure /dev/video is registered when tvtime starts
     tvtime
   done
 done
 -----------------------

There are over 144 card and 69 tuner combos = 9936.  
GAAACK!, takes a long time.

Also, from hard experience, I've found it's necessary to do a:

# tail -f /var/log/messages

in another shell to make sure the card is still responding 
to commands. Some tuner numbers apparently lock up the card, 
reboot required, and you won't know that anything is 
wrong -- while you spend hours testing combos that should 
have worked.

I finally found a card/tuner combo. Using tvtime, the video 
output doesn't appear on the 'Television' output. Instead 
it appears on 'Composite2' output. You can only tune 
channels by using 'Input Configuration', switching to a 
blue-screen 'Television' and then switching back to 
'Composite2' to view it.

Sometimes the board tunes fine. Sometimes after re-boot 
it may be necessary to do fine-tuning to receive stations. 
I suppose since the board is not recognized by V-4-L, the 
tuner section may not be initialized properly?

Regards,
-- Fritz Katz.







      

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
