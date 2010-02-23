Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-15.arcor-online.net ([151.189.21.55]:33696 "EHLO
	mail-in-15.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753388Ab0BWQx1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 11:53:27 -0500
Message-ID: <4B8407F3.3050802@arcor.de>
Date: Tue, 23 Feb 2010 17:53:07 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Abhijit Bhopatkar <bain@devslashzero.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Hauppague WinTV USB2-stick (tm6010)
References: <201002232142.07782.bain@devslashzero.com> <829197381002230815k5fe76c9ah727af57f56fd5401@mail.gmail.com> <201002232151.25852.bain@devslashzero.com>
In-Reply-To: <201002232151.25852.bain@devslashzero.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
Am 23.02.2010 17:21, schrieb Abhijit Bhopatkar:
> On Tuesday 23 Feb 2010 9:45:18 pm Devin Heitmueller wrote:
>> On Tue, Feb 23, 2010 at 11:12 AM, Abhijit Bhopatkar
>>
>> <bain@devslashzero.com> wrote:
>>> Is it worth for me to test this latest tree and driver against my card by
>>> just adding the device ids?
>>> If the devs need some more testing / help i can certainly volunteer my
>>> time/efforts.
>>> I do have fare familiarity with linux driver development and would be
>>> happy to help in debugging/developing support for this tuner. The only
>>> thing i don't have is knowledge for making this chipset work.
>>
>> Don't bother.  The driver is known to be broken - badly.  It needs
>> alot of work, although someone has finally started hacking at the
>> tm6000 driver recently (see the mailing list archives for more info).
>>
>
> Devin, thanks for the input
>
> I see that Stefan is doing some patching/cleanup.
>
> Stefan, is there anything i can do to help?
>
> Abhijit
I think, you can help to analyse the usb data communication -> what
for tuner, demodulator, gpio's etc.? And you can also ask Mauro
Carvalho Chehab.

Stefan
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQEcBAEBAgAGBQJLhAfzAAoJEDX/lZlmjdJlUPYH/RnDzHGSWwC78Nc2FgKDPkYw
RFnDOImVo4G+i/Mr0UtZB9JIx75lkntwPeeJVp+aal3tLBECil0eYLco6jTuxcYt
V5iBuSZClycyvaWBc+VFi40rJcX3cqG6210GwIzNZMJH41/wPhAj15D4BVauiNsc
8ZhupI0HhM66w5LiO22fYq80WkgTb7dx5UMBVDzhkKNaS4f5mmcvyxWMJZrVzesN
Fv36lsp/RnqdmT5GgOR6Bgc/zExyiHIiLmEVclmfKv1ExeuqrwscN8F6eASlqXlK
iXQgMYmqEb3jTtKJRzLi4R/Yl0s16iOhvK0AA7AAybBj3liQOZKeh/k5HG3Hf6g=
=g/SL
-----END PGP SIGNATURE-----

