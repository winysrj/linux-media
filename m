Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3HEgD65000312
	for <video4linux-list@redhat.com>; Fri, 17 Apr 2009 10:42:14 -0400
Received: from nlpi053.prodigy.net (nlpi053.sbcis.sbc.com [207.115.36.82])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n3HEfsOa020117
	for <video4linux-list@redhat.com>; Fri, 17 Apr 2009 10:41:55 -0400
Received: from [192.168.0.201] (adsl-99-151-171-231.dsl.emhril.sbcglobal.net
	[99.151.171.231]) (authenticated bits=0)
	by nlpi053.prodigy.net (8.13.8 smtpauth/dk/map_regex/8.13.8) with ESMTP
	id n3HEfr9p013552
	for <video4linux-list@redhat.com>; Fri, 17 Apr 2009 09:41:53 -0500
Message-ID: <49E89535.90700@xnet.com>
Date: Fri, 17 Apr 2009 09:41:57 -0500
From: stuart <stuart@xnet.com>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
References: <897950.38037.qm@web57907.mail.re3.yahoo.com>
In-Reply-To: <897950.38037.qm@web57907.mail.re3.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
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
> 
> 
> 
> 
> ----- Mensaje original ---- De: stuart <stuart@xnet.com> Para: Harol
> Hunter <hawk_eyes80@yahoo.com.mx> CC: video4linux-list@redhat.com 
> Enviado: miércoles, 15 de abril, 2009 14:15:45 Asunto: Re: ATI TV
> Wonder PCI
> 
> 
> 
> Harol Hunter wrote:
>> Hi there people:
>> 
>> I have an ATI TV Wonder 550 PCI card and I can't make linux
>> recognize it properly. I've been googling a lot with no result.
>> Here I let you my lscpi results:
>> 
>> 01:0b.0 Multimedia controller [0480]: ATI Technologies Inc Theater
>> 550 PRO PCI [ATI TV Wonder 550] [1002:4d52] Subsystem: ATI
>> Technologies Inc Unknown device [1002:a346] Flags: bus master,
>> medium devsel, latency 64, IRQ 5 Memory at bff00000 (32-bit,
>> non-prefetchable) [size=1M] Memory at de000000 (32-bit,
>> prefetchable) [size=32M] Capabilities: [50] Power Management
>> version 2
>> 
>> I read that I have to load the right modules for it and this is
>> what I've done 'till now
>> 
>> $ sudo modprobe bttv card=63 tuner=44 radio=1
>> 
>> and with no parameters also. Bttv loads properly but still won't
>> recognize the cards. Am I doing anything wrong or it's just my
>> card. I must say I can watch TV on Windows with this very same card
>> 
>> 
>> Thanks in advance Harol
> 
> Got to ask, if you are in the state, why are you fooling w/an NTSC
> tuner (unless you are connected to a subscription service - then
> pardon my dribble!).
> 
> Any ways - I just installed some ATI tuners as well - but, I checked
> (lspci) and they are not the same type.  You will find that ATI / AMD
> named almost all their tuners "ATI Wonder" making it very difficult
> to distinguish which is which (let alone which are well, partially
> and not supported here in linux land).
> 
> That said, have you googled to find like minded people w/the same
> problem?  So far, what I have found leads me to think you are at a
> dead end w/this particular ATI:
> 
> http://lists.linuxcoding.com/rhl/2008q1/msg04270.html
> 
> Further evidence that your card might not work can be found here
> (search for "ATI "):
> 
> http://www.mythtv.org/docs/mythtv-HOWTO-3.html
> 
> I say "might not work" as, again, ATI / AMD's crappy naming is
> confusing.  I think you have an "ATI Wonder" card and I have an "ATI
> All-in-Wonder" card.  But from our lspci's I can not be sure.  I'm
> basing the true name of your card from the ATI / AMD's web site:
> 
> http://ati.amd.com/products/tvwonder550/index.html
> 
> Ah, here's the coffin nail (search for your 550 card):
> 
> http://www.linuxtv.org/wiki/index.php/ATI/AMD#ATI_Graphic_cards_with_TV_Tuners_and.2For_Capture_facilities
> 
> 
> Regardless, if you are serious about using a tuner in linux (i.e.
> going to build a mythtv box) I would approach the problem the other
> way around.  First check for support then go out and buy a tuner.
> 
> In case you want to get what I have, this is one of the results from
> my lspci (I think I get 3 per ATI card).  I'm still putting together
> this mythtv box.  But the ATSC feature of this card appears to be
> working (in a Debian system):
> 
> 01:06.0 Multimedia video controller: Conexant Systems, Inc.
> CX23880/1/2/3 PCI Vi deo and Audio Decoder (rev 05) Subsystem: ATI
> Technologies Inc HDTV Wonder Flags: bus master, medium devsel,
> latency 64, IRQ 17 Memory at fa000000 (32-bit, non-prefetchable)
> [size=16M] Capabilities: <access denied> Kernel driver in use: cx8800
>  Kernel modules: cx8800
> 
> 
> Let's begging by saying that I live in Cuba, so Digital TV is quite
> far, about my card as I say it's an ATI TV Wonder 550 PCI, reading
> CARDLIST.bttv in kernel Doc I found out it's supported by bttv driver
> so I thought it might be easy to configure, but the real problem is
> that even when then kernel sees the card it wont recognize it, anyone
> who has had this problem?
> 
> Harol
> 
> 
> 
> ¡Obtén la mejor experiencia en la web! Descarga gratis el nuevo
> Internet Explorer 8. http://downloads.yahoo.com/ieak8/?l=mx

Hi...

Sorry to hear you still have problems - but I've already emailed just 
about everything I know.  I have had problems with tuner cards as well. 
   I just removed a Kworld 120 from my mythtv box and will probably 
never try using it as a TV tuner again (I might use it to sample video - 
but I will not invest any more time into the TV tuner part of the 
card!).  I'll stick with my original suggestion: Get a well supported 
card - it will save you lots of time and hair pulling.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
