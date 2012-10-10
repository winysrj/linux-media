Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64156 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab2JJGt4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 02:49:56 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so300918iea.19
        for <linux-media@vger.kernel.org>; Tue, 09 Oct 2012 23:49:55 -0700 (PDT)
MIME-Version: 1.0
Reply-To: martin-eric.racine@iki.fi
In-Reply-To: <20121010082308.4c802517@armhf>
References: <20120711100436.2305b098@armhf>
	<CAPZXPQdJC5yCYY6YRzuKj-ukFLzbY_yUzbogzbDx1S0bL1GrgQ@mail.gmail.com>
	<20120711124441.346a86b3@armhf>
	<CAPZXPQcvGqPjeyZh=vHtbSOoA91Htsg6DeyYyhYLeDgay8GSBg@mail.gmail.com>
	<20120711132739.6b527a27@armhf>
	<CAPZXPQeDKLAu13Qs-MhhxJEBrF-5620HNZDmPiH+4NRmkxx3Ag@mail.gmail.com>
	<4FFD7F48.6060905@redhat.com>
	<CAPZXPQfMrWySzx9=61WqoZ7zwzw19p69nN6_fuwAHjZVqGLDBw@mail.gmail.com>
	<20120711191835.1be1c8ef@armhf>
	<CAPZXPQeWC+pKJNLr12y_AybYCCKZr6ayBAa=EhaiyfN4iU8g5g@mail.gmail.com>
	<20121009225446.GA7396@elie.Belkin>
	<20121010082308.4c802517@armhf>
Date: Wed, 10 Oct 2012 09:49:55 +0300
Message-ID: <CAPZXPQdVs54w=a5sD+bJeyw0gPE3wXv3Qpx5DUk4MrTSgYf68g@mail.gmail.com>
Subject: Re: video: USB webcam fails since kernel 3.2
From: =?UTF-8?Q?Martin=2D=C3=89ric_Racine?= <martin-eric.racine@iki.fi>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Jonathan Nieder <jrnieder@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>, 677533@bugs.debian.org,
	linux-media@vger.kernel.org, debian-kernel@lists.debian.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/10/10 Jean-Francois Moine <moinejf@free.fr>:
> On Tue, 9 Oct 2012 15:54:46 -0700
> Jonathan Nieder <jrnieder@gmail.com> wrote:
>
>> Hi,
>>
>> In June, Martin-Éric Racine wrote:
>>
>> > Since recent kernels, this ASUS W5F's built-in webcam fails to be
>> > detected. Gstreamer-based applications (Cheese,
>> > gstreamer-properties) immediately crash whenever trying to access
>> > the video device.
>> [...]
>> > video_source:sr[3246]: segfault at 0 ip   (null) sp ab36de1c error
>> > 14 in cheese[8048000+21000]
>>
>> In July, Martin-Éric Racine wrote:
>>
>> > As far as I can tell, yes, the modules in Jean-François' tarball work
>> > as-is to fix the problem.
>> [...]
>> > [   11.834852] gspca_main: v2.15.18 registered
>> > [   11.844262] gspca_main: vc032x-2.15.18 probing 0ac8:0321
>> > [   11.844682] gspca_vc032x: vc0321 check sensor header 2c
>> > [   11.850304] gspca_vc032x: Sensor ID 3130 (0)
>> > [   11.850309] gspca_vc032x: Find Sensor PO3130NC
>> > [   11.851809] gspca_main: video0 created
>> >
>> > Backport would be needed against 3.2.21 as this is what Debian will
>> > (probably) release with.
>>
>> Sorry to have lost track of this.  Do you know what patch fixed it?
>> Does 3.5.y from experimental work?
>>
>> Curious,
>> Jonathan
>
> Hi Jonathan,
>
> I tried to prepare a patch set for the vc032x, but testing with
> Martin-Éric stopped  mid-july, so I have nothing to propose yet. I'm
> waiting for some other vc0321+po3130nc owner and continue the tests...

We kept on going back and forth between two versions of the same file,
none of which produced the result expected by Jean-Francois. I'd
venture that the change that fixed it involves an entirely different
file, but he seemed to expect otherwise.

Martin-Éric
