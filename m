Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vn0-f42.google.com ([209.85.216.42]:36307 "EHLO
	mail-vn0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030966AbbD1XI1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 19:08:27 -0400
Received: by vnbf62 with SMTP id f62so1444430vnb.3
        for <linux-media@vger.kernel.org>; Tue, 28 Apr 2015 16:08:27 -0700 (PDT)
In-Reply-To: <f5d61bc605459af7274e70e73c60cba84f9a02b8.1430235781.git.mchehab@osg.samsung.com>
References: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com><ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com> <f5d61bc605459af7274e70e73c60cba84f9a02b8.1430235781.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 08/14] avoid going past input/audio array
From: Andy Walls <awalls.cx18@gmail.com>
Date: Tue, 28 Apr 2015 19:08:21 -0400
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <E7D61729-817E-4752-8E82-465B048458E2@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On April 28, 2015 11:43:47 AM EDT, Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:
>As reported by smatch:
>	drivers/media/pci/ivtv/ivtv-driver.c:832 ivtv_init_struct2() error:
>buffer overflow 'itv->card->video_inputs' 6 <= 6
>
>That happens because nof_inputs and nof_audio_inputs can be initialized
>as IVTV_CARD_MAX_VIDEO_INPUTS, instead of IVTV_CARD_MAX_VIDEO_INPUTS -
>1.
>
>Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
>diff --git a/drivers/media/pci/ivtv/ivtv-driver.c
>b/drivers/media/pci/ivtv/ivtv-driver.c
>index c2e60b4f292d..8616fa8193bc 100644
>--- a/drivers/media/pci/ivtv/ivtv-driver.c
>+++ b/drivers/media/pci/ivtv/ivtv-driver.c
>@@ -805,11 +805,11 @@ static void ivtv_init_struct2(struct ivtv *itv)
> {
> 	int i;
> 
>-	for (i = 0; i < IVTV_CARD_MAX_VIDEO_INPUTS; i++)
>+	for (i = 0; i < IVTV_CARD_MAX_VIDEO_INPUTS - 1; i++)
> 		if (itv->card->video_inputs[i].video_type == 0)
> 			break;
> 	itv->nof_inputs = i;
>-	for (i = 0; i < IVTV_CARD_MAX_AUDIO_INPUTS; i++)
>+	for (i = 0; i < IVTV_CARD_MAX_AUDIO_INPUTS - 1; i++)
> 		if (itv->card->audio_inputs[i].audio_type == 0)
> 			break;
> 	itv->nof_audio_inputs = i;

Acked-by: Andy Walls <awalls@md.metrocast.net>
