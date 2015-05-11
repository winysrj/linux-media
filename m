Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:49021 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbbEKQJ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 May 2015 12:09:27 -0400
Message-ID: <5550D434.6000906@osg.samsung.com>
Date: Mon, 11 May 2015 10:09:24 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: Eric Wong <normalperson@yhbt.net>
CC: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, tiwai@suse.de, perex@perex.cz,
	agoode@google.com, pierre-louis.bossart@linux.intel.com,
	gtmkramer@xs4all.nl, clemens@ladisch.de, vladcatoi@gmail.com,
	damien@zamaudio.com, chris.j.arges@canonical.com,
	takamichiho@gmail.com, misterpib@gmail.com, daniel@zonque.org,
	pmatilai@laiskiainen.org, jussi@sonarnerd.net, fisch602@gmail.com,
	joe@oampo.co.uk, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 2/2] sound/usb: Update ALSA driver to use media controller
 API
References: <cover.1431110739.git.shuahkh@osg.samsung.com> <dd21d1282a85d620be1aae497b66ccb355e458ba.1431110739.git.shuahkh@osg.samsung.com> <20150509045109.GA6528@dcvr.yhbt.net>
In-Reply-To: <20150509045109.GA6528@dcvr.yhbt.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/08/2015 10:51 PM, Eric Wong wrote:
> Shuah Khan <shuahkh@osg.samsung.com> wrote:
>> @@ -541,13 +591,19 @@ int snd_usb_create_quirk(struct snd_usb_audio *chip,
>>  		[QUIRK_AUDIO_ALIGN_TRANSFER] = create_align_transfer_quirk,
>>  		[QUIRK_AUDIO_STANDARD_MIXER] = create_standard_mixer_quirk,
>>  	};
>> +	int ret;
>>  
>> +	if (quirk->media_device) {
>> +		/* don't want to fail when media_device_init() doesn't work */
>> +		ret = media_device_init(iface);
>> +	}
>>  	if (quirk->type < QUIRK_TYPE_COUNT) {
>> -		return quirk_funcs[quirk->type](chip, iface, driver, quirk);
>> +		ret = quirk_funcs[quirk->type](chip, iface, driver, quirk);
>>  	} else {
>>  		usb_audio_err(chip, "invalid quirk type %d\n", quirk->type);
>>  		return -ENXIO;
>>  	}
>> +	return ret;
>>  }
> 
> What is the point of saving 'ret' of media_device_init if it'll
> only be clobbered or ignored for ENXIO?
> 

Agreed. There is no point in saving it.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
