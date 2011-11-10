Return-path: <linux-media-owner@vger.kernel.org>
Received: from yop.chewa.net ([91.121.105.214]:55188 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277Ab1KJHIw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 02:08:52 -0500
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: DVBv5 frontend library
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 10 Nov 2011 08:08:50 +0100
From: =?UTF-8?Q?R=C3=A9mi_Denis-Courmont?= <remi@remlab.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@kernellabs.com>
In-Reply-To: <4EBACE27.8000907@redhat.com>
References: <4EBACE27.8000907@redhat.com>
Message-ID: <b0eac44a264432f586edf13983ea6829@chewa.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

   Hello kernel-space friends,



On Wed, 09 Nov 2011 17:01:59 -0200, Mauro Carvalho Chehab

<mchehab@redhat.com> wrote:

> As I've commented with some at the KS, I started writing a new DVB

> library, based on DVBv5.

> It is currently at very early stages. Help and suggestions are welcome.

> 

> It is at:

>

	http://git.linuxtv.org/mchehab/experimental-v4l-utils.git/shortlog/refs/heads/dvb-utils

> 

> It currently doesn't do much, but the hole idea is to offer a library

that

> can easily upgraded to support new standards, and based on DVBv5.



IMHO, adding new standards with DVBv5 is already fairly easy, as opposed

to with DVBv3.



The only issue I've had (while porting VLC to DVBv5) lied in determining

which parameters needed to be set and what values they would accept.



(...)

> The frontend library is inside:

> 	dvb-fe.c  

> 	dvb-fe.h 

> 

> And the pertinent parameters needed by each delivery system is provided

> into a separate header:

> 	dvb-v5-std.h  



As a documentation, it's nice to have. It should also enumerate the legal

values, a bit like V4L2 user controls.



However, I'm not sure how useful it can really be used to abstract away

tuning standards. There are a number of problems remaining:



1) User-space may need localization of parameters names and enumeration

value names. For frequency, we also need a unit, since it depends on the

delivery system. In VLC, we have to replicate and keep the list of

well-known V4L2 controls parameters just so gettext sees them. The same

problem would affect DVB if you carry on with this.



And unfortunately, even if v4l-utils had its own gettext domain, I doubt

it would get as good visibility among translators as end-user applications

have (e.g. VLC has 78 locales as of today).



2) Some user-space are cross-platform, say across Linux DVB and Windows

BDA. Since Windows BDA does not abstract delivery subsystems, such software

cannot leverage dvb-v5-std.h.



3) Some settings are absolutely required (e.g. frequency), some may be

required depending on hardware and/or driver, some are not normally

required to tune. When writing a UI, you need to know that.



4) Systems like DVB-H (R.I.P.) or ATSC-M/H cannot be abstracted

meaningfully as they don't provide a TS feed, so the user-space can't use

them.



5) Unless/Until the library implements scanning and some kind of channel

or transponder abstraction (e.g. unique ID per transponder), it is dubious

that it can really abstract new delivery systems. I mean, the tuning

parameters need to come from somewhere, so the application will have to

know about the delivery systems.





So hmm, that's a lot of problems before I could use that library. Maybe

some other user-space guys are less demanding bitches though :-)



-- 

Rémi Denis-Courmont

http://www.remlab.net/
