Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:35638 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966705AbcCPOiY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2016 10:38:24 -0400
Received: by mail-io0-f194.google.com with SMTP id n190so4194720iof.2
        for <linux-media@vger.kernel.org>; Wed, 16 Mar 2016 07:38:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160316113625.23f1bf82@recife.lan>
References: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
	<864cdbedcdde600b09d77bfecb1b828e16e41ac0.1458129823.git.mchehab@osg.samsung.com>
	<CABxcv=mvtXBs9qu6+HDbiB4pmMAM9cf=3mPTtLp0XWftRrGM1g@mail.gmail.com>
	<20160316113625.23f1bf82@recife.lan>
Date: Wed, 16 Mar 2016 11:38:23 -0300
Message-ID: <CABxcv=mafN8JcF2sucHCt1gtysdDuviymy5sCdEb1hCRAMb1Gw@mail.gmail.com>
Subject: Re: [PATCH 5/5] [media] media-device: make media_device_cleanup() static
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Michal Simek <michal.simek@xilinx.com>,
	=?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
	Antti Palosaari <crope@iki.fi>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?Q?Rafael_Louren=C3=A7o_de_Lima_Chehab?=
	<chehabrafael@gmail.com>, Matthias Schwarzott <zzam@gentoo.org>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Patrick Boettcher <patrick.boettcher@posteo.de>,
	Luis de Bethencourt <luis@debethencourt.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On Wed, Mar 16, 2016 at 11:36 AM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Em Wed, 16 Mar 2016 11:03:38 -0300
> Javier Martinez Canillas <javier@dowhile0.org> escreveu:
>
>> Hello Mauro,
>>
>> The patch looks mostly good to me, I just have a question below:
>>
>> On Wed, Mar 16, 2016 at 9:04 AM, Mauro Carvalho Chehab
>> <mchehab@osg.samsung.com> wrote:
>>
>> [snip]
>>
>> >
>> > -void media_device_cleanup(struct media_device *mdev)
>> > +static void media_device_cleanup(struct media_device *mdev)
>> >  {
>> >         ida_destroy(&mdev->entity_internal_idx);
>> >         mdev->entity_internal_idx_max = 0;
>> >         media_entity_graph_walk_cleanup(&mdev->pm_count_walk);
>> > -       mutex_destroy(&mdev->graph_mutex);
>>
>> Any reason why this is removed? mutex_init() is still called in
>> media_device_init() so I believe the destroy should be kept here.
>
> This code is now called only at do_media_device_unregister, with
> is protected by the mutex. If we keep the mutex_destroy there,
> the mutex will be destroyed in lock state, causing an error if
> mutex debug is enabled.
>
> Btw, the standard implementation for the mutex is:
>         include/linux/mutex.h:static inline void mutex_destroy(struct mutex *lock) {}
>
> Only when mutex debug is enabled, it becomes something else:
>         include/linux/mutex-debug.h:extern void mutex_destroy(struct mutex *lock);
>
> With produces a warning if the mutex_destroy() is called with the
> mutex is hold. This can never happen with the current implementation, as
> the logic is:
>         mutex_lock(&mdev->graph_mutex);
>         kref_put(&mdev->kref, do_media_device_unregister);
>         mutex_unlock(&mdev->graph_mutex);
>
> We could eventually move the mutex lock to
> do_media_device_unregister() and then add there the mutex_destroy()
>

I see, thanks a lot for your explanation.

> Regards,
> Mauro
>

Best regards,
Javier
