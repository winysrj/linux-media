Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx03.extmail.prod.ext.phx2.redhat.com
	[10.5.110.7])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n9K0JBOF024670
	for <video4linux-list@redhat.com>; Mon, 19 Oct 2009 20:19:11 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n9K0It2X022627
	for <video4linux-list@redhat.com>; Mon, 19 Oct 2009 20:18:55 -0400
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 20 Oct 2009 02:18:54 +0200
From: "Oleksandr Naumenko" <o.naumenko@gmx.de>
In-Reply-To: <20091019235613.7680@gmx.net>
Message-ID: <20091020001854.7690@gmx.net>
MIME-Version: 1.0
References: <20091019235613.7680@gmx.net>
To: video4linux-list@redhat.com
Content-Transfer-Encoding: 7bit
Subject: Re: AverTV GO 007 FM Plus
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


-------- Original-Nachricht --------
> Datum: Tue, 20 Oct 2009 01:56:13 +0200
> Von: "Oleksandr Naumenko" <o.naumenko@gmx.de>
> An: video4linux-list@redhat.com
> Betreff: AverTV GO 007 FM Plus

> Hello,
> 
> I recently installed Linux and am currently trying to make my tv tunner
> (AverTV GO 007 FM Plus) work. Had real problems with autodetection so i just
> did as discribed on
> http://www.ubuntuhcl.org/browse/product+AVerMedia_AVerTV_GO_007_FM_Plus_M15C?id=804
> 
> but i still don't have sound even tho i can see video now.
> 
> If i use "cat /dev/dsp1 | aplay -r 32000" I can hear sound, but its like
> compressed and totaly not understandable.
> 
> I tried to do as postet in 
> http://www.archivum.info/video4linux-list@redhat.com/2005-03/00107/Re:_Philips_SILICON_tuner_starts_working_-_was_-_Re:_asus_tvfm-7135
> 
> but if i try to apply the patch, i'm asked which file i want to patch...
> the problem is i have no clue which one it should be. Maybe someone could
> give me a small (a big one is very welcome as well) hint which file it is
> or what to do.
> -- 
list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list


Oops sorry i got the second url wrong its the 
http://www.archivum.info/video4linux-list@redhat.com/2005-03/00184/Re:_AverTv_GO_007_Fm_plus_-_saa7131e_+_tda8275

and not the one about Silicon tunner

and when i try "cat /dev/dsp1 | aplay -r 32000"
i get the output "Pufferunterlauf!!! (mindestens 509,198 ms lang)" (for the ones who don't understand german its some kind of buffering error min. for 509.198 in this case)


-- 
Jetzt kostenlos herunterladen: Internet Explorer 8 und Mozilla Firefox 3.5 -
sicherer, schneller und einfacher! http://portal.gmx.net/de/go/atbrowser

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
