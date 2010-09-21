Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:16817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038Ab0IUUhs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Sep 2010 16:37:48 -0400
Message-ID: <4C99177F.9060100@redhat.com>
Date: Tue, 21 Sep 2010 17:37:19 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitri Belimov <d.belimov@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Felipe Sanches <juca@members.fsf.org>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Bee Hock Goh <beehock@gmail.com>,
	Luis Henrique Fagundes <lhfagundes@hacklab.com.br>
Subject: Re: [PATCH v2] tm6000+audio
References: <20100622180521.614eb85d@glory.loctelecom.ru> <4C20D91F.500@redhat.com> <4C212A90.7070707@arcor.de> <4C213257.6060101@redhat.com> <4C222561.4040605@arcor.de> <4C224753.2090109@redhat.com> <4C225A5C.7050103@arcor.de> <20100716161623.2f3314df@glory.loctelecom.ru> <4C4C4DCA.1050505@redhat.com> <20100728113158.0f1495c0@glory.loctelecom.ru> <4C4FD659.9050309@arcor.de> <20100729140936.5bddd275@glory.loctelecom.ru> <4C51ADB5.7010906@redhat.com> <20100731122428.4ee569b4@glory.loctelecom.ru> <4C53A837.3070700@redhat.com> <20100825043746.225a352a@glory.local> <4C7543DA.1070307@redhat.com> <AANLkTimr3=1QHzX3BzUVyo6uqLdCKt8SS9sDtHfZtHGZ@mail.gmail.com> <4C767302.7070506@redhat.com> <20100920160715.7594ee2e@glory.local>
In-Reply-To: <20100920160715.7594ee2e@glory.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 20-09-2010 17:07, Dmitri Belimov escreveu:
> Hi 
> 
> I rework my last patch for audio and now audio works well. This patch can be submited to GIT tree
> Quality of audio now is good for SECAM-DK. For other standard I set some value from datasheet need some tests.
> 
> 1. Fix pcm buffer overflow
> 2. Rework pcm buffer fill method
> 3. Swap bytes in audio stream
> 4. Change some registers value for TM6010
> 5. Change pcm buffer size
> --- a/drivers/staging/tm6000/tm6000-stds.c
> +++ b/drivers/staging/tm6000/tm6000-stds.c
> @@ -96,6 +96,7 @@ static struct tm6000_std_tv_settings tv_stds[] = {
>  
>  			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
>  			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
> +			{TM6010_REQ08_R05_A_STANDARD_MOD, 0x21}, /* FIXME */

This didn't seem to work for PAL-M. Probably, the right value for it is 0x22, to
follow NTSC/M, since both uses the same audio standard.

On some tests, I was able to receive some audio there, at the proper rate, with a
tm6010-based device. It died when I tried to change the channel, so I didn't rear
yet the real audio, but I suspect it will work on my next tests.

Yet, is being hard to test, as the driver has a some spinlock logic broken.
I'm enclosing the logs.

I was able to test only when using a monitor on the same machine. All trials of
using vnc and X11 export ended by not receiving any audio and hanging the machine.

I suspect that we need to fix the spinlock issue, in order to better test it.

Cheers,
Mauro.

[  564.483502] [drm] nouveau 0000:0f:00.0: Allocating FIFO number 1
[  564.492341] [drm] nouveau 0000:0f:00.0: nouveau_channel_alloc: initialised F1
[  579.380503] BUG: spinlock wrong CPU on CPU#0, pulseaudio/4760
[  579.386244]  lock: ffff880119bde7e8, .magic: dead4ead, .owner: pulseaudio/471
[  579.394738] Pid: 4760, comm: pulseaudio Tainted: G         C  2.6.35+ #4
[  579.401415] Call Trace:
[  579.403856]  [<ffffffff8224f539>] spin_bug+0x9c/0xa3
[  579.408803]  [<ffffffff8224f625>] do_raw_spin_unlock+0xe5/0xfc
[  579.414617]  [<ffffffff824b2092>] _raw_spin_unlock+0x2b/0x30
[  579.420256]  [<ffffffffa04453e4>] snd_tm6000_card_trigger+0xb9/0xc7 [tm6000_]
[  579.427719]  [<ffffffffa0163a4e>] snd_pcm_do_start+0x2c/0x2e [snd_pcm]
[  579.434228]  [<ffffffffa0163975>] snd_pcm_action_single+0x33/0x6a [snd_pcm]
[  579.441166]  [<ffffffff824b1ad0>] ? _raw_spin_lock+0x39/0x40
[  579.446808]  [<ffffffffa016551a>] ? snd_pcm_action_lock_irq+0x7d/0xb1 [snd_p]
[  579.454092]  [<ffffffffa0165528>] snd_pcm_action_lock_irq+0x8b/0xb1 [snd_pcm]
[  579.461205]  [<ffffffffa0167edd>] snd_pcm_common_ioctl1+0x3ec/0xb08 [snd_pcm]
[  579.468316]  [<ffffffff821ff5da>] ? inode_has_perm+0xab/0xcf
[  579.473958]  [<ffffffffa0168801>] snd_pcm_capture_ioctl1+0x208/0x225 [snd_pc]
[  579.481160]  [<ffffffff8207bea5>] ? __lock_acquire+0x201/0x424
[  579.486974]  [<ffffffffa016884d>] snd_pcm_capture_ioctl+0x2f/0x33 [snd_pcm]
[  579.493910]  [<ffffffff8212e408>] vfs_ioctl+0x32/0xa6
[  579.498945]  [<ffffffff8212ed57>] do_vfs_ioctl+0x497/0x4d0
[  579.504414]  [<ffffffff8212edec>] sys_ioctl+0x5c/0x9c
[  579.509450]  [<ffffffff82009df2>] system_call_fastpath+0x16/0x1b

Message from syslogd@nehalem at Sep 21 20:06:31 ...
 kernel:[  579.380503] BUG: spinlock wrong CPU on CPU#0, pulseaudio/4760

Message from syslogd@nehalem at Sep 21 20:06:31 ...
 kernel:[  579.386244]  lock: ffff880119bde7e8, .magic: dead4ead, .owner: pulse1
[  745.147642] fuse init (API version 7.14)
[ 1170.332614] tm6000: open called (dev=video0)
[ 1171.028670] xc2028 3-0061: Loading firmware for type=BASE (1), id 0000000000.
[ 1233.289714] xc2028 3-0061: Loading firmware for type=(0), id 000000000000b70.
[ 1234.345782] SCODE (20000000), id 000000000000b700:
[ 1234.350586] xc2028 3-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60.
[ 1235.495700] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1235.541628] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1235.581902] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1235.616388] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1235.645121] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1235.668112] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1235.685352] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1235.697594] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1235.720580] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1235.766553] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1235.806788] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1235.841268] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1235.870005] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1235.892991] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1235.910230] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1235.922474] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1235.945465] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1235.991441] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1236.031667] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1236.066150] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1236.094887] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1236.117873] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1236.135114] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1236.147360] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1236.170348] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1236.216317] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1236.256553] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1236.291035] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1236.319770] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1236.342759] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1236.359997] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1236.372241] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1236.395229] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1236.441205] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1236.481440] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1236.515919] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1236.544653] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1236.567640] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1236.584882] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1236.597125] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1285.446681] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1285.492645] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1285.532873] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1285.567354] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1285.596092] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1285.619080] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1285.636320] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1285.648563] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1303.164298] tm6000: open called (dev=video0)
[ 1304.615684] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1304.661654] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1304.701882] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1304.736367] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1304.765099] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1304.788092] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1304.805329] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1304.817573] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1304.840563] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1304.886536] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1304.926769] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1304.961248] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1304.989985] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1305.012975] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1305.030214] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1305.042457] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1305.065445] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1305.111416] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1305.151665] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1305.186136] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1305.214867] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1305.237855] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1305.255095] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1305.267340] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1305.290327] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1305.336302] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1305.376533] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1305.411013] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1305.439752] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1305.462738] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1305.479980] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1305.492225] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1305.515210] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1305.561185] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1305.601414] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1305.635900] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1305.664634] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1305.687619] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1305.704861] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1305.717060] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1331.486680] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1331.532653] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1331.572882] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1331.607364] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1331.636097] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1331.659086] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1331.676330] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1331.688573] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1411.292381] tm6000: open called (dev=video0)
[ 1412.737342] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1412.783309] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1412.823540] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1412.858026] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1412.886757] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1412.909747] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1412.926990] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1412.939232] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1412.962223] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.008193] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.048425] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.082905] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.111643] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.134631] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.151871] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.164117] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.187106] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.233076] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.273308] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.307789] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.336525] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.359512] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.376756] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.388994] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.411996] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.457960] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.498190] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.532673] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.561407] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.584398] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.601640] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.613879] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.636868] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.682841] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.723071] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.757556] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.786290] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.809280] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.826522] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1413.838763] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1422.321344] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1422.367319] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1422.407549] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1422.442032] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1422.470766] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1422.493756] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1422.510991] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1422.523212] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1438.182687] tm6000: open called (dev=video0)
[ 1439.632325] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1439.678299] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1439.718525] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1439.753010] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1439.781744] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1439.804734] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1439.821975] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1439.834216] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1439.857207] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1439.903176] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1439.943408] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1439.977903] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1440.006626] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1440.029613] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1440.046856] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1440.059102] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1440.082089] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1440.128064] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1440.168249] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1440.202776] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1440.231510] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1440.254499] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1440.271740] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1440.283982] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1440.306977] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1440.352945] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1440.393173] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1440.427655] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1440.456395] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1440.479380] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1440.496622] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1440.508867] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1440.531854] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1440.577830] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1440.618057] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1440.652539] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1440.681274] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1440.704261] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1440.721506] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1440.733748] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1444.940556] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1444.986533] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1445.026762] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1445.061244] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1445.089983] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1445.112965] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1445.130208] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1445.142450] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 1461.052139] tm6000: Remove (TM6000 Audio Extension) extension
[ 1461.058516] usbcore: deregistering interface driver tm6000
[ 1461.064064] tm6000: disconnecting tm6000 #0
[ 1461.096303] xc2028 3-0061: destroying instance
[ 1472.642877] tm6000: module is from the staging directory, the quality is unk.
[ 1472.659238] tm6000 v4l2 driver version 0.0.2 loaded
[ 1472.665293] tm6000: alt 0, interface 0, class 255
[ 1472.670050] tm6000: alt 0, interface 0, class 255
[ 1472.674794] tm6000: Bulk IN endpoint: 0x82 (max size=512 bytes)
[ 1472.680758] tm6000: alt 0, interface 0, class 255
[ 1472.685499] tm6000: alt 1, interface 0, class 255
[ 1472.690244] tm6000: ISOC IN endpoint: 0x81 (max size=3072 bytes)
[ 1472.696284] tm6000: alt 1, interface 0, class 255
[ 1472.701030] tm6000: alt 1, interface 0, class 255
[ 1472.705730] tm6000: INT IN endpoint: 0x83 (max size=4 bytes)
[ 1472.705732] tm6000: alt 2, interface 0, class 255
[ 1472.705735] tm6000: alt 2, interface 0, class 255
[ 1472.705737] tm6000: alt 2, interface 0, class 255
[ 1472.705740] tm6000: alt 3, interface 0, class 255
[ 1472.705742] tm6000: alt 3, interface 0, class 255
[ 1472.705745] tm6000: alt 3, interface 0, class 255
[ 1472.705747] tm6000: New video device @ 480 Mbps (2040:6600, ifnum 0)
[ 1472.705750] tm6000: Found Hauppauge WinTV HVR-900H / WinTV USB2-Stick
[ 1473.512254] Board version = 0x67980bf4
[ 1473.875381] board=0x67980bf4
[ 1473.988648] tm6000 #0: i2c eeprom 00: 01 59 54 45 12 01 00 02 00 00 00 40 40f
[ 1474.151886] tm6000 #0: i2c eeprom 10: 69 00 10 20 40 01 02 03 48 00 79 00 62.
[ 1474.315115] tm6000 #0: i2c eeprom 20: ff 00 64 ff ff ff ff ff ff ff ff ff ff.
[ 1474.478357] tm6000 #0: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff.
[ 1474.644936] tm6000 #0: i2c eeprom 40: 10 03 48 00 56 00 52 00 39 00 30 00 30.
[ 1474.808167] tm6000 #0: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff.
[ 1474.971419] tm6000 #0: i2c eeprom 60: 30 ff ff ff 0f ff ff ff ff ff 0a 03 32.
[ 1475.134646] tm6000 #0: i2c eeprom 70: 3f 00 ff ff ff ff ff ff ff ff ff ff ff.
[ 1475.301228] tm6000 #0: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff.
[ 1475.464488] tm6000 #0: i2c eeprom 90: 36 ff ff ff 16 03 34 00 30 00 33 00 31.
[ 1475.627698] tm6000 #0: i2c eeprom a0: 33 00 32 00 37 00 34 00 35 00 00 00 00.
[ 1475.794267] tm6000 #0: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff.
[ 1475.960844] tm6000 #0: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff.
[ 1476.130747] tm6000 #0: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff.
[ 1476.300647] tm6000 #0: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff.
[ 1476.463871] tm6000 #0: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff.
[ 1476.619190]   ................
[ 1476.635986] tuner 3-0061: chip found @ 0xc2 (tm6000 #0)
[ 1476.641378] xc2028 3-0061: creating new instance
[ 1476.645986] xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
[ 1476.652067] Setting firmware parameters for xc2028
[ 1476.677341] xc2028 3-0061: Loading 81 firmware images from xc3028L-v36.fw, t6
[ 1476.923625] xc2028 3-0061: Loading firmware for type=BASE (1), id 0000000000.
[ 1539.194671] xc2028 3-0061: Loading firmware for type=(0), id 000000000000b70.
[ 1540.250706] SCODE (20000000), id 000000000000b700:
[ 1540.255635] xc2028 3-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60.
[ 1541.353840] Trident TVMaster TM5600/TM6000/TM6010 USB2 board (Load status: 0)
[ 1541.361753] tm6000: open called (dev=video0)
[ 1541.361769] usbcore: registered new interface driver tm6000
[ 1541.363332] tm6000_alsa: module is from the staging directory, the quality i.
[ 1541.381356] tm6000 #0: Initialized (TM6000 Audio Extension) extension
[ 1541.550945] BUG: unable to handle kernel NULL pointer dereference at (null)
[ 1541.557907] IP: [<ffffffff82244d2c>] plist_add+0x6a/0xa2
[ 1541.563214] PGD 5da7067 PUD d1e40067 PMD 0 
[ 1541.567419] Oops: 0000 [#1] SMP 
[ 1541.570658] last sysfs file: /sys/devices/pci0000:00/0000:00:1a.7/usb7/7-5/st
[ 1541.579149] CPU 0 
[ 1541.580980] Modules linked in: tm6000_alsa(C) tm6000(C) fuse tuner_xc2028 tu]
[ 1541.665005] 
[ 1541.666492] Pid: 5832, comm: pulseaudio Tainted: G  R      C  2.6.35+ #4 0AEn
[ 1541.675416] RIP: 0010:[<ffffffff82244d2c>]  [<ffffffff82244d2c>] plist_add+02
[ 1541.683143] RSP: 0018:ffff880005fbfca8  EFLAGS: 00010006
[ 1541.688435] RAX: 0000000000000000 RBX: fffffffffffffff8 RCX: 0000000000000000
[ 1541.695543] RDX: ffff8801198f2448 RSI: 0000000000000000 RDI: ffffffff82c77330
[ 1541.702650] RBP: ffff880005fbfcc8 R08: 0000000000000001 R09: 0000000000000001
[ 1541.709757] R10: 0000000000000000 R11: ffffffff82a761a8 R12: ffff8801198f1040
[ 1541.716864] R13: ffff8801198f1058 R14: ffffffff82a76010 R15: 0000000077359400
[ 1541.723973] FS:  00007f1b1c31c740(0000) GS:ffff880002e00000(0000) knlGS:00000
[ 1541.732031] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1541.737754] CR2: 0000000000000000 CR3: 0000000003865000 CR4: 00000000000006f0
[ 1541.744862] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1541.751968] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1541.759078] Process pulseaudio (pid: 5832, threadinfo ffff880005fbe000, task)
[ 1541.767656] Stack:
[ 1541.769659]  ffffffff82a76010 ffff8801198f1040 00000000ffffffff 0000000000000
[ 1541.776891] <0> ffff880005fbfd18 ffffffff820702a0 0000000000000282 ffffffff80
[ 1541.784579] <0> ffff880005fbfd28 ffff8801198f1040 ffff8800bd035000 ffff880110
[ 1541.792449] Call Trace:
[ 1541.794890]  [<ffffffff820702a0>] update_target+0xb5/0x110
[ 1541.800358]  [<ffffffff82070583>] pm_qos_add_request+0x6b/0x6d
[ 1541.806177]  [<ffffffffa0167595>] snd_pcm_hw_params+0x2e2/0x318 [snd_pcm]
[ 1541.812947]  [<ffffffffa0167d3e>] snd_pcm_common_ioctl1+0x24d/0xb08 [snd_pcm]
[ 1541.820057]  [<ffffffff821ff5da>] ? inode_has_perm+0xab/0xcf
[ 1541.825701]  [<ffffffffa0168801>] snd_pcm_capture_ioctl1+0x208/0x225 [snd_pc]
[ 1541.832901]  [<ffffffffa016884d>] snd_pcm_capture_ioctl+0x2f/0x33 [snd_pcm]
[ 1541.839838]  [<ffffffff8212e408>] vfs_ioctl+0x32/0xa6
[ 1541.844872]  [<ffffffff8212ed57>] do_vfs_ioctl+0x497/0x4d0
[ 1541.850338]  [<ffffffff8212edec>] sys_ioctl+0x5c/0x9c
[ 1541.855374]  [<ffffffff82009df2>] system_call_fastpath+0x16/0x1b
[ 1541.861356] Code: b8 a3 e0 ff 89 de 31 d2 48 c7 c7 30 73 c7 82 e8 4b d7 e7 f 
[ 1541.880975] RIP  [<ffffffff82244d2c>] plist_add+0x6a/0xa2
[ 1541.886365]  RSP <ffff880005fbfca8>
[ 1541.889838] CR2: 0000000000000000
[ 1541.893142] ---[ end trace 0971618c8b6b8c61 ]---

