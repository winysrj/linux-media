Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 216.14.233.220.exetel.com.au ([220.233.14.216]
	helo=mail.carbonaro.org) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mark@carbonaro.org>) id 1KPFHB-0005De-7G
	for linux-dvb@linuxtv.org; Sat, 02 Aug 2008 13:27:58 +0200
Date: Sat, 2 Aug 2008 21:21:21 +1000 (EST)
From: Mark Carbonaro <mark@carbonaro.org>
To: Jonathan Hummel <jhhummel@bigpond.com>
Message-ID: <24636158.81217676433289.JavaMail.mark@trogdor.carbonaro.org>
In-Reply-To: <9678479.61217676240039.JavaMail.mark@trogdor.carbonaro.org>
MIME-Version: 1.0
Cc: linux dvb mailing list <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Leadtek Winfast PxDVR 3200 H
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi Jon,

I just added some photos to the wiki that I took of my 3200 about a month ago, it's just some close ups of the chips.  I forgot all about them until you posted this message, figured I should probably pull my finger out and upload them.

I haven't taken the shielding off the card, I can only assume there is a tuner in there, I will crack it open on of these days and take note (and photos) of what is inside.

Mark

----- Original Message -----
From: "Jonathan Hummel" <jhhummel@bigpond.com>
To: stev391@email.com
Cc: "linux dvb mailing list" <linux-dvb@linuxtv.org>
Sent: Saturday, 2 August, 2008 5:43:45 PM (GMT+1000) Auto-Detected
Subject: Re: [linux-dvb] Leadtek Winfast PxDVR 3200 H

Hi Stephen

There was already a page of sorts:
http://www.linuxtv.org/wiki/index.php/Leadtek_Winfast_PxDVR_3200_H
I've added to it. I don't have winodws on that machine, but it apears
someone has done that for me already.
I have some more photos, of even higher res is you want them, but won't
clutter up everyone's inbox if not need/ wanted.

Cheers

Jon



On Mon, 2008-07-28 at 08:55 +1000, stev391@email.com wrote:
> Jon,
> 
> It appears that this card uses the CX23885 PCIe controller.
> 
> From initial research on the Leadtek site it appears that this card
> utilises the following main chips:
> Conexant CX23885 - PCIe Interface
> Conexant CX23417 - Analog Video to MPEG2 Encoder
> Intel CE6353 - Digital TV Demodulator (Formerly known as Zarlink
> 10353)
> Xceive ????? - Digital TV Tuner,
> 
> All of the above that I have identified have drivers in linux in
> various stages of development.
> 
> Can you take a high res photo of the card showing all chip IDs?
> Can you identify which tuner from Xceive it is?
> Do you have a partition set up with windows and the card working?
>    If so can you use regspy (Google "Dscaler Regspy" to find the
> correct program), and record what the values are for:
>       - Card sitting idle straight after bootup
>       - Watching Digital TV
>       - Watching Analog TV
>       - Sitting idle after watching TV
> 
> What is the output of `lspci -vnn` when in linux regarding this card?
> 
> What does `dmesg | grep cx23885` give you?
> 
> It might also be useful for others who have this card if you make an
> entry the linuxtv wiki for this card, with all of the information that
> I have requested linked to or included.
> 
> I may be able to knock up a driver that you can use for the digital TV
> side as this seems similar to other existing cards, I'm not familiar
> with the Analog side though. 
> (No gurantees, but it should be relatively simple to achieve).
> 
> Regards,
> 
> Stephen.
> 
> 
> --- Original Message ---
> Hi,
> 
>          I was wondering if anyone could help me get this card up and
>          working in
>          kubuntu 8.04. I've tried setting it up much like a Leadtek
>          DTV2000H,
>          version J, as per instructions here:
>          http://wiki.linuxmce.org/index.php/Leadtek_DTV2000H
>          (I've been using that card for a while in another box)
> 
>          System:
>          Gibagyte moher board (all in one) GA-MA78GM-S2H
>          AMD Athlon X2 6000 (2 core, 3GHz)
>          4G ram, heaps of hard disk
>          64bit KDE 4 kubuntu, kernel: 2.6.24-20 generic
> 
>          http://www.linuxtv.org/wiki/index.php/DVB-T_PCIe_Cards
>          suggested I email this address.
> 
> 
>          cheers
> 
>          Jon
> 
> 
> 
> 
> -- 
> Be Yourself @ mail.com!
> Choose From 200+ Email Addresses
> Get a Free Account at www.mail.com!


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
