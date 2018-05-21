Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:47753 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752803AbeEUQWt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 12:22:49 -0400
Date: Mon, 21 May 2018 18:22:45 +0200
From: =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>
To: Sean Young <sean@mess.org>
CC: <linux-media@vger.kernel.org>, Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 1/3] media: rc: nuvoton: Tweak the interrupt enabling
 dance
Message-ID: <20180521162245.clvdjw7nbq7b6oup@mwiniars-main.ger.corp.intel.com>
References: <20180521143803.25664-1-michal.winiarski@intel.com>
 <20180521155406.i5w4flucxrudblda@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180521155406.i5w4flucxrudblda@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 21, 2018 at 04:54:07PM +0100, Sean Young wrote:
> On Mon, May 21, 2018 at 04:38:01PM +0200, Michał Winiarski wrote:
> > It appears that we need to enable CIR device before attempting to touch
> > some of the registers. Previously, this was not a big issue, since we
> > were rarely seeing nvt_close() getting called.
> > 
> > Unfortunately, since:
> > cb84343fced1 ("media: lirc: do not call close() or open() on unregistered devices")
> > 
> > The initial open() during probe from rc_setup_rx_device() is no longer
> > successful, which means that userspace clients will actually end up
> > calling nvt_open()/nvt_close().
> > And since nvt_open() is broken, the device doesn't seem to work as
> > expected.
> 
> Since that commit was in v4.16, should we have the following:
> 
> Cc: stable@vger.kernel.org # v4.16+
> 
> On this commit (and not the other two, if I understand them correctly)?

Correct. I even had it in the series attached to the bugzilla.
Dropped it because the bug reporters have not confirmed that it fixes their
problem yet. (works for me though...)

-Michał

> 
> Thanks,
> Sean
> 
> > 
> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=199597
> > Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
> > Cc: Jarod Wilson <jarod@redhat.com>
> > Cc: Sean Young <sean@mess.org>
> > ---
> >  drivers/media/rc/nuvoton-cir.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
