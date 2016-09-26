Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:36933 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965343AbcIZJJM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Sep 2016 05:09:12 -0400
Received: by mail-wm0-f53.google.com with SMTP id b130so137308097wmc.0
        for <linux-media@vger.kernel.org>; Mon, 26 Sep 2016 02:09:11 -0700 (PDT)
From: Ajith Raj <ajith.raj@broadcom.com>
References: fa5d00935992850a08707a180aa6de97@mail.gmail.com
 <0afd07b4dc410140902808df6b909507@mail.gmail.com> f720c5ea1417467d9af6f214bfb0462f@mail.gmail.com
In-Reply-To: f720c5ea1417467d9af6f214bfb0462f@mail.gmail.com
MIME-Version: 1.0
Date: Mon, 26 Sep 2016 14:39:06 +0530
Message-ID: <3461d4fdf32e5b3a645419f0f3b1eb5b@mail.gmail.com>
Subject: [Camera Driver] Building as Static v/s Dynamic module
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, mchehab@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maintainers,

I was working on a CPI based camera driver based on soc_camera framework
which is compiled as a static module in kernel, due to the non-availability
of modprobe framework.
While I was pushing the changes, I got a question from the internel  code
review that why the driver is being compiled as static while all other
drivers available in the open source are compiled as dynamic .ko modules.

I understand that camera as a component need not have to be built static an=
d
can be added later on the need basis. Is there any reason apart from this?
Since the modprobe framework is not available, if I build it as dynamic .ko
module, I need to insert all dependent modules independently and in the
right order. There are many;

videobuf2-dma-contig.ko, videobuf2-v4l2.ko, videobuf2-memops.ko,
videobuf2-vmalloc.ko, =E2=80=A6..etc
v4l2-common.ko, v4l2-mem2mem.ko, v4l2-dv-timings.ko
soc_mediabus.ko,soc_camera.ko ,=E2=80=A6=E2=80=A6etc
media.ko, videodev.ko

Do you see any issues in submitting camera as a static module?
Or it has to be dynamic? If so, could you please help me understand the
reasons.

Thanks in advance.

Regards,
Ajith
