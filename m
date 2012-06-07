Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49793 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab2FGIac (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2012 04:30:32 -0400
Received: by yhmm54 with SMTP id m54so209816yhm.19
        for <linux-media@vger.kernel.org>; Thu, 07 Jun 2012 01:30:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOMZO5BA9pT0vwXT1zr+-fjHr5eT6eTYEzsKbrCs8rzxiQCwWg@mail.gmail.com>
References: <1338905173-5968-1-git-send-email-javier.martin@vista-silicon.com>
	<CAOMZO5AnR9e9O+A+8zH+W+3pa0=cey=9wL0Oa2z+YrhYadvQ1w@mail.gmail.com>
	<CACKLOr28+2pQqOKyVP728kiD2BAnCzkMFgNL=059jmTpeFvQHg@mail.gmail.com>
	<CAOMZO5BA9pT0vwXT1zr+-fjHr5eT6eTYEzsKbrCs8rzxiQCwWg@mail.gmail.com>
Date: Thu, 7 Jun 2012 10:30:31 +0200
Message-ID: <CACKLOr1_pOSkMfo7xWMPd4qJvo8MgNa-dswWVKGBx=enaEB2CQ@mail.gmail.com>
Subject: Re: [PATCH] media: mx2_camera: Add YUYV output format.
From: javier Martin <javier.martin@vista-silicon.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,

On 5 June 2012 16:17, Fabio Estevam <festevam@gmail.com> wrote:
> On Tue, Jun 5, 2012 at 11:14 AM, javier Martin
> <javier.martin@vista-silicon.com> wrote:
>
>> No, I'm still working on it in my spare time. Progress is rather slow.
>
> Ok, great. If you want to collaborate on this task, I will be glad to help.
>
> Let me know if you have a git tree with your work in progress.

As i stated, the driver is still in an early development stage, it
doesn't do anything useful yet. But this is the public git repository
if you want to take a look:

git repo: https://github.com/jmartinc/video_visstrim.git
branch:  mx27-codadx6

FYI we are only interested on adding support for the encoding path of
the VPU, but we are trying our best to make it modular (as it is done
in Samsung's [1]), so that anyone can add decoding support later.

By the way, you work for Freescale, don't you?

We have a couple of issues with the i.MX27 VPU:

1- Firmware for the VPU is provided as a table of binary values inside
a source file which is licensed as GPL, however software is packaged
in a .tar.gz file that is marked as NDA. Do we have the right to
distribute this firmware with our products?
2- There is a BUG in the firmware that marks P frames as IDR when it
should only be done to I frames. Would it be possible to have access
to the source code of the firmware in order to fix that problem?

Regards.

[1] http://lxr.linux.no/#linux+v3.4.1/drivers/media/video/s5p-mfc/

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
