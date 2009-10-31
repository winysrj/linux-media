Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.216.179]:43659 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608AbZJaBni (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Oct 2009 21:43:38 -0400
Received: by pxi9 with SMTP id 9so2160588pxi.4
        for <linux-media@vger.kernel.org>; Fri, 30 Oct 2009 18:43:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <702870ef0910301842i4e68f42rdd82b3ab25ed6e64@mail.gmail.com>
References: <1256932132.3563.12.camel@andy-laptop>
	 <829197380910301253w5e94a313idb942ad5336b2640@mail.gmail.com>
	 <702870ef0910301842i4e68f42rdd82b3ab25ed6e64@mail.gmail.com>
Date: Sat, 31 Oct 2009 12:43:43 +1100
Message-ID: <702870ef0910301843s4e844948h9a476cb57a7f88a1@mail.gmail.com>
Subject: Fwd: [linux-dvb] Possible error in firedtv-1394.o?
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

oops, forgot to reply to the list.

---------- Forwarded message ----------
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
Date: Sat, 31 Oct 2009 12:42:25 +1100
Subject: Re: [linux-dvb] Possible error in firedtv-1394.o?
To: Devin Heitmueller <dheitmueller@kernellabs.com>

I hit this too. To be a bit more explicit for those following along, I did this:

  make update;
  make distclean; make   # wait for it to fall over
  vi v4l/.config                  # set  CONFIG_DVB_FIREDTV=n
  make clean; make        # now it builds cleanly
  sudo make install

thanks for the tip Devin.

On 10/31/09, Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
> On Fri, Oct 30, 2009 at 3:48 PM, Andreas Breitbach
> <andreas.breitbach@gmail.com> wrote:
>> Hello all.
>>
>> I subscribed to this mailing list to report a possible error in the
>> above mentioned module. For your better understanding, some details
>> about my situation: I upgraded yesterday from Jaunty(Ubuntu) to the new
>> Karmic. I had a "0ccd:0069 TerraTec Electronic GmbH Cinergy T XE DVB-T
>> Receiver"(lsusb output), which worked with the drivers avaible from
>> http://linuxtv.org/hg/~anttip/. After the upgrade, I tried to compile
>> and install the modules necessary for the stick by entering "make all".
>> It compiles til reaching firedtv-1394.o, I attached the output, which
>> complains about this specific module.
>> As I'm not a programmer, but rather a normal user who clued together how
>> to get this stick working once, I fear I can not be of much help in
>> debugging. Nonetheless, I'd be very interested in knowing about the
>> status of this and when my TV will be back working(or how I could
>> circumvent this error).
>
> Hi Andy,
>
> Yeah, this is a known issue with the build process under Karmic.  The
> iee1394 is enabled by default but Karmic's packaging of the kernel
> headers is missing some files that are needed by the firedtv driver.
>
> To workaround the issue, I usually just open v4l/.config and change
> the firedtv driver from "=m" to "=n".
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
