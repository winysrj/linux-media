Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64362 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab2FTIJb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jun 2012 04:09:31 -0400
Received: by yenl2 with SMTP id l2so4976657yen.19
        for <linux-media@vger.kernel.org>; Wed, 20 Jun 2012 01:09:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOMZO5AOEdVpSvV2bnbw6bwGb8+83Zji3jkTjH01yaC7pZUGvA@mail.gmail.com>
References: <1340115094-859-1-git-send-email-javier.martin@vista-silicon.com>
	<CAOMZO5AOEdVpSvV2bnbw6bwGb8+83Zji3jkTjH01yaC7pZUGvA@mail.gmail.com>
Date: Wed, 20 Jun 2012 10:09:30 +0200
Message-ID: <CACKLOr2LHGmorUgPJvVH_caVLcRyFTU4MgQ1YAjgyCWqrRCGUQ@mail.gmail.com>
Subject: Re: [RFC] Support for 'Coda' video codec IP.
From: javier Martin <javier.martin@vista-silicon.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kernel@pengutronix.de, fabio.estevam@freescale.com,
	shawn.guo@linaro.org, dirk.behme@googlemail.com,
	r.schwebel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,

On 20 June 2012 05:26, Fabio Estevam <festevam@gmail.com> wrote:
> Hi Javier,
>
> On Tue, Jun 19, 2012 at 11:11 AM, Javier Martin
> <javier.martin@vista-silicon.com> wrote:
>> This patch adds support for the video encoder present
>> in the i.MX27. It currently support encoding in H.264 and
>> in MPEG4 SP. It's working properly in a Visstrim SM10 platform.
>> It uses V4L2-mem2mem framework.
>>
>> A public git repository is available too:
>> git://github.com/jmartinc/video_visstrim.git
>
> I will give it a try and I have some questions:
>
> - How did you generate the VPU firmware?

Using a modified version of the library provided in the SDK of
Freescale. Because of the NDA I can't tell you in an open mailing
list. I'll gladly tell you if you contact me directly using your
Freescale mail account.

As I told you in a previous mail it would be great if you could upload
vpu firmware for the different Freescale chips to the linux-firmware
repository [1] with a LICENSE file as well. Also, it would be
desirable that you fixed the firmware for the VPU in the i.MX27 that
makes some P frames be marked as IDR and only first KEY frames marked
as IDR or provide the code for us to fix it instead.

> - Which userspace application did you use for testing the encoding? Is
> Gstreamer OK to test it?

We use a custom library (V4L2 compatible). Until very recently
Gstreamer didn't support zerocopy. Because of this, the performance of
applications built on top of Gstreamer bundled with i.MX27 SDK was not
good enough for our application. So, we developed our program first
using directly the library provided by Freescale and then we made our
own library compatible with V4L2 API. The consequence is that we do
not have any need for developing a Gstreamer plugin anymore.

[1] http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=summary

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
