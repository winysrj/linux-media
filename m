Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx09.extmail.prod.ext.phx2.redhat.com
	[10.5.110.13])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nAN2WDC2028885
	for <video4linux-list@redhat.com>; Sun, 22 Nov 2009 21:32:13 -0500
Received: from mail-in-11.arcor-online.net (mail-in-11.arcor-online.net
	[151.189.21.51])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nAN2VxwV010025
	for <video4linux-list@redhat.com>; Sun, 22 Nov 2009 21:32:00 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Terry Wu <terrywu2009@gmail.com>
In-Reply-To: <6ab2c27e0911221742g739380d1m10b517d25f451898@mail.gmail.com>
References: <19415111.1258842824951.JavaMail.ngmail@webmail09.arcor-online.net>
	<6ab2c27e0911220451y1777caaelc54dd9e70b974bac@mail.gmail.com>
	<1258929022.7524.6.camel@pc07.localdom.local>
	<6ab2c27e0911221723v5479a179kbe42a67ebb53a797@mail.gmail.com>
	<6ab2c27e0911221742g739380d1m10b517d25f451898@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 23 Nov 2009 03:30:27 +0100
Message-Id: <1258943427.3257.28.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Re: Leadtek Winfast TV2100
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

Hi, thanks again!

Am Montag, den 23.11.2009, 09:42 +0800 schrieb Terry Wu:
> Hi,
> 
>     Please refer to the attached JPEG file for the GPIO settings of
> TV2100 with FM (PCB:B).
> 
>     Let me know if you need the information of TV2100 without FM
> (PCB:A, TVF8533-BDF).
> 
> Terry Wu

On a first look, if we start to count gpios from zero, we tell the same.

The TVF8533_BDF I would have to look up. It is four to five years back.

If it uses that minor number TI chip without radio support, we treat it
as tuner=69 too currently.

For all such older can tuners, widely different about the globe, counts,
that we don't have any way to detect them. So first working, either NTSC
or PAL, sits in the pool position and others have to think twice.

OEMs do code tuners into eeprom content, some do not at all, such doing
it are in competition and don't follow the rules of the main chip
manufacturer, Philips/NXP in that case, and go their own ways.

So tuner tables are unstable across manufacturers.

We often can't help that much in such cases, but implementing their own
tuner eeprom detection into the linux drivers is of course still
welcome. Hauppauge does it very successfully since years.

We can't do much about it, if OEMs don't follow Philips or whom ever on
such.

Thanks,
Hermann


> 
> 2009/11/23 Terry Wu <terrywu2009@gmail.com>:
> > Hi,
> >
> >    The TVF88T5-BDFF data sheet is attached.
> >
> > Terry Wu
> >
> > 11/17/2003  06:39 PM            72,010 TVF5531-MF.pdf
> > 03/12/2008  11:37 AM           555,285 TVF5533-MF-.pdf
> > 02/24/2004  02:19 PM           120,727 TVF5533-MF.pdf
> > 12/30/2003  06:59 PM            91,577 TVF5831-MFF.pdf
> > 09/26/2005  10:20 AM           156,853 TVF78P3-MFF.pdf
> > 11/17/2003  06:39 PM            67,947 TVF8531-BDF.pdf
> > 11/17/2003  06:39 PM            67,715 TVF8531-DIF.pdf
> > 03/12/2008  11:37 AM           509,340 TVF8533-BDF.pdf
> > 03/12/2008  11:37 AM           507,295 TVF8533-DIF.pdf
> > 12/30/2003  06:59 PM            87,921 TVF8831-BDFF.pdf
> > 12/30/2003  06:59 PM            87,624 TVF8831-DIFF.pdf
> > 09/26/2005  10:20 AM           176,525 TVF88P3-CFF.pdf
> > 03/24/2006  10:48 AM           460,941 TVF88T5-BDFF.pdf
> > 02/24/2004  02:19 PM           132,304 TVF9533-BDF.pdf
> > 02/24/2004  02:19 PM           120,940 TVF9533-DIF.pdf
> > 03/12/2008  11:37 AM           458,967 TVF99T5-BDFF.pdf
> >


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
