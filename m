Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:41123 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932163AbeCKUTG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Mar 2018 16:19:06 -0400
Received: by mail-pl0-f67.google.com with SMTP id d9-v6so8156422plo.8
        for <linux-media@vger.kernel.org>; Sun, 11 Mar 2018 13:19:06 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: ivtv: use arch_phys_wc_add() and require PAT disabled
From: Andy Lutomirski <luto@amacapital.net>
In-Reply-To: <20180311195116.GB4645@tivo.lan>
Date: Sun, 11 Mar 2018 13:19:03 -0700
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <38CB7D59-7F11-4BC3-B73C-C2F0BF16EFF8@amacapital.net>
References: <DM5PR03MB3035EE1AFCEE298AFB15AC46D3C60@DM5PR03MB3035.namprd03.prod.outlook.com> <20180301171936.GU14069@wotan.suse.de> <DM5PR03MB303587F12D7E56B951730A76D3D90@DM5PR03MB3035.namprd03.prod.outlook.com> <20180307190205.GA14069@wotan.suse.de> <DM5PR03MB30352350D588A81D2D02BE93D3DF0@DM5PR03MB3035.namprd03.prod.outlook.com> <20180308040601.GQ14069@wotan.suse.de> <20180308041411.GR14069@wotan.suse.de> <DM5PR03MB3035CCBF9718D7E42B35357FD3DF0@DM5PR03MB3035.namprd03.prod.outlook.com> <MWHPR03MB30402C0F8B8F457F5F760412D3DD0@MWHPR03MB3040.namprd03.prod.outlook.com> <67E7293F-6045-4EA1-8AEF-E4B92E046581@amacapital.net> <20180311195116.GB4645@tivo.lan>
To: Nick French <naf@ou.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>




> On Mar 11, 2018, at 12:51 PM, Nick French <naf@ou.edu> wrote:
>=20
> On Sat, Mar 10, 2018 at 10:20:23AM -0800, Andy Lutomirski wrote:
>>>> Perhaps the easy answer is to change the fatal is-pat-enabled check to j=
ust
>>>> a warning like "you have PAT enabled, so wc is disabled for the framebu=
ffer.
>>>> if you want wc, use the nopat parameter"?
>>>=20
>>> I like this idea more and more. I haven't experience any problems runnin=
g
>>> with PAT-enabled and no write-combining on the framebuffer. Any objectio=
ns?
>>>=20
>>=20
>> None from me.
>>=20
>> However, since you have the hardware, you could see if you can use the
>> change_page_attr machinery to change the memory type on the framebuffer o=
nce
>> you figure out where it is.
>=20
> I am certainly willing to try this, but my understanding of the goal of th=
e
> changes that disabled ivtvfb originally is that it was trying to hide the
> architecture-specific memory management from the driver.

Not really. The goal was to eliminate all code that touches MTRRs on PAT sys=
tems. So mtrr_add got unexported and the arch_phys are legacy hints that do n=
othing on modern machines.=20

>=20
> Wouldn't (figuring out a way to) expose x86/mm/pageattr internals to the
> driver be doing the opposite? (or maybe I misunderstand your suggestion)

It doesn=E2=80=99t conflict at all.  Obviously the code should be tidy.=20

=46rom memory, I see two potentially reasonable real fixes. One is to find a=
 way to punch a hole in an ioremap. So you=E2=80=99d find the framebuffer, r=
emove it from theproblematic mapping, and then make a new mapping. The secon=
d is to change the mapping type in place.=20

Or maybe you could just iounmap the whole thing after firmware is loaded and=
 the framebuffer is found and then redo the mapping right.=20
