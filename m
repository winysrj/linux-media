Return-path: <linux-media-owner@vger.kernel.org>
Received: from lider.pardus.org.tr ([193.140.100.216]:50008 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435AbZHJPmV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2009 11:42:21 -0400
Message-ID: <4A803FDC.8070005@pardus.org.tr>
Date: Mon, 10 Aug 2009 18:42:20 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: alsa-devel@alsa-project.org, linux-media@vger.kernel.org
Subject: Re: [alsa-devel] NULL pointer dereference in ALSA triggered	through
 saa7134-alsa
References: <4A8025BF.7030404@pardus.org.tr> <s5hab27n501.wl%tiwai@suse.de>
In-Reply-To: <s5hab27n501.wl%tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Takashi Iwai wrote:
> At Mon, 10 Aug 2009 16:50:55 +0300,
> Ozan Çağlayan wrote:
>   
>> Hi,
>>
>> I've finally succesfully compiled and linked saa7134-alsa driver using
>> an external alsa-driver and its Module.symvers file. Everything seems
>> okay, no undefined symbol or something else:
>>
>> - An installed 2.6.30.4 kernel which only builds and brings soundcore
>> and sound_firmware,
>> - Latest alsa-driver built externally and installed,
>> - Latest saa7134-alsa, cx88-alsa, etc. code from linus-2.6 (seen that
>> they don't affected by some API/ABI changes) patched on top of the
>> alsa-driver tarball,
>>     
>
> The external drivers using ALSA API have to be built with the
> newer ALSA header files from alsa-driver tree.  It's not enough to
> change snd_card_new() with snd_card_create().  The core structure
> was changed, so the whole build has to be adjusted, too.
>   
Actually that was the 0th step that I forgot to mention. I'm installing
the headers from the alsa-driver snapshot into /usr/include/sound and
then I build alsa-driver. Then I use the symvers from the alsa-driver
build alltogether with the headers that I've already installed into
/usr/include/sound to build the V4L ones.

Sorry If I understand what you said wrongly.

Thanks,
