Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay04.ispgateway.de ([80.67.31.38]:47889 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbZKFJdv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Nov 2009 04:33:51 -0500
Date: Fri, 6 Nov 2009 10:30:37 +0100
From: Lars Noschinski <lars@public.noschinski.de>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Subject: Re: pac7311
Message-ID: <20091106093037.GA2956@lars.home.noschinski.de>
References: <20091105233843.GA27459@lars.home.noschinski.de> <20091106083626.3fbe8428@tele>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091106083626.3fbe8428@tele>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

* Jean-Francois Moine <moinejf@free.fr> [09-11-06 09:43]:
> On Fri, 6 Nov 2009 00:38:43 +0100
> Lars Noschinski <lars@public.noschinski.de> wrote:
> 
> > I'm using a webcam which identifies itself as
> > 
> >     093a:2603 Pixart Imaging, Inc. PAC7312 Camera
> > 
> > and is sort-of supported by the gspca_pac7311 module. "sort-of"
> > because the image alternates quickly between having a red tint or a
> > green tint (using the gspca driver from
> > http://linuxtv.org/hg/~jfrancois/gspca/ on a 2.6.31 kernel; occurs
> > also with plain 2.6.31).

It is Philipps SPC500NC.

> > Is there something I can do to debug/fix this problem?

First of all, 
> 
> First, which viewer do you run and does it use the v4l2 library?

I'm using ekiga which uses libpt's v4l2 support. The libpt package
depends on the libv4l package, which contains libv4l2, so it probably
uses the v4l2 library.

I could try another viewer for debugging, if this is of any use, but
ekiga is what I care about.

> Then, a bug in the pac7311 driver has been found yesterday. Did you
> get/try this last one?

Tip of my tree is 13436:f353aa2982f2, which seems to be the latest one.

After rebooting my computer this morning, the cam worked for a few
minutes without those color glitches. Then, after turning off the light
in my room and turning it on again, the image started alternating
quickly between light and dark.  I tried to get rid of it with
re-plugging the device, but this soon led to the original problem
(red/green tints). I tried another reboot, but no luck.

 - Lars.
