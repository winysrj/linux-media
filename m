Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3FIG67G010882
	for <video4linux-list@redhat.com>; Wed, 15 Apr 2009 14:16:06 -0400
Received: from nlpi053.prodigy.net (nlpi053.sbcis.sbc.com [207.115.36.82])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n3FIFllB004659
	for <video4linux-list@redhat.com>; Wed, 15 Apr 2009 14:15:47 -0400
Message-ID: <49E62451.3060904@xnet.com>
Date: Wed, 15 Apr 2009 13:15:45 -0500
From: stuart <stuart@xnet.com>
MIME-Version: 1.0
To: Harol Hunter <hawk_eyes80@yahoo.com.mx>
References: <548493.31113.qm@web57903.mail.re3.yahoo.com>
In-Reply-To: <548493.31113.qm@web57903.mail.re3.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: ATI TV Wonder PCI
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



Harol Hunter wrote:
> Hi there people:
> 
> I have an ATI TV Wonder 550 PCI card and I can't make linux recognize it properly. I've been googling a lot with no result. Here I let you my lscpi results:
> 
> 01:0b.0 Multimedia controller [0480]: ATI Technologies Inc Theater 550 PRO PCI [ATI TV Wonder 550] [1002:4d52]
>     Subsystem: ATI Technologies Inc Unknown device [1002:a346]
>     Flags: bus master, medium devsel, latency 64, IRQ 5
>     Memory at bff00000 (32-bit, non-prefetchable) [size=1M]
>     Memory at de000000 (32-bit, prefetchable) [size=32M]
>     Capabilities: [50] Power Management version 2
> 
> I read that I have to load the right modules for it and this is what I've done 'till now
> 
> $ sudo modprobe bttv card=63 tuner=44 radio=1
> 
> and with no parameters also. Bttv loads properly but still won't recognize the cards. Am I doing anything wrong or it's just my card. I must say I can watch TV on Windows with this very same card
> 
> Thanks in advance
> Harol

Got to ask, if you are in the state, why are you fooling w/an NTSC tuner 
(unless you are connected to a subscription service - then pardon my 
dribble!).

Any ways - I just installed some ATI tuners as well - but, I checked 
(lspci) and they are not the same type.  You will find that ATI / AMD 
named almost all their tuners "ATI Wonder" making it very difficult to 
distinguish which is which (let alone which are well, partially and not 
supported here in linux land).

That said, have you googled to find like minded people w/the same 
problem?  So far, what I have found leads me to think you are at a dead 
end w/this particular ATI:

http://lists.linuxcoding.com/rhl/2008q1/msg04270.html

Further evidence that your card might not work can be found here (search 
for "ATI "):

http://www.mythtv.org/docs/mythtv-HOWTO-3.html

I say "might not work" as, again, ATI / AMD's crappy naming is 
confusing.  I think you have an "ATI Wonder" card and I have an "ATI 
All-in-Wonder" card.  But from our lspci's I can not be sure.  I'm 
basing the true name of your card from the ATI / AMD's web site:

http://ati.amd.com/products/tvwonder550/index.html

Ah, here's the coffin nail (search for your 550 card):

http://www.linuxtv.org/wiki/index.php/ATI/AMD#ATI_Graphic_cards_with_TV_Tuners_and.2For_Capture_facilities

Regardless, if you are serious about using a tuner in linux (i.e. going 
to build a mythtv box) I would approach the problem the other way 
around.  First check for support then go out and buy a tuner.

In case you want to get what I have, this is one of the results from my 
lspci (I think I get 3 per ATI card).  I'm still putting together this 
mythtv box.  But the ATSC feature of this card appears to be working (in 
a Debian system):

01:06.0 Multimedia video controller: Conexant Systems, Inc. 
CX23880/1/2/3 PCI Vi
deo and Audio Decoder (rev 05)
         Subsystem: ATI Technologies Inc HDTV Wonder
         Flags: bus master, medium devsel, latency 64, IRQ 17
         Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
         Capabilities: <access denied>
         Kernel driver in use: cx8800
         Kernel modules: cx8800




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
