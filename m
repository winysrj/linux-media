Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx07.extmail.prod.ext.phx2.redhat.com
	[10.5.110.11])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n8EITIR6012088
	for <video4linux-list@redhat.com>; Mon, 14 Sep 2009 14:29:18 -0400
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8EIT17P029125
	for <video4linux-list@redhat.com>; Mon, 14 Sep 2009 14:29:05 -0400
Date: Mon, 14 Sep 2009 20:28:55 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Niamathullah sharief <newbiesha@gmail.com>
Message-ID: <20090914202855.61b5e8ea@tele>
In-Reply-To: <25f5fcff0909141100m49db178cu178801a4d4fd5976@mail.gmail.com>
References: <25f5fcff0909110020m56f881d0q383aae1f5226476@mail.gmail.com>
	<b89eadb20909110234v2b8ee579nc19eed163cc77463@mail.gmail.com>
	<25f5fcff0909110507y635aa97eg1d599710372a6e9e@mail.gmail.com>
	<20090912082426.2dfba603@tele>
	<25f5fcff0909141100m49db178cu178801a4d4fd5976@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: kernelnewbies@nl.linux.org, video4linux-list@redhat.com
Subject: Re: About Webcam module
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

On Mon, 14 Sep 2009 23:30:27 +0530
Niamathullah sharief <newbiesha@gmail.com> wrote:

> Here i am facing a new problem. I tried to compile and install the
> gspca_main and gspca_zc3xx modules separately. I compiled them
> successfully. but i am getting error when inserting that modules
> 
> 
> root@sharief-desktop:/home/sharief/Desktop/video/gspca# insmod
> > gspca_zc3xx.ko
> >
> insmod: error inserting 'gspca_zc3xx.ko': -1 Unknown symbol in module
> >
> root@sharief-desktop:/home/sharief/Desktop/video/gspca# insmod
> gspca_main.ko
> >
> >
> insmod: error inserting 'gspca_main.ko': -1 Unknown symbol in module
> >
> 
> I think this both modules what some other modules to get insert in to
> kernel...But i am sure about that modules. Can anyone help me?

Indeed, the 2 modules videodev and v4l1_compat must be loaded prior to
load first gspca_main and then gspca_zc3xx, as shown by lsmod (below).

Usually, insmod is not directly used. You must use modprobe which looks
at the symbols and loads the required modules.

> On Sat, Sep 12, 2009 at 11:54 AM, Jean-Francois Moine
> <moinejf@free.fr>wrote:
> > 
> > So, your driver is gspca_zc3xx. Then, this module uses the gspca
> > framework, i.e it calls functions of the module gspca_main. This
> > last one calls functions of the common video module videodev. Then
> > again, if v4l1 compatibility is enabled, videodev calls functions
> > of v4l1_compat.
> >
> > lsmod shows all that directly:
> >
> > Module              Size   Used by
> > gspca_zc3xx        55936   0
> > gspca_main         29312   1   gspca_zc3xx
> > videodev           41344   1   gspca_main
> > v4l1_compat        22404   1   videodev


-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
