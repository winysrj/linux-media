Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:48330 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab0GFRM5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Jul 2010 13:12:57 -0400
MIME-Version: 1.0
In-Reply-To: <1277118245.2230.17.camel@localhost>
References: <20100424211411.11570.2189.stgit@localhost.localdomain>
	<4BDF2B45.9060806@redhat.com>
	<20100607190003.GC19390@hardeman.nu>
	<20100607201530.GG16638@redhat.com>
	<20100608175017.GC5181@hardeman.nu>
	<AANLkTimuYkKzDPvtnrWKoT8sh1H9paPBQQNmYWOT7-R2@mail.gmail.com>
	<20100609132908.GM16638@redhat.com>
	<20100609175621.GA19620@hardeman.nu>
	<20100609181506.GO16638@redhat.com>
	<AANLkTims0dmYCOoI_K4S6Q8hwLV_MqUdGQjVwFu43sCL@mail.gmail.com>
	<20100613202945.GA5883@hardeman.nu>
	<AANLkTim6f6jM4TGzyQsuHDNPUSsjINXFHck0NevrtqHr@mail.gmail.com>
	<AANLkTil6P0rnmViLwpkiBOYoC6qF217V90g7Nslk3DHN@mail.gmail.com>
	<1276776859.2461.16.camel@localhost>
	<AANLkTinJPFBBDEiOpbFhkAccF5E7caKNmAuvEnq-uV4W@mail.gmail.com>
	<1277081276.2252.12.camel@localhost>
	<AANLkTikkSIk9XZiuF62YeCmGebrfy8SA9n3J5Agv8LjD@mail.gmail.com>
	<1277118245.2230.17.camel@localhost>
Date: Tue, 6 Jul 2010 13:12:55 -0400
Message-ID: <AANLkTinNTUfrR3Yl7E2i7etRkW6cJ_HMeoG7uTZ_zy5A@mail.gmail.com>
Subject: Re: [PATCH 3/4] ir-core: move decoding state to ir_raw_event_ctrl
From: Jarod Wilson <jarod@wilsonet.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	Jarod Wilson <jarod@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 21, 2010 at 7:04 AM, Andy Walls <awalls@md.metrocast.net> wrote:
> On Sun, 2010-06-20 at 23:51 -0400, Jarod Wilson wrote:
>> On Sun, Jun 20, 2010 at 8:47 PM, Andy Walls <awalls@md.metrocast.net> wrote:
>
>
>> As for the building your own kernel thing... I've been doing my work
>> mainly on a pair of x86_64 systems, one a ThinkPad T61 running Fedora
>> 13, and the other an HP xw4400 workstation running RHEL6. In both
>> cases, I copied a distro kernel's, config file out of /boot/, and then
>> ran make oldconfig over it and build straight from what's in my tree,
>> which works well enough on both setups.
>
> I pulled the config out of the kernel*.src.rpm after 'rpmbuild -bp' (I
> only saw the configs in /boot after doing that :P ), and then ran 'make
> oldconfig'.
>
> The first time around I forgot to do a modules_install and the ext[234]
> modules weren't in the initramfs.  That made it hard for the kernel to
> read the /boot and / filesystems. ;)
>
> After fixing that idiocy, it now hangs in early boot - just a blinking
> cursor.  I'm speculating it is a problem with support for my old-ish ATI
> Radeon Xpress 200 video chipset with a vanilla kernel.  I'll work it out
> eventually.

Seems you've already gotten around this, but it did remind me of
someone on one of the fedora mailing lists who said w/their older
radeon hardware, they could only boot recent kernels if the passed in
nomodeset=1 or something like that.

>> > I'll have time on Thursday night to try again.
>>
>> No rush yet, we've got a while before the merge window still.
>> Christoph (Bartelmus) helped me out with a bunch of ioctl
>> documentation this weekend, so I've got that to add to the tree, then
>> I think I'll be prepared to resubmit the lirc bits. I'll shoot for
>> doing that next weekend, and hopefully, that'll give you a chance to
>> try 'em out before then and provide any necessary feedback/fixes/etc.
>> (Not that we can't also just fix things up as needed post-merge). I'm
>> still up in the air as to what I should work on next... So many lirc
>> drivers left to port still... Maybe zilog, maybe streamzap... Maybe
>> the MCE IR keyboard...
>
> I've got a PVR-150 and HVR-1600 both with the Zilog Z8's on them.  If I
> ever get my act together, I'll at least be able to test that and
> integrate any changes into the ivtv & cx18 drivers.   I've recently seen
> users having trouble on IRC, BTW.

Yeah, me too. Hoping to dig into porting (and fixing) lirc_zilog RSN...

-- 
Jarod Wilson
jarod@wilsonet.com
