Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f51.google.com ([209.85.216.51]:46997 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaK3PvW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Nov 2014 10:51:22 -0500
Received: by mail-qa0-f51.google.com with SMTP id k15so6091783qaq.38
        for <linux-media@vger.kernel.org>; Sun, 30 Nov 2014 07:51:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141129185012.714473bc@recife.lan>
References: <5478D31E.5000402@cogweb.net>
	<CAGoCfizK4kN5QnmFs_trAk2w3xuSVtXYVF2wSmdXDazxbhk=yQ@mail.gmail.com>
	<547934E1.3050609@cogweb.net>
	<CAGoCfix11OiF5_kojJ4jKZadz3XYdYJccPGtivtzDepFfn4Rnw@mail.gmail.com>
	<20141129090408.1b52c9ea@recife.lan>
	<5479F19A.9000408@cogweb.net>
	<20141129185012.714473bc@recife.lan>
Date: Sun, 30 Nov 2014 10:51:21 -0500
Message-ID: <CAGoCfizVVJMkOLXk5LdYAWJdvFmzzA-uZHyyWS5k-GcNKJiLAw@mail.gmail.com>
Subject: Re: ISDB caption support
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: David Liontooth <lionteeth@cogweb.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> With regards to CC decoding, IMHO, the best would be to add a parser
> for ISDB CC at libdvbv5.

It probably makes more sense to extend one of the existing libraries
that supports captions/subtitles to include support for ISDB (such as
libzvbi or ccextractor).  The libdvbv5 library has no infrastructure
today for subtitle rendering for any other formats, so generating a
generic caption/subtitle API within libdvbv5 that is extensible enough
to support other formats seems redundant.  It also means that
applications that already use libzvbi will get the support for ISDB
effectively "for free" (in fact, I'm considering moving VLC over to
using libzvbi for CC rendering - it's already used today for raw VBI
slicing).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
