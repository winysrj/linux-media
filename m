Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62036 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab1JJURp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Oct 2011 16:17:45 -0400
Received: by gyg10 with SMTP id 10so5712724gyg.19
        for <linux-media@vger.kernel.org>; Mon, 10 Oct 2011 13:17:45 -0700 (PDT)
Message-ID: <4E9352E5.5080209@gmail.com>
Date: Mon, 10 Oct 2011 15:17:41 -0500
From: Patrick Dickey <pdickeybeta@gmail.com>
MIME-Version: 1.0
To: Allan Macdonald <allan.w.macdonald@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Cannot configure second Kodicom 4400R
References: <CALVOWFPrcYuQ-A=Td7AQMj02e96VNg_z2nUOmTvwKyZC_yUmLg@mail.gmail.com>
In-Reply-To: <CALVOWFPrcYuQ-A=Td7AQMj02e96VNg_z2nUOmTvwKyZC_yUmLg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi there Allan,

I'm not familiar with the card (so you'll want to defer to someone else
if their answer differs from mine).  It looks like video0 and video1 are
assigned to the first card, and video2 and video3 are assigned to the
second card.  So, you might want to try

xawtv -d /dev/video2'

or

xawtv -d /dev/video3

and see if one of those uses the second card (you could try video4 or
video5 also, since they're assigned to cards).

Have a great day:)
Patrick.

On 10/10/2011 01:45 PM, Allan Macdonald wrote:
> Hi to all,
> 
> I am new to this list.
> 
> I have been successfully using a Kodicom 4400R with zoneminder but I
> wanted to expand so I bought a second card and installed it.  The
> problem with this card is that I cannot seem to be able to get the
> second card to work.  I tried using xawtv with the following command:
> 
> xawtv -d /dev/video1
> 
> The result is that I get images from /dev/video0
> 
> I also tried:
> 
> xawtv -d /dev/video4
> 
> with the same result.
> 
> I obviously don't understand what's going on.
> 
> I tried following the instructions here, to no avail:
> 
> http://www.zoneminder.com/wiki/index.php/Kodicom_4400r
> 
> I also looked here:
> 
> http://linuxtv.org/wiki/index.php/Kodicom_4400R
> 
> but, unfortunately, the following page does not explain what happens
> with more than one card installed.
> 
> Here's my bttv.conf:
> 
> [code]
> options bttv gbuffers=32 card=133,132,133,133,133,132,133,133 tuner=4
> chroma_agc=1
> [/code]
> 
> I have attached a dmesg output and an lsmod output.
> 
> I would greatly appreciate some help.  Many thanks in advance.
> 
> Regards,
> 
> Allan Macdonald

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk6TUuUACgkQMp6rvjb3CAT9VwCfTyqoIrlUS+IszJIQWpyYD7j9
NlsAnRFpxHKQT+p7Hem+D2SpUWiDkxu2
=l16i
-----END PGP SIGNATURE-----
