Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:49475 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab0BJTUQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 14:20:16 -0500
Received: by bwz19 with SMTP id 19so437745bwz.28
        for <linux-media@vger.kernel.org>; Wed, 10 Feb 2010 11:20:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <f535cc5a1002101102w146050c5v91ddc6ec86542153@mail.gmail.com>
References: <f535cc5a1002100021u37bf47a5y50a0a90873a082e2@mail.gmail.com>
	 <f535cc5a1002101058h4d8e4bd1p6fd03abd4f724f52@mail.gmail.com>
	 <f535cc5a1002101101k709bbe9bv504cf33fab14dedc@mail.gmail.com>
	 <f535cc5a1002101102w146050c5v91ddc6ec86542153@mail.gmail.com>
Date: Wed, 10 Feb 2010 14:20:14 -0500
Message-ID: <829197381002101120v76e5ad9w28283bbaafc941c4@mail.gmail.com>
Subject: Re: Want to help in MSI TV VOX USB 2.0
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Carlos Jenkins <carlos.jenkins.perez@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 10, 2010 at 2:02 PM, Carlos Jenkins
<carlos.jenkins.perez@gmail.com> wrote:
> Hi everyone.
>
> First of all, great job :)
>
> My name is Carlos Jenkins, and I'm here to help getting to work the
> MSI TV VOX 8609 USB 2.0 device once again. I know it's an old device,
> but here where I live, in Costa Rica, we still have analog TV only.
>
> TV Standard: NTSC
>
> This device is a em2820/SAA7114H device, I'm sure, I opened it and
> looked at the chips :P
<snip>

Try card=9, and make sure you have tvtime configured to the correct
video standard *before* starting it up (you may need to run the
tvtime-configure command line tool).

Devin


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
