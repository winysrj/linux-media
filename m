Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56125C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1239620659
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:42:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="BcbPdMZK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1239620659
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amarulasolutions.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbeLEKmM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 05:42:12 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:37123 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbeLEKmM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 05:42:12 -0500
Received: by mail-it1-f193.google.com with SMTP id b5so19479439iti.2
        for <linux-media@vger.kernel.org>; Wed, 05 Dec 2018 02:42:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TwuF27VaYgsEQ66NARt3sXmyD+Z9BEMtwBPS0cBRVbY=;
        b=BcbPdMZKXhWXR71BkcOxD7JJ4DRrDu3QbUj2yijLW2zzKpj5lQqFW7S/5xSsuxhpyF
         XwYr6TkHr7ithiMdCg/OVszIwtX8Gb/PPxZStc8dvnmHxd01EOYbgSQX855VhEv6x5yy
         Ahtwmn3G0os82oypVvk5TLd3KzBei/8+Jkfww=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TwuF27VaYgsEQ66NARt3sXmyD+Z9BEMtwBPS0cBRVbY=;
        b=CpcLkT28YKBn/NzZRTUJzeiPEvGtbm65e14r4TZwfNlolum+Ja+xgfVVkCeGANwQRy
         M3tM4DiBRe5Q2MRf2lQF9lYgKTukdztUp8rQR2U1eHfKgsaamUWHGIsXMS+zYRUuhzex
         bKmryjJg6mWKkKIHX6cOSDfYneGiHJP+EnO3kxkqTkW2EM8Tw8a5/SuGQEeAJtW1k4Xu
         G5CX/wPryG6fnzmBqd4RYj7yjWQt2Rfs4sOkB1b4VGtWxfkgLmyHlMn2GyPjDwBCrnNy
         azsV0FMAd6ik4imc1FtuWTdtsaYG/i7QuDWd9gA3Imz9Lyf/rkE8G7xK+UY9kknCannl
         JNOA==
X-Gm-Message-State: AA+aEWYRweiJrdt9KopL/lWTjg308QsJvErdN9WxhXMrDEeM6sl4Pyw8
        t5ML+Rszq0KpTlMVk4PYHjhq0y/L57QrCraUypQiWg==
X-Google-Smtp-Source: AFSGD/U9obVPCmjzwEPFeoNHy0Z3qZXMcCen6WQp6I/x90QGR8c//2H4dZApac2zvkCpd5ejXVCm2lsPFdFnAbjZP/Q=
X-Received: by 2002:a24:10cb:: with SMTP id 194mr15176353ity.173.1544006530043;
 Wed, 05 Dec 2018 02:42:10 -0800 (PST)
MIME-Version: 1.0
References: <20181203100747.16442-1-jagan@amarulasolutions.com> <CAGb2v64B-afrJ=n1td4HsJgtyrr=oxjF3M=pqjuKtp2AU2V0Gw@mail.gmail.com>
In-Reply-To: <CAGb2v64B-afrJ=n1td4HsJgtyrr=oxjF3M=pqjuKtp2AU2V0Gw@mail.gmail.com>
From:   Jagan Teki <jagan@amarulasolutions.com>
Date:   Wed, 5 Dec 2018 16:11:58 +0530
Message-ID: <CAMty3ZAKaQcMhv=0+ZL-_o4xqUkZnu3h9+=COupzVhMmREdcBQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] media/sun6i: Allwinner A64 CSI support
To:     Chen-Yu Tsai <wens@csie.org>
Cc:     Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media <linux-media@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Dec 3, 2018 at 3:44 PM Chen-Yu Tsai <wens@csie.org> wrote:
>
> On Mon, Dec 3, 2018 at 6:07 PM Jagan Teki <jagan@amarulasolutions.com> wrote:
> >
> > This series support CSI on Allwinner A64.
> >
> > The CSI controller seems similar to that of in H3, so fallback
> > compatible is used to load the driver.
> >
> > Unlike other SoC's A64 has set of GPIO Pin gropus SDA, SCK intead
> > of dedicated I2C controller, so this series used i2c-gpio bitbanging.
> >
> > Right now the camera is able to detect, but capture images shows
> > sequence of red, blue line. any suggestion please help.
>
> The CSI controller doesn't seem to work properly at the default
> clock rate of 600 MHz. Dropping it down to 300 MHz, the default
> rate used by the BSP, fixes things.
>
> The BSP also tries to use different clock rates (multiples of 108 MHz)
> according to the captured image size. I've not tried this since the
> driver no longer exports sub-device controls, and I currently don't
> know how to handle that to change the resolution.

I saw 1080p@30 capture is not working, but rest 320x240@30,
640x480@30, 640x480@60, 1280x720@30 with UYVY8_2X8 and YUYV8_2X8 seems
working on 300MHz.

