Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f204.google.com ([209.85.216.204]:40257 "EHLO
	mail-px0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255AbZKHW6x (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Nov 2009 17:58:53 -0500
Received: by pxi42 with SMTP id 42so1735057pxi.5
        for <linux-media@vger.kernel.org>; Sun, 08 Nov 2009 14:58:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <829197380911071840l41fbaa8et58641ea99ad79b94@mail.gmail.com>
References: <20764.64.213.30.2.1257390002.squirrel@webmail.exetel.com.au>
	 <25126.64.213.30.2.1257464759.squirrel@webmail.exetel.com.au>
	 <829197380911051551q3b844c5ek490a5eb7c96783e9@mail.gmail.com>
	 <39786.64.213.30.2.1257466403.squirrel@webmail.exetel.com.au>
	 <40380.64.213.30.2.1257474692.squirrel@webmail.exetel.com.au>
	 <829197380911051843r4a55bddcje8c014f5548ca247@mail.gmail.com>
	 <702870ef0911061659q208b73c3te7d62f5a220e9499@mail.gmail.com>
	 <829197380911061743o64c4661gfdee5c65f680904e@mail.gmail.com>
	 <702870ef0911070328v4d39afd9kc2469fb3e78ba203@mail.gmail.com>
	 <829197380911071840l41fbaa8et58641ea99ad79b94@mail.gmail.com>
Date: Mon, 9 Nov 2009 09:51:33 +1100
Message-ID: <702870ef0911081451l285a635bn54cafee3528f5b91@mail.gmail.com>
Subject: Re: bisected regression in tuner-xc2028 on DVICO dual digital 4
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Robert Lowery <rglowery@exemail.com.au>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/8/09, Devin Heitmueller <dheitmueller@kernellabs.com> wrote:

> I think the next step at this point is for you to definitively find a
> use case that does not work with the latest v4l-dvb tip and Robert's
> patch, and include exactly what kernel you tested with and which board
> is having the problem (including the PCI or USB ID).
>
> At this point, your description seems a bit vague in terms of what is
> working and what is not.  If you do the additional testing to narrow
> down specifically the failure case you are experiencing, I will see
> what I can do.

I'm trying to be as clear as I can.

We can forget about setups 1 and 2, they no longer have the messages
from the cxusb module that I originally reported, I can tune and run
signal level tests like [1].

I'm now looking at setup 3.
 os: ubuntu karmic i386
 kernel: 2.6.31-14-generic
 v4l modules: hg identify returns "19c0469c02c3+ tip"

 If I cold boot, I see no tuning issues at the kernel level. Details
of the test below.

 The failure I was attempting to report is that
 I am unable to tune with dvbscan or w_scan.
 I think it is due to changes in the V4L API with respect to the versions
 of these programs I have installed.

 However I am able to tune with 'tzap'. I'm not entirely sure why tzap works,
 but it does and it shows the v4l tip drivers are ok regarding the
issue originally
 reported.

 There are two further areas I am looking into.
 1. If I *warm* boot the same setup, I see "dvb-usb: bulk message failed:"
     in dmesg.
     I am working on this still to try to get a clear report for you of when
     and on which device it occurs. It will probably take me a week to get
     back to you.
 2. There may be differences in performance, in that:
     2.6.31-14-generic+v4l+Rob shows worse Bit Error Rates than
     2.6.31-14-generic+Rob
     Again I have some work to do to clarify this.
     It seems likely it is a separate issue from this thread.

> That said, I'm preparing a tree with Robert's patch since I am pretty
> confident at least his particular problem is now addressed.

I can see no obstacle to you going ahead with that. Thanks again.

Cheers
Vince

Test details:
 I tune like this:
   sudo strace -t -ff -F -o tzap.strace /usr/bin/tzap -a 0 -r -c
channels.conf "7 Digital(Seven Network)"

 In dmesg I see the firmware being loaded but no other messages:
   [ 1232.684884] usb 3-1: firmware: requesting xc3028-v27.fw
   [ 1232.743698] xc2028 1-0061: Loading 80 firmware images from
xc3028-v27.fw, type: xc2028 firmware, ver 2.7
   [ 1232.756391] xc2028 1-0061: Loading firmware for type=BASE F8MHZ
(3), id 0000000000000000.
   [ 1237.332511] xc2028 1-0061: Loading firmware for type=D2633 DTV7
(90), id 0000000000000000.
   [ 1237.416510] xc2028 1-0061: Loading SCODE for type=SCODE
HAS_IF_5260 (60000000), id 0000000000000000.

 I can successfully tune each of the 4 tuners in this way. Each time I
run tzap on
 a tuner I've not used before, dmesg shows the firmware loading ok.


[1] http://linuxtv.org/wiki/index.php/Testing_reception_quality
