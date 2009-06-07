Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:3385 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbZFGNiI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Jun 2009 09:38:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jon Smirl <jonsmirl@gmail.com>
Subject: Re: RFC: proposal for new i2c.h macro to initialize i2c address lists  on the fly
Date: Sun, 7 Jun 2009 15:38:07 +0200
Cc: linux-i2c@vger.kernel.org, linux-media@vger.kernel.org
References: <200906061500.49338.hverkuil@xs4all.nl> <9e4733910906070625i74477c9ma422b061eb61449d@mail.gmail.com> <9e4733910906070630i1ffcb821xb912f5ea662c7bef@mail.gmail.com>
In-Reply-To: <9e4733910906070630i1ffcb821xb912f5ea662c7bef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906071538.07268.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 07 June 2009 15:30:50 Jon Smirl wrote:
> On Sun, Jun 7, 2009 at 9:25 AM, Jon Smirl<jonsmirl@gmail.com> wrote:
> > On Sun, Jun 7, 2009 at 2:35 AM, Hans Verkuil<hverkuil@xs4all.nl> wrote:
> >> On Sunday 07 June 2009 00:20:26 Jon Smirl wrote:
> >>> On Sat, Jun 6, 2009 at 9:00 AM, Hans Verkuil<hverkuil@xs4all.nl> 
wrote:
> >>> > Hi all,
> >>> >
> >>> > For video4linux we sometimes need to probe for a single i2c
> >>> > address. Normally you would do it like this:
> >>>
> >>> Why does video4linux need to probe to find i2c devices? Can't the
> >>> address be determined by knowing the PCI ID of the board?
> >>
> >> There are two reasons we need to probe: it is either because when the
> >> board was added no one bothered to record which chip was on what
> >> address (this happened in particular with old drivers like bttv) or
> >> because there is simply no other way to determine the presence or
> >> absence of an i2c device.
> >
> > Unrecorded boards could be handled by adding a printk at driver init
> > time asking people to email you the needed information. Then remove
> > the printks as soon as you get the answer.

It's rather unfeasible when you are dealing with dozens and dozens of cards. 
We also know that there are variants of these cards out there where they 
changed audio chips or tuner chips without changing anything. It's not a 
big deal, that's why we have the i2c probing to solve these cases. Newer 
drivers try to avoid probing wherever possible, of course.

> >> E.g. there are three versions of one card: without upd64083 (Y/C
> >> separation device) and upd64031a (ghost reduction device), with only
> >> the upd64031a and one with both. Since they all have the same PCI ID
> >> the only way to determine the model is to probe.
> >
> > Did they happen to change the subsystem device_id? There are two pairs
> > of PCI IDs on each card. Most of the time the subsystem vendor/device
> > isn't set.

No, it's all the same. This is very common for the cheaper cards. They take 
a reference design, modify it and never bother to change the IDs.

Regards,

	Hans

>
> Example using lspci -vvv -nn
>
> This is an Intel ICH8 but Dell as set in a subsystem id if 1028:01db
> to indicate their custom use of the generic part.
>
> 00:1f.3 SMBus [0c05]: Intel Corporation 82801H (ICH8 Family) SMBus
> Controller [8086:283e] (rev 02)
> 	Subsystem: Dell Device [1028:01db]
> 	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Interrupt: pin C routed to IRQ 10
> 	Region 0: Memory at dffdab00 (32-bit, non-prefetchable) [size=256]
> 	Region 4: I/O ports at ece0 [size=32]
> 	Kernel modules: i2c-i801
>
> > Getting rid of the probes altogether is the most reliable solution.
> > There is probably a way to identify these boards more specifically
> > that you haven't discovered yet.  PCI subsystem device ID is worth
> > checking.
> >
> >> Regards,
> >>
> >>        Hans
> >>
> >>> > static const unsigned short addrs[] = {
> >>> >        addr, I2C_CLIENT_END
> >>> > };
> >>> >
> >>> > client = i2c_new_probed_device(adapter, &info, addrs);
> >>> >
> >>> > This is a bit awkward and I came up with this macro:
> >>> >
> >>> > #define V4L2_I2C_ADDRS(addr, addrs...) \
> >>> >        ((const unsigned short []){ addr, ## addrs, I2C_CLIENT_END
> >>> > })
> >>> >
> >>> > This can construct a list of one or more i2c addresses on the fly.
> >>> > But this is something that really belongs in i2c.h, renamed to
> >>> > I2C_ADDRS.
> >>> >
> >>> > With this macro we can just do:
> >>> >
> >>> > client = i2c_new_probed_device(adapter, &info, I2C_ADDRS(addr));
> >>> >
> >>> > Comments?
> >>> >
> >>> > Regards,
> >>> >
> >>> >        Hans
> >>> >
> >>> > --
> >>> > Hans Verkuil - video4linux developer - sponsored by TANDBERG
> >>> > Telecom --
> >>> > To unsubscribe from this list: send the line "unsubscribe
> >>> > linux-i2c" in the body of a message to majordomo@vger.kernel.org
> >>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >> --
> >> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
> >
> > --
> > Jon Smirl
> > jonsmirl@gmail.com



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
