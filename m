Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7F65nDL030590
	for <video4linux-list@redhat.com>; Fri, 15 Aug 2008 02:05:49 -0400
Received: from smtp-vbr12.xs4all.nl (smtp-vbr12.xs4all.nl [194.109.24.32])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7F65ZuA008997
	for <video4linux-list@redhat.com>; Fri, 15 Aug 2008 02:05:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Fri, 15 Aug 2008 08:05:20 +0200
References: <20080814093320.49265ec1@glory.loctelecom.ru>
	<48A4763D.8030509@hccnet.nl>
	<20080815115954.0be6c5ba@glory.loctelecom.ru>
In-Reply-To: <20080815115954.0be6c5ba@glory.loctelecom.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808150805.20459.hverkuil@xs4all.nl>
Cc: Mauro@xs4all.nl, Gert Vervoort <gert.vervoort@hccnet.nl>,
	Chehab <mchehab@infradead.org>
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

On Friday 15 August 2008 03:59:54 Dmitri Belimov wrote:
> Hi All
>
> I found problem in v4l2-ctl. This programm can't set correct TV norm.
> After my hack TV norm was set correct.

???

$ v4l2-ctl -s secam-dk
Standard set to 00320000

v4l2-ctl works fine for me!

Are you using the latest v4l2-ctl version from v4l-dvb? I did fix a bug 
in SetStandard some time ago (although I think that bug didn't affect 
this particular situation either).

Regards,

	Hans

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
>
> --
> video4linux-list mailing list
> Unsubscribe
> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
