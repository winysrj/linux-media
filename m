Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1HKPFwC004791
	for <video4linux-list@redhat.com>; Sun, 17 Feb 2008 15:25:15 -0500
Received: from mail-in-13.arcor-online.net (mail-in-13.arcor-online.net
	[151.189.21.53])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1HKOdQG015612
	for <video4linux-list@redhat.com>; Sun, 17 Feb 2008 15:24:39 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: "Peter D." <peter_s_d@fastmail.com.au>, video4linux-list@redhat.com
In-Reply-To: <200802171428.10859.peter_s_d@fastmail.com.au>
References: <200802171428.10859.peter_s_d@fastmail.com.au>
Content-Type: text/plain
Date: Sun, 17 Feb 2008 21:19:05 +0100
Message-Id: <1203279545.3473.184.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] auto detection of Flytv duo/hybrid and pci/cardbus
	confusion
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

Hi Peter,

Am Sonntag, den 17.02.2008, 14:28 +1100 schrieb Peter D.:
> Hi, 
> 
> I've finally gotten around to reading the code and trying to get my 
> PCI MSI TV@nywhere A/D card auto detected. 
> 
> First clarification, duo versus hybrid.  
> Are "duo" cards equipped with two independent tuners that can both be 
> used at the same time?  
> Are "hybrid" cards necessarily equipped with digital and analogue tuners?  
> Can a two tuner card be both a duo and a hybrid, if one tuner is digital 
> the other is analogue and they can both be used at the same time?  

for that all I give some examples further below.

> Second clarification, PCI versus cardbus.  
> They don't look anything like each other, but can they be logically 
> interchangeable?  If the code for a cardbus tuner happens to work for 
> a PCI tuner is there anything wrong with referring to the PCI tuner 
> as a cardbus device?  

No, we do such and vice versa, but then we add a comment PCI or cardbus
version usually and another important compatible category is Mini PCI.
You should also add LR306 as the board type.

> Looking at <http://www.linuxtv.org/wiki/index.php/DVB-T_PCMCIA_Cards> 
> there does not appear to be any such thing as a 
> SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS, despite the entry (number 94) 
> in saa7134.h.  Looking at 
> <http://www.linuxtv.org/wiki/index.php/DVB-T_PCI_Cards#LifeView> 
> there is a PCI version - but there is no PCI version in saa7134.h.  

They do exist, see bttv-gallery.de, also Mauro has already a MSI OEM
version. They are special for DVB-T, since they switch the mode by a
gpio pin and have the silent i2c connection to the tuner open and don't
use the i2c gate of the tda8290 analog demod inside the saa7131e for
DVB-T tuning.

> Should 
> "SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS" be changed to 
> "SAA7134_BOARD_FLYDVBT_HYBRID"?

No. Just also add "PCI" and "LR306" to your comments.
The gpio 21 is used for the TV/radio switch. The gpio 22 = 0 in the mask
is used to switch the tuner AGC to the analog demod.
On some cardbus version, which have the gpio 27 high, switching it to 0
turns the fan on, on yours it does nothing, since it is 0 anyway.

> It appears that both PCI and cardbus versions of the Flytv duo exist 
> and are listed in saa7134.h - despite slightly inconsistent punctuation; 
> SAA7134_BOARD_FLYDVBTDUO versus 
> SAA7134_BOARD_FLYDVBT_DUO_CARDBUS.  
> 
> Should 
> "SAA7134_BOARD_FLYDVBTDUO" be changed to 
> "SAA7134_BOARD_FLYDVBT_DUO"?

Not related to your device. Subdevice is 0x0306 and you have 0x3306,
but yes, these are in a different family of devices too.

> I have an MSI TV@nywhere A/D PCI card that works with the option card=94
> 
> There appears to not be an entry in struct pci_device_id saa7134_pci_tbl[] 
> in saa7134-cards.c for my card.  There is a reference to a 
> "TV@nywhere DUO" which I guess is a valid entry for a different card.  

Yes it is. Peter Missel bought some and added the entry.

