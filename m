Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7F2QhvJ017236
	for <video4linux-list@redhat.com>; Thu, 14 Aug 2008 22:26:43 -0400
Received: from mail-in-16.arcor-online.net (mail-in-16.arcor-online.net
	[151.189.21.56])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7F2QSV9009892
	for <video4linux-list@redhat.com>; Thu, 14 Aug 2008 22:26:28 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Dmitri Belimov <d.belimov@gmail.com>
In-Reply-To: <20080815115954.0be6c5ba@glory.loctelecom.ru>
References: <20080814093320.49265ec1@glory.loctelecom.ru>
	<48A4763D.8030509@hccnet.nl>
	<20080815115954.0be6c5ba@glory.loctelecom.ru>
Content-Type: text/plain
Date: Fri, 15 Aug 2008 04:18:41 +0200
Message-Id: <1218766721.2669.15.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Gert Vervoort <gert.vervoort@hccnet.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: MPEG stream work
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


Am Freitag, den 15.08.2008, 11:59 +1000 schrieb Dmitri Belimov:
> Hi All
> 
> I found problem in v4l2-ctl. This programm can't set correct TV norm. After my hack TV norm was set correct.
> 
> diff -r 42e3970c09aa v4l2-apps/util/v4l2-ctl.cpp
> --- a/v4l2-apps/util/v4l2-ctl.cpp	Sun Jul 27 19:30:46 2008 -0300
> +++ b/v4l2-apps/util/v4l2-ctl.cpp	Fri Aug 15 05:53:38 2008 +1000
> @@ -1572,6 +1572,7 @@
>  	}
>  
>  	if (options[OptSetStandard]) {
> +	  std = 0x320000; // durty hack for SECAM-DK
>  		if (std & (1ULL << 63)) {
>  			vs.index = std & 0xffff;
>  			if (ioctl(fd, VIDIOC_ENUMSTD, &vs) >= 0) {
> 
> I have MPEG stream with CORRECT TV data.
> See link:
> 
> http://debian.oshec.org/binary/tmp/mpeg02.dat
> 
> Yahooooo!
> 
> With my best regards, Dmitry.

Hi Dimitry,

looks fine!

Thanks for all your efforts and excuse to have been thrown in such a
real cruel mess, totally undocumented..

Thanks again, for not giving up!

Cheers,
Hermann




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
