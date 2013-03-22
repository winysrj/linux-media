Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qe0-f49.google.com ([209.85.128.49]:47333 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab3CVS4i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Mar 2013 14:56:38 -0400
Received: by mail-qe0-f49.google.com with SMTP id 1so2527623qec.8
        for <linux-media@vger.kernel.org>; Fri, 22 Mar 2013 11:56:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201303221738.16145.hverkuil@xs4all.nl>
References: <201303221738.16145.hverkuil@xs4all.nl>
Date: Fri, 22 Mar 2013 14:50:28 -0400
Message-ID: <CAGoCfiwjF-C_sbivVi_+JST32BykFXSnKzpmZ0q5W3H-pGOzsw@mail.gmail.com>
Subject: Re: [GIT PULL FOR v3.10] au0828 driver overhaul
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 22, 2013 at 12:38 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> It works fine with qv4l2, but there is still a bug causing tvtime to fail.
> That's caused by commit e58071f024aa337b7ce41682578b33895b024f8b, applied
> August last year, that broke g_tuner: after that 'signal' would always be 0
> and tvtime expects signal to be non-zero for a valid frequency. The signal
> field is set by the au8522, but g_tuner is only called for the tuner (well,
> also for au8522 but since the i2c gate is set for the tuner that won't do
> anything).

Wait, are you saying that the G_TUNER call is no longer being routed
to the au8522 driver?  The signal level has always been set to a
nonzero value by au8522 if a signal is present, and thus the state of
the i2c gate isn't relevant.  This is because the xc5000 driver didn't
actually have implemented a call to return the signal level.

If what you're saying is true, then the behavior of the framework
itself changed, and who knows what else is broken.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
