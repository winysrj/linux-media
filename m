Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:46870 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499Ab0BBPup convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Feb 2010 10:50:45 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"khilman@deeprootsystems.com" <khilman@deeprootsystems.com>
Date: Tue, 2 Feb 2010 09:50:26 -0600
Subject: RE: [PATCH v3 1/6] V4L - vpfe capture - header files for ISIF driver
Message-ID: <A69FA2915331DC488A831521EAE36FE401630F3053@dlee06.ent.ti.com>
References: <1265063238-29072-1-git-send-email-m-karicheri2@ti.com>
 <1265063238-29072-2-git-send-email-m-karicheri2@ti.com>
 <1265063238-29072-3-git-send-email-m-karicheri2@ti.com>
 <4B675FC3.2050505@redhat.com>
In-Reply-To: <4B675FC3.2050505@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

If you scan the patch, you would see the status of this patch series. 

>> ---
>> Applies to linux-next tree of v4l-dvb
>>  - rebasing to latest for merge (v3)

Not sure if there is a better way to include this information. The arch part
of this series requires sign-off from Kevin who is copied on this. I have
seen your procedure for submitting patches and would send you an official
pull request as per your procedure once Kevin sign-off the arch part.

I have following questions though..

Should we always add [RFC PATCH] in the subject? It makes sense for
patches being reviewed. How to request sign-off? Do I only send patches
to the person, not to the list?


Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Mauro Carvalho Chehab [mailto:mchehab@redhat.com]
>Sent: Monday, February 01, 2010 6:12 PM
>To: Karicheri, Muralidharan
>Cc: linux-media@vger.kernel.org
>Subject: Re: [PATCH v3 1/6] V4L - vpfe capture - header files for ISIF
>driver
>
>m-karicheri2@ti.com wrote:
>> From: Murali Karicheri <m-karicheri2@ti.com>
>>
>> This is the header file for ISIF driver on DM365.  ISIF driver is
>equivalent
>> to CCDC driver on DM355 and DM644x. This driver is tested for
>> YUV capture from TVP514x driver. This patch contains the header files
>required for
>> this driver. The name of the file is changed to reflect the name of IP.
>>
>> Reviewed-by: Nori, Sekhar <nsekhar@ti.com>
>> Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
>>
>> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
>> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
>> ---
>> Applies to linux-next tree of v4l-dvb
>>  - rebasing to latest for merge (v3)
>>  - Updated based on comments against v1 of the patch (v2)
>>  drivers/media/video/davinci/isif_regs.h |  269 ++++++++++++++++
>>  include/media/davinci/isif.h            |  531
>+++++++++++++++++++++++++++++++
>>  2 files changed, 800 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/media/video/davinci/isif_regs.h
>>  create mode 100644 include/media/davinci/isif.h
>
>Hi Murali,
>
>As always, it is almost impossible for me to know if you're submitting yet
>another RFC version
>or a final version to be applied.
>
>So, I kindly ask you to send all those patches that are still under
>discussions with [RFC PATCH]
>at the subject, and, on the final version, send it to me via a git pull
>request.
>
>Unfortunately, I don't have enough time to go inside every RFC patch that
>are under discussion,
>so I prefer to optimize my time focusing on the patch versions that are
>considered ready for
>inclusion, and where there's no c/c to any members-only ML.
>
>--
>
>Cheers,
>Mauro
