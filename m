Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49550 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbaFLV2B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 17:28:01 -0400
Message-ID: <539A1B5A.60804@iki.fi>
Date: Fri, 13 Jun 2014 00:27:54 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jason.Dong@ite.com.tw, tephra@gmail.com
CC: sebastian_ml@gmx.net, linux-media@vger.kernel.org
Subject: Re: AF9033 / IT913X: Avermedia A835B(1835) only works sporadically
References: <20140610125059.GA1930@wolfgang>	<97D30D57D08C2C49A26A3312F17290483B008B5E@TPEMAIL2.internal.ite.com.tw> <CAM187nBbeZJyG-4K+N4nicaYjcvrgXB5u10J7gHOp=xrbO9Bkg@mail.gmail.com> <97D30D57D08C2C49A26A3312F17290483B008D96@TPEMAIL2.internal.ite.com.tw>
In-Reply-To: <97D30D57D08C2C49A26A3312F17290483B008D96@TPEMAIL2.internal.ite.com.tw>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka,

The reason is that Avermedia has programmed wrong tuner ID to device 
eeprom. For one IT9135BX device I have it is set 0x38 (whilst Windows 
driver programs 0x60), no idea how others. That same issues was for 
AF9015 too, where I added USB ID based overrides for certain Avermedia 
models. I think I will do same for AF9035 driver.

regards
Antti


