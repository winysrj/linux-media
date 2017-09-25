Return-path: <linux-media-owner@vger.kernel.org>
Received: from pide.tip.net.au ([203.10.76.2]:51401 "EHLO pide.tip.net.au"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932430AbdIYAQ2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Sep 2017 20:16:28 -0400
From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: f26: dvb_usb_rtl28xxu not tuning "Leadtek Winfast DTV2000 DS PLUS
 TV"
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
Cc: list linux-media <linux-media@vger.kernel.org>
References: <00ad85dd-2fe3-5f15-6c0c-47fcf580f541@eyal.emu.id.au>
 <3f0c2037-4a84-68a9-228f-015034e27900@eyal.emu.id.au>
 <20170924090417.GA24153@ubuntu.windy>
Message-ID: <47886ad7-ae90-0667-d6e3-d32d99fa85de@eyal.emu.id.au>
Date: Mon, 25 Sep 2017 10:16:23 +1000
MIME-Version: 1.0
In-Reply-To: <20170924090417.GA24153@ubuntu.windy>
Content-Type: multipart/mixed;
 boundary="------------50EE55B0E57B3980767C1C14"
Content-Language: en-AU
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------50EE55B0E57B3980767C1C14
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24/09/17 19:04, Vincent McIntyre wrote:
> On Sat, Sep 23, 2017 at 10:48:34PM +1000, Eyal Lebedinsky wrote:
>> On 18/09/17 14:26, Eyal Lebedinsky wrote:
>>> I have just upgraded to f24. I am now using the standard dvb_usb_rtl28xxu fe
>>
>> I have upgraded to f26 and this driver still fails to tune the "Leadtek Winfast DTV2000 DS PLUS TV".
>>
>>> which logs messages suggesting all is well (I get the /dev/dvb/adapter? etc.)
>>> but I get no channels tuned when I run mythfrontend or scandvb.
>>>
>>> Is anyone using this combination?
>>> Is this the correct way to use this tuner?
>>
>> Is this the wrong list? If so then please suggest a more suitable one.
> 
> It's the right list. The problem is nobody seems to care.
> I have one of these too, I was able to get it tune at one time
> but there were some problems that I never ended up running down.
> 
> I was planning to dig it out and have a play with it again.
> 
> Just to confirm - you're building the media_build git tree on f26

I now installed from media_build with no improvement. These are the boot messages:
[included are the two USB tuners: 'Realtek RTL2832U reference design' 'AVerMedia Twinstar (A825)']

Sep 25 09:12:04 e7 kernel: dvb_usb_af9035: unknown parameter 'remote' ignored
Sep 25 09:12:04 e7 kernel: usb 3-1: dvb_usb_v2: found a 'Leadtek WinFast DTV2000DS Plus' in warm state
Sep 25 09:12:04 e7 kernel: dvb_usb_af9035 2-1.5:1.0: prechip_version=00 chip_version=03 chip_type=3802
Sep 25 09:12:04 e7 kernel: usb 2-1.5: dvb_usb_v2: found a 'AVerMedia Twinstar (A825)' in cold state
Sep 25 09:12:04 e7 kernel: usb 2-1.5: dvb_usb_v2: downloading firmware from file 'dvb-usb-af9035-02.fw'
Sep 25 09:12:04 e7 kernel: usb 3-1: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
Sep 25 09:12:04 e7 kernel: dvbdev: DVB: registering new adapter (Leadtek WinFast DTV2000DS Plus)
Sep 25 09:12:04 e7 kernel: usb 3-1: DVB: registering adapter 0 frontend 0 (Realtek RTL2832 (DVB-T))...
Sep 25 09:12:05 e7 kernel: rc rc0: lirc_dev: driver ir-lirc-codec (dvb_usb_rtl28xxu) registered at minor = 0
Sep 25 09:12:05 e7 kernel: usb 3-1: dvb_usb_v2: schedule remote query interval to 200 msecs
Sep 25 09:12:05 e7 kernel: usb 3-1: dvb_usb_v2: 'Leadtek WinFast DTV2000DS Plus' successfully initialized and connected
Sep 25 09:12:05 e7 kernel: usb 3-2: dvb_usb_v2: found a 'Leadtek WinFast DTV2000DS Plus' in warm state
Sep 25 09:12:05 e7 kernel: usb 3-2: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
Sep 25 09:12:05 e7 kernel: dvbdev: DVB: registering new adapter (Leadtek WinFast DTV2000DS Plus)
Sep 25 09:12:05 e7 kernel: usb 3-2: DVB: registering adapter 1 frontend 0 (Realtek RTL2832 (DVB-T))...
Sep 25 09:12:05 e7 kernel: rc rc1: lirc_dev: driver ir-lirc-codec (dvb_usb_rtl28xxu) registered at minor = 1
Sep 25 09:12:05 e7 kernel: usb 3-2: dvb_usb_v2: schedule remote query interval to 200 msecs
Sep 25 09:12:05 e7 kernel: usb 3-2: dvb_usb_v2: 'Leadtek WinFast DTV2000DS Plus' successfully initialized and connected
Sep 25 09:12:05 e7 kernel: usb 4-1: dvb_usb_v2: found a 'Leadtek WinFast DTV2000DS Plus' in warm state
Sep 25 09:12:05 e7 kernel: usb 4-1: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
Sep 25 09:12:05 e7 kernel: dvbdev: DVB: registering new adapter (Leadtek WinFast DTV2000DS Plus)
Sep 25 09:12:05 e7 kernel: usb 4-1: DVB: registering adapter 2 frontend 0 (Realtek RTL2832 (DVB-T))...
Sep 25 09:12:05 e7 kernel: rc rc2: lirc_dev: driver ir-lirc-codec (dvb_usb_rtl28xxu) registered at minor = 2
Sep 25 09:12:05 e7 kernel: usb 4-1: dvb_usb_v2: schedule remote query interval to 200 msecs
Sep 25 09:12:05 e7 kernel: usb 4-1: dvb_usb_v2: 'Leadtek WinFast DTV2000DS Plus' successfully initialized and connected
Sep 25 09:12:05 e7 kernel: usb 4-2: dvb_usb_v2: found a 'Leadtek WinFast DTV2000DS Plus' in warm state
Sep 25 09:12:05 e7 kernel: usb 4-2: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
Sep 25 09:12:05 e7 kernel: dvbdev: DVB: registering new adapter (Leadtek WinFast DTV2000DS Plus)
Sep 25 09:12:05 e7 kernel: usb 4-2: DVB: registering adapter 3 frontend 0 (Realtek RTL2832 (DVB-T))...
Sep 25 09:12:05 e7 kernel: rc rc3: lirc_dev: driver ir-lirc-codec (dvb_usb_rtl28xxu) registered at minor = 3
Sep 25 09:12:05 e7 kernel: usb 4-2: dvb_usb_v2: schedule remote query interval to 200 msecs
Sep 25 09:12:05 e7 kernel: usb 4-2: dvb_usb_v2: 'Leadtek WinFast DTV2000DS Plus' successfully initialized and connected
Sep 25 09:12:05 e7 kernel: usb 1-1.6.4: dvb_usb_v2: found a 'Realtek RTL2832U reference design' in warm state
Sep 25 09:12:05 e7 kernel: usb 1-1.6.4: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
Sep 25 09:12:05 e7 kernel: dvbdev: DVB: registering new adapter (Realtek RTL2832U reference design)
Sep 25 09:12:05 e7 kernel: usb 1-1.6.4: DVB: registering adapter 4 frontend 0 (Realtek RTL2832 (DVB-T))...
Sep 25 09:12:05 e7 kernel: rc rc4: lirc_dev: driver ir-lirc-codec (dvb_usb_rtl28xxu) registered at minor = 4
Sep 25 09:12:05 e7 kernel: usb 1-1.6.4: dvb_usb_v2: schedule remote query interval to 200 msecs
Sep 25 09:12:05 e7 kernel: usb 1-1.6.4: dvb_usb_v2: 'Realtek RTL2832U reference design' successfully initialized and connected
Sep 25 09:12:05 e7 kernel: usbcore: registered new interface driver dvb_usb_rtl28xxu
Sep 25 09:12:07 e7 kernel: dvb_usb_af9035 2-1.5:1.0: firmware version=12.13.15.0
Sep 25 09:12:07 e7 kernel: usb 2-1.5: dvb_usb_v2: found a 'AVerMedia Twinstar (A825)' in warm state
Sep 25 09:12:07 e7 kernel: dvb_usb_af9035 2-1.5:1.0: Device may have issues with I2C read operations. Enabling fix.
Sep 25 09:12:07 e7 kernel: usb 2-1.5: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
Sep 25 09:12:07 e7 kernel: dvbdev: DVB: registering new adapter (AVerMedia Twinstar (A825))
Sep 25 09:12:07 e7 kernel: usb 2-1.5: DVB: registering adapter 5 frontend 0 (Afatech AF9033 (DVB-T))...
Sep 25 09:12:07 e7 kernel: usb 2-1.5: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
Sep 25 09:12:07 e7 kernel: dvbdev: DVB: registering new adapter (AVerMedia Twinstar (A825))
Sep 25 09:12:07 e7 kernel: usb 2-1.5: DVB: registering adapter 6 frontend 0 (Afatech AF9033 (DVB-T))...
Sep 25 09:12:07 e7 kernel: usb 2-1.5: dvb_usb_v2: schedule remote query interval to 500 msecs
Sep 25 09:12:07 e7 kernel: usb 2-1.5: dvb_usb_v2: 'AVerMedia Twinstar (A825)' successfully initialized and connected
Sep 25 09:12:07 e7 kernel: usbcore: registered new interface driver dvb_usb_af9035

> and those drivers are the ones that are not working, yes?

Yes.

> If not, you need to try that to get any help here.
> Have a look at https://git.linuxtv.org/media_build.git/about/
> and let me know if you need further help with that.
> 
> It may be possible to get the driver into debug mode and get more
> information logged. I'm not sure this will work but give it a go.
> 
> First set up the dynamic debug filesystem (may already be there)
> # cat >> /etc/fstab
> debugfs /sys/kernel/debug debugfs defaults 0 0
> ^D
> # mount -av

Already had debugfs.

> Turn on debug printing for the modules of interest
> # echo 'module rtl2832 +p' > /sys/kernel/debug/dynamic_debug/control
> # echo 'module dvb_usb_rtl28xxu +p' > /sys/kernel/debug/dynamic_debug/control

Have done this. Attached are the messages from a (failed) scandvb that fails for all multiplexes.

The messages at the end continued at a high rate after the test finished (until I disabled debug
with '-p') and there was no user of the tuners. Maybe IR RC is active?

> Vince

cheers

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)

--------------50EE55B0E57B3980767C1C14
Content-Type: application/x-xz;
 name="debug.dmesg.xz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="debug.dmesg.xz"

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
Z/sCAAAAAARZWg==
--------------50EE55B0E57B3980767C1C14--
