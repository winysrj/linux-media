Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.eclipso.de ([217.69.254.104]:52909 "EHLO mail.eclipso.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726958AbeKWIZy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 03:25:54 -0500
Received: from roadrunner.suse (p5B318127.dip0.t-ipconnect.de [91.49.129.39])
        by mail.eclipso.de with ESMTPS id 570CDC6E
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2018 22:44:37 +0100 (CET)
From: stakanov <stakanov@eclipso.eu>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: DVB-S PCI card regression on 4.19 / 4.20
Date: Thu, 22 Nov 2018 22:44:34 +0100
Message-ID: <2248241.AKzUZ5aokr@roadrunner.suse>
In-Reply-To: <20181122183549.331ecbc4@coco.lan>
References: <4e0356d6303c128a3e6d0bcc453ba1be@mail.eclipso.de> <12757009.r0OKxgvFl0@roadrunner.suse> <20181122183549.331ecbc4@coco.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In data giovedì 22 novembre 2018 21:35:49 CET, Mauro Carvalho Chehab ha 
scritto:
> Em Thu, 22 Nov 2018 21:19:49 +0100
> 
> stakanov <stakanov@eclipso.eu> escreveu:
> > Hello Mauro.
> > 
> > Thank you so much, for this fast reply and especially for the detailed
> > indications. I expected to have a lack of knowledge.
> > 
> > Well,  I am replying to the question as of below: (for convenience I did
> > cut the before text, if you deem it useful for the list I can then
> > correct that in the next posts).
> > 
> > In data giovedì 22 novembre 2018 21:06:11 CET, Mauro Carvalho Chehab ha
> > 
> > scritto:
> > > Are you sure that the difference is just the Kernel version? Perhaps you
> > > also updated some other package.
> > 
> > To be clear: I had the same system(!) with all three kernel 4.18.15-1,
> > 4.19.1 (when the problem did arise) and 4.20.2 rc3 from Takashi's repo)
> > installed.
> Ok, so rebooting to 4.18.15-1 solves the issue?
> 
> Also, what GPU driver are you using?
> 
> In any case, by using the old "Universal" LNBf, you're likely missing some
> transponders, and missing several channels.
> 
> > In this very configuration: if one booted in 4.18 (that is in perfect
> > parity with all other packages) the card worked. 4.19.1 no. And the last
> > kernel the same. So whatever might be different, forcefully it has to be
> > in the kernel. (Which is not really a problem if I manage to make it
> > work, so settings will be known to others or, if not, we will find out
> > what is different, and all will be happy. As you see I am still
> > optimist).
> 
> Well, we don't want regressions in Kernel. If there's an issue there,
> it should be fixed. However, I can't think on any other changes since
> 4.18 that would be causing troubles for b2c2 driver.
> 
> See, the only change at the driver itself is just a simple API
> replacement that wouldn't cause this kind of problems:
> 
> 	$ git log --oneline v4.18.. drivers/media/common/b2c2/
> 	c0decac19da3 media: use strscpy() instead of strlcpy()
> 
> There were a few changes at the DVB core:
> 
> 	$ git log --no-merges --oneline v4.18.. drivers/media/dvb-core/
> 	f3efe15a2f05 media: dvb: use signal types to discover pads
> 	b5d3206112dd media: dvb: dmxdev: move compat_ioctl handling to dmxdev.c
> 	cc1e6315e83d media: replace strcpy() by strscpy()
> 	c0decac19da3 media: use strscpy() instead of strlcpy()
> 	fd89e0bb6ebf media: videobuf2-core: integrate with media requests
> 	db6e8d57e2cd media: vb2: store userspace data in vb2_v4l2_buffer
> 	6a2a1ca34ca6 media: dvb_frontend: ensure that the step is ok for both FE
> and tuner f1b1eabff0eb media: dvb: represent min/max/step/tolerance freqs
> in Hz a3f90c75b833 media: dvb: convert tuner_info frequencies to Hz
> 	6706fe55af6f media: dvb_ca_en50221: off by one in
> dvb_ca_en50221_io_do_ioctl() 4d1e4545a659 media: mark entity-intf links as
> IMMUTABLE
> 
> But, on a first glance, the only ones that has potential to cause issues
> were the ones addressed that the patch I wrote (merged by Takashi).
> 
> If you're really receiving data from EPG (you may just have it
> cached), it means that the DVB driver is doing the right thing.
> 
> Btw, to be sure that you're not just seeing the old EPG data, you
> should move or remove this file:
> 
> 	~/.local/share/kaffeine/epgdata.dvb
> 
> Kaffeine will generate a new one again once it tunes into a TV channel.
> 
> > I will proceed as indicated and report back here tomorrow.
> 
> Ok.
> 
> Thanks,
> Mauro

