Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab0D1VBH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Apr 2010 17:01:07 -0400
Date: Wed, 28 Apr 2010 17:00:58 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] IR/imon: add proper auto-repeat support
Message-ID: <20100428210058.GO15951@redhat.com>
References: <20100428173700.GA14240@redhat.com>
 <20100428204112.GA6663@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428204112.GA6663@core.coreip.homeip.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 28, 2010 at 01:41:12PM -0700, Dmitry Torokhov wrote:
> On Wed, Apr 28, 2010 at 01:37:00PM -0400, Jarod Wilson wrote:
> > Set the EV_REP bit, so reported key repeats actually make their
> > way out to userspace, and fix up the handling of repeats a bit,
> > routines for which are shamelessly heisted from ati_remote2.c.
> >
> 
> Is it really needed? I'd expect input core handling auto-repeating
> for you as long as you set EV_REP flag.

In my own (albeit brief) testing, the heisted bits don't make a
significant difference, but I had a user say that it helped a bit at
suppressing what he perceived as extraneous repeats being passed through.
In reality, setting a slightly higher rep delay or rep period might be the
better answer here.

Actually, I think I know exactly what was happening for said user. He's
using a device that only supports mce mode, where these devices don't have
a release code, they're timer-based, I think the repeat timeout of 200ms
was triggering an auto-repeat every 33ms for 200ms, thus giving the
appearance of way more repeats than the hardware actually sent.

Okay, lemme rework this patch a bit, I think I can drop all that heisted
crud, and simply bumping the release timer in mce mode by rep period ms
instead of 200ms for repeats should be sufficient. Need to get my imon
device that supports both imon and mce proto back into a state where I can
use it for testing...

-- 
Jarod Wilson
jarod@redhat.com

