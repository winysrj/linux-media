Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vn0-f42.google.com ([209.85.216.42]:40333 "EHLO
	mail-vn0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031262AbbD1XHq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 19:07:46 -0400
Received: by vnbg62 with SMTP id g62so1436674vnb.7
        for <linux-media@vger.kernel.org>; Tue, 28 Apr 2015 16:07:45 -0700 (PDT)
In-Reply-To: <b5e6ddaf21e8e2c8517b21bfc36ebc09d8f33a20.1430235781.git.mchehab@osg.samsung.com>
References: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com><ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com> <b5e6ddaf21e8e2c8517b21bfc36ebc09d8f33a20.1430235781.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 02/14] cx18: avoid going past input/audio array
From: Andy Walls <awalls.cx18@gmail.com>
Date: Tue, 28 Apr 2015 19:07:40 -0400
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <C7F874A8-D9AB-47AC-A103-4A99DCA0043C@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On April 28, 2015 11:43:41 AM EDT, Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:
>As reported by smatch:
>	drivers/media/pci/cx18/cx18-driver.c:807 cx18_init_struct2() error:
>buffer overflow 'cx->card->video_inputs' 6 <= 6
>
>That happens because nof_inputs and nof_audio_inputs can be initialized
>as CX18_CARD_MAX_VIDEO_INPUTS, instead of CX18_CARD_MAX_VIDEO_INPUTS -
>1.
>
>Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
>diff --git a/drivers/media/pci/cx18/cx18-driver.c
>b/drivers/media/pci/cx18/cx18-driver.c
>index 83f5074706f9..260e462d91b4 100644
>--- a/drivers/media/pci/cx18/cx18-driver.c
>+++ b/drivers/media/pci/cx18/cx18-driver.c
>@@ -786,11 +786,11 @@ static void cx18_init_struct2(struct cx18 *cx)
> {
> 	int i;
> 
>-	for (i = 0; i < CX18_CARD_MAX_VIDEO_INPUTS; i++)
>+	for (i = 0; i < CX18_CARD_MAX_VIDEO_INPUTS - 1; i++)
> 		if (cx->card->video_inputs[i].video_type == 0)
> 			break;
> 	cx->nof_inputs = i;
>-	for (i = 0; i < CX18_CARD_MAX_AUDIO_INPUTS; i++)
>+	for (i = 0; i < CX18_CARD_MAX_AUDIO_INPUTS - 1; i++)
> 		if (cx->card->audio_inputs[i].audio_type == 0)
> 			break;
> 	cx->nof_audio_inputs = i;

Acked-by: Andy Walls <awalls@md.metrocast.net>
