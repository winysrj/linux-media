Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36861 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbcCGWG7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Mar 2016 17:06:59 -0500
Subject: Re: [PATCH v5 22/22] sound/usb: Use Media Controller API to share
 media resources
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1456937431-3794-1-git-send-email-shuahkh@osg.samsung.com>
 <20160305070055.6e17edcd@recife.lan>
Cc: tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	javier@osg.samsung.com, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de,
	dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi,
	ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com,
	k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de,
	inki.dae@samsung.com, jh1009.sung@samsung.com,
	elfring@users.sourceforge.net, prabhakar.csengg@gmail.com,
	sw0312.kim@samsung.com, p.zabel@pengutronix.de,
	ricardo.ribalda@gmail.com, labbott@fedoraproject.org,
	pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com,
	julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de,
	misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl,
	normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net,
	johan@oljud.se, klock.android@gmail.com, nenggun.kim@samsung.com,
	j.anaszewski@samsung.com, geliangtang@163.com, albert@huitsing.nl,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56DDFB7E.7020108@osg.samsung.com>
Date: Mon, 7 Mar 2016 15:06:54 -0700
MIME-Version: 1.0
In-Reply-To: <20160305070055.6e17edcd@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/05/2016 03:00 AM, Mauro Carvalho Chehab wrote:
> Em Wed,  2 Mar 2016 09:50:31 -0700
> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> 
>> Change ALSA driver to use Media Controller API to
>> share media resources with DVB and V4L2 drivers
>> on a AU0828 media device. Media Controller specific
>> initialization is done after sound card is registered.
>> ALSA creates Media interface and entity function graph
>> nodes for Control, Mixer, PCM Playback, and PCM Capture
>> devices.
>>
>> snd_usb_hw_params() will call Media Controller enable
>> source handler interface to request the media resource.
>> If resource request is granted, it will release it from
>> snd_usb_hw_free(). If resource is busy, -EBUSY is returned.
>>
>> Media specific cleanup is done in usb_audio_disconnect().
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> Acked-by: Takashi Iwai <tiwai@suse.de>
> 
> Shuah, by looking at the produced graphs:
> 	https://mchehab.fedorapeople.org/mc-next-gen/au0828_test/
> 
> I'm noticing the lack of ALSA I/O entities in the diagram
> (MEDIA_ENT_F_AUDIO_CAPTURE). The mixer there is not connected.
> 
> Could you please check what's happening?
> 
> Those are the relevant dmesg data:
> 
> [   19.017276] usbcore: registered new interface driver snd-usb-audio
> [  230.706102] Linux video capture interface: v2.00
> [  230.856983] au0828: au0828 driver loaded
> [  231.230612] au0828: i2c bus registered
> [  231.822006] tveeprom 5-0050: Hauppauge model 72001, rev E1H3, serial# 4035199481
> [  231.822991] tveeprom 5-0050: MAC address is 00:0d:fe:84:41:f9
> [  231.823955] tveeprom 5-0050: tuner model is Xceive XC5000C (idx 173, type 88)
> [  231.824782] tveeprom 5-0050: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)
> [  231.825272] tveeprom 5-0050: audio processor is AU8522 (idx 44)
> [  231.825276] tveeprom 5-0050: decoder processor is AU8522 (idx 42)
> [  231.825280] tveeprom 5-0050: has no radio, has IR receiver, has no IR transmitter
> [  231.825283] au0828: hauppauge_eeprom: hauppauge eeprom: model=72001
> [  231.857567] au8522 5-0047: creating new instance
> [  231.857879] au8522_decoder creating new instance...
> [  231.910525] tuner 5-0061: Setting mode_mask to 0x06
> [  231.910532] tuner 5-0061: tuner 0x61: Tuner type absent
> [  231.910535] tuner 5-0061: Tuner -1 found with type(s) Radio TV.
> [  231.911343] tuner 5-0061: Calling set_type_addr for type=88, addr=0x61, mode=0x04, config=ffffffffa0e64100
> [  231.911347] tuner 5-0061: defining GPIO callback
> [  231.934896] xc5000 5-0061: creating new instance
> [  231.954664] xc5000: Successfully identified at address 0x61
> [  231.954987] xc5000: Firmware has not been loaded previously
> [  231.955327] tuner 5-0061: type set to Xceive XC5000
> [  231.955330] tuner 5-0061: au0828 tuner I2C addr 0xc2 with type 88 used for 0x04
> [  233.622614] au8522 5-0047: attaching existing instance
> [  233.636061] xc5000 5-0061: attaching existing instance
> [  233.645775] xc5000: Successfully identified at address 0x61
> [  233.646034] xc5000: Firmware has not been loaded previously
> [  233.646461] DVB: registering new adapter (au0828)
> [  233.647575] usb 2-3.3: DVB: registering adapter 0 frontend 0 (Auvitek AU8522 QAM/8VSB Frontend)...
> [  233.648344] dvb_create_media_entity: media entity 'Auvitek AU8522 QAM/8VSB Frontend' registered.
> [  233.656105] dvb_create_media_entity: media entity 'dvb-demux' registered.
> [  234.166644] IR keymap rc-hauppauge not found
> [  234.166962] Registered IR keymap rc-empty
> [  234.178055] input: au0828 IR (Hauppauge HVR950Q) as /devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3.3/rc/rc0/input14
> [  234.203311] rc rc0: au0828 IR (Hauppauge HVR950Q) as /devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3.3/rc/rc0
> [  234.207828] au0828: Remote controller au0828 IR (Hauppauge HVR950Q) initalized
> [  234.208270] au0828: Registered device AU0828 [Hauppauge HVR950Q]
> [  234.212073] usbcore: registered new interface driver au0828
> [  234.230371] lirc_dev: IR Remote Control driver registered, major 243 
> [  234.257555] rc rc0: lirc_dev: driver ir-lirc-codec (au0828-input) registered at minor = 0
> [  234.257960] IR LIRC bridge handler initialized
> 
> (as au0828 is blacklisted, snd-usb-audio was probed first)
> 
> ====xxxx====
> 
> I'm also getting some other weird behavior when removing/reinserting
> the modules a few times. OK, officially we don't support it, but,
> as devices can be bind/unbind all the times, removing modules is
> a way to simulate such things. Also, I use it a lot while testing
> USB drivers ;)
> 
> This one is after removing both the media drivers and snd-usb-audio, 
> and then modprobing snd-usb-audio:
> 

