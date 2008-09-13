Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8DMKUKc012153
	for <video4linux-list@redhat.com>; Sat, 13 Sep 2008 18:20:30 -0400
Received: from speedy.tutby.com (mail.tut.by [195.137.160.40])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8DMKHb9001049
	for <video4linux-list@redhat.com>; Sat, 13 Sep 2008 18:20:17 -0400
From: "Igor M. Liplianin" <liplianin@tut.by>
To: Steven Toth <stoth@linuxtv.org>
Date: Sun, 14 Sep 2008 01:19:37 +0300
References: <E1KdnPr-0002YP-SF@www.linuxtv.org>
	<200809131623.10155.liplianin@tut.by>
	<48CC2512.2020502@linuxtv.org>
In-Reply-To: <48CC2512.2020502@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Disposition: inline
Message-Id: <200809140119.38052.liplianin@tut.by>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [linux-dvb]  [PATCH] Add support for SDMC DM1105 PCI chip
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

В сообщении от 13 September 2008 23:39:46 Steven Toth написал(а):
> Igor M. Liplianin wrote:
> > The patch adds support for SDMC DM1105 PCI chip. There is a lot of
> > cards based on it, like DvbWorld 2002 DVB-S , 2004 DVB-S2
> > Source code prepaired to and already tested with cards, which have
> > si2109, stv0288, cx24116 demods.  Currently enabled only stv0299, as
> > other demods are not in a v4l-dvb main tree, but I will submit
> > corresponded patches (si2109, stv0288) next time.
>
> Igor,
>
> Cool.
>
> Master repo does not have cx24116 support so it probably cannot be
> merged. Do you need me to merge this into the s2api tree?
>
Steve,

It would be great !
Patch is ready to s2api tree.

So I must prepair next patch, which enables DvbWorld 2004 DVB-S2.

Igor

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
