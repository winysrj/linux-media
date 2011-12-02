Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38593 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976Ab1LBWKF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Dec 2011 17:10:05 -0500
Received: by iage36 with SMTP id e36so4781186iag.19
        for <linux-media@vger.kernel.org>; Fri, 02 Dec 2011 14:10:03 -0800 (PST)
Message-ID: <4ED94CB8.4080005@gmail.com>
Date: Fri, 02 Dec 2011 16:10:00 -0600
From: Patrick Dickey <pdickeybeta@gmail.com>
MIME-Version: 1.0
To: =?windows-1252?Q?R=E9mi_Denis-Courmont?= <remi@remlab.net>
CC: linux-media@vger.kernel.org
Subject: Re: LinuxTV ported to Windows
References: <4ED65C46.20502@netup.ru> <CAGoCfiwShvPSgAPHKaxj=sMG-Fs9RdH0_3mLHYWuY96Z33AOag@mail.gmail.com> <201112022003.28737.remi@remlab.net>
In-Reply-To: <201112022003.28737.remi@remlab.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/02/2011 12:03 PM, Rémi Denis-Courmont wrote:
> Hello,
> 
> A GPL troll, as the "Vicious Nokia Employee [that got] VLC Removed
> from Apple App Store" I cannot resist...
> 
> Le mercredi 30 novembre 2011 19:23:26 Devin Heitmueller, vous avez
> écrit :
>> Am I the only one who thinks this is a legally ambigious grey
>> area? Seems like this could be a violation of the GPL as the
>> driver code in question links against a proprietary kernel.
> 
> If you have any doubt, I would suggest you ask the SFLC. They tend
> to give valuable insights into that sort of problems. It might be
> intricate and/or not what you want to hear from them though (Been
> there done that).
> 
>> I don't want to start a flame war, but I don't see how this is
>> legal. And you could definitely question whether it goes against
>> the intentions of the original authors to see their GPL driver
>> code being used in non-free operating systems.
> 
> As long as the distributed binaries do not include any
> GPL-incompatible code (presumably from Microsoft), there should be
> no GPL contamination problem. So it boils down to whether the
> driver binary has non-GPL code in it. I don't see how the license
> of the Windows code is relevant, so long as NetUp is not 
> distributing the Windows OS alongside the driver (or vice versa).
> 
> And while I do not know the Windows DDK license, I doubt it cares
> much about the driver license, so long as Microsoft does not need
> to distribute nor certify the driver.
> 

I'm not sure about the Windows DDK license either, but I can tell you
that at least some of their licenses specifically forbid you to use
their libraries or source code in GPL-style programs.

I downloaded an iso of the Windows Driver Kit version 7.1.0, and what
I found in the Windows Development Kit license is this (concerning
redistributed code from the WDK)

> iii. Distribution Restrictions.  You may not alter any copyright,
> trademark or patent notice in the Distributable Code; use
> Microsoft’s trademarks in your programs’ names or in a way that
> suggests your programs come from or are endorsed by Microsoft;

********
> distribute Distributable Code to run on a platform other than the
> Windows platform;

********
> include Distributable Code in malicious, deceptive or unlawful
> programs; or

********
> modify or distribute the source code of any Distributable Code so
> that any part of it becomes subject to an Excluded License.  An
> Excluded License is one that requires, as a condition of use,
> modification or distribution, that the code be disclosed or
> distributed in source code form; or others have the right to modify
> it.

********

Which would tell me that you can't redistribute their code in any
product licensed under the GPL. So, if NetUP used any of the
redistributable code from the development kit in their port, it would
violate Microsoft's licensing. And any code that NetUP used cannot be
backported to Linux.  (The **'s are my emphasis of what I believe are
the relevant portions of the license)

> 
> There may however be problems with the toolchain. The driver binary
> must be recompilable with just the GPL'd source code and "anything
> that is normally distributed with the operating system".
> VisualStudio is not distributed with Windows. In fact, it is sold
> as a separate product, except for restrictive freeware versions.
> 
> So unless this driver can be compiled with a GPL-compatible
> toolchain (and the toolchain is provided by NetUp), it might not be
> possible to distribute binary copies of the driver.
> 
> Then again, I am not a laywer. Someone that cares, please ask SFLC
> or friends.
> 

I agree about contacting the SFLC. Also the copyright holder (Steven
Toth) weighed in about his concerns. So at the end of the day, this is
between him and the developers (NetUP, Abylay, etc).

GPL questions/potential issues aside, I can see some benefit from
this. Just in the idea that if the port works fairly decently, and
with the proper advertising, it might get the name "Linux" into the
average user's field of view (so to speak). Of course if the port is
crap, or if you have to pay for the product (or pay for a
spyware/adware free version), then it might have the opposite effect.
This is just my 2 cents worth, as an end-user mainly.

Have a great day:)
Patrick.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7ZTLcACgkQMp6rvjb3CARnqwCgy6MqGTObMugv1S0v5gOTf/xx
f+sAn3hkImJvOCVMJlKcnV/b+VfI4wZL
=UJN4
-----END PGP SIGNATURE-----
