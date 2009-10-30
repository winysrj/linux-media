Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:2018 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088AbZJ3TxA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Oct 2009 15:53:00 -0400
Received: by ey-out-2122.google.com with SMTP id d26so96816eyd.19
        for <linux-media@vger.kernel.org>; Fri, 30 Oct 2009 12:53:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1256932132.3563.12.camel@andy-laptop>
References: <1256932132.3563.12.camel@andy-laptop>
Date: Fri, 30 Oct 2009 15:53:03 -0400
Message-ID: <829197380910301253w5e94a313idb942ad5336b2640@mail.gmail.com>
Subject: Re: [linux-dvb] Possible error in firedtv-1394.o?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 30, 2009 at 3:48 PM, Andreas Breitbach
<andreas.breitbach@gmail.com> wrote:
> Hello all.
>
> I subscribed to this mailing list to report a possible error in the
> above mentioned module. For your better understanding, some details
> about my situation: I upgraded yesterday from Jaunty(Ubuntu) to the new
> Karmic. I had a "0ccd:0069 TerraTec Electronic GmbH Cinergy T XE DVB-T
> Receiver"(lsusb output), which worked with the drivers avaible from
> http://linuxtv.org/hg/~anttip/. After the upgrade, I tried to compile
> and install the modules necessary for the stick by entering "make all".
> It compiles til reaching firedtv-1394.o, I attached the output, which
> complains about this specific module.
> As I'm not a programmer, but rather a normal user who clued together how
> to get this stick working once, I fear I can not be of much help in
> debugging. Nonetheless, I'd be very interested in knowing about the
> status of this and when my TV will be back working(or how I could
> circumvent this error).

Hi Andy,

Yeah, this is a known issue with the build process under Karmic.  The
iee1394 is enabled by default but Karmic's packaging of the kernel
headers is missing some files that are needed by the firedtv driver.

To workaround the issue, I usually just open v4l/.config and change
the firedtv driver from "=m" to "=n".

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
