Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:19484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403Ab1F2LAU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 07:00:20 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5TB0H5A026344
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 29 Jun 2011 07:00:20 -0400
Message-ID: <4E0B05F5.1000704@redhat.com>
Date: Wed, 29 Jun 2011 13:01:09 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [git:xawtv3/master] xawtv: reenable its usage with webcam's
References: <E1Qbdw6-0007wL-E8@www.linuxtv.org>
In-Reply-To: <E1Qbdw6-0007wL-E8@www.linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 06/28/2011 07:32 PM, Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following patch were queued at the
> http://git.linuxtv.org/xawtv3.git tree:
>
> Subject: xawtv: reenable its usage with webcam's
> Author:  Mauro Carvalho Chehab<mchehab@redhat.com>
> Date:    Tue Jun 28 14:22:55 2011 -0300
>
> git changeset c28978f3693bc0f40607d0b3e589774b9452608d was requiring that
> tuner would be available, in order to allow it to run. Relax the restriction,
> in order to allow using xawtv to test webcams, restoring the previous
> behavior.
>
> Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
>
>   libng/grab-ng.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> ---
>
> http://git.linuxtv.org/xawtv3.git?a=commitdiff;h=2238f79d9fb2801a3acd114242b437686fa2f0c8
>
> diff --git a/libng/grab-ng.c b/libng/grab-ng.c
> index f5203cc..94f31e8 100644
> --- a/libng/grab-ng.c
> +++ b/libng/grab-ng.c
> @@ -563,9 +563,9 @@ static void *ng_vid_open_auto(struct ng_vid_driver *drv, char *devpath)
>   	    continue;
>   	}
>
> -	/* Check caps return this device if it can capture and has a tuner */
> +	/* Check caps return this device if it can capture */
>   	caps = drv->capabilities(handle);
> -	if ((caps&  CAN_CAPTURE)&&  (caps&  CAN_TUNE))
> +	if (caps&  CAN_CAPTURE)
>   	    break;
>
>   	drv->close(handle);
>

Hmm, this changes the behavior from what I intended, the idea was to select the
first *tv-card*, without checking for a tuner, there is little value in the auto
device feature. Granted it will still skip v4l2 output only devices but those are
very rare.

Note that only the xawtv binary is using a device value of "auto" by default,
the webcam tool still defaults to /dev/video0

Given that xawtv is specifically meant for tv-cards (unlike the webcam tool)
failing if it cannot find a tv-card and no device is explicitly specified seems
reasonable.

Alternatively we could make the desired caps a param too ng_vid_open_auto
and first try with (CAN_CAPTURE | CAN_TUNE) and then retry with only
CAN_CAPTURE.

The above patch definitely is not what I had in mind. My system has a
bt878 tv card, and a varying number of webcams connected, thus constantly
changing the /dev/video# for the tv-card. The intent of my "auto" device
patches was to make xawtv automatically pick the tvcard.

Regards,

Hans

p.s.

I intented to mail you about my get_media_devices fixes as well as my
auto device patches, and suggest that we do a new release soon. But first
we need to sort out the auto device thingie. If you could fix it to
first look for cards with a tuner and if none is available fall back
to just looking for capture capable cards that would be great, I'm a
bit busy atm I'm afraid.
