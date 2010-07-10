Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:14253 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753988Ab0GJNCN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Jul 2010 09:02:13 -0400
Subject: Re: Status of the patches under review at LMML (60 patches)
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LMML <linux-media@vger.kernel.org>, moinejf@free.fr,
	g.liakhovetski@gmx.de, jarod@redhat.com, corbet@lwn.net,
	rz@linux-m68k.org, pboettcher@dibcom.fr, crope@iki.fi,
	davidtlwong@gmail.com, laurent.pinchart@ideasonboard.com,
	eduardo.valentin@nokia.com, p.osciak@samsung.com, liplianin@tut.by,
	isely@isely.net, tobias.lorenz@gmx.net, hdegoede@redhat.com,
	u.kleine-koenig@pengutronix.de, abraham.manu@gmail.com,
	stoth@kernellabs.com, henrik@kurelid.se
In-Reply-To: <4C332A5F.4000706@redhat.com>
References: <4C332A5F.4000706@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Jul 2010 08:59:15 -0400
Message-ID: <1278766755.2273.28.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2010-07-06 at 10:06 -0300, Mauro Carvalho Chehab wrote:
> This is the summary of the patches that are currently under review at 
> Linux Media Mailing List <linux-media@vger.kernel.org>.
> Each patch is represented by its submission date, the subject (up to 70
> chars) and the patchwork link (if submitted via email).
> 
> P.S.: This email is c/c to the developers where some action is expected.
>       If you were copied, please review the patches, acking/nacking or
>       submitting an update.
> 

> 		== Andy Walls <awalls@radix.net> and Aleksandr Piskunov <aleksandr.v.piskunov@gmail.com> are discussing around the solution == 
> 
> Oct,11 2009: AVerTV MCE 116 Plus radio
> http://patchwork.kernel.org/patch/52981
> 
> 		== Waiting for Andy Walls <awalls@md.metrocast.net> == 

At the end of the thread both Aleksandr and I concluded that adding 50
ms or more to each frequency change was not a good thing to do.  Please
mark this patach not to be merged.  There is not alternative solution at
the moment.



> Apr,10 2010: cx18: "missing audio" for analog recordings
> http://patchwork.kernel.org/patch/91879

The patch at patchwork is obsolete.  Please mark it not to be merged.

The audio problem still exists and I was working a solution with Mark
Lord testing, but I haven't done any work on it for a few months.  The
current fix, for NTSC with BTSC audio, is at least the first two of the
three patches here:

	http://linuxtv.org/hg/~awalls/cx18-audio2/

Mark reported the 3rd patch broke things.

Anyone with access to a bona-fide BTSC stereo broadcast signal (which a
STB will not produce) feel free to test.




On a general note for all CX2584x and CX23418 audio standard
auto-detection problems:  without the problem analog signals and
detailed specifications on the Merlin audio decoder core, I am not in a
good position to fix these audio standard detection problems with these
devices.

Regards,
Andy