Message from syslogd@nehalem[ 1631.848176] BUG: spinlock lockup on CPU#0, swapp0
[ 1631.850318] BUG: spinlock lockup on CPU#1, swapper/0, ffffffff82a76190
[ 1631.850321] Pid: 0, comm: swapper Tainted: G  R   D  C  2.6.35+ #4
[ 1631.850323] Call Trace:
[ 1631.850330]  [<ffffffff8224f7bd>] do_raw_spin_lock+0x181/0x1b1
[ 1631.850334]  [<ffffffff824b1a8d>] _raw_spin_lock_irqsave+0x4c/0x56
[ 1631.850338]  [<ffffffff820705a4>] ? pm_qos_request+0x1f/0x6b
[ 1631.850341]  [<ffffffff820705a4>] pm_qos_request+0x1f/0x6b
[ 1631.850344]  [<ffffffff823c03a2>] menu_select+0x33/0x2dc
[ 1631.850348]  [<ffffffff824b5a07>] ? __atomic_notifier_call_chain+0x0/0x8b
[ 1631.850352]  [<ffffffff823bf553>] cpuidle_idle_call+0x5a/0x143
[ 1631.850357]  [<ffffffff82008cd4>] cpu_idle+0xc7/0x122
[ 1631.850360]  [<ffffffff824a94f4>] start_secondary+0x2ff/0x34a
[ 1631.850362] sending NMI to all CPUs:
[ 1631.850367] NMI backtrace for cpu 0
[ 1631.850369] CPU 0 
[ 1631.850370] Modules linked in: tm6000_alsa(C) tm6000(C) fuse tuner_xc2028 tu]
[ 1631.850422] 
[ 1631.850425] Pid: 0, comm: swapper Tainted: G  R   D  C  2.6.35+ #4 0AE4h/HP n
[ 1631.850427] RIP: 0010:[<ffffffff82311725>]  [<ffffffff82311725>] io_serial_ia
[ 1631.850433] RSP: 0018:ffffffff82a01b28  EFLAGS: 00000002
[ 1631.850434] RAX: ffffffff82a01b00 RBX: ffffffff83973ea0 RCX: 0000000000000000
[ 1631.850436] RDX: 00000000000003fd RSI: 00000000000003fd RDI: ffffffff83973ea0
[ 1631.850438] RBP: ffffffff82a01b28 R08: 0000000000000001 R09: 0000000000000000
[ 1631.850440] R10: 0000000000000000 R11: ffffffff83973eb8 R12: 000000000000270f
[ 1631.850442] R13: 0000000000000020 R14: 0000000000000000 R15: ffffffff82311da5
[ 1631.850444] FS:  0000000000000000(0000) GS:ffff880002e00000(0000) knlGS:00000
[ 1631.850446] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1631.850448] CR2: 0000000000000000 CR3: 0000000118db8000 CR4: 00000000000006f0
[ 1631.850450] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1631.850452] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1631.850454] Process swapper (pid: 0, threadinfo ffffffff82a00000, task fffff)
[ 1631.850455] Stack:
[ 1631.850457]  ffffffff82a01b58 ffffffff82311d3c ffffffff83973ea0 000000000000b
[ 1631.850459] <0> 000000000000004a ffffffff82ea9c39 ffffffff82a01b78 ffffffff81
[ 1631.850462] <0> ffffffff82ea9c1d ffffffff83973ea0 ffffffff82a01bb8 ffffffff84
[ 1631.850466] Call Trace:
[ 1631.850469]  [<ffffffff82311d3c>] wait_for_xmitr+0x27/0x90
[ 1631.850473]  [<ffffffff82311dc1>] serial8250_console_putchar+0x1c/0x2c
[ 1631.850476]  [<ffffffff8230e104>] uart_console_write+0x45/0x5b
[ 1631.850479]  [<ffffffff82312435>] serial8250_console_write+0xc7/0x121
[ 1631.850482]  [<ffffffff8204f297>] __call_console_drivers+0x6c/0x7e
[ 1631.850485]  [<ffffffff8204f307>] _call_console_drivers+0x5e/0x62
[ 1631.850488]  [<ffffffff8204f762>] release_console_sem+0x147/0x1ec
[ 1631.850490]  [<ffffffff8204fe72>] vprintk+0x3ff/0x452
[ 1631.850494]  [<ffffffff824af2a9>] printk+0x41/0x43
[ 1631.850498]  [<ffffffff8224f7b8>] do_raw_spin_lock+0x17c/0x1b1
[ 1631.850501]  [<ffffffff824b1a8d>] _raw_spin_lock_irqsave+0x4c/0x56
[ 1631.850504]  [<ffffffff820705a4>] ? pm_qos_request+0x1f/0x6b
[ 1631.850507]  [<ffffffff820705a4>] pm_qos_request+0x1f/0x6b
[ 1631.850509]  [<ffffffff823c03a2>] menu_select+0x33/0x2dc
[ 1631.850513]  [<ffffffff824b5a07>] ? __atomic_notifier_call_chain+0x0/0x8b
[ 1631.850516]  [<ffffffff823bf553>] cpuidle_idle_call+0x5a/0x143
[ 1631.850520]  [<ffffffff82008cd4>] cpu_idle+0xc7/0x122
[ 1631.850523]  [<ffffffff82498cfb>] rest_init+0xcf/0xd6
[ 1631.850526]  [<ffffffff82498c2c>] ? rest_init+0x0/0xd6
[ 1631.850529]  [<ffffffff82cece16>] start_kernel+0x429/0x434
[ 1631.850533]  [<ffffffff82cec2c8>] x86_64_start_reservations+0xb3/0xb7
[ 1631.850536]  [<ffffffff82cec3c4>] x86_64_start_kernel+0xf8/0x107
[ 1631.850538] Code: 88 11 83 fe 01 77 0b be 01 00 00 00 48 89 c7 ff 50 40 58 5 
[ 1631.850565] Call Trace:
[ 1631.850568]  [<ffffffff82311d3c>] wait_for_xmitr+0x27/0x90
[ 1631.850571]  [<ffffffff82311dc1>] serial8250_console_putchar+0x1c/0x2c
[ 1631.850573]  [<ffffffff8230e104>] uart_console_write+0x45/0x5b
[ 1631.850576]  [<ffffffff82312435>] serial8250_console_write+0xc7/0x121
[ 1631.850579]  [<ffffffff8204f297>] __call_console_drivers+0x6c/0x7e
[ 1631.850581]  [<ffffffff8204f307>] _call_console_drivers+0x5e/0x62
[ 1631.850584]  [<ffffffff8204f762>] release_console_sem+0x147/0x1ec
[ 1631.850587]  [<ffffffff8204fe72>] vprintk+0x3ff/0x452
[ 1631.850590]  [<ffffffff824af2a9>] printk+0x41/0x43
[ 1631.850593]  [<ffffffff8224f7b8>] do_raw_spin_lock+0x17c/0x1b1
[ 1631.850595]  [<ffffffff824b1a8d>] _raw_spin_lock_irqsave+0x4c/0x56
[ 1631.850598]  [<ffffffff820705a4>] ? pm_qos_request+0x1f/0x6b
[ 1631.850601]  [<ffffffff820705a4>] pm_qos_request+0x1f/0x6b
[ 1631.850603]  [<ffffffff823c03a2>] menu_select+0x33/0x2dc
[ 1631.850606]  [<ffffffff824b5a07>] ? __atomic_notifier_call_chain+0x0/0x8b
[ 1631.850609]  [<ffffffff823bf553>] cpuidle_idle_call+0x5a/0x143
[ 1631.850612]  [<ffffffff82008cd4>] cpu_idle+0xc7/0x122
[ 1631.850614]  [<ffffffff82498cfb>] rest_init+0xcf/0xd6
[ 1631.850617]  [<ffffffff82498c2c>] ? rest_init+0x0/0xd6
[ 1631.850619]  [<ffffffff82cece16>] start_kernel+0x429/0x434
[ 1631.850622]  [<ffffffff82cec2c8>] x86_64_start_reservations+0xb3/0xb7
[ 1631.850625]  [<ffffffff82cec3c4>] x86_64_start_kernel+0xf8/0x107
[ 1631.850628] Pid: 0, comm: swapper Tainted: G  R   D  C  2.6.35+ #4
[ 1631.850629] Call Trace:
[ 1631.850630]  <NMI>  [<ffffffff820118ca>] ? show_regs+0x2b/0x2f
[ 1631.850636]  [<ffffffff824b3b41>] nmi_watchdog_tick+0xc2/0x1a5
[ 1631.850639]  [<ffffffff824b2fa4>] do_nmi+0xd8/0x2b7
[ 1631.850642]  [<ffffffff82311da5>] ? serial8250_console_putchar+0x0/0x2c
[ 1631.850644]  [<ffffffff824b29d0>] nmi+0x20/0x30
[ 1631.850647]  [<ffffffff82311da5>] ? serial8250_console_putchar+0x0/0x2c
[ 1631.850650]  [<ffffffff82311725>] ? io_serial_in+0x15/0x1a
[ 1631.850652]  <<EOE>>  [<ffffffff82311d3c>] wait_for_xmitr+0x27/0x90
[ 1631.850656]  [<ffffffff82311dc1>] serial8250_console_putchar+0x1c/0x2c
[ 1631.850659]  [<ffffffff8230e104>] uart_console_write+0x45/0x5b
[ 1631.850662]  [<ffffffff82312435>] serial8250_console_write+0xc7/0x121
[ 1631.850665]  [<ffffffff8204f297>] __call_console_drivers+0x6c/0x7e
[ 1631.850667]  [<ffffffff8204f307>] _call_console_drivers+0x5e/0x62
[ 1631.850670]  [<ffffffff8204f762>] release_console_sem+0x147/0x1ec
[ 1631.850673]  [<ffffffff8204fe72>] vprintk+0x3ff/0x452
[ 1631.850676]  [<ffffffff824af2a9>] printk+0x41/0x43
[ 1631.850679]  [<ffffffff8224f7b8>] do_raw_spin_lock+0x17c/0x1b1
[ 1631.850681]  [<ffffffff824b1a8d>] _raw_spin_lock_irqsave+0x4c/0x56
[ 1631.850684]  [<ffffffff820705a4>] ? pm_qos_request+0x1f/0x6b
[ 1631.850687]  [<ffffffff820705a4>] pm_qos_request+0x1f/0x6b
[ 1631.850689]  [<ffffffff823c03a2>] menu_select+0x33/0x2dc
[ 1631.850692]  [<ffffffff824b5a07>] ? __atomic_notifier_call_chain+0x0/0x8b
[ 1631.850695]  [<ffffffff823bf553>] cpuidle_idle_call+0x5a/0x143
[ 1631.850698]  [<ffffffff82008cd4>] cpu_idle+0xc7/0x122
[ 1631.850700]  [<ffffffff82498cfb>] rest_init+0xcf/0xd6
[ 1631.850703]  [<ffffffff82498c2c>] ? rest_init+0x0/0xd6
[ 1631.850705]  [<ffffffff82cece16>] start_kernel+0x429/0x434
[ 1631.850708]  [<ffffffff82cec2c8>] x86_64_start_reservations+0xb3/0xb7
[ 1631.850711]  [<ffffffff82cec3c4>] x86_64_start_kernel+0xf8/0x107
[ 1631.850713] NMI backtrace for cpu 1
[ 1631.850715] CPU 1 
[ 1631.850716] Modules linked in: tm6000_alsa(C) tm6000(C) fuse tuner_xc2028 tu]
[ 1631.850763] 
[ 1631.850765] Pid: 0, comm: swapper Tainted: G  R   D  C  2.6.35+ #4 0AE4h/HP n
[ 1631.850767] RIP: 0010:[<ffffffff8224ab40>]  [<ffffffff8224ab40>] delay_tsc+02
[ 1631.850771] RSP: 0018:ffff88011b749d58  EFLAGS: 00000046
[ 1631.850773] RAX: 0000000000000024 RBX: 0000000036a12720 RCX: 0000000036a12744
[ 1631.850774] RDX: 00000000000003d1 RSI: 0000000000000010 RDI: 000000000026a757
[ 1631.850776] RBP: ffff88011b749d88 R08: 0000000000000000 R09: 0000000000000040
[ 1631.850778] R10: 0000000000000000 R11: ffffffff82a70ab8 R12: 0000000000000001
[ 1631.850780] R13: 000000000026a757 R14: 0000000036a12744 R15: 0000000000000000
[ 1631.850782] FS:  0000000000000000(0000) GS:ffff880002e20000(0000) knlGS:00000
[ 1631.850784] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1631.850786] CR2: 000000000221a000 CR3: 0000000116c78000 CR4: 00000000000006e0
[ 1631.850788] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1631.850790] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1631.850792] Process swapper (pid: 0, threadinfo ffff88011b748000, task ffff8)
[ 1631.850793] Stack:
[ 1631.850795]  ffff88011b749d68 0000000000000001 ffff88011b742620 0000000096fdc
[ 1631.850797] <0> ffff88011b742cb8 0000000096fd5e1c ffff88011b749d98 ffffffff81
[ 1631.850801] <0> ffff88011b749db8 ffffffff820247a0 ffffffff82a76190 ffffffff80
[ 1631.850804] Call Trace:
[ 1631.850807]  [<ffffffff8224aac1>] __const_udelay+0x40/0x42
[ 1631.850811]  [<ffffffff820247a0>] arch_trigger_all_cpu_backtrace+0x78/0x84
[ 1631.850814]  [<ffffffff8224f7c2>] do_raw_spin_lock+0x186/0x1b1
[ 1631.850817]  [<ffffffff824b1a8d>] _raw_spin_lock_irqsave+0x4c/0x56
[ 1631.850820]  [<ffffffff820705a4>] ? pm_qos_request+0x1f/0x6b
[ 1631.850823]  [<ffffffff820705a4>] pm_qos_request+0x1f/0x6b
[ 1631.850825]  [<ffffffff823c03a2>] menu_select+0x33/0x2dc
[ 1631.850828]  [<ffffffff824b5a07>] ? __atomic_notifier_call_chain+0x0/0x8b
[ 1631.850831]  [<ffffffff823bf553>] cpuidle_idle_call+0x5a/0x143
[ 1631.850834]  [<ffffffff82008cd4>] cpu_idle+0xc7/0x122
[ 1631.850837]  [<ffffffff824a94f4>] start_secondary+0x2ff/0x34a
[ 1631.850838] Code: e8 e8 be 63 dc ff 66 90 48 63 d8 0f 1f 00 0f ae e8 e8 ae 6 
[ 1631.850865] Call Trace:
[ 1631.850868]  [<ffffffff8224aac1>] __const_udelay+0x40/0x42
[ 1631.850871]  [<ffffffff820247a0>] arch_trigger_all_cpu_backtrace+0x78/0x84
[ 1631.850873]  [<ffffffff8224f7c2>] do_raw_spin_lock+0x186/0x1b1
[ 1631.850876]  [<ffffffff824b1a8d>] _raw_spin_lock_irqsave+0x4c/0x56
[ 1631.850879]  [<ffffffff820705a4>] ? pm_qos_request+0x1f/0x6b
[ 1631.850881]  [<ffffffff820705a4>] pm_qos_request+0x1f/0x6b
[ 1631.850884]  [<ffffffff823c03a2>] menu_select+0x33/0x2dc
[ 1631.850887]  [<ffffffff824b5a07>] ? __atomic_notifier_call_chain+0x0/0x8b
[ 1631.850890]  [<ffffffff823bf553>] cpuidle_idle_call+0x5a/0x143
[ 1631.850892]  [<ffffffff82008cd4>] cpu_idle+0xc7/0x122
[ 1631.850895]  [<ffffffff824a94f4>] start_secondary+0x2ff/0x34a
[ 1631.850898] Pid: 0, comm: swapper Tainted: G  R   D  C  2.6.35+ #4
[ 1631.850899] Call Trace:
[ 1631.850900]  <NMI>  [<ffffffff820118ca>] ? show_regs+0x2b/0x2f
[ 1631.850905]  [<ffffffff824b3b41>] nmi_watchdog_tick+0xc2/0x1a5
[ 1631.850908]  [<ffffffff824b2fa4>] do_nmi+0xd8/0x2b7
[ 1631.850910]  [<ffffffff824b29d0>] nmi+0x20/0x30
[ 1631.850913]  [<ffffffff8224ab40>] ? delay_tsc+0x52/0xa2
[ 1631.850914]  <<EOE>>  [<ffffffff8224aac1>] __const_udelay+0x40/0x42
[ 1631.850919]  [<ffffffff820247a0>] arch_trigger_all_cpu_backtrace+0x78/0x84
[ 1631.850922]  [<ffffffff8224f7c2>] do_raw_spin_lock+0x186/0x1b1
[ 1631.850924]  [<ffffffff824b1a8d>] _raw_spin_lock_irqsave+0x4c/0x56
[ 1631.850927]  [<ffffffff820705a4>] ? pm_qos_request+0x1f/0x6b
[ 1631.850930]  [<ffffffff820705a4>] pm_qos_request+0x1f/0x6b
[ 1631.850932]  [<ffffffff823c03a2>] menu_select+0x33/0x2dc
[ 1631.850935]  [<ffffffff824b5a07>] ? __atomic_notifier_call_chain+0x0/0x8b
[ 1631.850938]  [<ffffffff823bf553>] cpuidle_idle_call+0x5a/0x143
[ 1631.850941]  [<ffffffff82008cd4>] cpu_idle+0xc7/0x122
[ 1631.850943]  [<ffffffff824a94f4>] start_secondary+0x2ff/0x34a
[ 1633.056411] Pid: 0, comm: swapper Tainted: G  R   D  C  2.6.35+ #4
[ 1633.062565] Call Trace:
[ 1633.065001]  [<ffffffff8224f7bd>] do_raw_spin_lock+0x181/0x1b1
[ 1633.070810]  [<ffffffff824b1a8d>] _raw_spin_lock_irqsave+0x4c/0x56
[ 1633.076966]  [<ffffffff820705a4>] ? pm_qos_request+0x1f/0x6b
[ 1633.082604]  [<ffffffff820705a4>] pm_qos_request+0x1f/0x6b
[ 1633.088068]  [<ffffffff823c03a2>] menu_select+0x33/0x2dc
[ 1633.093360]  [<ffffffff824b5a07>] ? __atomic_notifier_call_chain+0x0/0x8b
[ 1633.100121]  [<ffffffff823bf553>] cpuidle_idle_call+0x5a/0x143
[ 1633.105930]  [<ffffffff82008cd4>] cpu_idle+0xc7/0x122
[ 1633.110960]  [<ffffffff82498cfb>] rest_init+0xcf/0xd6
[ 1633.115991]  [<ffffffff82498c2c>] ? rest_init+0x0/0xd6
[ 1633.121108]  [<ffffffff82cece16>] start_kernel+0x429/0x434
[ 1633.126573]  [<ffffffff82cec2c8>] x86_64_start_reservations+0xb3/0xb7
[ 1633.132989]  [<ffffffff82cec3c4>] x86_64_start_kernel+0xf8/0x107
[ 1633.138970] sending NMI to all CPUs:
[ 1633.142532] NMI backtrace for cpu 0
[ 1633.146006] CPU 0 
[ 1633.147834] Modules linked in: tm6000_alsa(C) tm6000(C) fuse tuner_xc2028 tu]
[ 1633.231779] 
[ 1633.233263] Pid: 0, comm: swapper Tainted: G  R   D  C  2.6.35+ #4 0AE4h/HP n
[ 1633.241667] RIP: 0010:[<ffffffff8224aaee>]  [<ffffffff8224aaee>] delay_tsc+02
[ 1633.249306] RSP: 0018:ffffffff82a01cd0  EFLAGS: 00000807
[ 1633.254595] RAX: 00000000d195a130 RBX: 0000000000000000 RCX: ffff880002e00000
[ 1633.261701] RDX: 000000000003dd6d RSI: 0000000000000001 RDI: 000000000003dd6e
[ 1633.268807] RBP: ffffffff82a01cd8 R08: 0000000000000000 R09: ffffffff82ccbad0
[ 1633.275912] R10: 0000000000000086 R11: ffffffff82a70ab8 R12: 0000000000001000
[ 1633.283019] R13: 0000000000000004 R14: 0000000000000001 R15: 0000000000000001
[ 1633.290125] FS:  0000000000000000(0000) GS:ffff880002e00000(0000) knlGS:00000
[ 1633.298184] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1633.303907] CR2: 0000000000000000 CR3: 0000000118db8000 CR4: 00000000000006f0
[ 1633.311012] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1633.318119] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1633.325226] Process swapper (pid: 0, threadinfo ffffffff82a00000, task fffff)
[ 1633.333284] Stack:
[ 1633.335286]  ffffffff8224aac1 ffffffff82a01cf8 ffffffff82024037 0000000000002
[ 1633.342513] <0> 0000000000000000 ffffffff82a01d28 ffffffff82024411 0000000002
[ 1633.350195] <0> 000000000000ea40 0000000000000002 ffffffff82ccbad0 ffffffff88
[ 1633.358061] Call Trace:
[ 1633.360496]  [<ffffffff8224aac1>] ? __const_udelay+0x40/0x42
[ 1633.366134]  [<ffffffff82024037>] native_safe_apic_wait_icr_idle+0x36/0x4b
[ 1633.372983]  [<ffffffff82024411>] __default_send_IPI_dest_field+0x45/0x84
[ 1633.379746]  [<ffffffff82024658>] default_send_IPI_mask_sequence_phys+0x51/0d
[ 1633.387025]  [<ffffffff82027e04>] physflat_send_IPI_all+0x17/0x19
[ 1633.393093]  [<ffffffff8202477e>] arch_trigger_all_cpu_backtrace+0x56/0x84
[ 1633.399942]  [<ffffffff8224f7c2>] do_raw_spin_lock+0x186/0x1b1
[ 1633.405752]  [<ffffffff824b1a8d>] _raw_spin_lock_irqsave+0x4c/0x56
[ 1633.411908]  [<ffffffff820705a4>] ? pm_qos_request+0x1f/0x6b
[ 1633.417546]  [<ffffffff820705a4>] pm_qos_request+0x1f/0x6b
[ 1633.423008]  [<ffffffff823c03a2>] menu_select+0x33/0x2dc
[ 1633.428299]  [<ffffffff824b5a07>] ? __atomic_notifier_call_chain+0x0/0x8b
[ 1633.435060]  [<ffffffff823bf553>] cpuidle_idle_call+0x5a/0x143
[ 1633.440870]  [<ffffffff82008cd4>] cpu_idle+0xc7/0x122
[ 1633.445901]  [<ffffffff82498cfb>] rest_init+0xcf/0xd6
[ 1633.450931]  [<ffffffff82498c2c>] ? rest_init+0x0/0xd6
[ 1633.456048]  [<ffffffff82cece16>] start_kernel+0x429/0x434
[ 1633.461512]  [<ffffffff82cec2c8>] x86_64_start_reservations+0xb3/0xb7
[ 1633.467927]  [<ffffffff82cec3c4>] x86_64_start_kernel+0xf8/0x107
[ 1633.473906] Code: 55 48 89 e5 0f 1f 44 00 00 48 69 ff c7 10 00 00 e8 a9 ff f 
[ 1633.493477] Call Trace:
[ 1633.495911]  [<ffffffff8224aac1>] ? __const_udelay+0x40/0x42
[ 1633.501547]  [<ffffffff82024037>] native_safe_apic_wait_icr_idle+0x36/0x4b
[ 1633.508394]  [<ffffffff82024411>] __default_send_IPI_dest_field+0x45/0x84
[ 1633.515156]  [<ffffffff82024658>] default_send_IPI_mask_sequence_phys+0x51/0d
[ 1633.522435]  [<ffffffff82027e04>] physflat_send_IPI_all+0x17/0x19
[ 1633.528506]  [<ffffffff8202477e>] arch_trigger_all_cpu_backtrace+0x56/0x84
[ 1633.535354]  [<ffffffff8224f7c2>] do_raw_spin_lock+0x186/0x1b1
[ 1633.541163]  [<ffffffff824b1a8d>] _raw_spin_lock_irqsave+0x4c/0x56
[ 1633.547318]  [<ffffffff820705a4>] ? pm_qos_request+0x1f/0x6b
[ 1633.552954]  [<ffffffff820705a4>] pm_qos_request+0x1f/0x6b
[ 1633.558417]  [<ffffffff823c03a2>] menu_select+0x33/0x2dc
[ 1633.563708]  [<ffffffff824b5a07>] ? __atomic_notifier_call_chain+0x0/0x8b
[ 1633.570470]  [<ffffffff823bf553>] cpuidle_idle_call+0x5a/0x143
[ 1633.576279]  [<ffffffff82008cd4>] cpu_idle+0xc7/0x122
[ 1633.581310]  [<ffffffff82498cfb>] rest_init+0xcf/0xd6
[ 1633.586340]  [<ffffffff82498c2c>] ? rest_init+0x0/0xd6
[ 1633.591456]  [<ffffffff82cece16>] start_kernel+0x429/0x434
[ 1633.596921]  [<ffffffff82cec2c8>] x86_64_start_reservations+0xb3/0xb7
[ 1633.603337]  [<ffffffff82cec3c4>] x86_64_start_kernel+0xf8/0x107
[ 1633.609318] Pid: 0, comm: swapper Tainted: G  R   D  C  2.6.35+ #4
[ 1633.615472] Call Trace:
[ 1633.617906]  <NMI>  [<ffffffff820118ca>] ? show_regs+0x2b/0x2f
[ 1633.623730]  [<ffffffff824b3b41>] nmi_watchdog_tick+0xc2/0x1a5
[ 1633.629540]  [<ffffffff824b2fa4>] do_nmi+0xd8/0x2b7
[ 1633.634398]  [<ffffffff824b29d0>] nmi+0x20/0x30
[ 1633.638910]  [<ffffffff8224aaee>] ? delay_tsc+0x0/0xa2
[ 1633.644026]  <<EOE>>  [<ffffffff8224aac1>] ? __const_udelay+0x40/0x42
[ 1633.650454]  [<ffffffff82024037>] native_safe_apic_wait_icr_idle+0x36/0x4b
[ 1633.657302]  [<ffffffff82024411>] __default_send_IPI_dest_field+0x45/0x84
[ 1633.664062]  [<ffffffff82024658>] default_send_IPI_mask_sequence_phys+0x51/0d
[ 1633.671342]  [<ffffffff82027e04>] physflat_send_IPI_all+0x17/0x19
[ 1633.677410]  [<ffffffff8202477e>] arch_trigger_all_cpu_backtrace+0x56/0x84
[ 1633.684257]  [<ffffffff8224f7c2>] do_raw_spin_lock+0x186/0x1b1
[ 1633.690066]  [<ffffffff824b1a8d>] _raw_spin_lock_irqsave+0x4c/0x56
[ 1633.696221]  [<ffffffff820705a4>] ? pm_qos_request+0x1f/0x6b
[ 1633.701856]  [<ffffffff820705a4>] pm_qos_request+0x1f/0x6b
[ 1633.707319]  [<ffffffff823c03a2>] menu_select+0x33/0x2dc
[ 1633.712610]  [<ffffffff824b5a07>] ? __atomic_notifier_call_chain+0x0/0x8b
[ 1633.719371]  [<ffffffff823bf553>] cpuidle_idle_call+0x5a/0x143
[ 1633.725180]  [<ffffffff82008cd4>] cpu_idle+0xc7/0x122
[ 1633.730212]  [<ffffffff82498cfb>] rest_init+0xcf/0xd6
[ 1633.735243]  [<ffffffff82498c2c>] ? rest_init+0x0/0xd6
[ 1633.740359]  [<ffffffff82cece16>] start_kernel+0x429/0x434
[ 1633.745822]  [<ffffffff82cec2c8>] x86_64_start_reservations+0xb3/0xb7
[ 1633.752237]  [<ffffffff82cec3c4>] x86_64_start_kernel+0xf8/0x107
[ 1633.758318] NMI backtrace for cpu 1
[ 1633.761791] CPU 1 
[ 1633.763619] Modules linked in: tm6000_alsa(C) tm6000(C) fuse tuner_xc2028 tu]
[ 1633.847596] 
[ 1633.849078] Pid: 0, comm: swapper Tainted: G  R   D  C  2.6.35+ #4 0AE4h/HP n
[ 1633.857482] RIP: 0010:[<ffffffff8224ab26>]  [<ffffffff8224ab26>] delay_tsc+02
[ 1633.865204] RSP: 0018:ffff88011b749d78  EFLAGS: 00000006
[ 1633.870494] RAX: 000003d256dcceb4 RBX: 0000000056dcceb4 RCX: 0000000056dcceb4
[ 1633.877601] RDX: 00000000000003d2 RSI: 0000000000000010 RDI: 0000000000000001
[ 1633.884708] RBP: ffff88011b749da8 R08: 0000000000000000 R09: 0000000000000040
[ 1633.891814] R10: 0000000000000000 R11: ffffffff82a70ab8 R12: 0000000000000001
[ 1633.898919] R13: 0000000000000001 R14: ffff88011b742cb8 R15: 0000000003336eed
[ 1633.906025] FS:  0000000000000000(0000) GS:ffff880002e20000(0000) knlGS:00000
[ 1633.914083] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1633.919805] CR2: 000000000221a000 CR3: 0000000116c78000 CR4: 00000000000006e0
[ 1633.926911] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1633.934017] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1633.941122] Process swapper (pid: 0, threadinfo ffff88011b748000, task ffff8)
[ 1633.949179] Stack:
[ 1633.951180]  ffff88011b742cb8 ffffffff82a76190 ffff88011b742620 0000000096fdc
[ 1633.958409] <0> ffff88011b742cb8 0000000003336eed ffff88011b749db8 ffffffff8f
[ 1633.966090] <0> ffff88011b749e08 ffffffff8224f783 0000000000000002 0000000000
[ 1633.973954] Call Trace:
[ 1633.976390]  [<ffffffff8224aa7f>] __delay+0xf/0x11
[ 1633.981160]  [<ffffffff8224f783>] do_raw_spin_lock+0x147/0x1b1
[ 1633.986970]  [<ffffffff824b1a8d>] _raw_spin_lock_irqsave+0x4c/0x56
[ 1633.993127]  [<ffffffff820705a4>] ? pm_qos_request+0x1f/0x6b
[ 1633.998763]  [<ffffffff820705a4>] pm_qos_request+0x1f/0x6b
[ 1634.004225]  [<ffffffff823c03a2>] menu_select+0x33/0x2dc
[ 1634.009516]  [<ffffffff824b5a07>] ? __atomic_notifier_call_chain+0x0/0x8b
[ 1634.016277]  [<ffffffff823bf553>] cpuidle_idle_call+0x5a/0x143
[ 1634.022086]  [<ffffffff82008cd4>] cpu_idle+0xc7/0x122
[ 1634.027118]  [<ffffffff824a94f4>] start_secondary+0x2ff/0x34a
[ 1634.032840] Code: 48 83 ec 08 0f 1f 44 00 00 49 89 fd 65 44 8b 24 25 38 ea 0 
[ 1634.052328] Call Trace:
[ 1634.054764]  [<ffffffff8224aa7f>] __delay+0xf/0x11
[ 1634.059536]  [<ffffffff8224f783>] do_raw_spin_lock+0x147/0x1b1
[ 1634.065345]  [<ffffffff824b1a8d>] _raw_spin_lock_irqsave+0x4c/0x56
[ 1634.071501]  [<ffffffff820705a4>] ? pm_qos_request+0x1f/0x6b
[ 1634.077136]  [<ffffffff820705a4>] pm_qos_request+0x1f/0x6b
[ 1634.082600]  [<ffffffff823c03a2>] menu_select+0x33/0x2dc
[ 1634.087891]  [<ffffffff824b5a07>] ? __atomic_notifier_call_chain+0x0/0x8b
[ 1634.094651]  [<ffffffff823bf553>] cpuidle_idle_call+0x5a/0x143
[ 1634.100461]  [<ffffffff82008cd4>] cpu_idle+0xc7/0x122
[ 1634.105490]  [<ffffffff824a94f4>] start_secondary+0x2ff/0x34a
[ 1634.111213] Pid: 0, comm: swapper Tainted: G  R   D  C  2.6.35+ #4
[ 1634.117366] Call Trace:
[ 1634.119801]  <NMI>  [<ffffffff820118ca>] ? show_regs+0x2b/0x2f
[ 1634.125623]  [<ffffffff824b3b41>] nmi_watchdog_tick+0xc2/0x1a5
[ 1634.131432]  [<ffffffff824b2fa4>] do_nmi+0xd8/0x2b7
[ 1634.136289]  [<ffffffff824b29d0>] nmi+0x20/0x30
[ 1634.140802]  [<ffffffff8224ab26>] ? delay_tsc+0x38/0xa2
[ 1634.146006]  <<EOE>>  [<ffffffff8224aa7f>] __delay+0xf/0x11
[ 1634.151569]  [<ffffffff8224f783>] do_raw_spin_lock+0x147/0x1b1
[ 1634.157380]  [<ffffffff824b1a8d>] _raw_spin_lock_irqsave+0x4c/0x56
[ 1634.163535]  [<ffffffff820705a4>] ? pm_qos_request+0x1f/0x6b
[ 1634.169172]  [<ffffffff820705a4>] pm_qos_request+0x1f/0x6b
[ 1634.174636]  [<ffffffff823c03a2>] menu_select+0x33/0x2dc
[ 1634.179927]  [<ffffffff824b5a07>] ? __atomic_notifier_call_chain+0x0/0x8b
[ 1634.186690]  [<ffffffff823bf553>] cpuidle_idle_call+0x5a/0x143
[ 1634.192499]  [<ffffffff82008cd4>] cpu_idle+0xc7/0x122
[ 1634.197530]  [<ffffffff824a94f4>] start_secondary+0x2ff/0x34a
