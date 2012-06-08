Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61434 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2FHHVP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jun 2012 03:21:15 -0400
Received: by bkcji2 with SMTP id ji2so1435225bkc.19
        for <linux-media@vger.kernel.org>; Fri, 08 Jun 2012 00:21:13 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 8 Jun 2012 09:21:13 +0200
Message-ID: <CACKLOr2jQMnBPTaTFOcfLN_9J1n39tLx-ffDcVGuZ4ZB-odYfg@mail.gmail.com>
Subject: [RFC] Support for H.264/MPEG4 encoder (VPU) in i.MX27.
From: javier Martin <javier.martin@vista-silicon.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-media@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
	Shawn Guo <shawn.guo@linaro.org>,
	Dirk Behme <dirk.behme@googlemail.com>,
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fabio,

On 8 June 2012 08:51, javier Martin <javier.martin@vista-silicon.com> wrote:
> Hi Fabio,
>
> On 7 June 2012 19:35, Fabio Estevam <festevam@gmail.com> wrote:
>> Hi Javier,
>>
>> On Thu, Jun 7, 2012 at 5:30 AM, javier Martin
>> <javier.martin@vista-silicon.com> wrote:
>>
>>> As i stated, the driver is still in an early development stage, it
>>> doesn't do anything useful yet. But this is the public git repository
>>> if you want to take a look:
>>>
>>> git repo: https://github.com/jmartinc/video_visstrim.git
>>> branch:  mx27-codadx6
>>
>> Thanks, I will take a look at your tree when I am back to the office next week.
>>
>> I also see that Linaro's tree has support for VPU for mx5/mx6:
>> http://git.linaro.org/gitweb?p=landing-teams/working/freescale/kernel.git;a=summary
>>
>> ,so we should probably think in unifying it with mx27 support there too.

If you refer to driver in [1] I have some concerns: i.MX27 VPU should
be implemented as a V4L2 mem2mem device since it gets raw pictures
from memory and outputs encoded frames to memory (some discussion
about the subject can be fond here [2]), as Exynos driver from Samsung
does. However, this driver you've mentioned doesn't do that: it just
creates several mapping regions so that the actual functionality is
implemented in user space by a library provided by Freescale, which
regarding i.MX27 it is also GPL.

What we are trying to do is implementing all the functionality in
kernel space using mem2mem V4L2 framework so that it can be accepted
in mainline.

Please, correct me if the driver you are talking about is not the one in [1].

Regards.

[1] http://git.linaro.org/gitweb?p=landing-teams/working/freescale/kernel.git;a=blob;f=drivers/mxc/vpu/mxc_vpu.c;h=27b09e56d5a3f6cb7eeba16fe5493cbec46c65cd;hb=d0f289f67f0ff403d92880c410b009f1fd4e69f3
[2] http://www.mail-archive.com/linux-media@vger.kernel.org/msg36555.html

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
