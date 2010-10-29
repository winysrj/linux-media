Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42211 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761850Ab0J2ULp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Oct 2010 16:11:45 -0400
Received: by vws13 with SMTP id 13so475067vws.19
        for <linux-media@vger.kernel.org>; Fri, 29 Oct 2010 13:11:45 -0700 (PDT)
Subject: Re: [PATCH 0/7] rc-core: ir-core to rc-core conversion
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=iso-8859-1
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <20101029190745.11982.75723.stgit@localhost.localdomain>
Date: Fri, 29 Oct 2010 16:11:42 -0400
Cc: linux-media@vger.kernel.org, mchehab@infradead.org
Content-Transfer-Encoding: 8BIT
Message-Id: <44165E94-F983-430F-8433-80985E1FF21F@wilsonet.com>
References: <20101029190745.11982.75723.stgit@localhost.localdomain>
To: =?iso-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Oct 29, 2010, at 3:07 PM, David Härdeman wrote:

> This is my current patch queue, the main change is to make struct rc_dev
> the primary interface for rc drivers and to abstract away the fact that
> there's an input device lurking in there somewhere. The patchset has been
> updated to apply on top of the staging/for_v2.6.37-rc1 branch of the
> media_tree git repo.
> 
> In addition, the cx88 and winbond-cir drivers are converted to use rc-core.
> 
> The first patch (which is not to be merged) just merges the large scancodes
> patches for the input subsystem to make sure that merging my patches upstream
> will be doable post -rc1 (the input patches are already merged upstream).
> 
> Given the changes, these patches touch every single driver. Obviously I
> haven't tested them all due to a lack of hardware (I have made sure that
> all drivers compile without any warnings and I have tested the end result
> on mceusb and winbond-cir hardware).

You can definitely sign me up for imon, streamzap and nuvoton-cir testing, and for sanity's sake, I can also verify multiple generations of mceusb devices. I'll see what I can get done on that front this weekend...

-- 
Jarod Wilson
jarod@wilsonet.com