Duo in LifeView terminology means two separate tuners. One for analog
TV/FM and one for DVB-T.

On the older Duo versions those two tuners were _not hybrid_ and
different for analog TV and DVB-T.
Only the newer Duo variants with tda8275A use two identical such tuners,
but not in hybrid mode. One is always in analog and the other always in
digital mode. The older types are out of production and using two still
allows to have DVB-T and analog TV from the tuners at once.

This is not possible with one single hybrid tuner. DVB-T and analog
video from an external input, VCR tuner or something, is possible at
once, but needs also to use packed video formats for analog during that
due to limitations of the dma engines with planar formats.

Then the Trio has even one more tuner for DVB-S, but there is only _one_
saa713x PCI bridge on all such and only one channel decoder/demodulator
for each mode. Since the single saa713x chip has only one TS/mpeg/host
interface, either usable in parallel or serial mode, DVB-S and DVB-T can
not be used at the same time. (also not an mpeg encoder)

This is only possible with two saa713x bridges, like the md7134 in the
CTX925 version has them and when we enable DVB-S support on the second
bridge hopefully soon. Else functionality is like on the Trio. (BTW, the
md7134 represents lots of different cards through eeprom detection)

Next category is the Medion md8800 Quad(ro) with two saa7131e,
two fully usable tda8275ac1 hybrid (2 analog + 2 DVB-T demods, no FM)
and two tda8263 DVB-S tuners plus two tda10086 channel decoders plus an
isl6405 dual LNB controller, where we just have support of the first SAT
connector now, diseqc for multiswitches is not fully tested yet. There
is RF loopthrough, in and out, respectively to the other.

So it should be already possible to view and record from both DVB-S
devices at once, within that tunable spectrum the active one limits for
the passive by controlling tone and LNB voltage.

That loopthrough can be switched off, for example when we have active
control for the second SAT connector too. 

On the two hybrid tuners the RF feed can also be switched, either to
loopthrough mode from TV1 antenna connector to both tuners or have input
of choice from both analog/DVB-T antenna connectors separately.   

> Is the entry; 
> 
>           {
>                 .vendor       = PCI_VENDOR_ID_PHILIPS,
>                 .device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
>                 .subvendor    = 0x4e42,
>                 .subdevice    = 0x3502,
>                 .driver_data  = SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS
>         },
> 
> supposed to be;
> 
>            {
>                 .vendor       = PCI_VENDOR_ID_PHILIPS,
>                 .device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
>                 .subvendor    = 0x4E42,         /* MSI */
>                 .subdevice    = 0x3306,         /* TV@nywhere Hybrid A/D */
>                 driver_data  = SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS,
>         },
> 
> with the subdevice changed, or possibly;
> 
>            {
>                 .vendor       = PCI_VENDOR_ID_PHILIPS,
>                 .device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
>                 .subvendor    = 0x4E42,         /* MSI */
>                 .subdevice    = 0x3306,         /* TV@nywhere Hybrid A/D */
>                 driver_data  = SAA7134_BOARD_FLYDVBT_HYBRID,
>         },
> 
> with the subdevice and driver_data changed, or should there be an extra 
> entry in the list?  

We have no SAA7134_BOARD_FLYDVBT_HYBRID, this would require already the
new entry.

The 4e42:3502 is Mauro's MSI TV @nywhere A/D NB cardbus and likely other
OEMs too. On the subdevice 0x3306 are the related PCI cards and 0x3307
are Mini PCI.

Thought you did not pick up my patch suggestion that time,
http://www.linuxtv.org/pipermail/linux-dvb/2007-June/018678.html
because we had no means to make a difference to the Vivanco 21056 and we
did not get the analog TV mode right on it.

For the i2c remote with mdt10p55 (pic 16c505) Eddi had a patch. We
talked about it and remaining implementation questions, but should be
usable for you in private if you replace the appearance of
SAA7134_BOARD_FLYDVB_TRIO with your device or add it accordingly.

Since the cardbus and mini pci devices seem not to have a remote so far,
this could eventually rise the question of a separate entry later on
IMHO.

Cheers,
Hermann








--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
