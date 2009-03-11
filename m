Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2BBJj3k029049
	for <video4linux-list@redhat.com>; Wed, 11 Mar 2009 07:19:45 -0400
Received: from mail-ew0-f179.google.com (mail-ew0-f179.google.com
	[209.85.219.179])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n2BBJLNb017823
	for <video4linux-list@redhat.com>; Wed, 11 Mar 2009 07:19:21 -0400
Received: by ewy27 with SMTP id 27so1554820ewy.3
	for <video4linux-list@redhat.com>; Wed, 11 Mar 2009 04:19:21 -0700 (PDT)
Date: Wed, 11 Mar 2009 12:18:53 +0100
From: Domenico Andreoli <cavokz@gmail.com>
To: =?iso-8859-1?Q?Mar=EDn_Carre=F1o=2C?= David <dmarin@sice.com>
Message-ID: <20090311111853.GA13357@tilt.dandreoli.com>
References: <8F6D811624318142856E608CDFA656FC0210F3F8@sic_alc_107>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8F6D811624318142856E608CDFA656FC0210F3F8@sic_alc_107>
Cc: video4linux-list@redhat.com
Subject: Re: BTTV-gpio driver for user-space access
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

On Wed, Mar 11, 2009 at 10:33:14AM +0100, "Marín Carreño, David" wrote:
> Hello.

Hi,

> Has anyone source code of a driver for accessing bt878 gpios from userspace?

nothing i have pushed anywhere. i was also learning how to use gpiolib. i
must have it somewhere... it has some defects and must be used with
care on many cards, i guess. it was a very simple application of gpiolib
on bttv-gpiolib.c.

> Specifically I want to access GPIO pins of a IVC-100G video card. And before
> developing it from scratch, I'd like to know if anyone has already done it.

i successfully used it to move pins on my IVC-200G :)

i will send it as soon as i find it.

cheers,
Domenico

-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
