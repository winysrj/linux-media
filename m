Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3NDwruX018993
	for <video4linux-list@redhat.com>; Thu, 23 Apr 2009 09:58:53 -0400
Received: from namebay.info (mail.namebay.info [80.247.68.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n3NDwY7O014551
	for <video4linux-list@redhat.com>; Thu, 23 Apr 2009 09:58:35 -0400
Received: from localhost by namebay.info (MDaemon PRO v9.6.2)
	with ESMTP id md50005090367.msg
	for <video4linux-list@redhat.com>; Thu, 23 Apr 2009 15:58:26 +0200
Message-ID: <20090423155832.scwpf66v0xwcsws0@webmail.hebergement.com>
Date: Thu, 23 Apr 2009 15:58:32 +0200
From: fpantaleao@mobisensesystems.com
To: judith.baumgarten@freenet.de
References: <E1Lwyls-000600-JS@www17.emo.freenet-rz.de>
In-Reply-To: <E1Lwyls-000600-JS@www17.emo.freenet-rz.de>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Re: setting values to CICR2 register in PXA320 Quick Capture
	Interface
Reply-To: fpantaleao@mobisensesystems.com
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

> Hi Florian,
>
> first: Thanks for your answer!
>
> Do you know, if actually somebody works at this point? I asked   
> google, but it didn't find a newer driver for a PXA-Camera.

Since XScale business was sold by Intel to Marvell, all XScale  
documentation access requires NDA which discourages open source  
development.
I think there are few chances to find open PXA3xx camera driver one day.

> I also had the chance to look at the Documentation of the PXA270,   
> and it isn't as detailed as the one for PXA320, but the register   
> also exists and has the same hardware address. So the "old" driver   
> would work for me so far, if there would be a way to set the register.

CICR2 is set to 0 for PXA27x, would be better to allow its  
initialization with platform_data.
 From userland, you can set it with /dev/mem but CI must be stopped  
first and then restarted: not the best way.

>
> regards
> Judith
>
> ----- original Nachricht --------
>
> Betreff: Re: setting values to CICR2 register in PXA320 Quick   
> Capture Interface
> Gesendet: Do 23 Apr 2009 09:40:51 CEST
> Von: "Florian PANTALEAO"<fpantaleao@mobisensesystems.com>
>
>>
>>
>> > Hi,
>> >
>> > I want to set various parameters in the Quick Capture Interface for a
>> PXA320 processor. I think, I found a way to do this, for resolution and
>> pixel clock parameters, but there is no way to set the parameters of CICR2
>> using the actual pxa_camera driver. It seems the driver  just implements
>> the
>> master mode, and I wondered why. Is it not usefull to run a pxa_camera in
>> slave mode?
>> >
>> > Nevertheless. CICR2 contains also the BLW (Beginning-of-Line Pixel Clock
>> Wait Count) parameter, which is used in master and slave mode. So I
>> wondered, why there isn't a way to set it (Or have I just missed it?).
>>
>> Quick Capture interface in PXA3xx has significantly evolved over PXA27x. I
>> remember a discussion in this list a couple of months ago about it.
>> Suggestion was to create a separate pxa3xx_camera driver because of these
>> differences.
>>
>> Florian
>>
>> > Here some extra information: I use V4L2 in combination with soc_camera
>> interface and a PXA320 host. The soc_camera interface and pxa_camera driver
>> are out of the 2.6.29 kernel.
>> >
>> > Thanks
>> > Judith
>> >
>> >
>> >
>> >
>> >
>> >
>> >
>> > #adBox3 {display:none;}
>> >
>> >
>> >
>> > --
>> > video4linux-list mailing list
>> > Unsubscribe
>> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>> > https://www.redhat.com/mailman/listinfo/video4linux-list
>>
>>
>
> --- original Nachricht Ende ----
>
>
>
>
> Ist Ihr wunschname@freenet.de noch frei?
> Jetzt prüfen und kostenlose E-Mail-Adresse sichern!
> http://email.freenet.de/dienste/emailoffice/produktuebersicht/basic/mail/index.html?pid=6829
>
>



----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
