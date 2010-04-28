Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:35026 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab0D1Ult (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Apr 2010 16:41:49 -0400
Date: Wed, 28 Apr 2010 13:41:12 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] IR/imon: add proper auto-repeat support
Message-ID: <20100428204112.GA6663@core.coreip.homeip.net>
References: <20100428173700.GA14240@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428173700.GA14240@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 28, 2010 at 01:37:00PM -0400, Jarod Wilson wrote:
> Set the EV_REP bit, so reported key repeats actually make their
> way out to userspace, and fix up the handling of repeats a bit,
> routines for which are shamelessly heisted from ati_remote2.c.
>

Is it really needed? I'd expect input core handling auto-repeating
for you as long as you set EV_REP flag.

-- 
Dmitry
