Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:41937 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab1J0JFr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Oct 2011 05:05:47 -0400
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "'Ralph Metzler'" <rjkm@metzlerbros.de>
Cc: "'Linux Media Mailing List'" <linux-media@vger.kernel.org>
References: <004c01cc7a03$064111c0$12c33540$@coexsi.fr>	<201110240906.24543@orion.escape-edv.de>	<004e01cc9247$0a8da4d0$1fa8ee70$@coexsi.fr> <20133.44781.388484.71473@morden.metzler>
In-Reply-To: <20133.44781.388484.71473@morden.metzler>
Subject: RE: [DVB] Digital Devices Cine CT V6 support
Date: Thu, 27 Oct 2011 11:05:47 +0200
Message-ID: <000b01cc9487$9e48aac0$dada0040$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Language: fr
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Ralph Metzler
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
> E.g.:
> 
> echo "00 01" > /sys/class/ddbridge/ddbridge0/redirect
> 
> will pipe input 0 of card 0 through CI at port 1 (TAB 2) of card 0.
> 

Dear Ralph,

I've made two diagrams (see below) to explain the numbering based on your
explanation and the driver code source.
I hope they are right and it can help for understanding the octopus bridge.

The good news with the new redirect function is we can emulate the
traditional CAM handling and then use the current DVB software without
modification.

Best regards,
Sebastien.


                          OCTOPUS BRIDGE

                        +----------------+
  Tuner 0 -> Input 0 -> |                |
                        | Port 0 - TAB 1 | -> Output 0
  Tuner 1 -> Input 1 -> |                |
                        +----------------+
  Tuner 0 -> Input 2 -> |                |
                        | Port 1 - TAB 2 | -> Output 1
  Tuner 1 -> Input 3 -> |                |
                        +----------------+
  Tuner 0 -> Input 4 -> |                |
                        | Port 2 - TAB 3 | -> Output 2
  Tuner 1 -> Input 5 -> |                |
                        +----------------+
  Tuner 0 -> Input 6 -> |                |
                        | Port 3 - TAB 4 | -> Output 3
  Tuner 1 -> Input 7 -> |                |
                        +----------------+


                     CineS2 v6 + 2 CAM Readers

                        +----------------+
  Tuner 0 -> Input 0 -> |                |
                        | Port 0 - TAB 1 | -> Output 0
  Tuner 1 -> Input 1 -> |     DVB-S2     |
                        +----------------+
             Input 2 -> |                |
                        | Port 1 - TAB 2 | -> Output 1
             Input 3 -> |                |
                        +----------------+
    CAM 0 -> Input 4 -> |                |
                        | Port 2 - TAB 3 | -> Output 2 -> CAM 0
             Input 5 -> |       CAM      |
                        +----------------+
    CAM 1 -> Input 6 -> |                |
                        | Port 3 - TAB 4 | -> Output 3 -> CAM 1
             Input 7 -> |       CAM      |
                        +----------------+

Two redirections to set : 

* "X0 X2" (input #0 to port #2)
* "X1 X3" (input #1 to port #3)

Where X is the device number.


> Redirection should only be done right after loading the driver (or
> booting if the driver is built-in) and before using the devices in any
> way.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html

