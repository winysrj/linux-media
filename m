Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6SKkBtO028951
	for <video4linux-list@redhat.com>; Mon, 28 Jul 2008 16:46:11 -0400
Received: from mail-in-13.arcor-online.net (mail-in-13.arcor-online.net
	[151.189.21.53])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6SKjwWK021892
	for <video4linux-list@redhat.com>; Mon, 28 Jul 2008 16:45:58 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: "P. van Gaans" <w3ird_n3rd@gmx.net>
In-Reply-To: <488B7AD1.1040106@gmx.net>
References: <488B7AD1.1040106@gmx.net>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 22:40:01 +0200
Message-Id: <1217277601.3654.15.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: saa7134-alsa  appears to be broken
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

Am Samstag, den 26.07.2008, 21:28 +0200 schrieb P. van Gaans: 
> On my Asus P7131 (DVB-T+analog+radio) I can't listen to FM radio anymore 
> with a recent v4l-dvb or multiproto. If I go back to the v4l-dvb that 
> comes with the kernel (2.6.24-19) I do get sound. Not completely without 
> problems, have to restart aplay/arecord now and then but at least it 
> works. With the recent v4l-dvb/multiproto it doesn't work at all.
> 

for what I read, on recent v4l-dvb all relevant outstanding patches are
applied and the driver should be in a sane state

To avoid further drift of the known status, I made some testing early
morning yesterday.

The saa7133/35/31e radio over RIF (amux = TV) is OK on v4l-dvb as of
head 8325 with only the proposed patch for fixing user tuner setting
applied, which Mauro picked up now. Thanks!

It is also fine on vanilla 2.6.26, radio and TV sound at 32000Hz, 16bit
stereo, up-sampled to what ever or not.

I currently only have one remaining card with a saa7134 chip in the
slots with a FMD1216ME/I MK3 on an old nforce2. That one showed, since
used, opposite to prior boards is use, soon sync drifting on saa7134
radio with tda9887, no matter of sampling rate. External analog TV sound
to the sound card is fine.

Audacity is equally bad for TV sound as radio on that one using the alsa
OSS emulation at 32000HZ, but sox in the same emulation mode has no
issues for TV sound. I suspect board/sound driver specific issues, but
would have to revive some old machines for further testing.
Also the audio clock at the one might be worse than seen on my prior
cards, but we always had such reports from time to time.

Likely you kept some old module loaded or it is reloaded.
Exported symbols for saa7134-tvaudio used by saa7134-alsa and videobuf
dma stuff are out of sync and for sure cause trouble.

Try "make rminstall", still old modules around in /lib/modules/...?

Or try "modprobe -v saa7134" to see if your distribution is playing
games with you and from where maybe duplicate and out of sync modules
are loaded.

If that doesn't help, we might start to use the same v4l-dvb snapshot
next. Currently i only have the P7131 Dual and the prior Asus Tiger.

On which P7131 you are exactly? (dmesg for subsystem, gpio init, eeprom)
It is a whole bunch of different cards meanwhile and external firmware
loading started with the P7131 Hybrid. Yes, radio is not related, but
there is also some board specific antenna input switching and LNA stuff
I can't test.  

Cheers,
Hermann

> dmesg has something to say (took out the interesting part):
> 
> [   31.155028] saa7133[0]: registered device video0 [v4l2]
> [   31.155043] saa7133[0]: registered device vbi0
> [   31.155055] saa7133[0]: registered device radio0
> [   31.247453] saa7134_alsa: disagrees about version of symbol 
> saa7134_tvaudio_setmute
> [   31.247457] saa7134_alsa: Unknown symbol saa7134_tvaudio_setmute
> [   31.247542] saa7134_alsa: disagrees about version of symbol 
> saa_dsp_writel
> [   31.247544] saa7134_alsa: Unknown symbol saa_dsp_writel
> [   31.247808] saa7134_alsa: disagrees about version of symbol 
> saa7134_dmasound_init
> [   31.247809] saa7134_alsa: Unknown symbol saa7134_dmasound_init
> [   31.247884] saa7134_alsa: disagrees about version of symbol 
> saa7134_dmasound_exit
> [   31.247886] saa7134_alsa: Unknown symbol saa7134_dmasound_exit
> [   31.248165] saa7134_alsa: disagrees about version of symbol 
> saa7134_set_dmabits
> [   31.248167] saa7134_alsa: Unknown symbol saa7134_set_dmabits
> [   31.320315] DVB: registering new adapter (saa7133[0])
> 
> I don't know if this also causes my problem but it possibly does. The 
> saa7134 audio device is not recognized at all.
> 
> And yes, I have the firmware (required for DVB-T so irrelevant but 
> anyway) installed.
> 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
