Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m612g909031253
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 22:42:09 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.229])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m612fqNb012569
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 22:41:53 -0400
Received: by rv-out-0506.google.com with SMTP id f6so1941187rvb.51
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 19:41:52 -0700 (PDT)
From: Paul Kelly <pksings@gmail.com>
To: frtzkatz@yahoo.com
In-Reply-To: <642127.1103.qm@web63003.mail.re1.yahoo.com>
References: <642127.1103.qm@web63003.mail.re1.yahoo.com>
Content-Type: text/plain
Date: Mon, 30 Jun 2008 19:41:49 -0700
Message-Id: <1214880109.12218.5.camel@phred.pksings.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
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

Thank you for your help. Unfortunately I had already found this one and
tried it. It was very helpful in getting the card to work even though it
was written to support completely different hardware, USB tuner along
with a PCI tuner on a card.  The Dual express does NOT have a USB tuner,
it's actually two separate identical conexant chips on the board only
one of which the linux driver recognizes. Also the Dual Express does not
use the "bluebird" firmware referred to in that howto, that is strictly
for the USB tuner apparently and since it doesn't have one it ignores
it. I actually had to find and download different firmware that it
requested. Using that firmware I can view and record all of the
unencrypted HD cable channels that are available to me. However, I
cannot tune any non-HD content at all.

Thanks again, it's much appreciated.

PK

On Mon, 2008-06-30 at 15:02 -0700, Fritz Katz wrote:
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
> 
> Reviewers using Windoze at NewEgg gave it bad reviews. But maybe it works better for Linux-TV?  What's your experience?
> 
> I'm looking for a card that does analog PAL/NTSC/SECAM -- that also works for Linux-TV.
> 
> Regards,
> -- Fritz Katz
> frtzkatz (at) yahoo.com
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
>       

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