On 06/11/2014 11:11 AM, Jason.Dong@ite.com.tw wrote:
> Dear David,
>
> The RF performance of ITE9137 BX + IE9133 dongle is a little worse than single tuner.
> As our test resolut, the RF performances should be -80db and -82db for dual tuners and single tuner.
> There is an issue in hardware design if the reception capability is too worse.
>
> We don’t need to change the firmware for dual tuners. I think there are some problems in af9033 driver of kernel v3.15.
>
> BRs,
> Jason
>
> -----Original Message-----
> From: David Shirley [mailto:tephra@gmail.com]
> Sent: Wednesday, June 11, 2014 3:00 PM
> To: Jason Dong (董志堅)
> Cc: sebastian_ml@gmx.net; linux-media@vger.kernel.org
> Subject: Re: AF9033 / IT913X: Avermedia A835B(1835) only works sporadically
>
> Hey Jason,
>
> Do we know if that RF problem exists in 3.14.5? Using the IT913X driver?
>
> I have a Leadtek Winfast Dual Dongle (0413:6a05 - dual usb - ITE9137 BX + IE9133) which is being extremely painful (random signal locks, tzap reports ok signal strength for one tuner but poor for the other, random signal dropouts (ie working fine, then progressively getting more and more blips in visual/audio from stream)).
>
> I dont think its signal strength related because 3x Leadtek Winfast Gold dongles (AF9013) all work (until they stop tuning and cold reboot is required)
>
> I suspect something about the firmware is at fault, I have tried to talk to Antti - but he must be busy. I have tried three different dvb-usb-it9135-02.fw firmwares, and they don't seem to make a huge difference (newest doesn't create /dev/dvb bits)...
>
> Does a BX (v2) 9137 require yet another firmware image?
>
> If I use the AF9035 kernel driver it doesn't tune at all. But does detect the tuners...
>
> Sorry to threadjack - but seeing your @ite.com.tw I thought I would ask while I can :)
>
> Regards
> David
>
> On 11 June 2014 15:31,  <Jason.Dong@ite.com.tw> wrote:
>> Dear Sebastian,
>>
>> There is a RF performance issue in the af9033 driver of kernel 3.15. It is no problem in the it913x driver of kernel 3.14.
>> There were some initial sequences not correct after the it913x driver was integrated into af9033 driver.
>>
>> BRs,
>> Jason
>>
>> -----Original Message-----
>> From: linux-media-owner@vger.kernel.org
>> [mailto:linux-media-owner@vger.kernel.org] On Behalf Of Sebastian
>> Kemper
>> Sent: Tuesday, June 10, 2014 8:51 PM
>> To: linux-media@vger.kernel.org
>> Subject: AF9033 / IT913X: Avermedia A835B(1835) only works
>> sporadically
>>
>> Hello list,
>>
>> I have an "Avermedia A835B(1835)" USB DVB-T stick (07ca:1835) which works only (very) sporadically. It's pure luck as far as I can see.
>> I can't reproduce how to get it working. There are no special steps that I can take to guarantee that it'll work once I plug it in.
>>
>> I'd rate my chances of having the device actually working between 5
>> and
>> 10 percent.
>>
>> In the log everything looks fine, apart from the messages at the bottom about the device not being able to get a lock on a channel.
>>
>> Reception here is really good, so there's no problem with signal strength. When loading the device in Windows 7 64 bit it always finds a lock.
>>
>> Has anybody any idea? Thanks for any suggestions!
>>
>> Jun 10 14:18:07 meiner kernel: usb 1-2: new high-speed USB device number 2 using xhci_hcd Jun 10 14:18:07 meiner kernel: WARNING: You are using an experimental version of the media stack.
>> Jun 10 14:18:07 meiner kernel:  As the driver is backported to an
>> older kernel, it doesn't offer Jun 10 14:18:07 meiner kernel:  enough quality for its usage in production.
>> Jun 10 14:18:07 meiner kernel:  Use it with care.
>> Jun 10 14:18:07 meiner kernel: Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
>> Jun 10 14:18:07 meiner kernel:
>> bfd0306462fdbc5e0a8c6999aef9dde0f9745399 [media] v4l: Document
>> timestamp buffer flag behaviour Jun 10 14:18:07 meiner kernel:
>> 309f4d62eda0e864c2d4eef536cc82e41931c3c5 [media] v4l: Copy timestamp
>> source flags to destination on m2m devices Jun 10 14:18:07 meiner kernel:  599b08929efe9b90e44b504454218a120bb062a0 [media] exynos-gsc, m2m-deinterlace, mx2_emmaprp: Copy v4l2_buffer data from src to dst Jun 10 14:18:07 meiner kernel:  experimental: a60b303c3e347297a25f0a203f0ff11a8efc818c experimental/ngene: Support DuoFlex C/C2/T/T2 (V3) Jun 10 14:18:07 meiner kernel:  v4l-dvb-saa716x: 052c468e33be00a3d4d9b93da3581ffa861bb288 saa716x: IO memory of upper PHI1 regions is mapped in saa716x_ff driver.
>> Jun 10 14:18:07 meiner kernel: usb 1-2: dvb_usb_af9035: prechip_version=83 chip_version=02 chip_type=9135 Jun 10 14:18:07 meiner kernel: usb 1-2: dvb_usb_v2: found a 'Avermedia A835B(1835)' in cold state Jun 10 14:18:07 meiner kernel: usb 1-2: dvb_usb_v2: downloading firmware from file 'dvb-usb-it9135-02.fw'
>> Jun 10 14:18:07 meiner kernel: usb 1-2: dvb_usb_af9035: firmware version=3.42.3.3 Jun 10 14:18:07 meiner kernel: usb 1-2: dvb_usb_v2: found a 'Avermedia A835B(1835)' in warm state Jun 10 14:18:07 meiner kernel: usb 1-2: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer Jun 10 14:18:07 meiner kernel: DVB: registering new adapter (Avermedia A835B(1835)) Jun 10 14:18:07 meiner kernel: i2c i2c-0: af9033: firmware version: LINK=0.0.0.0 OFDM=3.29.3.3 Jun 10 14:18:07 meiner kernel: usb 1-2: DVB: registering adapter 0 frontend 0 (Afatech AF9033 (DVB-T))...
>> Jun 10 14:18:07 meiner kernel: i2c i2c-0: tuner_it913x: ITE Tech IT913X successfully attached Jun 10 14:18:07 meiner kernel: usb 1-2: dvb_usb_v2: 'Avermedia A835B(1835)' successfully initialized and connected Jun 10 14:18:07 meiner kernel: usbcore: registered new interface driver dvb_usb_af9035 Jun 10 14:18:28 meiner vdr: [1653] VDR version 2.0.4 started Jun 10 14:18:28 meiner vdr: [1653] switched to user 'vdr'
>> Jun 10 14:18:28 meiner vdr: [1653] codeset is 'UTF-8' - known Jun 10
>> 14:18:28 meiner vdr: [1653] loading plugin:
>> /usr/lib64/vdr/plugins/libvdr-softhddevice.so.2.0.0
>> Jun 10 14:18:28 meiner vdr: New default svdrp port 6419!
>> Jun 10 14:18:29 meiner vdr: [1653] loading /etc/vdr/setup.conf Jun 10 14:18:29 meiner vdr: [1653] loading /etc/vdr/sources.conf Jun 10 14:18:29 meiner vdr: [1653] loading /etc/vdr/diseqc.conf Jun 10 14:18:29 meiner vdr: [1653] loading /etc/vdr/scr.conf Jun 10 14:18:29 meiner vdr: [1653] loading /etc/vdr/channels.conf Jun 10 14:18:29 meiner vdr: [1653] loading /etc/vdr/timers.conf Jun 10 14:18:29 meiner vdr: [1653] loading /etc/vdr/commands.conf Jun 10 14:18:29 meiner vdr: [1653] loading /etc/vdr/reccmds.conf Jun 10 14:18:29 meiner vdr: [1653] loading /etc/vdr/svdrphosts.conf Jun 10 14:18:29 meiner vdr: [1653] loading /etc/vdr/remote.conf Jun 10 14:18:29 meiner vdr: [1653] loading /etc/vdr/keymacros.conf Jun 10 14:18:29 meiner vdr: [1653] DVB API version is 0x050A (VDR was built with 0x050A) Jun 10 14:18:29 meiner vdr: [1653] frontend 0/0 provides DVB-T with QPSK,QAM16,QAM64 ("Afatech AF9033 (DVB-T)") Jun 10 14:18:29 meiner vdr: [1653] found 1 DVB device Jun 10 14:18:29 meiner vdr: 
[1653] initializing plugin: softhddevice (0.6.1rc1): Ein Software und GPU emulieres HD-Gerät Jun 10 14:18:29 meiner vdr: [1653] setting primary device to 2 Jun 10 14:18:29 meiner vdr: [1653] SVDRP listening on port 6419 Jun 10 14:18:29 meiner vdr: [1653] setting current skin to "lcars"
>> Jun 10 14:18:29 meiner vdr: [1653] loading
>> /etc/vdr/themes/lcars-default.theme
>> Jun 10 14:18:29 meiner vdr: [1653] starting plugin: softhddevice Jun 10 14:18:30 meiner vdr: [1653] switching to channel 2 Jun 10 14:18:30 meiner lircd-0.9.0[1219]: accepted new client on /var/run/lirc/lircd Jun 10 14:18:30 meiner lircd-0.9.0[1219]: zotac initializing '/dev/usb/hiddev0'
>> Jun 10 14:18:31 meiner kernel: nvidia 0000:02:00.0: irq 46 for
>> MSI/MSI-X Jun 10 14:18:31 meiner vdr: [1653] connect from 127.0.0.1,
>> port 59159 - accepted Jun 10 14:18:31 meiner vdr: [1653] closing SVDRP
>> connection Jun 10 14:18:31 meiner vdrwatchdog[1702]: Starting
>> vdrwatchdog Jun 10 14:18:39 meiner vdr: [1674] frontend 0/0 timed out
>> while tuning to channel 2, tp 818 Jun 10 14:19:43 meiner vdr: [1674]
>> frontend 0/0 timed out while tuning to channel 2, tp 818
>>
>> Kind regards,
>> Sebatian
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>> in the body of a message to majordomo@vger.kernel.org More majordomo
>> info at  http://vger.kernel.org/majordomo-info.html
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{���bj)���w*jg��������ݢj/���z�ޖ��2�ޙ���&�)ߡ�a�����G���h��j:+v���w�٥
>


-- 
http://palosaari.fi/
