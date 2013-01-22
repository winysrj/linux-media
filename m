Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f43.google.com ([209.85.216.43]:49595 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab3AVNnx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 08:43:53 -0500
Received: by mail-qa0-f43.google.com with SMTP id cr7so7532064qab.16
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2013 05:43:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5AFD6ADC04BAC644902876711A98009E43BCBC54@ASCTECSBS2.asctec.local>
References: <5AFD6ADC04BAC644902876711A98009E43BC3C18@ASCTECSBS2.asctec.local>
	<201301211053.43912.hverkuil@xs4all.nl>
	<5AFD6ADC04BAC644902876711A98009E43BCBC54@ASCTECSBS2.asctec.local>
Date: Tue, 22 Jan 2013 08:36:02 -0500
Message-ID: <CAGoCfiw1oSohcU=LBUxco6A2EmuNi649YiQFPgjnG1r0E4rZmw@mail.gmail.com>
Subject: Re: [cx231xx] Support for Arm / Omap working at all?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jan Stumpf <Jan.Stumpf@asctec.de>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 22, 2013 at 4:38 AM, Jan Stumpf <Jan.Stumpf@asctec.de> wrote:
> Thanks!
>
> I will try it with your patches!
>
> Regards
> Jan

FYI:  the cx231xx driver has worked in the past on ARM platforms,
although I haven't tried the USBLive2 on OMAP specifically.  In fact,
I merged the original driver support upstream as part of a project I
did while developing a product that has it running on ARM.

You may wish to try whatever kernel you have on an x86 platform, as
people have a history of introducing regressions for the USBLive 2 in
the past (I've fixed it multiple times since I originally submitted
the support upstream).  It's possible that it's broken on x86 as well,
and has nothing to do with your being on ARM at all.

Regards,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
