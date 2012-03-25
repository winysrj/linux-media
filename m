Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60541 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180Ab2CYVyU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Mar 2012 17:54:20 -0400
Received: by bkcik5 with SMTP id ik5so3535861bkc.19
        for <linux-media@vger.kernel.org>; Sun, 25 Mar 2012 14:54:19 -0700 (PDT)
Message-ID: <4F6F9407.5020602@googlemail.com>
Date: Sun, 25 Mar 2012 23:54:15 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Marien Zwart <marien.zwart@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: libv4l: add Lenovo Thinkpad Edge E325 to upside down devices
 table
References: <1332616469.3755.9.camel@cyclops.marienz.net>
In-Reply-To: <1332616469.3755.9.camel@cyclops.marienz.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Hello Marien,

On 3/24/12 8:14 PM, Marien Zwart wrote:
> Like the recently added Thinkpad X200 and X201 the Thinkpad Edge 
> E325 apparently has its camera upside down. dmidecode and lsusb 
> output is attached. I have also confirmed that Debian's 
> libv4l-0.8.6 with the following entry added to its table makes the 
> camera work:
> 
> { 0x04f2, 0xb27c, 0, "LENOVO", "12973MG", V4LCONTROL_HFLIPPED | 
> V4LCONTROL_VFLIPPED },
> 

Thanks for the patch! I've applied this change in a slightly modified
form to the v4l-utils head and stable-0.8 branch.

I assume you're a Debian user: libv4l-0.8.6-2 got just uploaded to
Debian Sid. In case you're on Ubuntu, the libv4l/stable PPA will pick
up the patch with the next nightly build.

> It looks like v4l-utils git master does not know about this model 
> yet. My apologies if it does and I overlooked it (I only grepped 
> through that code, I did not run it).

Thanks again for the diff.

> Please let me know if you need more information (note I'm not 
> subscribed to the list, so please CC me).

It would be great if you could test the updated package.

Thanks,
Gregor
-----BEGIN PGP SIGNATURE-----
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCAAGBQJPb5QHAAoJEBmaZPrftQD/hKkP/jpvILuhjowJOjdKGfmj9NQK
X6mCk8Sc7ViaMG/GrzdC+J3Aufry2k1X8ntqh09UbGqz5C+/pmV1pcwLHJr113Xe
PUZ0exNDszfGDB6VEYZIUd7eQGZnxmX6wnWjNKRM5SEirr65Fg6vYzz29zxxGgXq
XeryRSE4EfwPOIrkpmRbiG3Vfz2bkD5o9bpE7CTSX4Xjof1oUGRi8zVP6k/ItogL
GAjvtI1BUdscOHunxJK4kFPT+WpcCoQTCTvZdEhDIW5gZGFA+tIH6Swv/qIgPgYB
FC2tw5DzA7i1+HW2Cf/+o0iT5BRrvbJVaVFmBJDzM/oVY30nysfVukcSCOPKTYOi
0/YbIt/bnXGz3leltSMy9pBwndPz72H6fnV5uzZWaUHED+Nlwt1mnROXMAyvkjuw
auVmd5JZ1vMaC/oyJx/UsEwe7TOZRogoJnMviWlOrHXAyBW6OvHf17OYLNv0mKmU
70MsJyd0JF/mB5skHiEZWfZn5W27lndWRoM5/cjX9aN4sE4tngR+ZXkd50C6AXZJ
3eFCxvTl8zDR1mkyOuXwBrqrT8wVocgjdGLuv0B3ng7RuGOyKvH3Bl73iEXsxXSz
QEXnVdh+YfcuRsrKRkk9Xwdu4iS7swd6oapSlV48QMkNWDm5L+SWkKI1epG2JxWH
W/BQapX+yorgza4jKSJ/
=6Ow6
-----END PGP SIGNATURE-----
