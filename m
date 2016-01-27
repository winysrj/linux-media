Return-path: <linux-media-owner@vger.kernel.org>
Received: from chaven.anvil.org ([82.152.56.163]:52702 "EHLO mail.anvil.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932669AbcA0QsM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2016 11:48:12 -0500
Subject: Re: [PATCH 1/2] Revert "[media] ivtv: avoid going past input/audio
 array"
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <93fa669548266b15798131e0f5875bd85306caf4.1447242435.git.mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Warren Sturm <warren.sturm@gmail.com>,
	Andy Walls <awalls@md.metrocast.net>
From: Andrew Meredith <andrew@anvil.org>
Message-ID: <56A8F049.9000705@anvil.org>
Date: Wed, 27 Jan 2016 16:28:57 +0000
MIME-Version: 1.0
In-Reply-To: <93fa669548266b15798131e0f5875bd85306caf4.1447242435.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

There was a flurry of activity around November last year, so thanks for 
that, but nothing seems to made it through to the stock Fedora kernel.

Have I missed something, or is there a roadblock somewhere?

I ask as I haven't allowed any updates through since November last and 
they're piling up somewhat.

Andy M

On 11/11/2015 11:48 AM, Mauro Carvalho Chehab wrote:
> This patch broke ivtv logic, as reported at
>   https://bugzilla.redhat.com/show_bug.cgi?id=1278942
>
> This reverts commit 09290cc885937cab3b2d60a6d48fe3d2d3e04061.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
> diff --git a/drivers/media/pci/ivtv/ivtv-driver.c b/drivers/media/pci/ivtv/ivtv-driver.c
> index 3a6f668b14b8..21501c560610 100644
> --- a/drivers/media/pci/ivtv/ivtv-driver.c
> +++ b/drivers/media/pci/ivtv/ivtv-driver.c
> @@ -805,11 +805,11 @@ static void ivtv_init_struct2(struct ivtv *itv)
>   {
>   	int i;
>
> -	for (i = 0; i < IVTV_CARD_MAX_VIDEO_INPUTS - 1; i++)
> +	for (i = 0; i < IVTV_CARD_MAX_VIDEO_INPUTS; i++)
>   		if (itv->card->video_inputs[i].video_type == 0)
>   			break;
>   	itv->nof_inputs = i;
> -	for (i = 0; i < IVTV_CARD_MAX_AUDIO_INPUTS - 1; i++)
> +	for (i = 0; i < IVTV_CARD_MAX_AUDIO_INPUTS; i++)
>   		if (itv->card->audio_inputs[i].audio_type == 0)
>   			break;
>   	itv->nof_audio_inputs = i;
>


-- 
Andrew Meredith CEng CITP
