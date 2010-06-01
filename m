Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083Ab0FAD7E (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 May 2010 23:59:04 -0400
Message-ID: <4C048593.7010105@redhat.com>
Date: Tue, 01 Jun 2010 00:59:15 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Luis Henrique Fagundes <lhfagundes@hacklab.com.br>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: tm6000 audio urb
References: <AANLkTikHJfHDnSdX-TqHR9ZU4J6KRqS5vVgB9D0LynZC@mail.gmail.com>
In-Reply-To: <AANLkTikHJfHDnSdX-TqHR9ZU4J6KRqS5vVgB9D0LynZC@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 31-05-2010 19:22, Luis Henrique Fagundes escreveu:
> Hi,
> 
> I'm having my first adventures on driver coding, trying to help audio
> development of tm6000 based on Mauro's hints.
> 
> According to Mauro and coding comments, the audio URBs are already
> being received by tm6000-video. The copy_packet function correctly
> filters video packets (identified as cmd=1, extracted from header) and
> the tm6000_msg_type array suggests that the cmd=2 would be the audio
> packets. I logged all packets not being copied to video buffer and
> realized that the only packets remaining have been identified as
> cmd=4, which is supposedly type "pts".
> 
> For me it looks like either the cmd=4 type is audio, or the audio is
> not really being received. Does this make sense?

Luis Henrique,

The audio type is correct. You should notice that some logic is needed to enable
audio at tm6000. For example, you'll see this code at tm6000-alsa:


static int _tm6000_start_audio_dma(struct snd_tm6000_card *chip)
{
	struct tm6000_core *core = chip->core;
	int val;

	/* Enables audio */
	val = tm6000_get_reg(core, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, 0x0);
	val |= 0x20;
	tm6000_set_reg(core, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, val);

	tm6000_set_reg(core, TM6010_REQ08_R01_A_INIT, 0x80);

	return 0;
}

You'll also see this at tm6000-core:

	tm6000_set_audio_bitrate (dev,48000);

...


int tm6000_set_audio_bitrate(struct tm6000_core *dev, int bitrate)
{
	int val;

	val=tm6000_get_reg (dev, REQ_07_SET_GET_AVREG, 0xeb, 0x0);
printk("Original value=%d\n",val);
	if (val<0)
		return val;

	val &= 0x0f;		/* Preserve the audio input control bits */
	switch (bitrate) {
	case 44100:
		val|=0xd0;
		dev->audio_bitrate=bitrate;
		break;
	case 48000:
		val|=0x60;
		dev->audio_bitrate=bitrate;
		break;
	}
	val=tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0xeb, val);

	return val;
}

You need to double check if the enabling stuff is properly called
at the right place.

I'm sure that, before adding tm6010 support, audio packages got received.
Eventually, some new patches to add support for tm6010 might have broken
the reception of audio packages.

So, I suggest that you should play with those routines and review the
git backlog to get what's going wrong.

> 
> Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers,
Mauro.
