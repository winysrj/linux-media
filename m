Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3UCaJRd001148
	for <video4linux-list@redhat.com>; Wed, 30 Apr 2008 08:36:19 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3UCZaEn014832
	for <video4linux-list@redhat.com>; Wed, 30 Apr 2008 08:36:09 -0400
Received: by yw-out-2324.google.com with SMTP id 2so235386ywt.81
	for <video4linux-list@redhat.com>; Wed, 30 Apr 2008 05:36:09 -0700 (PDT)
Message-ID: <37219a840804300536y720facfeg91872b207c617989@mail.gmail.com>
Date: Wed, 30 Apr 2008 08:36:09 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20080430112138.GA11844@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080430110115.GA5633@elte.hu> <s5hiqxzwqak.wl%tiwai@suse.de>
	<20080430111516.GA9954@elte.hu> <20080430111803.GA11628@elte.hu>
	<20080430112138.GA11844@elte.hu>
Cc: video4linux-list@redhat.com, Takashi Iwai <tiwai@suse.de>,
	Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-dvb-maintainer@linuxtv.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [v4l-dvb-maintainer] [patch, -git] media/video/sound build fix,
	TEA5761/TEA5767
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Wed, Apr 30, 2008 at 7:21 AM, Ingo Molnar <mingo@elte.hu> wrote:
>  Subject: dvb: fix3
>  From: Ingo Molnar <mingo@elte.hu>
>  Date: Mon Apr 28 23:22:13 CEST 2008
>
>  Signed-off-by: Ingo Molnar <mingo@elte.hu>
>  ---
>   drivers/media/video/cx23885/Kconfig |    2 ++
>   1 file changed, 2 insertions(+)
>
>  Index: linux/drivers/media/video/cx23885/Kconfig
>  ===================================================================
>  --- linux.orig/drivers/media/video/cx23885/Kconfig
>  +++ linux/drivers/media/video/cx23885/Kconfig
>  @@ -9,6 +9,8 @@ config VIDEO_CX23885
>         select VIDEO_IR
>         select VIDEOBUF_DVB
>         select VIDEO_CX25840
>  +       select VIDEO_CX2341X
>  +       select DVB_DIB7000P
>         select MEDIA_TUNER_MT2131 if !DVB_FE_CUSTOMISE
>         select DVB_S5H1409 if !DVB_FE_CUSTOMISE
>         select DVB_LGDT330X if !DVB_FE_CUSTOMISE


Ingo,

It should actually be as follows:



[PATCH] cx23885: fix kbuild dependencies

Thanks to Ingo Molnar for finding this.

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>

--- linux.orig/drivers/media/video/cx23885/Kconfig
+++ linux/drivers/media/video/cx23885/Kconfig
@@ -9,6 +9,8 @@ config VIDEO_CX23885
 	select VIDEO_IR
 	select VIDEOBUF_DVB
 	select VIDEO_CX25840
+	select VIDEO_CX2341X
+	select DVB_DIB7000P if !DVB_FE_CUSTOMISE
 	select MEDIA_TUNER_MT2131 if !DVB_FE_CUSTOMISE
 	select DVB_S5H1409 if !DVB_FE_CUSTOMISE
 	select DVB_LGDT330X if !DVB_FE_CUSTOMISE

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
