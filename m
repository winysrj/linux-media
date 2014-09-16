Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14962 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbaIPOUU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Sep 2014 10:20:20 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBZ008XOZYIO420@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 16 Sep 2014 15:23:06 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Kiran Avnd' <kiran@chromium.org>
Cc: 'Kiran AVND' <avnd.kiran@samsung.com>, linux-media@vger.kernel.org,
	wuchengli@chromium.org, posciak@chromium.org,
	'Arun Mankuzhi' <arun.m@samsung.com>, ihf@chromium.org,
	'Prathyush' <prathyush.k@samsung.com>,
	'Arun Kumar' <arun.kk@samsung.com>
References: <1410763393-12183-1-git-send-email-avnd.kiran@samsung.com>
 <1410763393-12183-4-git-send-email-avnd.kiran@samsung.com>
 <022a01cfd0f3$48185be0$d84913a0$%debski@samsung.com>
 <CAFHkUjjjK4TOSfYj=xS12LPcUAusKrMaDG1WYiVegG+B9K6w3A@mail.gmail.com>
In-reply-to: <CAFHkUjjjK4TOSfYj=xS12LPcUAusKrMaDG1WYiVegG+B9K6w3A@mail.gmail.com>
Subject: RE: [PATCH 03/17] [media] s5p-mfc: set B-frames as 2 while encoding
Date: Tue, 16 Sep 2014 16:20:17 +0200
Message-id: <02ba01cfd1b9$57162de0$054289a0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kiran,

> From: Kiran Avnd [mailto:kiran@chromium.org]
> Sent: Tuesday, September 16, 2014 10:10 AM
> 
> Hi Kamil,
> 
> 
> On Mon, Sep 15, 2014 at 8:12 PM, Kamil Debski <k.debski@samsung.com>
> wrote:
> 
> 
> 	Hi,
> 
> 	> From: Kiran AVND [mailto:avnd.kiran@samsung.com]
> 	> Sent: Monday, September 15, 2014 8:43 AM
> 	>
> 	> set default number of B-frames as 2 while encoding for better
> 	> compression. This User can however change this setting using
> 	> V4L2_CID_MPEG_VIDEO_B_FRAMES.
> 
> 	The last sentence should be rephrased, as it is not clear.
> 
> 
> 
> Sure. Will do.
> 
> 
> 	The tougher question is what should be the default?
> 	In my opinion the default should produce a stream that is as
> 	simple as it gets. It should be playable on most hardware,
> 	some of which may not support B frames.
> 
> 	Anyway - this setting can be changed by the user to 2 using
> 	V4L2_CID_MPEG_VIDEO_B_FRAMES ;)
> 
> 
> 
> 
> Its empirical, and this setting has better compression quality and bit
> rate than otherwise, in our testing.

It doesn't surprise me - introducing B frames should increase both quality
and compression efficiency at the cost of computation complexity and
limiting compatibility.

The thing I am against is changing the driver so that it forces such
value of the encoding parameter on the user. Default number of B frames
should remain 0. The application should consciously choose to use B frames.

Best wishes,
--
Kamil Debski
Samsung R&D Institute Poland


> 
> Regards,
> Kiran
> 
> 
> 
> 
> 	>
> 	> Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
> 	> ---
> 	>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c |    2 +-
> 	>  1 files changed, 1 insertions(+), 1 deletions(-)
> 	>
> 	> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> 	> b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> 	> index cd1b2a2..f7a6f68 100644
> 	> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> 	> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> 	> @@ -280,7 +280,7 @@ static struct mfc_control controls[] = {
> 	>               .minimum = 0,
> 	>               .maximum = 2,
> 	>               .step = 1,
> 	> -             .default_value = 0,
> 	> +             .default_value = 2,
> 	>       },
> 	>       {
> 	>               .id = V4L2_CID_MPEG_VIDEO_H264_PROFILE,
> 	> --
> 	> 1.7.3.rc2
> 
> 	--
> 	To unsubscribe from this list: send the line "unsubscribe linux-
> media" in
> 	the body of a message to majordomo@vger.kernel.org
> 	More majordomo info at  http://vger.kernel.org/majordomo-
> info.html
> 
> 


