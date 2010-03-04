Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx04.extmail.prod.ext.phx2.redhat.com
	[10.5.110.8])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o24JgglJ008509
	for <video4linux-list@redhat.com>; Thu, 4 Mar 2010 14:42:42 -0500
Received: from mail-fx0-f218.google.com (mail-fx0-f218.google.com
	[209.85.220.218])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o24JgTPJ021224
	for <video4linux-list@redhat.com>; Thu, 4 Mar 2010 14:42:30 -0500
Received: by fxm10 with SMTP id 10so990111fxm.30
	for <video4linux-list@redhat.com>; Thu, 04 Mar 2010 11:42:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1267702141.5175.15.camel@chimpin>
References: <1267621938.3066.46.camel@chimpin>
	<829197381003030656q6b5cf73eybcf30b713ba9be37@mail.gmail.com>
	<1267702141.5175.15.camel@chimpin>
Date: Thu, 4 Mar 2010 14:42:28 -0500
Message-ID: <829197381003041142n2af48730q8d73a0c985be22ba@mail.gmail.com>
Subject: Re: em28xx v4l-info returns gibberish on igepv2
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: John Banks <john.banks@noonanmedia.com>
Cc: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi John,

On Thu, Mar 4, 2010 at 6:29 AM, John Banks <john.banks@noonanmedia.com> wrote:
> As you can see I get the correct output. I think it has to do with the
> size of variables created in struct-v4l2.c as they don't match the
> declaration in videodev2.h
>
> Anyway this doesn't help to explain why I get the 0000's seen in the
> hexdump of the file. I had been hoping that it was incorrectly reading
> the variables it needed in order for it to create the output correctly.
>
> I was originally using the gstreamer v4l2src module that was in the
> repositories but I tried compiling the gstreamer provided by TI (it
> contains extra plugins for use on the dsp) but the same problem
> occurred.
>
> If I want to further track down this problem, where should I look?

At this point, your best bet would probably to be to build v4l-info
program from source and add some debugging (for example, dumping out
the sizes of some of the structs).  If you can reproduce it, then
nailing down the issue is just a matter of iterative debugging.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
