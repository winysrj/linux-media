Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0a-00272701.pphosted.com ([67.231.145.144]:43698 "EHLO
        mx0a-00272701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750946AbeCJQ5r (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Mar 2018 11:57:47 -0500
From: "French, Nicholas A." <naf@ou.edu>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Andy Lutomirski <luto@kernel.org>
CC: "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: ivtv: use arch_phys_wc_add() and require PAT disabled
Date: Sat, 10 Mar 2018 16:57:41 +0000
Message-ID: <MWHPR03MB30402C0F8B8F457F5F760412D3DD0@MWHPR03MB3040.namprd03.prod.outlook.com>
References: <DM5PR03MB3035EE1AFCEE298AFB15AC46D3C60@DM5PR03MB3035.namprd03.prod.outlook.com>
 <20180301171936.GU14069@wotan.suse.de>
 <DM5PR03MB303587F12D7E56B951730A76D3D90@DM5PR03MB3035.namprd03.prod.outlook.com>
 <20180307190205.GA14069@wotan.suse.de>
 <DM5PR03MB30352350D588A81D2D02BE93D3DF0@DM5PR03MB3035.namprd03.prod.outlook.com>
 <20180308040601.GQ14069@wotan.suse.de>,<20180308041411.GR14069@wotan.suse.de>,<DM5PR03MB3035CCBF9718D7E42B35357FD3DF0@DM5PR03MB3035.namprd03.prod.outlook.com>
In-Reply-To: <DM5PR03MB3035CCBF9718D7E42B35357FD3DF0@DM5PR03MB3035.namprd03.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 07, 2018 at 11:23:09PM -0600, French, Nicholas A. wrote:
> On Thu, Mar 08, 2018 at 04:14:11AM +0000, Luis R. Rodriguez wrote:
> > On Thu, Mar 08, 2018 at 04:06:01AM +0000, Luis R. Rodriguez wrote:
> > > On Thu, Mar 08, 2018 at 03:16:29AM +0000, French, Nicholas A. wrote:
> > > >
> > > > Ah, I see. So my proposed ioremap_wc call was only "working" by ali=
asing the
> > > > ioremap_nocache()'d mem area and not actually using write combining=
 at all.
> > >
> > > There are some debugging PAT toys out there I think but I haven't pla=
yed with
> > > them yet or I forgot how to to confirm or deny this sort of effort, b=
ut
> > > likeley.
> >
> >  In fact come to think of it I believe some neurons are telling me that=
 if
> >  two type does not match we'd get an error?

I can confirm that my original suggested patch just aliases to ivtv-driver'=
s nocache mapping:
$ sudo modprobe ivtvfb
$ sudo dmesg
...
x86/PAT: Overlap at 0xd5000000-0xd5800000
x86/PAT: reserve_memtype added [mem 0xd5510000-0xd56b0fff], track uncached-=
minus, req write-combining, ret uncached-minus
ivtvfb0: Framebuffer at 0xd5510000, mapped to 0x00000000c6a7ed52, size 1665=
k
...
$ sudo cat /sys/kernel/debug/x86/pat_memtype_list | grep 0xd5
uncached-minus @ 0xd5000000-0xd5800000
uncached-minus @ 0xd5510000-0xd56b1000

So nix that.

> > No what if the framebuffer driver is just requested as a secondary step
> > after firmware loading?
>
> Its a possibility. The decoder firmware gets loaded at the beginning of t=
he decoder
> memory range and we know its length, so its possible to ioremap_nocache e=
nough
> room for the firmware only on init and then ioremap the remaining non-fir=
mware
> decoder memory areas appropriately after the firmware load succeeds...

I looked in more detail, and this would be "hard" due to the way the rest o=
f the
decoder offsets are determined by either making firmware calls or scanning =
the
decoder memory range for magic bytes and other mess.

I think some smart guy named mcgrof apparently came to the same conclusion=
=20
in a really old email chain I found [https://lists.gt.net/linux/kernel/2387=
536]:
"The ivtv case is the *worst* example we can expect where the firmware
hides from us the exact ranges for write-combining, that we should somehow
just hope no one will ever do again."
:-)

> Perhaps the easy answer is to change the fatal is-pat-enabled check to ju=
st a
> warning like "you have PAT enabled, so wc is disabled for the framebuffer=
.
> if you want wc, use the nopat parameter"?

I like this idea more and more. I haven't experience any problems running
with PAT-enabled and no write-combining on the framebuffer. Any objections?

- Nick=
