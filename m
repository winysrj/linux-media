Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3730 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3KDK7w (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 05:59:52 -0500
Message-ID: <52777E15.9050303@xs4all.nl>
Date: Mon, 04 Nov 2013 11:59:33 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org,
	Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v2 00/18] OMAP4 ISS driver
References: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com> <52776BD3.60309@xs4all.nl>
In-Reply-To: <52776BD3.60309@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/04/2013 10:41 AM, Hans Verkuil wrote:
> Hi Laurent,
> 
> For this whole patch series:
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

And also for patches 19-22 :-)

Thanks!

	Hans

> 
> I strongly recommend that you add another patch adding the s_input function.
> It's trivial to do and it will make v4l2-compliance happy :-)
> 
> Fixing the issue with iss_video_try_format() and a missing get_fmt op is nice-to-have,
> but can be done later.
> 
> Regards,
> 
> 	Hans
> 
> On 11/04/2013 01:06 AM, Laurent Pinchart wrote:
>> Hello,
>>
>> This is the second version of the OMAP4 ISS driver patches for inclusion in the
>> mainline kernel. I've addressed most of the comments received on the first
>> version (some of them are still being discussed) in additional patches, except
>> for the file path updates in the documentation that have been squashed with
>> patch 01/18.
>>
>> The OMAP4 ISS driver has lived out of tree for more than two years now. This
>> situation is both sad and resource-wasting, as the driver has been used (and
>> thus) hacked since then with nowhere to send patches to. Time has come to fix
>> the problem.
>>
>> As the code is mostly, but not quite ready for prime time, I'd like to request
>> its addition to drivers/staging/. I've added a (pretty small) TODO file and I
>> commit to cleaning up the code and get it to drivers/media/ where it belongs.
>>
>> I've split the driver in six patches to avoid getting caught in vger's size
>> and to make review slightly easier. Sergio Aguirre is the driver author (huge
>> thanks for that!), I've thus kept his authorship on patches 1/6 to 5/6. Beside
>> minimal changes to make the code compile on v3.12 and updates the file paths in
>> the documentation I've kept Sergio's code unmodified.
>>
>> I don't have much else to add here, let's get this beast to mainline and allow
>> other developers to use the driver and contribute patches. Given that v3.12 has
>> just been released I'm fine with pushing this series back to v3.13.
>>
>> Laurent Pinchart (13):
>>   v4l: omap4iss: Add support for OMAP4 camera interface - Build system
>>   v4l: omap4iss: Don't use v4l2_g_ext_ctrls() internally
>>   v4l: omap4iss: Move common code out of switch...case
>>   v4l: omap4iss: Report device caps in response to VIDIOC_QUERYCAP
>>   v4l: omap4iss: Remove iss_video streaming field
>>   v4l: omap4iss: Set the vb2 timestamp type
>>   v4l: omap4iss: Remove duplicate video_is_registered() check
>>   v4l: omap4iss: Remove unneeded status variable
>>   v4l: omap4iss: Replace udelay/msleep with usleep_range
>>   v4l: omap4iss: Make omap4iss_isp_subclk_(en|dis)able() functions void
>>   v4l: omap4iss: Make loop counters unsigned where appropriate
>>   v4l: omap4iss: Don't initialize fields to 0 manually
>>   v4l: omap4iss: Simplify error paths
>>
>> Sergio Aguirre (5):
>>   v4l: omap4iss: Add support for OMAP4 camera interface - Core
>>   v4l: omap4iss: Add support for OMAP4 camera interface - Video devices
>>   v4l: omap4iss: Add support for OMAP4 camera interface - CSI receivers
>>   v4l: omap4iss: Add support for OMAP4 camera interface - IPIPE(IF)
>>   v4l: omap4iss: Add support for OMAP4 camera interface - Resizer
>>
>>  Documentation/video4linux/omap4_camera.txt   |   60 ++
>>  drivers/staging/media/Kconfig                |    2 +
>>  drivers/staging/media/Makefile               |    1 +
>>  drivers/staging/media/omap4iss/Kconfig       |   12 +
>>  drivers/staging/media/omap4iss/Makefile      |    6 +
>>  drivers/staging/media/omap4iss/TODO          |    4 +
>>  drivers/staging/media/omap4iss/iss.c         | 1462 ++++++++++++++++++++++++++
>>  drivers/staging/media/omap4iss/iss.h         |  153 +++
>>  drivers/staging/media/omap4iss/iss_csi2.c    | 1368 ++++++++++++++++++++++++
>>  drivers/staging/media/omap4iss/iss_csi2.h    |  156 +++
>>  drivers/staging/media/omap4iss/iss_csiphy.c  |  278 +++++
>>  drivers/staging/media/omap4iss/iss_csiphy.h  |   51 +
>>  drivers/staging/media/omap4iss/iss_ipipe.c   |  581 ++++++++++
>>  drivers/staging/media/omap4iss/iss_ipipe.h   |   67 ++
>>  drivers/staging/media/omap4iss/iss_ipipeif.c |  847 +++++++++++++++
>>  drivers/staging/media/omap4iss/iss_ipipeif.h |   92 ++
>>  drivers/staging/media/omap4iss/iss_regs.h    |  883 ++++++++++++++++
>>  drivers/staging/media/omap4iss/iss_resizer.c |  905 ++++++++++++++++
>>  drivers/staging/media/omap4iss/iss_resizer.h |   75 ++
>>  drivers/staging/media/omap4iss/iss_video.c   | 1124 ++++++++++++++++++++
>>  drivers/staging/media/omap4iss/iss_video.h   |  198 ++++
>>  include/media/omap4iss.h                     |   65 ++
>>  22 files changed, 8390 insertions(+)
>>  create mode 100644 Documentation/video4linux/omap4_camera.txt
>>  create mode 100644 drivers/staging/media/omap4iss/Kconfig
>>  create mode 100644 drivers/staging/media/omap4iss/Makefile
>>  create mode 100644 drivers/staging/media/omap4iss/TODO
>>  create mode 100644 drivers/staging/media/omap4iss/iss.c
>>  create mode 100644 drivers/staging/media/omap4iss/iss.h
>>  create mode 100644 drivers/staging/media/omap4iss/iss_csi2.c
>>  create mode 100644 drivers/staging/media/omap4iss/iss_csi2.h
>>  create mode 100644 drivers/staging/media/omap4iss/iss_csiphy.c
>>  create mode 100644 drivers/staging/media/omap4iss/iss_csiphy.h
>>  create mode 100644 drivers/staging/media/omap4iss/iss_ipipe.c
>>  create mode 100644 drivers/staging/media/omap4iss/iss_ipipe.h
>>  create mode 100644 drivers/staging/media/omap4iss/iss_ipipeif.c
>>  create mode 100644 drivers/staging/media/omap4iss/iss_ipipeif.h
>>  create mode 100644 drivers/staging/media/omap4iss/iss_regs.h
>>  create mode 100644 drivers/staging/media/omap4iss/iss_resizer.c
>>  create mode 100644 drivers/staging/media/omap4iss/iss_resizer.h
>>  create mode 100644 drivers/staging/media/omap4iss/iss_video.c
>>  create mode 100644 drivers/staging/media/omap4iss/iss_video.h
>>  create mode 100644 include/media/omap4iss.h
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

