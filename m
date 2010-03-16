Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41894 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659Ab0CPFQH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Mar 2010 01:16:07 -0400
Received: by pwi1 with SMTP id 1so2441589pwi.19
        for <linux-media@vger.kernel.org>; Mon, 15 Mar 2010 22:16:03 -0700 (PDT)
Message-ID: <4B9F14C6.1010505@gmail.com>
Date: Tue, 16 Mar 2010 13:19:02 +0800
From: Huang Shijie <shijie8@gmail.com>
MIME-Version: 1.0
To: Huang Shijie <shijie8@gmail.com>
CC: mchehab@redhat.com, linux-media@vger.kernel.org
Subject: Re: [BUGFIX][PATCH] change some parameters for tlg2300
References: <1268642648-3132-1-git-send-email-shijie8@gmail.com> <4B9DF759.2070400@gmail.com>
In-Reply-To: <4B9DF759.2070400@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro:
> This patch has side effect : the radio does not run well with this patch.
>   
I tested the patch carefully.
If I listen the radio with mplayer in the root account, the radio does
not run well ( a xrun occurs);
if I listen the radio with mplayer in the normal account (not root). the
radio runs well.

Do you have any advice ? Do you think this is a problem?

thanks.

> Best Regards
> Huang Shijie.
>
>   
>> The orgin parameters may cause a bug : The audio may lost in certain
>> situation (such as open the VLC at the first time).
>>
>> The origin parameters set a small stop_threshold for snd_pcm_runtime{}.
>> So a xrun occurs in some situation.
>>
>> Signed-off-by: Huang Shijie <shijie8@gmail.com>
>> ---
>>  drivers/media/video/tlg2300/pd-alsa.c |   10 ----------
>>  1 files changed, 0 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/media/video/tlg2300/pd-alsa.c b/drivers/media/video/tlg2300/pd-alsa.c
>> index 6f42621..e9ad715 100644
>> --- a/drivers/media/video/tlg2300/pd-alsa.c
>> +++ b/drivers/media/video/tlg2300/pd-alsa.c
>> @@ -21,9 +21,6 @@
>>  static void complete_handler_audio(struct urb *urb);
>>  #define AUDIO_EP	(0x83)
>>  #define AUDIO_BUF_SIZE	(512)
>> -#define PERIOD_SIZE	(1024 * 8)
>> -#define PERIOD_MIN	(4)
>> -#define PERIOD_MAX 	PERIOD_MIN
>>  
>>  static struct snd_pcm_hardware snd_pd_hw_capture = {
>>  	.info = SNDRV_PCM_INFO_BLOCK_TRANSFER |
>> @@ -38,18 +35,11 @@ static struct snd_pcm_hardware snd_pd_hw_capture = {
>>  	.rate_max = 48000,
>>  	.channels_min = 2,
>>  	.channels_max = 2,
>> -	.buffer_bytes_max = PERIOD_SIZE * PERIOD_MIN,
>> -	.period_bytes_min = PERIOD_SIZE,
>> -	.period_bytes_max = PERIOD_SIZE,
>> -	.periods_min = PERIOD_MIN,
>> -	.periods_max = PERIOD_MAX,
>> -	/*
>>  	.buffer_bytes_max = 62720 * 8,
>>  	.period_bytes_min = 64,
>>  	.period_bytes_max = 12544,
>>  	.periods_min = 2,
>>  	.periods_max = 98
>> -	*/
>>  };
>>  
>>  static int snd_pd_capture_open(struct snd_pcm_substream *substream)
>>   
>>     
>   

