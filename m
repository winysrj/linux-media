Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40084 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab2JIWyz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2012 18:54:55 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so5714475pad.19
        for <linux-media@vger.kernel.org>; Tue, 09 Oct 2012 15:54:55 -0700 (PDT)
Date: Tue, 9 Oct 2012 15:54:46 -0700
From: Jonathan Nieder <jrnieder@gmail.com>
To: =?utf-8?Q?Martin-=C3=89ric?= Racine <martin-eric.racine@iki.fi>
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>, 677533@bugs.debian.org,
	linux-media@vger.kernel.org, debian-kernel@lists.debian.org
Subject: Re: video: USB webcam fails since kernel 3.2
Message-ID: <20121009225446.GA7396@elie.Belkin>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAPZXPQeWC+pKJNLr12y_AybYCCKZr6ayBAa=EhaiyfN4iU8g5g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

In June, Martin-Éric Racine wrote:

> Since recent kernels, this ASUS W5F's built-in webcam fails to be
> detected. Gstreamer-based applications (Cheese,
> gstreamer-properties) immediately crash whenever trying to access
> the video device.
[...]
> video_source:sr[3246]: segfault at 0 ip   (null) sp ab36de1c error
> 14 in cheese[8048000+21000]

In July, Martin-Éric Racine wrote:

> As far as I can tell, yes, the modules in Jean-François' tarball work
> as-is to fix the problem.
[...]
> [   11.834852] gspca_main: v2.15.18 registered
> [   11.844262] gspca_main: vc032x-2.15.18 probing 0ac8:0321
> [   11.844682] gspca_vc032x: vc0321 check sensor header 2c
> [   11.850304] gspca_vc032x: Sensor ID 3130 (0)
> [   11.850309] gspca_vc032x: Find Sensor PO3130NC
> [   11.851809] gspca_main: video0 created
>
> Backport would be needed against 3.2.21 as this is what Debian will
> (probably) release with.

Sorry to have lost track of this.  Do you know what patch fixed it?
Does 3.5.y from experimental work?

Curious,
Jonathan
