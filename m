Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:39501 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758183AbZKXR46 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Nov 2009 12:56:58 -0500
Received: by fxm5 with SMTP id 5so6099876fxm.28
        for <linux-media@vger.kernel.org>; Tue, 24 Nov 2009 09:57:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1259027346.3871.76.camel@palomino.walls.org>
References: <1257913905.28958.32.camel@palomino.walls.org>
	 <829197380911221904uedc18e5qbc9a37cfcee23b5d@mail.gmail.com>
	 <1258978370.3058.25.camel@palomino.walls.org>
	 <829197380911230909u27f6df33icbbc52c5268a1658@mail.gmail.com>
	 <1259027346.3871.76.camel@palomino.walls.org>
Date: Tue, 24 Nov 2009 12:57:03 -0500
Message-ID: <829197380911240957t5bc93f3esb85bea7a5a12bf04@mail.gmail.com>
Subject: Re: cx18: Reprise of YUV frame alignment improvements
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@radix.net>
Cc: ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 23, 2009 at 8:49 PM, Andy Walls <awalls@radix.net> wrote:
> Of course that's all speculation about the problem.  If you could
> reproduce the condition and then
>
> # echo 271 > /sys/modules/cx18/parameters/debug

Hi Andy,

Thanks for the additional info.  I had to tear down my HVR-1600 test
rig to finish the em28xx PAL support (using a PVR-350 and the CD of
PAL VBI samples you were very kind in sending me), but I should be
able to get back to this early next week.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
