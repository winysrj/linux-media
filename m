Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:59196 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933743Ab0CLRjw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 12:39:52 -0500
Received: by bwz1 with SMTP id 1so1259004bwz.21
        for <linux-media@vger.kernel.org>; Fri, 12 Mar 2010 09:39:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B9A794F.3040204@gmail.com>
References: <4AAF568D.1070308@gmail.com> <4AB3B43A.2030103@gmail.com>
	 <4AB3B947.1040202@kernellabs.com> <4AB3C17D.1030300@gmail.com>
	 <4AB3C8E5.4010700@kernellabs.com> <4AB3CDC2.20505@gmail.com>
	 <4B968267.3090808@gmail.com> <4B990E76.2010603@kernellabs.com>
	 <4B9A794F.3040204@gmail.com>
Date: Fri, 12 Mar 2010 12:39:50 -0500
Message-ID: <829197381003120939x307462dm2880635a6516bf67@mail.gmail.com>
Subject: Re: Hw capabilities of the HVR-2200
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jed <jedi.theone@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 12, 2010 at 12:26 PM, Jed <jedi.theone@gmail.com> wrote:
> Considering that in the specs for the reference card it was highlighted
> as part of the silicon... Wouldn't it be safe to assume that it's
> something that'd be unlocked by drivers?
>
> But if that were true, what is their motivation in not wanting to enable
> it? (assuming they still haven't)

The features of a given piece of silicon do not always match what a
company has ultimately licensed.  This is especially true for things
like codec support which can have significant royalties that have to
be paid.  Hence it's possible that while the chip *in theory* could
support some particular codec, that doesn't mean that the firmware
that ultimately got licensed has the necessary support.

Regarding component support, it's entirely possible that although the
chip supports it, it may have been cost prohibitive to put the
supporting hardware on the PCB.  It's ultimately up to the product
vendor to decide what subset of the functionality on the reference
design to ship with.

Of course, everything I said in the above is complete speculation
(based on my own previous experience working for a company that makes
hardware), as I have no actual knowledge of why they chose to take the
approach they did.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
