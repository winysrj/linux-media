Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:54086 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab2AZOSk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 09:18:40 -0500
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "'Kovacs Balazs'" <basq@bitklub.hu>
Cc: "'Ralph Metzler'" <rjkm@metzlerbros.de>,
	<linux-media@vger.kernel.org>
References: <18710154015.20120125181510@bitklub.hu> <4F20429F.6030003@maindata.sk> <1528925641.20120125233437@bitklub.hu> <20257.17724.917769.890215@morden.metzler> <008001ccdc29$2054a5d0$60fdf170$@coexsi.fr> <666295992.20120126144456@bitklub.hu>
In-Reply-To: <666295992.20120126144456@bitklub.hu>
Subject: RE: CI/CAM support for offline (from file) decoding
Date: Thu, 26 Jan 2012 15:18:41 +0100
Message-ID: <00ae01ccdc35$67e3edf0$37abc9d0$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Language: fr
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Kovacs Balazs [mailto:basq@bitklub.hu]
> Sent: jeudi 26 janvier 2012 14:45
> To: Sébastien RAILLARD (COEXSI)
> Cc: 'Ralph Metzler'; linux-media@vger.kernel.org
> Subject: Re: CI/CAM support for offline (from file) decoding
> 
> 
> 
> 
> >> -----Original Message-----
> >> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> >> owner@vger.kernel.org] On Behalf Of Ralph Metzler
> >> Sent: jeudi 26 janvier 2012 13:21
> >> To: linux-media@vger.kernel.org
> >> Subject: Re: CI/CAM support for offline (from file) decoding
> >>
> >> Kovacs Balazs writes:
> >>  > Yes,  i  thought about that, but i need the Hardware CAM + CI,
> >> because  > it's chip paired encryption. It means in my situation that
> >> the EMM and  > ECM is also encrypted so it's hard to use in a SoftCam
> >> configuration.
> >>  >
> >>  > I hope there's a solution in the DVB driver space.
> >>  >
> >>  > I receive the signal via RF or IP. If via RF i think it can be
> >> decoded  > via  the  HW,  and  the  record  it  to  disk,  but i need
> >> the full TS  > decrypted, and i think it's not possible (to decrypt
> >> all the encrypted  > ES  which  can be 20-30-40 in real time when i
> >> receive the signal). In  > IP  configuration  it's also not possible.
> >> So i have the recorded full  > TS  pieces  and somehow i have to
> >> decrypt with a
> >> CAM+Card paired to each  > other.  Of  course  i know that the
> >> decryption is only possible if the  > Smartcard  has  the
> >> authorization in those date ranges when the files  > was recorded. I
> >> have seen this kind of solution in Windows, but i need  > it on Linux
> now.
> >>
> >> Yes, you can do that, but only if the hardware supports it. Most
> >> cards with CAM/CI are hardwired in such a way that the transport
> >> stream comes from the demodulator, goes through the CAM/CI and then
> >> into the PCIe/PCI bridge. There are only a few cards where you can
> >> send a TS from memory to the CAM/CI and back.
> >>
> >> -Ralph
> >>
> >>
> 
> > The "Octopus CI" from "Digital Devices" is the only one I know where
> > you can input the TS stream directly to the CAM:
> > http://shop.digital-devices.de/epages/62357162.sf/en_GB/?ViewObjectID=
> > 370117
> > 11
> 
> Is  this  the  only  solution?  I need s2 tuner and IP input (from the
> motherboard's  Ethernet)  and  record  them to file splices. Then (for
> request)  i  have to decrypt one or more ES from the recorded file and
> push them back. It's a DVB monitoring solution.
> 

If you need to decrypt stream using an official CAM, I don't think you'll
have too much choice.
By the way, this "Octopus CI" card has 2 connectors where you can connect
two double DVB-S2 tuners.
Tuners and CAM work independently.

If you don't need an official CAM, maybe you can look to the OSCAM
project...

> thanks
> Balazs


