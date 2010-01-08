Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:55261 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab0AHBfJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Jan 2010 20:35:09 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NT3km-0001lE-83
	for linux-media@vger.kernel.org; Fri, 08 Jan 2010 02:35:05 +0100
Received: from 124-168-2-82.dyn.iinet.net.au ([124.168.2.82])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 08 Jan 2010 02:35:04 +0100
Received: from baroque by 124-168-2-82.dyn.iinet.net.au with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 08 Jan 2010 02:35:04 +0100
To: linux-media@vger.kernel.org
From: dave_a <baroque@iinet.net.au>
Subject: Re: IR device at I2C address 0x7a
Date: Fri, 8 Jan 2010 01:27:12 +0000 (UTC)
Message-ID: <loom.20100108T015120-7@post.gmane.org>
References: <4B324EF0.7090606@aster.pl> <20100106153909.6bce3183@hyperion.delvare> <4B44CF62.5060405@aster.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Daro <ghost-rider <at> aster.pl> writes:

> 
> Hi Jean,
> 
> Thank you for your answer.
> It is not the error message itself that bothers me but the fact that IR 
> remote control device is not detected and I cannot use it (I checked it 
> on Windows and it's working). After finding this thread I thought it 
> could have had something to do with this error mesage.
> Is there something that can be done to get my IR remote control working?
> Thanks for your help in advance.
> 
> Best regards
> Darek
> 

Hi Darek,
I use a P7131 Dual with mythbuntu, and the IR remote needed special setup. 
While it's a slightly different model of P7131 yours, it could be worth a try.
In /etc/lirc/hardware.conf I needed the lines:
REMOTE_DRIVER="devinput"
REMOTE_DEVICE="name=saa7134*"
REMOTE_LIRCD_CONF="asus/mycinema.conf"
(remove or comment out any existing REMOTE_DEVICE entries)
The device name (with wildcard) matches on input device name (rather than using
numbered input which could change on reboot)

The remote config (IR codes for remote) go in:
/usr/share/lirc/remotes/asus/mycinema.conf

The button mappings are in another file associated with the specific application
(lircrc for mythtv).

Dave

> W dniu 06.01.2010 15:39, Jean Delvare pisze:
> > Hi Darek,
> >
> > Adding LMML to Cc.
> >
> > On Wed, 23 Dec 2009 18:10:08 +0100, Daro wrote:
> >    
> >> I have the problem you described at the mailing list with Asus
> >> MyCinema-P7131/P/FM/AV/RC Analog TV Card:
> >> IR remote control is not detected and "i2c-adapter i2c-3: Invalid 7-bit
> >> address 0x7a" error occurs.
> >> lspci gives the following output:
> >> 04:00.0 Multimedia controller: Philips Semiconductors
> >> SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d1)
> >> dmesg output I enclose in the attachment.
> >> I use:
> >> Linux DOMOWY 2.6.31-16-generic #53-Ubuntu SMP Tue Dec 8 04:02:15 UTC
> >> 2009 x86_64 GNU/Linux
> >>
> >> I would be gratefull for the help on that.
> >> (...)
> >> subsystem: 1043:4845, board: ASUS TV-FM 7135 [card=53,autodetected]
> >> (...)
> >> i2c-adapter i2c-3: Invalid 7-bit address 0x7a
> >> saa7133[0]: P7131 analog only, using entry of ASUSTeK P7131 Analog
> >>      
> > This error message will show on virtually every SAA713x-based board
> > with no known IR setup. It doesn't imply your board has any I2C device
> > at address 0x7a. So chances are that the message is harmless and you
> > can simply ignore it.
> >
> >    
> 
> 




