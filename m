Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756551Ab1LESQT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Dec 2011 13:16:19 -0500
Message-ID: <4EDD0A6E.7070807@redhat.com>
Date: Mon, 05 Dec 2011 16:16:14 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "Zhu, Mingcheng" <mingchen@quicinc.com>
CC: "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: V4L2 driver node directory structure under /video directory
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com> <4ED6C5B8.8040803@linuxtv.org> <4ED75F53.30709@redhat.com> <CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com> <4ED7BBA3.5020002@redhat.com> <CAJbz7-1_Nb8d427bOMzCDbRcvwQ3QjD=2KhdPQS_h_jaYY5J3w@mail.gmail.com> <4ED7E5D7.8070909@redhat.com> <4ED805CB.5020302@linuxtv.org> <4ED8B327.9090505@redhat.com> <CAJbz7-2EVgwPY0wkqPVCoOyH2gM_7pf0DzP-Lf4Y65uZpci9GQ@mail.gmail.com> <4ED90BFD.3040805@redhat.com> <3D233F78EE854A4BA3D34C11AD4FAC1FDD141F@nasanexd01b.na.qualcomm.com>
In-Reply-To: <3D233F78EE854A4BA3D34C11AD4FAC1FDD141F@nasanexd01b.na.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05-12-2011 13:40, Zhu, Mingcheng wrote:
> Hi Mauro and Hans,
> For our MSM chipset family we will have multiple capture device drivers. There are two directory layout approaches as:
> Tree type directory structure:
>
>   * /video/msm/camera: for camera driver
>   * /video/msm/wfd: for our wfd driver
>   * Etc.
>
> Flat directory structure:
>
>   * /video/msm: for our existing camera driver
>   * /video/msm_wfd: for our new wfd driver
>
> Both have pros and cons. The tree directory structure groups msm family drivers well but less readable than the flat directory structure. However, the flat directory structure floods the /video directory when all venders add more drivers into it.
> What approach do you suggest/prefer? Looking forward to getting your reply.

Not sure if I understood your question. If by "msm/camera" you're meaning the
sensors drivers,  we're currently putting all camera sensors at /drivers/media/video.
I don't see any reason why those should be under drivers/media/video/msm
(or whatever inside it). Those drivers should use the V4L2 subdev approach and
be capable of being re-used on other drivers, as we don't want to have duplicated
efforts to maintain them at the kernel.

Eventually, we might, in the future, move all of them to some sensor-specific directory.

If you're just referring to two different drivers, it is basically up to you
to choose whatever fits better. If they don't share any common code, it makes
sense to have one different directory under /video. We do this already. For example,
there are several supported Conexant chipsets. Each has their own directory, as they're
completely independent designs and don't share any code between them (well, except for
the risc code generator at drivers/media/video/btcx-risc.c that is shared
by both bttv and cx88 drivers).

On the other hand, if the drivers share several common stuff that are specific
for the MSM chipset, it is likely better to do:
.../video/msm/common
.../video/msm/wfd
	...

E. g. one directory for each driver, and a common directory with the shared
modules.

Regards,
Mauro
