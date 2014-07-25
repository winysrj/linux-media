Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:59748 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbaGYUrS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 16:47:18 -0400
Received: by mail-we0-f175.google.com with SMTP id t60so4856943wes.34
        for <linux-media@vger.kernel.org>; Fri, 25 Jul 2014 13:47:17 -0700 (PDT)
From: James Hogan <james@albanarts.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Antti =?ISO-8859-1?Q?Sepp=E4l=E4?= <a.seppala@gmail.com>,
	linux-media@vger.kernel.org,
	David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Jarod Wilson <jarod@redhat.com>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v2 0/9] rc: Add IR encode based wakeup filtering
Date: Fri, 25 Jul 2014 21:46:58 +0100
Message-ID: <1572764.UGr4uaq7NC@radagast>
In-Reply-To: <20140723163936.164aa577.m.chehab@samsung.com>
References: <1394838259-14260-1-git-send-email-james@albanarts.com> <20140723163936.164aa577.m.chehab@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wednesday 23 July 2014 16:39:36 Mauro Carvalho Chehab wrote:
> Em Fri, 14 Mar 2014 23:04:10 +0000
> 
> James Hogan <james@albanarts.com> escreveu:
> > A recent discussion about proposed interfaces for setting up the
> > hardware wakeup filter lead to the conclusion that it could help to have
> > the generic capability to encode and modulate scancodes into raw IR
> > events so that drivers for hardware with a low level wake filter (on the
> > level of pulse/space durations) can still easily implement the higher
> > level scancode interface that is proposed.
> > 
> > I posted an RFC patchset showing how this could work, and Antti Seppälä
> > posted additional patches to support rc5-sz and nuvoton-cir. This
> > patchset improves the original RFC patches and combines & updates
> > Antti's patches.
> > 
> > I'm happy these patches are a good start at tackling the problem, as
> > long as Antti is happy with them and they work for him of course.
> > 
> > Future work could include:
> >  - Encoders for more protocols.
> >  - Carrier signal events (no use unless a driver makes use of it).
> > 
> > Patch 1 adds the new encode API.
> > Patches 2-3 adds some modulation helpers.
> > Patches 4-6 adds some raw encode implementations.
> > Patch 7 adds some rc-core support for encode based wakeup filtering.
> > Patch 8 adds debug loopback of encoded scancode when filter set.
> > Patch 9 (untested) adds encode based wakeup filtering to nuvoton-cir.
> 
> > Changes in v2:
> Any news about this patch series? There are some comments about them,
> so I'll be tagging it as "changes requested" at patchwork, waiting
> for a v3 (or is it already there in the middle of the 49 patches from
> David?).

This patch series seems to have been forgotten. I do have a few changes on top 
of v2 to address the review comments, so as you say I should probably rebase 
and do a v3 at some point.

Cheers
James
