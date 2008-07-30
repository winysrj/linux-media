Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6UJ5O5t026256
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 15:05:25 -0400
Received: from smtp-vbr10.xs4all.nl (smtp-vbr10.xs4all.nl [194.109.24.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6UJ49jb023911
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 15:04:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: frtzkatz@yahoo.com
Date: Wed, 30 Jul 2008 21:04:07 +0200
References: <505955.90581.qm@web63003.mail.re1.yahoo.com>
In-Reply-To: <505955.90581.qm@web63003.mail.re1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807302104.07478.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com
Subject: Re: What info does V-4-L expect to be in the "Identifier EEprom"?
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

On Wednesday 30 July 2008 20:37:19 Fritz Katz wrote:
> --- On Wed, 7/30/08, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > It is likely you will choose your own format, but it is
> > very useful if the eeprom has information like:
> >
> > - model number/type of the card
> > - what tuner chip(s) is/are used (tuners tend to be
> >     swapped for different models quite often).
> > - whether there is a radio supported
> > - IR support (none, just a receiver, both receiver
> >     and transmitter)
> > - Any encoder/decoder chips (unless that can be derived
> >   from the model number).
> >
> > In general: anything you need to determine which chips are
> > on the board and on which i2c address. And how external
> > connectors are hooked up to those chips (if that can vary).
>
>   So it would be sufficient to just include an ASCII string
> containing the above information?

That's one way of doing it. Usually it tends to be a bit more 
systematic.

> Then I could send it to this list, and the board could be recognized
> in the next release of V-4-L?

Someone needs to add code to the saa7134 driver to parse the eeprom.

> > Of course, if all this can be directly determined by the
> > PCI (sub)vendor/device IDs, then there is no need for an
> > eeprom.
>
> I'm assuming that the list of PCI (sub)vendor/device IDs is here:
>
> http://www.pcidatabase.com/pci_c_header.php
>
> and that the Video-4-Linux references pcihdr.h:
> "PCI_DEVTABLE	PciDevTable [] = {..."
> to determine the vendor/device ID.
>
> Should those two hex numbers should be the first 32 bytes in the
> EEPROM?

No, PCI IDs are stored by the PCI hardware (I'm no expert on this). The 
boards already have PCI IDs since they are mandated by the PCI 
standard. You can find them with 'lspci -vn'.

> Unfortunately, the company I'm consulting for is not in the list. I
> suppose we can submit an unused vendor ID to the site.

No! The cards already have vendor/device/subvendor/subdevice IDs. Ask 
the engineers, they should have all the details on this.

You need to add a card definition to the saa7134-cards.c source. It's 
not magic, someone has to do some coding. And if the PCI IDs are 
sufficient to uniquely determine with card it is, then there is no need 
for an eeprom. On the other hand, if there are several types of board 
with the same PCI IDs but different components, then something like 
that might be needed.

> > Sadly, my experience is that the PCI IDs tend to be insufficient
> > or plain wrong, especially by cheap cards based on a reference
> > design from another company.
>
> Here's my sad story attempting to bring the board up on Linux:
>
> ____________
>
> When I install one of the pci cards in the Linux box, and boot, an
> actual 'rant' appears in the dmesg:
>
> 	saa7130/34: v4l2 driver version 0.2.14 loaded
> 	phy0: hwaddr 00:40:f4:f8:83:e4, RTL8185vD + rtl8225z2
> 	ACPI: PCI Interrupt 0000:00:09.0[A] -> GSI 17 (level, low) -> IRQ 17
> 	saa7130[0]: found at 0000:00:09.0, rev: 1, irq: 17, latency: 32,
> mmio: 0xe2000000 saa7134: <rant>
> 	saa7134:  Congratulations!  Your TV card vendor saved a few
> 	saa7134:  cents for a eeprom, thus your pci board has no
> 	saa7134:  subsystem ID and I can't identify it automatically
> 	saa7134: </rant>

PCI IDs are not known in the card list, so it falls back to this.

>
> and, when it sees the Philips decoder chip it says:
>
> 	saa7130[0]: Huh, no eeprom present (err=-5)?
>
> I suppose the 5 line <rant> is useful if it shames companies
> into including the ID eeprom. But the <rant> then goes on to
> spew into dmesg and /var/log/messages a list 144 different
> cards. A more helpful suggestion might be to print a URL
> to a trouble-shooting webpage to help people determine
> which card they have. I have found this page to be helpful:
>
> http://www.de.gentoo-wiki.com/HARDWARE_saa7134
>
> Apparently it's necessary to cycle through rmmod/modprobe/watchTV
> to see which combo works. Here's the simple script:
>  -----------------------
>  #/bin/sh
>  MAXCARD=144
>  MAXTUNER=69
>  for i in $(seq 0 $MAXCARD);
>  do
>    for j in $(seq 0 $MAXTUNER);
>    do
>      rmmod tuner saa7134
>      modprobe saa7134 card=$i tuner=$j
>      echo "Is TVtime working with card=" $i " and tuner=" $j " ? "
>      sleep 1 # make sure /dev/video is registered when tvtime starts
>      tvtime
>    done
>  done
>  -----------------------
>
> There are over 144 card and 69 tuner combos = 9936.
> GAAACK!, takes a long time.
>
> Also, from hard experience, I've found it's necessary to do a:
>
> # tail -f /var/log/messages
>
> in another shell to make sure the card is still responding
> to commands. Some tuner numbers apparently lock up the card,
> reboot required, and you won't know that anything is
> wrong -- while you spend hours testing combos that should
> have worked.
>
> I finally found a card/tuner combo. Using tvtime, the video
> output doesn't appear on the 'Television' output. Instead
> it appears on 'Composite2' output. You can only tune
> channels by using 'Input Configuration', switching to a
> blue-screen 'Television' and then switching back to
> 'Composite2' to view it.
>
> Sometimes the board tunes fine. Sometimes after re-boot
> it may be necessary to do fine-tuning to receive stations.
> I suppose since the board is not recognized by V-4-L, the
> tuner section may not be initialized properly?

Yup. As I said, someone has to write card definitions for these boards. 
It's not magic, you know. Someone has to tell the saa7134 driver how to 
detect the cards and what to do.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
