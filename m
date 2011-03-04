Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61749 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932677Ab1CDWtF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 17:49:05 -0500
Received: by wyg36 with SMTP id 36so2574708wyg.19
        for <linux-media@vger.kernel.org>; Fri, 04 Mar 2011 14:49:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D716B15.6090609@redhat.com>
References: <201102171606.58540.laurent.pinchart@ideasonboard.com>
	<4D7164C6.9080503@redhat.com>
	<AANLkTi=p6S0CYv6=E51LHJprp1AZpd+ZymiVywaaUWOy@mail.gmail.com>
	<4D716B15.6090609@redhat.com>
Date: Sat, 5 Mar 2011 00:49:04 +0200
Message-ID: <AANLkTi=2S2FUJmafdgz--ujKLXdyBZ4DVz1nbFzkU2DL@mail.gmail.com>
Subject: Re: [GIT PULL FOR 2.6.39] Media controller and OMAP3 ISP driver
From: David Cohen <dacohen@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org,
	Sakari Ailus <sakari.ailus@retiisi.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, Mar 5, 2011 at 12:43 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 04-03-2011 19:33, David Cohen escreveu:
>> Hi Mauro,
>>
>> On Sat, Mar 5, 2011 at 12:16 AM, Mauro Carvalho Chehab
>> <mchehab@redhat.com> wrote:
>>> Hi Laurent,
>>>
>>> Em 17-02-2011 13:06, Laurent Pinchart escreveu:
>>>> Hi Mauro,
>>>>
>>>> The following changes since commit 85e2efbb1db9a18d218006706d6e4fbeb0216213:
>>>>
>>>>   Linux 2.6.38-rc5 (2011-02-15 19:23:45 -0800)
>>>>
>>>> are available in the git repository at:
>>>>   git://linuxtv.org/pinchartl/media.git media-0005-omap3isp
>>>
>>> I've added the patches that looked ok on my eyes at:
>>>
>>> http://git.linuxtv.org/mchehab/experimental.git?a=shortlog;h=refs/heads/media_controller
>>>
>>> There are just a few small adjustments on a few of them, as I've commented.
>>> I prefer if you do them on separate patches, to save my work of not needing
>>> to review the entire series again.
>>>
>>> The ones still pending on my quilt tree are:
>>>
>>> 0030-v4l-subdev-Generic-ioctl-support.patch
>>> 0040-omap3isp-OMAP3-ISP-core.patch
>>> 0041-omap3isp-Video-devices-and-buffers-queue.patch
>>> 0042-omap3isp-CCP2-CSI2-receivers.patch
>>> 0043-omap3isp-CCDC-preview-engine-and-resizer.patch
>>> 0044-omap3isp-Statistics.patch
>>> 0045-omap3isp-Kconfig-and-Makefile.patch
>>> 0046-omap3isp-Add-set-performance-callback-in-isp-platfor.patch
>>>
>>> with the following diffstat:
>>>
>>>  Documentation/video4linux/v4l2-framework.txt       |    5 +
>>>  MAINTAINERS                                        |    6 +
>>>  drivers/media/video/Kconfig                        |   13 +
>>>  drivers/media/video/Makefile                       |    2 +
>>>  drivers/media/video/omap3-isp/Makefile             |   13 +
>>>  drivers/media/video/omap3-isp/cfa_coef_table.h     |   61 +
>>>  drivers/media/video/omap3-isp/gamma_table.h        |   90 +
>>>  drivers/media/video/omap3-isp/isp.c                | 2220 +++++++++++++++++++
>>>  drivers/media/video/omap3-isp/isp.h                |  428 ++++
>>>  drivers/media/video/omap3-isp/ispccdc.c            | 2268 ++++++++++++++++++++
>>>  drivers/media/video/omap3-isp/ispccdc.h            |  219 ++
>>>  drivers/media/video/omap3-isp/ispccp2.c            | 1173 ++++++++++
>>>  drivers/media/video/omap3-isp/ispccp2.h            |   98 +
>>>  drivers/media/video/omap3-isp/ispcsi2.c            | 1317 ++++++++++++
>>>  drivers/media/video/omap3-isp/ispcsi2.h            |  166 ++
>>>  drivers/media/video/omap3-isp/ispcsiphy.c          |  247 +++
>>>  drivers/media/video/omap3-isp/ispcsiphy.h          |   74 +
>>>  drivers/media/video/omap3-isp/isph3a.h             |  117 +
>>>  drivers/media/video/omap3-isp/isph3a_aewb.c        |  374 ++++
>>>  drivers/media/video/omap3-isp/isph3a_af.c          |  429 ++++
>>>  drivers/media/video/omap3-isp/isphist.c            |  520 +++++
>>>  drivers/media/video/omap3-isp/isphist.h            |   40 +
>>>  drivers/media/video/omap3-isp/isppreview.c         | 2113 ++++++++++++++++++
>>>  drivers/media/video/omap3-isp/isppreview.h         |  214 ++
>>>  drivers/media/video/omap3-isp/ispqueue.c           | 1153 ++++++++++
>>>  drivers/media/video/omap3-isp/ispqueue.h           |  187 ++
>>>  drivers/media/video/omap3-isp/ispreg.h             | 1589 ++++++++++++++
>>>  drivers/media/video/omap3-isp/ispresizer.c         | 1693 +++++++++++++++
>>>  drivers/media/video/omap3-isp/ispresizer.h         |  147 ++
>>>  drivers/media/video/omap3-isp/ispstat.c            | 1092 ++++++++++
>>>  drivers/media/video/omap3-isp/ispstat.h            |  169 ++
>>>  drivers/media/video/omap3-isp/ispvideo.c           | 1255 +++++++++++
>>>  drivers/media/video/omap3-isp/ispvideo.h           |  202 ++
>>>  drivers/media/video/omap3-isp/luma_enhance_table.h |   42 +
>>>  drivers/media/video/omap3-isp/noise_filter_table.h |   30 +
>>>  drivers/media/video/v4l2-subdev.c                  |    2 +-
>>>  drivers/media/video/videobuf-dma-contig.c          |    2 +-
>>>  include/linux/Kbuild                               |    1 +
>>>  38 files changed, 19769 insertions(+), 2 deletions(-)
>>>
>>> I used quilt for all patches, except for the one patch with some gifs, where I did a
>>> git cherry-pick. So, the imported patches should be ok. Of course, it doesn't hurt
>>> do double check.
>>>
>>> The main issue with the omap3isp is due to the presence of private ioctl's that
>>> I don't have a clear idea about what they are really doing.
>>>
>>> I couldn't see any documentation about them on a very quick look. While I suspect
>>> that they are used only for 3A, I have no means of being sure about that.
>>>
>>> Also, as I've said several times, while I don't like, I have nothing against
>>> having some ioctls that would be used by a vendor to implement their own 3A software
>>> algorithms that he may need to hide for some reason or have any patents applied to
>>> the algorithm, but only if:
>>>        1) such algorithms are implemented on userspace;
>>
>> Yes.
>>
>>>        2) the userspace API used by them is fully documented, in order
>>> to allow that someone else with enough motivation and spare time may
>>> want to implement his own algorithm (including an open-source one);
>>
>> The API is pretty close to what is found on public OMAP3 TRM. I'd say
>> it's almost to fill registers through a userspace API.
>
> Ok, so a simple patch adding a txt file documenting those private ioctls
> to Documentation/video4linux explaining how to use them and pointing to
> OMAP3 TRM documentation is enough.

Ok. I'll provide a patch for it.

>
>>>        3) there are no patents denying or charging for the usage and/or
>>> distribution/redistribution of the Kernel with the provided kernel driver;
>>
>> I'd say there's no patent / charge for usage or redistribution. But
>> that's lawyer stuff. :/
>>
>>>        4) if the device works with a reasonable quality without them
>>> (by reasonable I mean like a cheap webcam, where libv4l could use his
>>> set of 3A algorithms to provide a good quality).
>>
>> It depends on the sensor as well, but in general should work with a
>> reasonable quality without using statistic modules.
>>
>>>
>>> Assuming that all those private ioctl's are really for 3A, it is ok for me
>>> to accept such ioctls after being sure that the above applies. I'm not sure
>>> how to check (4), as, while I have 2 omap boards here (a Beagleboard and a
>>> gumstix), none of them have any sensor.
>>
>> The private ioctl are used mostly on statistic modules (3A and
>> Histogram). But it's used for CCDC and Preview modules configuration
>> too.
>
> The issue here is: what if no CCDC and no Preview initialization ever happen?

Currently the driver does not support such situation. Either all
modules successfully initialize or ISP driver doesn't probe correctly.

Regards,

Davd

>
> Cheers,
> Mauro
>
