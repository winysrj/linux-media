Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:60731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930Ab0JYXSy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Oct 2010 19:18:54 -0400
Message-ID: <4CC61058.7090205@redhat.com>
Date: Mon, 25 Oct 2010 21:18:48 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Florian Klink <flokli@flokli.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx: Terratec Grabby no sound
References: <f9fc4355b0c721744c6522a720ee2df7@flokli.de> <4CC5BE39.70206@redhat.com> <d8211f823d481e2991821b5dfc4e8b84@flokli.de> <4CC5EDC3.3020506@redhat.com> <0346874f2869b186cbe1224baeef5462@flokli.de>
In-Reply-To: <0346874f2869b186cbe1224baeef5462@flokli.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 25-10-2010 20:06, Florian Klink escreveu:
> Hi,
> 
> I'm not very familiar with mailing lists, sorry!
> 
> Patched em28xx-cards.c, but no luck with
> mplayer -v -tv driver=v4l2:input=0:device=/dev/video1:forceaudio tv://
> (/dev/video0 is webcam). I'm able to see the video, but still no sound in mplayer
> 
> playing the sound with arecord works (i think it goes over the snd-usb-audio module,
> but don't know why some "mplayer -v -tv driver=v4l2:input=0:device=/dev/video1:alsa:adevice=hw.2,0:forceaudio tv://" magic won't do the job.
> 
> And shouldn't the sound go over v4l, too?

The sound comes from alsa device. Several em28xx types provide standard USB audio. So,
snd-usb-audio handles it. That's why you need alsa:adevice=hw.2,0:forceaudio at mplayer.

> 
> Florian
> 
> 
> 
> On Mon, 25 Oct 2010 18:51:15 -0200, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>> Em 25-10-2010 18:24, Florian Klink escreveu:
>>> Hi Mauro,
>>>
>>> thanks for your answer!
>>
>> I'm c/c the mailing list, as this info may be useful for the others.
>> It would be nice to have this added to wiki, but I won't have time for it,
>> unfortunately.
>>>
>>>> Maybe the amux is wrong. The only way to know for sure is to check
>>>> the used GPIO's,
>>>> via a USB snoop dump. Please take a look at linuxtv.org Wiki (search
>>>> for usbsnoop).
>>>> After getting the dump, please parse it and send me.
>>>
>>> I did the usbsnooping and hope I did the parsing right (At least the log
>>> file shrinked from 100MB to some KB, and there are plenty of EM28XX
>>> strings inside ;-))
>>>
>>> You can get it here: http://pastebin.com/SXKfLUny
>>
>> There are a few things that are relevant:
>>
>> First of all, GPIO's. They enable/disable parts of the board:
>>
>> $ grep GPIO /tmp/dump
>> em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xff);
>> em28xx_read_reg(dev, EM28XX_R08_GPIO);        /* read 0xff */
>> em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xfd);
>> em28xx_read_reg(dev, EM28XX_R08_GPIO);        /* read 0xfd */
>> em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xfd);
>> em28xx_read_reg(dev, EM28XX_R08_GPIO);        /* read 0xfd */
>> em28xx_write_reg(dev, EM28XX_R08_GPIO, 0x7d);
>> em28xx_write_reg(dev, EM28XX_R08_GPIO, 0x2a);
>> em28xx_write_reg(dev, EM28XX_R08_GPIO, 0x2a);
>>
>> Currently, they're not touched for this device. Perhaps, we might
>> need to initialize
>> them to 0xfd for capture mode, and 0x2a for sleep mode.
>>
>> In this specific case, maybe it is just safe to keep it as-is, as I
>> suspect that GPIO's
>> are not used on this device. I may be wrong, though. A simple test will tell.
>>
>> The audio entries are related to the ac97 chip.
>>
>> The driver will basically run this code:
>>
>> amux = EM28XX_AMUX_VIDEO2;     /* from Terratec Grabby entry, at
>> em28xx-cards.c */
>>
>> static struct em28xx_vol_table inputs[] = {
>>     { EM28XX_AMUX_VIDEO,     AC97_VIDEO_VOL   },
>>     { EM28XX_AMUX_LINE_IN,    AC97_LINEIN_VOL  },
>>     { EM28XX_AMUX_PHONE,    AC97_PHONE_VOL   },
>>     { EM28XX_AMUX_MIC,    AC97_MIC_VOL     },
>>     { EM28XX_AMUX_CD,    AC97_CD_VOL      },
>>     { EM28XX_AMUX_AUX,    AC97_AUX_VOL     },
>>     { EM28XX_AMUX_PCM_OUT,    AC97_PCM_OUT_VOL },
>>
>> if (amux == inputs[i].mux)
>>             ret = em28xx_write_ac97(dev, inputs[i].reg, 0x0808);        /* Put the
>> volume in 50% */
>>         else
>>             ret = em28xx_write_ac97(dev, inputs[i].reg, 0x8000);        /* Mute the
>> volume */
>>
>> Any mixer entry equal or bigger than 0x8000 is muted.
>>
>>
>> $ grep 97 dump
>> em28xx_read_ac97(dev, AC97_VENDOR_ID1);    /* read 0x0x8384 */
>> em28xx_read_ac97(dev, AC97_VENDOR_ID2);    /* read 0x0x7652 */
>> em28xx_write_ac97(dev, AC97_LINEIN_VOL, 0x0808);
>> em28xx_write_ac97(dev, AC97_VIDEO_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_AUX_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_MIC_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x0000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x0000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x8000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x8000);
>> em28xx_write_ac97(dev, AC97_POWER_DOWN_CTRL, 0x4200);
>> em28xx_write_ac97(dev, AC97_RECORD_SELECT, 0x0505);
>> em28xx_write_ac97(dev, AC97_EXT_AUD_CTRL, 0x0031);
>> em28xx_write_ac97(dev, AC97_PCM_IN_SRATE, 0xbb80);
>> em28xx_write_ac97(dev, AC97_LINEIN_VOL, 0x0808);
>> em28xx_write_ac97(dev, AC97_VIDEO_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_AUX_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_MIC_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x8000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x8000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x8000);
>> em28xx_write_ac97(dev, AC97_LINEIN_VOL, 0x0808);
>> em28xx_write_ac97(dev, AC97_VIDEO_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_AUX_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_MIC_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x0000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x0000);
>> em28xx_write_ac97(dev, AC97_LINEIN_VOL, 0x0808);
>> em28xx_write_ac97(dev, AC97_VIDEO_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_AUX_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_MIC_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x0000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x0000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x8000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x8000);
>> em28xx_write_ac97(dev, AC97_POWER_DOWN_CTRL, 0x4200);
>> em28xx_write_ac97(dev, AC97_RECORD_SELECT, 0x0505);
>> em28xx_write_ac97(dev, AC97_EXT_AUD_CTRL, 0x0031);
>> em28xx_write_ac97(dev, AC97_PCM_IN_SRATE, 0xbb80);
>> em28xx_write_ac97(dev, AC97_LINEIN_VOL, 0x0808);
>> em28xx_write_ac97(dev, AC97_VIDEO_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_AUX_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_MIC_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x8000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x8000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x8000);
>> em28xx_write_ac97(dev, AC97_LINEIN_VOL, 0x0808);
>> em28xx_write_ac97(dev, AC97_VIDEO_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_AUX_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_MIC_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x0000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x0000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x8000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x8000);
>> em28xx_write_ac97(dev, AC97_POWER_DOWN_CTRL, 0x4200);
>> em28xx_write_ac97(dev, AC97_RECORD_SELECT, 0x0505);
>> em28xx_write_ac97(dev, AC97_EXT_AUD_CTRL, 0x0031);
>> em28xx_write_ac97(dev, AC97_PCM_IN_SRATE, 0xbb80);
>> em28xx_write_ac97(dev, AC97_LINEIN_VOL, 0x0808);
>> em28xx_write_ac97(dev, AC97_VIDEO_VOL, 0x9010);
>> em28xx_write_reg(dev, EM28XX_R42_AC97ADDR, 0x16);
>> em28xx_write_ac97(dev, AC97_MIC_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x8000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x8000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x8000);
>> em28xx_write_ac97(dev, AC97_LINEIN_VOL, 0x0808);
>> em28xx_write_ac97(dev, AC97_VIDEO_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_AUX_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_MIC_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x0000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x0000);
>> em28xx_write_ac97(dev, AC97_LINEIN_VOL, 0x0808);
>> em28xx_write_ac97(dev, AC97_VIDEO_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_AUX_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_MIC_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x0000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x0000);
>> em28xx_write_ac97(dev, AC97_LINEIN_VOL, 0x0808);
>> em28xx_write_ac97(dev, AC97_VIDEO_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_AUX_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_MIC_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x0000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x0000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x8000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x8000);
>> em28xx_write_ac97(dev, AC97_POWER_DOWN_CTRL, 0x4200);
>> em28xx_write_ac97(dev, AC97_RECORD_SELECT, 0x0505);
>> em28xx_write_ac97(dev, AC97_EXT_AUD_CTRL, 0x0031);
>> em28xx_write_ac97(dev, AC97_PCM_IN_SRATE, 0xbb80);
>> em28xx_write_ac97(dev, AC97_LINEIN_VOL, 0x0808);
>> em28xx_write_ac97(dev, AC97_VIDEO_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_AUX_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_MIC_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x8000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x8000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x8000);
>> em28xx_write_ac97(dev, AC97_LINEIN_VOL, 0x0808);
>> em28xx_write_ac97(dev, AC97_VIDEO_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_AUX_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_MIC_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x0000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x0000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x8000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x8000);
>> em28xx_write_ac97(dev, AC97_POWER_DOWN_CTRL, 0x4200);
>> em28xx_write_ac97(dev, AC97_RECORD_SELECT, 0x0505);
>> em28xx_write_ac97(dev, AC97_EXT_AUD_CTRL, 0x0031);
>> em28xx_write_ac97(dev, AC97_PCM_IN_SRATE, 0xbb80);
>> em28xx_write_ac97(dev, AC97_LINEIN_VOL, 0x0808);
>> em28xx_write_ac97(dev, AC97_VIDEO_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_AUX_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_MIC_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x8000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x8000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x8000);
>> em28xx_write_ac97(dev, AC97_LINEIN_VOL, 0x0808);
>> em28xx_write_ac97(dev, AC97_VIDEO_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_AUX_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_MIC_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x0000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x0000);
>> em28xx_write_ac97(dev, AC97_LINEIN_VOL, 0x0808);
>> em28xx_write_ac97(dev, AC97_VIDEO_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_AUX_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_MIC_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x0000);
>> em28xx_write_ac97(dev, AC97_RECORD_GAIN, 0x0000);
>> em28xx_write_ac97(dev, AC97_LINEIN_VOL, 0x0808);
>> em28xx_write_ac97(dev, AC97_VIDEO_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_AUX_VOL, 0x9010);
>> em28xx_write_ac97(dev, AC97_MIC_VOL, 0x9010);
>>
>> From the logs, the only mixer line used on this device is:
>>     em28xx_write_ac97(dev, AC97_LINEIN_VOL, 0x0808);
>>
>> So, I think that the correct value, at em28xx-cards.c is:
>>     amux = EM28XX_AMUX_LINE_IN,
>>
>> Ok, could you please test the enclosed patch? Please test it with both
>> Composite and S-Video entries.
>>
>> Cheers,
>> Mauro
>>
>> ---
>>
>> em28xx: fix Terratec Grabby lack of sound
>>
>> Audio mux were pointing to the wrong line entry.
>>
>> Reported-by: Florian Klink <flokli@flokli.de>
>>
>> diff --git a/drivers/media/video/em28xx/em28xx-cards.c
>> b/drivers/media/video/em28xx/em28xx-cards.c
>> index 5485923..afb206b 100644
>> --- a/drivers/media/video/em28xx/em28xx-cards.c
>> +++ b/drivers/media/video/em28xx/em28xx-cards.c
>> @@ -1633,11 +1633,11 @@ struct em28xx_board em28xx_boards[] = {
>>          .input           = { {
>>              .type     = EM28XX_VMUX_COMPOSITE1,
>>              .vmux     = SAA7115_COMPOSITE0,
>> -            .amux     = EM28XX_AMUX_VIDEO2,
>> +            .amux     = EM28XX_AMUX_LINE_IN,
>>          }, {
>>              .type     = EM28XX_VMUX_SVIDEO,
>>              .vmux     = SAA7115_SVIDEO3,
>> -            .amux     = EM28XX_AMUX_VIDEO2,
>> +            .amux     = EM28XX_AMUX_LINE_IN,
>>          } },
>>      },
>>      [EM2860_BOARD_TERRATEC_AV350] = {
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

