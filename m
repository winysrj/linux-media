Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3H8VovB029668
	for <video4linux-list@redhat.com>; Thu, 17 Apr 2008 04:31:50 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3H8V2Lr017145
	for <video4linux-list@redhat.com>; Thu, 17 Apr 2008 04:31:18 -0400
Received: by wf-out-1314.google.com with SMTP id 28so2758933wfc.6
	for <video4linux-list@redhat.com>; Thu, 17 Apr 2008 01:30:51 -0700 (PDT)
Message-ID: <1dea8a6d0804170130v55718384m2f6ffea5620b8075@mail.gmail.com>
Date: Thu, 17 Apr 2008 16:30:51 +0800
From: "Ben Caldwell" <benny.caldwell@gmail.com>
To: stuart <stuart.partridge@gmail.com>
In-Reply-To: <3a4a99ca0804170008x45657b06t40021faf073f0f38@mail.gmail.com>
MIME-Version: 1.0
References: <3a4a99ca0804162333p1d08e308ufea59a2cd40edd19@mail.gmail.com>
	<1dea8a6d0804162349n271b028bgf2b709d7bb19efa1@mail.gmail.com>
	<3a4a99ca0804170008x45657b06t40021faf073f0f38@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: video4linux-list@redhat.com
Subject: Re: Fusion/DVICO HDTV Dual 4 not working and crashing lsusb
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

On Thu, Apr 17, 2008 at 3:08 PM, stuart <stuart.partridge@gmail.com> wrote:

> Thanks for that. Progress made: the 'hg update' went well but I ran into
> errors during 'make', specifally:
>
> *
> In file included from /home/stuart/v4l-dvb/v4l/zoran_procfs.c:50:
> /home/stuart/v4l-dvb/v4l/zoran.h:276: error: redefinition of 'struct
> v4l2_jpegcompression'
> make[3]: *** [/home/stuart/v4l-dvb/v4l/zoran_procfs.o] Error 1
> make[2]: *** [_module_/home/stuart/v4l-dvb/v4l] Error 2
> make[2]: Leaving directory `/usr/src/linux-headers-2.6.22-14-generic'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/home/stuart/v4l-dvb/v4l'
> make: *** [all] Error 2
> *
>
Did you 'make clean' and 'make release' before 'make'?

- Ben
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
