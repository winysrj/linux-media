Return-path: <linux-media-owner@vger.kernel.org>
Received: from gate2.ipvision.dk ([94.127.49.3]:45159 "EHLO gate2.ipvision.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755502Ab2JaW04 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Oct 2012 18:26:56 -0400
From: Benny Amorsen <benny+usenet@amorsen.dk>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: Frank =?utf-8?Q?Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 00/23] em28xx: add support fur USB bulk transfers
References: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
	<m3vcdr1ku9.fsf@ursa.amorsen.dk> <50911079.7010404@googlemail.com>
	<m3pq3ywh0w.fsf@ursa.amorsen.dk>
	<CALF0-+Xzb_HULqQLkG3OZaG-9bfe7vaLX5nRdgBSehkbyvRqLA@mail.gmail.com>
Date: Wed, 31 Oct 2012 23:26:51 +0100
In-Reply-To: <CALF0-+Xzb_HULqQLkG3OZaG-9bfe7vaLX5nRdgBSehkbyvRqLA@mail.gmail.com>
	(Ezequiel Garcia's message of "Wed, 31 Oct 2012 17:25:12 -0300")
Message-ID: <m3625qwa50.fsf@ursa.amorsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ezequiel Garcia <elezegarcia@gmail.com> writes:

> Very interesting. Let me see if I understand this: you say it's not a
> problem with USB bandwidth, but with isochronous transfers, in the
> sense it could achieve enough speed for streaming if bulk transfers
> were used?

It is more of a hope than a statement... I have no proof.

> Do you have any links supporting this?

Only old stuff like http://www.mail-archive.com/linux-usb@vger.kernel.org/msg04232.html

There are quite a few reports of problems with USB cameras in general
and Kinect in particular. That seems to point at problems with
isochronous transfers. A typical USB camera does not need particularly
much bandwidth.

The Nanostick only needs 40Mbps + overhead for me -- the size of the
largest MUX in the UK currently. That is less than 10% of the 480Mbps
theoretically available.

The other problem reports tend to be about "full speed" (11Mbps) USB
devices which are difficult for the Pi hardware to handle. Most of the
reports are getting old, some have reported that driver upgrades fixed
the problems.

I believe most people experience stable ethernet performance (and the
ethernet is USB attached as you are undoubtedly aware). That is a lot
more demanding than a USB camera or a Nanostick. However, the ethernet
chip uses bulk transfers, not isochronous ones.


/Benny