I did see some issues when I did the following sequence:

- blacklisted au0828 and snd-usb-audio was probed first
  graph is good just with audio entities as expected
- modprobed au0828 - graph looks good.
- rmmod au0828 - no problems seen in dmesg
- modprobe au0828 - problems kasan reports bad access etc.
  http://pastebin.com/FFqNzx9G

Here is what's going on after each step:

blacklisted au0828 and snd-usb-audio was probed first
1. snd-usb-audio creates media device and registers it
   Creates its graph etc.
2. modprobed au0828
   au0828 finds the media device created and registered.
   Adds its graph
3. rmmod au0828
   Even though there are no problems reported, at this
   time media device is unregistered, and /dev/mediaX is
   removed. We still have snd_usb-audio and media device.
   As media device is a device resource on usb device parent,
   it will still be there, but no way to access the device
   itself, because it is no longer registered.
4. modprobe au0828
   At this point, au0828 finds the media device as it still
   there, registers it and adds its graph. No audio graph
   present at this time.

Please note that the media device will not be deleted until
the last put on the parent usb struct device. So even when
both snd-usb-audio, and au0828 modules are removed, media
device is still there without its graph and associated devnode
(/dev/mediax is removed).

This isn't bad, however, media_device could still have
stale information.

e.g: enable/disable handlers - when au0828 is removed,
these are no longer valid. Could be cleaned up in
media device unregister just like entity_notify() handler
gets deleted from media device unregister. At the moment,
either driver can call unregister and same cleanup happens.

I will send a patch to do enable/disable hanlder cleanup
in unregister path.

However, the root of the problem is media device is
still there without its graph and associated devnode
(/dev/mediax is removed) when any one of the drivers
is removed. This leaves the remaining drivers in a
degenerate state.

The problem can be solved with some handshaking at
unregister time. We could add a callback for each
if the drivers to handle media device unregister.
However, that would add delays in device removal path
when all the drivers exit. I think it will be hard to
handle all the corner cases without adding run-time overhead.

Any thoughts on whether we want to unofficially support
being able to remove individual drivers?

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
