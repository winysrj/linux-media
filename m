Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:64772 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab2L2OZJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Dec 2012 09:25:09 -0500
Received: by mail-ie0-f169.google.com with SMTP id c14so13778329ieb.14
        for <linux-media@vger.kernel.org>; Sat, 29 Dec 2012 06:25:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALF0-+U_am2qBv=ifRgeocP_OehyRZCUpdfd+y1Uqnf7B7cKJQ@mail.gmail.com>
References: <CALF0-+U_am2qBv=ifRgeocP_OehyRZCUpdfd+y1Uqnf7B7cKJQ@mail.gmail.com>
Date: Sat, 29 Dec 2012 11:25:08 -0300
Message-ID: <CALF0-+W4azszmaMs9QVGt9GLcFq1=Nd_ZDcqi_OShXfRfo1f4Q@mail.gmail.com>
Subject: Re: saa711x doesn't match in easycap devices (stk1160 bridged)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ccing a few more people to get some feedback.

Toughts anyone? Have you ever seen this before?

On Fri, Dec 28, 2012 at 11:13 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> Hi everyone,
>
> Some stk1160 users (a lot acually) are reporting that stk1160 is broken.
> The reports come in the out of tree driver [1], but probably the issue
> is in mainline too.
>
> Now, it seems to me the problem is the saa711x decoder can't get matched,
> see a portion of dmesg.
>
> [89947.448813] usb 1-2.4: New device Syntek Semiconductor USB 2.0
> Video Capture Controller @ 480 Mbps (05e1:0408, interface 0, class 0)
> [89947.448827] usb 1-2.4: video interface 0 found
> [89948.200366] saa7115 21-0025: chip found @ 0x4a (ID 000000000000000)
> does not match a known saa711x chip.
> [89948.200555] stk1160: driver ver 0.9.3 successfully loaded
> [...]
>
> I'm working on this right now, but would like to know, given the ID
> seems to be NULL,
> what would be the right thing to do here.
> Perhaps, replacing the -ENODEV error by a just warning and keep going?
>
> Further debugging [2] shows the chip doesn't seem to have a proper
> chipid (as expected):
>
> [ 304.059917] stk1160_i2c_xfer: addr=4a
> [ 304.084238] OK
> [ 304.084483] stk1160_i2c_xfer: addr=4a
> [ 304.084498] subaddr=0 write=0
> [ 304.108254] OK
> [ 304.108276] stk1160_i2c_xfer: addr=4a
> [ 304.108286] subaddr=0
> [ 304.132367] read=10
> [ 304.132378] OK
> [ 304.132394] stk1160_i2c_xfer: addr=4a
> [ 304.132403] subaddr=0 write=1
> [ 304.156269] OK
> [ 304.156288] stk1160_i2c_xfer: addr=4a
> [ 304.156297] subaddr=0
> [ 304.180490] read=10
> [ 304.180500] OK
> [ 304.180514] stk1160_i2c_xfer: addr=4a
> [ 304.180523] subaddr=0 write=2
> [ 304.204249] OK
> [ 304.204268] stk1160_i2c_xfer: addr=4a
> [ 304.204276] subaddr=0
> [ 304.228365] read=10
> [ 304.228374] OK
> [ 304.228388] stk1160_i2c_xfer: addr=4a
> [ 304.228397] subaddr=0 write=3
> [ 304.252267] OK
> [ 304.252286] stk1160_i2c_xfer: addr=4a
> [ 304.252295] subaddr=0
> [ 304.276363] read=10
> [ 304.276372] OK
> [ 304.276386] stk1160_i2c_xfer: addr=4a
> [ 304.276395] subaddr=0 write=4
> [ 304.300248] OK
> [ 304.300266] stk1160_i2c_xfer: addr=4a
> [ 304.300275] subaddr=0
> [ 304.324363] read=10
> [ 304.324373] OK
> [ 304.324386] stk1160_i2c_xfer: addr=4a
> [ 304.324394] subaddr=0 write=5
> [ 304.348250] OK
> [ 304.348268] stk1160_i2c_xfer: addr=4a
> [ 304.348277] subaddr=0
> [ 304.372364] read=10
> [ 304.372374] OK
> [ 304.372387] stk1160_i2c_xfer: addr=4a
> [ 304.372396] subaddr=0 write=6
> [ 304.396250] OK
> [ 304.396266] stk1160_i2c_xfer: addr=4a
> [ 304.396275] subaddr=0
> [ 304.420363] read=10
> [ 304.420372] OK
> [ 304.420386] stk1160_i2c_xfer: addr=4a
> [ 304.420395] subaddr=0 write=7
> [ 304.444253] OK
> [ 304.444274] stk1160_i2c_xfer: addr=4a
> [ 304.444283] subaddr=0
> [ 304.468364] read=10
> [ 304.468374] OK
> [ 304.468389] stk1160_i2c_xfer: addr=4a
> [ 304.468398] subaddr=0 write=8
> [ 304.492248] OK
> [ 304.492266] stk1160_i2c_xfer: addr=4a
> [ 304.492275] subaddr=0
> [ 304.516360] read=10
> [ 304.516370] OK
> [ 304.516384] stk1160_i2c_xfer: addr=4a
> [ 304.516392] subaddr=0 write=9
> [ 304.540248] OK
> [ 304.540278] stk1160_i2c_xfer: addr=4a
> [ 304.540291] subaddr=0
> [ 304.564638] read=10
> [ 304.564653] OK
> [ 304.564675] stk1160_i2c_xfer: addr=4a
> [ 304.564687] subaddr=0 write=a
> [ 304.565874] OK
> [ 304.565895] stk1160_i2c_xfer: addr=4a
> [ 304.565904] subaddr=0
> [ 304.588370] read=10
> [ 304.588376] OK
> [ 304.588386] stk1160_i2c_xfer: addr=4a
> [ 304.588390] subaddr=0 write=b
> [ 304.612222] OK
> [ 304.612241] stk1160_i2c_xfer: addr=4a
> [ 304.612249] subaddr=0
> [ 304.636369] read=10
> [ 304.636380] OK
> [ 304.636396] stk1160_i2c_xfer: addr=4a
> [ 304.636405] subaddr=0 write=c
> [ 304.660268] OK
> [ 304.660288] stk1160_i2c_xfer: addr=4a
> [ 304.660297] subaddr=0
> [ 304.684364] read=10
> [ 304.684374] OK
> [ 304.684388] stk1160_i2c_xfer: addr=4a
> [ 304.684396] subaddr=0 write=d
> [ 304.708249] OK
> [ 304.708267] stk1160_i2c_xfer: addr=4a
> [ 304.708276] subaddr=0
> [ 304.732366] read=10
> [ 304.732375] OK
> [ 304.732389] stk1160_i2c_xfer: addr=4a
> [ 304.732398] subaddr=0 write=e
> [ 304.756251] OK
> [ 304.756270] stk1160_i2c_xfer: addr=4a
> [ 304.756279] subaddr=0
> [ 304.780365] read=10
>
> --
>     Ezequiel
>
> [1] https://github.com/ezequielgarcia/stk1160-standalone/issues/14
> [2] https://github.com/ezequielgarcia/stk1160-standalone/issues/14#issuecomment-11732376



-- 
    Ezequiel