I even tried 1080p on 600MHz but kernel seems crashing
[video4linux2,v4l2 @ 0x2eaa9380] ioctl(VIDIOC_G_PARM): Inappropriate
ioctl for device
[video4linux2,v4l2 @ 0x2eaa9380] Time per frame unknown
[video4linux2,v4l2 @ 0x2eaa9380] Stream #0: not enough frames to
estimate rate; consider increasing probesize
Input #0, video4linux2,v4l2, from '/dev/video0':
  Duration: N/A, start: 44.934807, bitrate: N/A
    Stream #0:0: Video: rawvideo (I420 / 0x30323449), yuv420p,
1920x1080, 1000k tbr, 1000k tbn, 1000k tbc
Stream mapping:
  Stream #0:0 -> #0:0 (rawvideo (native) -> mpeg4 (native))
Press [q] to stop, [?] for help
Output #0, matroska, to 'output_YUYV8_2X8_1920x1080@1_30-new.mkv':
  Metadata:
    encoder         : Lavf57.83.100
    Stream #0:0: Video: mpeg4 (FMP4 / 0x34504D46), yuv420p, 1920x1080,
q=2-31, 200 kb/s, 65535 fps, 1k tbn, 65535 tbc
    Metadata:
      encoder         : Lavc57.107.100 mpeg4
    Side data:
      cpb: bitrate max/min/avg: 0/0/200000 buffer size: 0 vbv_delay: -1
[   45.255793] random: ffmpeg: uninitialized urandom read (4 bytes read)
frame=    4 fps=0.0 q=10.0 size=     150kB time=00:00:00.10
bitrate=12162.7kbits/s speed=0.17x    [   46.115153] ------------[ cut
here ]------------
[   46.119804] kernel BUG at arch/arm64/kernel/traps.c:426!
[   46.125120] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
[   46.130607] Modules linked in:
[   46.133670] CPU: 2 PID: 1630 Comm: ffmpeg Not tainted
4.20.0-rc4-next-20181130-00027-g58d9b3c5c1db-dirty #10
[   46.143497] Hardware name: Amarula A64-Relic (DT)
[   46.148203] pstate: 60000085 (nZCv daIf -PAN -UAO)
[   46.153005] pc : do_undefinstr+0x248/0x260
[   46.157103] lr : do_undefinstr+0x13c/0x260
[   46.161198] sp : ffff000008013bb0
[   46.164513] x29: ffff000008013bb0 x28: ffff800035b30d40
[   46.169827] x27: ffff00000815a758 x26: 0000000000000001
[   46.175141] x25: 0000000000000000 x24: 0000000000000000
[   46.180454] x23: 0000000000000000 x22: ffff000009344140
[   46.185768] x21: 00000000837f8080 x20: ffff000008013c00
[   46.191082] x19: ffff0000091dd000 x18: 0000000000000000
[   46.196395] x17: 0000000000000000 x16: 0000000000000000
[   46.201709] x15: 0000000000000043 x14: 0000000000000341
[   46.207022] x13: 0000000000000400 x12: 0000000000000043
[   46.212336] x11: 0000000000000400 x10: 000000000001234d
[   46.217650] x9 : 0000000000000001 x8 : ffff800037db7900
[   46.222964] x7 : ffff800037db8380 x6 : ffff000008013bf8
[   46.228278] x5 : ffff0000091e8310 x4 : 00000000d5300000
[   46.233592] x3 : 0000000083700000 x2 : 0000000000000000
[   46.238906] x1 : ffff800035b30d40 x0 : 0000000000000005
[   46.244222] Process ffmpeg (pid: 1630, stack limit = 0x(____ptrval____))
[   46.250921] Call trace:
[   46.253371]  do_undefinstr+0x248/0x260
[   46.257125]  el1_undef+0x10/0x70
[   46.260358]  task_tick_fair+0x140/0x548
[   46.264199]  scheduler_tick+0x6c/0x110
[   46.267956]  update_process_times+0x40/0x58
[   46.272144]  tick_sched_handle.isra.5+0x30/0x50
[   46.276677]  tick_sched_timer+0x48/0x98
[   46.280516]  __hrtimer_run_queues+0x11c/0x190
[   46.284875]  hrtimer_interrupt+0xe4/0x240
[   46.288890]  arch_timer_handler_phys+0x30/0x40
[   46.293340]  handle_percpu_devid_irq+0x78/0x130
[   46.297874]  generic_handle_irq+0x24/0x38
[   46.301887]  __handle_domain_irq+0x5c/0xb8
[   46.305986]  gic_handle_irq+0x58/0xb0
[   46.309651]  el0_irq_naked+0x4c/0x54
[   46.313233] Code: b5fff8c0 b94047b5 17ffff9e d503201f (d4210000)
[   46.319338] ---[ end trace 0463ef25f03a52f8 ]---
[   46.323957] Kernel panic - not syncing: Fatal exception in interrupt
[   46.330311] SMP: stopping secondary CPUs
[   46.334240] Kernel Offset: disabled
[   46.337732] CPU features: 0x2,24802004
[   46.341481] Memory Limit: none