Further the question:
>Also, what GPU driver are you using?
Hope that this responding to what you ask for:


silversurfer:~ # lspci | grep VGA

01:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] 
Cedar [Radeon HD 5000/6000/7350/8350 Series]
silversurfer:~ # lsmod | grep "kms\|drm"
drm_kms_helper        204800  1 radeon
syscopyarea            16384  1 drm_kms_helper
sysfillrect            16384  1 drm_kms_helper
sysimgblt              16384  1 drm_kms_helper
fb_sys_fops            16384  1 drm_kms_helper
drm                   491520  16 drm_kms_helper,radeon,ttm


silversurfer:~ # find /dev -group video
/dev/dvb/adapter2/net0
/dev/dvb/adapter2/dvr0
/dev/dvb/adapter2/demux0
/dev/dvb/adapter2/frontend0
/dev/dvb/adapter1/net0
/dev/dvb/adapter1/dvr0
/dev/dvb/adapter1/demux0
/dev/dvb/adapter1/frontend0
/dev/dvb/adapter0/frontend0
/dev/dvb/adapter0/net0
/dev/dvb/adapter0/dvr0
/dev/dvb/adapter0/demux0
/dev/fb0
/dev/dri/card0


silversurfer:~ # cat /proc/cmdline
BOOT_IMAGE=/vmlinuz-4.20.0-rc3-2.gfe5d771-default 
root=UUID=30e41f49-6c35-4381-9274-10491d5004ef resume=/dev/disk/by-uuid/
e20f311b-d45c-49ea-846f-8eac8aaa0d85 splash=silent quiet showopts iommu=soft


silversurfer:~ # find /etc/modprobe.d/
/etc/modprobe.d/
/etc/modprobe.d/firewalld-sysctls.conf
/etc/modprobe.d/truescale.conf
/etc/modprobe.d/50-ipw2200.conf
/etc/modprobe.d/50-yast.conf
/etc/modprobe.d/50-yast.conf.YaST2save
/etc/modprobe.d/tuned.conf
/etc/modprobe.d/50-alsa.conf
/etc/modprobe.d/50-iwl3945.conf
/etc/modprobe.d/50-bluetooth.conf
/etc/modprobe.d/00-system.conf
/etc/modprobe.d/50-blacklist.conf
/etc/modprobe.d/50-prism54.conf
/etc/modprobe.d/99-local.conf
/etc/modprobe.d/mlx4.conf
/etc/modprobe.d/10-unsupported-modules.conf
/etc/modprobe.d/50-libmlx4.conf


silversurfer:~ # cat /etc/modprobe.d/*kms*
cat: '/etc/modprobe.d/*kms*': No such file or directory


silversurfer:~ # ls /etc/X11/xorg.conf.d
00-keyboard.conf  10-evdev.conf   10-quirks.conf  40-libinput.conf  50-
elotouch.conf    50-monitor.conf  70-synaptics.conf  70-wacom.conf
10-amdgpu.conf    10-libvnc.conf  11-evdev.conf   50-device.conf    50-
extensions.conf  50-screen.conf   70-vmmouse.conf


silversurfer:~ # glxinfo | grep -i "vendor\|rendering"
direct rendering: Yes
server glx vendor string: SGI
client glx vendor string: Mesa Project and SGI
    Vendor: X.Org (0x1002)
OpenGL vendor string: X.Org


silversurfer:~ # grep LoadModule /var/log/Xorg.0.log
[    43.342] (II) LoadModule: "glx"
[    43.357] (II) LoadModule: "radeon"
[    43.362] (II) LoadModule: "ati"
[    43.426] (II) LoadModule: "modesetting"
[    43.427] (II) LoadModule: "fbdev"
[    43.428] (II) LoadModule: "vesa"
[    43.443] (II) LoadModule: "fbdevhw"
[    43.444] (II) LoadModule: "fb"
[    43.445] (II) LoadModule: "dri2"
[    43.638] (II) LoadModule: "glamoregl"
[    43.808] (II) LoadModule: "ramdac"
[    43.951] (II) LoadModule: "libinput"
[    44.276] (II) LoadModule: "wacom"




_________________________________________________________________
________________________________________________________
Ihre E-Mail-Postfächer sicher & zentral an einem Ort. Jetzt wechseln und alte E-Mail-Adresse mitnehmen! https://www.eclipso.de
