Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3NDFgrh020942
	for <video4linux-list@redhat.com>; Thu, 23 Apr 2009 09:15:42 -0400
Received: from mout0.freenet.de (mout0.freenet.de [195.4.92.90])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n3NDFLNs025361
	for <video4linux-list@redhat.com>; Thu, 23 Apr 2009 09:15:24 -0400
To: "Florian PANTALEAO"<fpantaleao@mobisensesystems.com>,
	video4linux-list@redhat.com
From: judith.baumgarten@freenet.de
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Message-Id: <E1Lwyls-000600-JS@www17.emo.freenet-rz.de>
Date: Thu, 23 Apr 2009 15:15:20 +0200
Content-Transfer-Encoding: 8bit
Cc: 
Subject: Re: Re: setting values to CICR2 register in PXA320 Quick Capture
	Interface
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

Hi Florian,

first: Thanks for your answer!

Do you know, if actually somebody works at this point? I asked google, but it didn't find a newer driver for a PXA-Camera.
I also had the chance to look at the Documentation of the PXA270, and it isn't as detailed as the one for PXA320, but the register also exists and has the same hardware address. So the "old" driver would work for me so far, if there would be a way to set the register.

regards
Judith

----- original Nachricht --------

Betreff: Re: setting values to CICR2 register in PXA320 Quick Capture Interface
Gesendet: Do 23 Apr 2009 09:40:51 CEST
Von: "Florian PANTALEAO"<fpantaleao@mobisensesystems.com>

> 
> 
> > Hi,
> >
> > I want to set various parameters in the Quick Capture Interface for a
> PXA320 processor. I think, I found a way to do this, for resolution and
> pixel clock parameters, but there is no way to set the parameters of CICR2
> using the actual pxa_camera driver. It seems the driver  just implements
> the
> master mode, and I wondered why. Is it not usefull to run a pxa_camera in
> slave mode?
> >
> > Nevertheless. CICR2 contains also the BLW (Beginning-of-Line Pixel Clock
> Wait Count) parameter, which is used in master and slave mode. So I
> wondered, why there isn't a way to set it (Or have I just missed it?).
> 
> Quick Capture interface in PXA3xx has significantly evolved over PXA27x. I
> remember a discussion in this list a couple of months ago about it.
> Suggestion was to create a separate pxa3xx_camera driver because of these
> differences.
> 
> Florian
> 
> > Here some extra information: I use V4L2 in combination with soc_camera
> interface and a PXA320 host. The soc_camera interface and pxa_camera driver
> are out of the 2.6.29 kernel.
> >
> > Thanks
> > Judith
> >
> >
> >
> >
> >
> >
> >
> > #adBox3 {display:none;}
> >
> >
> >
> > --
> > video4linux-list mailing list
> > Unsubscribe
> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> > https://www.redhat.com/mailman/listinfo/video4linux-list
> 
> 

--- original Nachricht Ende ----




Ist Ihr wunschname@freenet.de noch frei?
Jetzt prüfen und kostenlose E-Mail-Adresse sichern!
http://email.freenet.de/dienste/emailoffice/produktuebersicht/basic/mail/index.html?pid=6829


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
