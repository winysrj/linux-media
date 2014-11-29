Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:47375 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbaK2DXO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Nov 2014 22:23:14 -0500
Received: by mail-qg0-f49.google.com with SMTP id a108so5356042qge.8
        for <linux-media@vger.kernel.org>; Fri, 28 Nov 2014 19:23:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <547934E1.3050609@cogweb.net>
References: <5478D31E.5000402@cogweb.net>
	<CAGoCfizK4kN5QnmFs_trAk2w3xuSVtXYVF2wSmdXDazxbhk=yQ@mail.gmail.com>
	<547934E1.3050609@cogweb.net>
Date: Fri, 28 Nov 2014 22:23:13 -0500
Message-ID: <CAGoCfix11OiF5_kojJ4jKZadz3XYdYJccPGtivtzDepFfn4Rnw@mail.gmail.com>
Subject: Re: ISDB caption support
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: David Liontooth <lionteeth@cogweb.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I realize captions is an application-layer function, and intend to work with
> the CCExtractor team. Do any other applications already have ISDB caption
> support?

Based on a Google search, it looks like dvbviewer can decode them:

http://www.dvbviewer.tv/forum/topic/41933-brazilian-terrestrial-isdb-tb-subtitles-closed-caption/
http://www.dvbviewer.com/en/index.php

It's not open source, and it's not Linux, but at least it may give you
something to compare against if you want to build the functionality
yourself.

> For DVB and ATSC there's quite a bit of code written by several people for
> teletext and captions -- has anything at all been done for ISDB captions?

Not to my knowledge.  I've done a ton of work with CC decoding in VLC,
but haven't poked around at the other formats.

> It's used in nearly all of Central and South America, plus the Philippines
> and of course Japan -- you would have thought someone has started on the
> task?

>From what I understand, most terrestrial TV in Japan is encrypted, so
you're likely to not find many open source solutions which targeted at
that market.  Presumably there is less of that in Brazil (why else
would Mauro be doing all that ISDB-T work if there was no way to watch
the actual video?).

> We're looking for a good solution for capturing television in Brazil, when
> the signal is encrypted -- are there set-top boxes or tv capture cards that
> handle the decryption so that the decoded signal is passed on with the
> ISDB-Tb caption stream intact?

This would be very unusual.  Satellite captioning often has the same
issues - the decoders only support overlaying the captions over the
video and provide no means to access the underlying data.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
