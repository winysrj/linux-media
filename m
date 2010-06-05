Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932168Ab0FEA23 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jun 2010 20:28:29 -0400
Message-ID: <4C099A25.7010302@redhat.com>
Date: Fri, 04 Jun 2010 21:28:21 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Luis Henrique Fagundes <lhfagundes@hacklab.com.br>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: tm6000 audio buffer
References: <AANLkTind4rEphKcFnoBBa-GV9iQsOumX7M0mRVE1SYyq@mail.gmail.com>
In-Reply-To: <AANLkTind4rEphKcFnoBBa-GV9iQsOumX7M0mRVE1SYyq@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Luis,

Em 04-06-2010 16:39, Luis Henrique Fagundes escreveu:
> Hi,
> 
> I'm sending a patch that hypothetically would allocate a memory buffer
> for the audio and copy the data from urb to buffer. It doesn't work,
> so I'm not putting a [PATCH] in subject and send it just for feedback.
> Am I going on the right way of implementing this? The patch was made
> against the mercurial version at http://linuxtv.org/hg/v4l-dvb.
> 
> I can see the audio packets at tm6000-video.c. Mauro said that the urb
> audio packets had just 4 bytes of relevant data, 2 for each channel,
> but the audio buffer has 128Kb and I see too few packets. Anyway, the
> tm6000_audio_isocirq function receives the size of the packet and now
> is copying everything to the buffer, I guess next step will be to find
> what is relevant in this stream and make sure I have all packets here.
> 
> I haven't applied all the recent patches from Stefan yet.

I just sent a series of patches against my git (branch staging/tm6000), where
the other patches were added. I'll be merging those patches there shortly.

It basically implements most of the code to proccess alsa, and fixes some bugs.

The remaining code is just to copy the data into the alsa dma runtime buffers,
that the code already allocates.

I'll be writing the code and sending the patch soon. Yet, I suspect that there's
something still wrong, as the amount of audio data seems too less than I would
expect (at least on my tests, where those info are printed at console).

This is what I'm getting here with the Saphire WonderTV (you need to modprobe
tm6000-alsa to see the printk's, as they're implemented inside the alsa module):

[ 4476.987081] Audio (48 bytes): (0x24a4, 0x03dc), (0x472f, 0x346e), (0x5b86, 0x5982), (0x427a, 0x4585), (0x5080, 0x4a8a), (0x4889, 0x4162), (0x4192, 0x2448), (0x2a7b, 0x4e5e), (0x4f6b, 0x3d6a), (0x4679, 0x546f), (0x4880, 0x4172), (0x4d83, 0x4f77), 
[ 4479.534198] Audio (8 bytes): (0x2a91, 0x2868), (0x2e88, 0x2578), 
[ 4480.908388] Audio (16 bytes): (0x5387, 0x5578), (0x5064, 0x4e8e), (0x4c61, 0x4a91), (0x4967, 0x4897), 
[ 4482.184835] Audio (132 bytes): (0xb03e, 0x633a), (0x9238, 0x7b32), (0x882d, 0x7734), (0x8738, 0x7836), (0x7b34, 0x8137), (0x8439, 0x7738), (0x5c37, 0x2683), (0x8347, 0x7935), (0x6e34, 0x8235), (0x7d37, 0x7637), (0x8639, 0x763a), (0x8238, 0x7d36), (0x8e37, 0x7e37), (0x8736, 0x8c3a), (0x7b3d, 0x953f), (0x6a40, 0x963f), (0x5b3d, 0x8e3d), (0x6541, 0x7e42), (0x763f, 0x793c), (0x813b, 0x7c39), (0x813a, 0x7e3b), (0x843a, 0x7d39), (0x883c, 0x7f3e), (0x883b, 0x8139), (0x853b, 0x833b), (0x7e38, 0x843a), (0x773d, 0x7f3b), (0x6d38, 0x7c35), (0x6f35, 0x7d35), (0x8d3a, 0x7a41), (0xa946, 0x6f58), (0xa25a, 0x6a3f), (0x9328, 0x6d34), 
[ 4483.810896] Audio (28 bytes): (0x478a, 0x4862), (0x4889, 0x4761), (0x4385, 0x4067), (0x3f87, 0x3e6e), (0x3d7a, 0x3f74), (0x416f, 0x4372), (0x427e, 0x416d), 
[ 4483.813847] Audio (56 bytes): (0x4273, 0x4930), (0x5035, 0x502a), (0x5148, 0x5250), (0x5669, 0x5e60), (0x5a74, 0x4f5f), (0x4c89, 0x4d5e), (0x4988, 0x425e), (0x4380, 0x4468), (0x4487, 0x496b), (0x4d8f, 0x4d6b), (0x4d8b, 0x5276), (0x5883, 0x4f79), (0x4d7f, 0x4b79), (0x4578, 0x457d), 
[ 4484.794152] Audio (8 bytes): (0x5b73, 0x5c65), (0x5487, 0x5b5f), 
[ 4488.094453] Audio (180 bytes): (0x8847, 0x2644), (0x9e56, 0x4f3f), (0x852f, 0x554b), (0x814c, 0x6e3a), (0x7b41, 0x9b40), (0x833b, 0x9e37), (0xa135, 0x8134), (0xa435, 0x8c34), (0x913a, 0x7a3e), (0x9f32, 0x6336), (0x8e3d, 0x873e), (0x783e, 0x7648), (0x974b, 0x6540), (0x933f, 0x873d), (0x733c, 0x914a), (0x6f59, 0x7249), (0x803a, 0x594c), (0x8363, 0x576a), (0x776d, 0xb37e), (0x4c87, 0xe380), (0x5687, 0x9592), (0x8175, 0x7e5e), (0x6c5e, 0x9366), (0x5c72, 0x8d75), (0x627d, 0x9289), (0x5b7f, 0xaa7c), (0x558d, 0xa39b), (0x66a6, 0x9bb2), (0x6dba, 0x5cc0), (0x29b3, 0x9247), (0x72c3, 0x7fc4), (0x76c1, 0x88bb), (0x6ab5, 0x99af), (0x6aac, 0x90a7), (0x7aa9, 0x96a2), (0x708e, 0xdc7b), (0x527f, 0xf080), (0x7073, 0xd96a), (0xb85e, 0x9264), (0xcb55, 0x784b), (0xb447, 0x5344), (0xb747, 0x6a40), (0x9624, 0x9517), (0x751e, 0x6c24), (0x8c27, 0x6b2e), 

Cheers,
Mauro
