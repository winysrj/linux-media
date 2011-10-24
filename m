Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:41283 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab1JXVom convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Oct 2011 17:44:42 -0400
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "'Ralph Metzler'" <rjkm@metzlerbros.de>
Cc: "'Linux Media Mailing List'" <linux-media@vger.kernel.org>
References: <004c01cc7a03$064111c0$12c33540$@coexsi.fr>	<201110240906.24543@orion.escape-edv.de>	<004e01cc9247$0a8da4d0$1fa8ee70$@coexsi.fr> <20133.44781.388484.71473@morden.metzler>
In-Reply-To: <20133.44781.388484.71473@morden.metzler>
Subject: RE: [DVB] Digital Devices Cine CT V6 support
Date: Mon, 24 Oct 2011 23:44:39 +0200
Message-ID: <00a001cc9296$22c75420$6855fc60$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Language: fr
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Ralph Metzler [mailto:rjkm@metzlerbros.de]
> Sent: lundi 24 octobre 2011 20:31
> To: S é bastien RAILLARD (COEXSI)
> Cc: 'Linux Media Mailing List'
> Subject: RE: [DVB] Digital Devices Cine CT V6 support
> 
> Sébastien RAILLARD (COEXSI) writes:
>  > I've seen a new parameter "ts_loop", can you explain how it's
> working?
>  > Is-it for sending the stream from the demodulator directly to the CAM
> > reader?
> 
> No, it is mainly for testing. It declares one TAB as loopback, which
> means that the data output is directly connected to the input.
> 

Ok

> For redirecting a stream through a CI see the "redirect" attribute.
> I don't know if my small redirect readme was included in the package I
> sent to Oliver. So, I attached it below.
> 
> 
> -Ralph
> 
> 
> 
> Redirection of TS streams through CI modules is now supported through
> /sys/class/ddbridge/ddbridge0/redirect.
> It only works with cards based on the ddbridge PCIe bridge, not with
> nGene based cards.
> 
> It is set up in such a way that you can write "AB CD" to a "redirect"
> attribute and data from input B of card A is then piped through port D
> (meaning TAB (D+1) which uses output D and input 2*D for CI io) of card
> C and then shows up in the demux device belonging to input B (input
> (B&1) of TAB (B/2+1)) of card A.
> 

Great feature, thanks!

> E.g.:
> 
> echo "00 01" > /sys/class/ddbridge/ddbridge0/redirect
> 
> will pipe input 0 of card 0 through CI at port 1 (TAB 2) of card 0.
> 
> Redirection should only be done right after loading the driver (or
> booting if the driver is built-in) and before using the devices in any
> way.


