Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:47684 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab3CVSph (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Mar 2013 14:45:37 -0400
Received: by mail-qc0-f169.google.com with SMTP id t2so2033866qcq.14
        for <linux-media@vger.kernel.org>; Fri, 22 Mar 2013 11:45:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201303221738.16145.hverkuil@xs4all.nl>
References: <201303221738.16145.hverkuil@xs4all.nl>
Date: Fri, 22 Mar 2013 14:45:34 -0400
Message-ID: <CAGoCfiyho+--cobfWcFwC-zgpQxbuE_3bJozzRKhqqcXnRyA0w@mail.gmail.com>
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

During your testing, did you bisect the entire media tree or just the
au0828/au8522 driver.  This discovery is pretty damn surprising since
I actively test with tvtime whenever I do any work on that driver.
Are you sure something else in the framework didn't change which
caused breakage for this driver?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
