Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m610laPj018414
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 20:47:36 -0400
Received: from mail-in-10.arcor-online.net (mail-in-10.arcor-online.net
	[151.189.21.50])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m610l1AB031729
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 20:47:01 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: frtzkatz@yahoo.com
In-Reply-To: <642127.1103.qm@web63003.mail.re1.yahoo.com>
References: <642127.1103.qm@web63003.mail.re1.yahoo.com>
Content-Type: text/plain
Date: Tue, 01 Jul 2008 02:44:22 +0200
Message-Id: <1214873062.2623.51.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, pksings@gmail.com
Subject: Re: DVICO dual express second tuner?
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

Hi,

Am Montag, den 30.06.2008, 15:02 -0700 schrieb Fritz Katz:
> "Paul Kelly" wrote Monday, June 30, 2008: 
> >  
> >  I got the latest tree and firmware and successfully 
> >  brought up a new DVICO dual express and can tune HD cable.
> >  
> >  According to the marketing fluff this card has two 
> >  tuners and can tune either two digital HD streams or one 
> >  analog and one HD stream. 
> >  
> >  Can anyone give me any idea how to make it do that? 
> >  Mythtv only identifies tuner 0. 
> >  
> >  Any information needed will happily be supplied, 
> >  please ask.
> >  
> >  Thanks in advance
> >  
> >  PK
> _________________________
> 
> Hello Paul Kelly,
> 
>   I don't own one myself, but I can point you in the direction of the HCL (Linux Hardware Compatability List):
> 
> http://www.linuxquestions.org/hcl/showproduct.php/product/4012/cat/196
> 
>   Maybe info here can help you getting the second tuner working:
> http://www.mythtv.org/wiki/index.php/DViCO_FusionHDTV_DVB-T_Dual_Digital_Installation
> 
> > The "DViCO FusionHDTV DVB-T Dual Tuner" card has two tuners. 
> > One is PCI, the other is USB. You will either need to connect 
> > an external USB cable to your card, or use the supplied internal 
> > USB cable which connects to your motherboard. This will enable 
> > the second tuner and is needed for the remote to function.
> 
> Let me know how it works out.
> 
> -----------------------
> Everyone,
> 
> I'm considering getting this el-cheapo card that isn't on the HCL list :
> 
> "Sabrent Philips7130 PCI TV Tuner/Video Capture Card"
> http://www.geeks.com/details.asp?invtid=TV-PCIRC&cat=VID

oh my, this is a historical document.

Are those warnings already valid for all over the US or in California
only?

> 
> Reviewers using Windoze at NewEgg gave it bad reviews. But maybe it works better for Linux-TV?  What's your experience?

It will have US and/or European chips taking most of the remaining
possible profit. But not the newest ones ...

> I'm looking for a card that does analog PAL/NTSC/SECAM -- that also works for Linux-TV.

If you have a good analog cable-tv signal, you might try.
The tuner will do only NTSC and the TV sound is MONO only.

For other inputs are no known restrictions, except you will have to use
the analog audio loop through to the sound card on that saa7130.
No analog to digital audio converters on it.

Cheers,
Hermann

> 
> Regards,
> -- Fritz Katz
> frtzkatz (at) yahoo.com


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
