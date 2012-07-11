Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974Ab2GKN1N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 09:27:13 -0400
Message-ID: <4FFD7F48.6060905@redhat.com>
Date: Wed, 11 Jul 2012 15:27:36 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: martin-eric.racine@iki.fi
CC: Jean-Francois Moine <moinejf@free.fr>,
	Jonathan Nieder <jrnieder@gmail.com>, 677533@bugs.debian.org,
	linux-media@vger.kernel.org
Subject: Re: video: USB webcam fails since kernel 3.2
References: <20120614162609.4613.22122.reportbug@henna.lan> <20120614215359.GF3537@burratino> <CAPZXPQd9gNCxn7xGyqj_xymPaF5OxvRtxRFkt+SsLs942te4og@mail.gmail.com> <20120616044137.GB4076@burratino> <1339932233.20497.14.camel@henna.lan> <CAPZXPQegp7RA5M0H9Ofq4rJ9aj-rEdg=Ly9_1c6vAKi3COw50g@mail.gmail.com> <4FF9CA30.9050105@redhat.com> <CAPZXPQd026xfKrAU0D7CLQGbdAs8U01u5vsHp+5-wbVofAwdqQ@mail.gmail.com> <4FFAD8D9.8070203@redhat.com> <20120709203929.GC17301@burratino> <CAPZXPQcaEzW1zGXfGwp-JuOrfBu2xhoidaYjthD8jhYAFpWr7A@mail.gmail.com> <20120710163645.04fb0af0@armhf> <CAPZXPQehjGRDZ=rXWjGFPQvRqOMzRpeA2dpoSWc3XwuUkvvesg@mail.gmail.com> <20120711100436.2305b098@armhf> <CAPZXPQdJC5yCYY6YRzuKj-ukFLzbY_yUzbogzbDx1S0bL1GrgQ@mail.gmail.com> <20120711124441.346a86b3@armhf> <CAPZXPQcvGqPjeyZh=vHtbSOoA91Htsg6DeyYyhYLeDgay8GSBg@mail.gmail.com> <20120711132739.6b527a27@armhf> <CAPZXPQeDKLAu13Qs-MhhxJEBrF-5620HNZDmPiH+4NRmkxx3Ag@mail.gmail.com>
In-Reply-To: <CAPZXPQeDKLAu13Qs-MhhxJEBrF-5620HNZDmPiH+4NRmkxx3Ag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/11/2012 02:01 PM, Martin-Éric Racine wrote:
> 2012/7/11 Jean-Francois Moine <moinejf@free.fr>:
>> On Wed, 11 Jul 2012 14:14:24 +0300
>> Martin-Éric Racine <martin-eric.racine@iki.fi> wrote:
>>
>>>    CC [M]  /home/perkelix/gspca-2.15.18/build/ov534_9.o
>>> /home/perkelix/gspca-2.15.18/build/ov534_9.c: In function ‘sd_init’:
>>> /home/perkelix/gspca-2.15.18/build/ov534_9.c:1353:3: error: implicit
>>> declaration of function ‘err’ [-Werror=implicit-function-declaration]
>>> cc1: some warnings being treated as errors
>>> make[2]: *** [/home/perkelix/gspca-2.15.18/build/ov534_9.o] Virhe 1
>>> make[1]: *** [_module_/home/perkelix/gspca-2.15.18/build] Error 2
>>> make[1]: Leaving directory `/usr/src/linux-headers-3.5.0-rc6+'
>>> make: *** [modules] Error 2
>>
>> Sorry, I did not compile yet with kernel >= 3.4.
>>
>> So, please, edit the file build/ov534_9.c (and possibly other sources),
>> changing  the calls to 'err' to 'pr_err'.
>
> This was was required for both build/ov534_9.c and build/spca505.c to
> build agaist 3.5.
>
> Sure enough, this seems to fix support for this camera in both Cheese
> and Skype. Hurray! :-)

Ok, so it seems that increasing the bandwidth we claim for the camera
(which is what my suggested "return 2000 * 2000 * 120;" change does, helps
a bit, where as the changes to vc032x which are in Jean-Francois Moine's
gspca-2.15.18 tarbal fix the problem entirely, correct?

>
> Now, the only thing that remains is for this to be merged in the 3.5
> tree, then backported to the 3.2 tree that is used for Debian's
> upcoming Wheezy stable release (and for Ubuntu's recently released
> Precise also).

Well we first need to turn the changes made in gspca-2.15.18 into
a patch will which apply to the latest gspca tree:
http://git.linuxtv.org/hgoede/gspca.git/shortlog/refs/heads/media-for_v3.6

And then apply them there, before the can be backported to older
kernels. Unfortunately I'm leaving for a week vacation Friday, and I
probably won't get around to this before then.

Jean-Francois, can you perhaps make a patch against my latest tree for
the poXXXX / PO3130 changes in your tarbal?

Regards,

Hans
