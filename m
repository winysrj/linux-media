Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m431wnkZ015666
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 21:58:49 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.238])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m431wFpf012536
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 21:58:15 -0400
Received: by rv-out-0506.google.com with SMTP id f6so267273rvb.51
	for <video4linux-list@redhat.com>; Fri, 02 May 2008 18:58:14 -0700 (PDT)
Message-ID: <e686f5060805021858x65d13891je32a0791ec893ae4@mail.gmail.com>
Date: Fri, 2 May 2008 21:58:13 -0400
From: "Brandon Jenkins" <bcjenkins@gmail.com>
To: video4linux-list@redhat.com, ivtv-users@ivtvdriver.org
In-Reply-To: <37219a840805021206r4f409269j1d2a6df260af8ca0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e686f5060805021035w1f804d9eifde9c7837737e618@mail.gmail.com>
	<1209754601.3269.30.camel@palomino.walls.org>
	<37219a840805021206r4f409269j1d2a6df260af8ca0@mail.gmail.com>
Cc: 
Subject: Re: Trouble with drivers for CX18, CX23885, IVTV
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

On Fri, May 2, 2008 at 3:06 PM, Michael Krufky <mkrufky@linuxtv.org> wrote:
> On Fri, May 2, 2008 at 2:56 PM, Andy Walls <awalls@radix.net> wrote:
>  >
>  > On Fri, 2008-05-02 at 13:35 -0400, Brandon Jenkins wrote:
>  >  > Greetings,
>  >  >
>  >  > When the CX18 merge to the V4L tree happened, I began pulling the
>  >  > source from the v4l mercurial. Everything compiles correctly, but upon
>  >  > reboot the only driver which loads for me is cx88 all others fail
>  >  > with:
>  >  >
>  >  > [    8.554593] videobuf_dvb: disagrees about version of symbol
>  >  > videobuf_read_stop
>
>  You are using an Ubuntu Hardy Heron kernel -- This is Ubuntu's fault,
>  not the drivers.
>
>  Please see accurate problem description AND workaround solution here:
>
>  https://bugs.launchpad.net/ubuntu/+source/linux-ubuntu-modules-2.6.24/+bug/220857
>
>  -Mike
>

Andy and Mike,

Thanks for the replies. As I indicated in my original submission I am
not using the ubuntu sources/kernel.

I actually use the sources from kernel.org. The problem actually
turned out to be that I wasn't compiling in support for SND and SOUND
in my main kernel config because all playback of media recorded
happens on other devices.

When I was using the driver source from
http://linuxtv.org/hg/~hverkuil/cx18 this wasn't an issue for some
reason. Once it merged to the http://linuxtv.org/hg/v4l-dvb/ tree it
became broken for me. I don't know why, but it is working now.

Thanks for the responses, the link to the other site had me look into
my source config.

Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
