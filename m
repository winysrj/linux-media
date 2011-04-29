Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:56365 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab1D2II5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2011 04:08:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 29 Apr 2011 10:08:55 +0200
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: <linux-media@vger.kernel.org>
Subject: Re: [PATCH 00/10] rc-core: my current patchqueue
In-Reply-To: <1304021602.3288.5.camel@localhost>
References: <20110428151311.8272.17290.stgit@felix.hardeman.nu> <1304021602.3288.5.camel@localhost>
Message-ID: <fb1dfe1e7035bbcf648a4bf908a7d1a4@hardeman.nu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 28 Apr 2011 21:13:22 +0100, Malcolm Priestley <tvboxspy@gmail.com>
wrote:
> On Thu, 2011-04-28 at 17:13 +0200, David Härdeman wrote:
>> The following series is what's in my current patch queue for rc-core.
>> 
>> It only been lightly tested so far and it's based on the "for_v2.6.39"
>> branch,
>> but I still wanted to send it to the list so that I can get some
>> feedback while
>> I refresh the patches to "for_v2.6.40" and do more testing.
> 
> Patch [06/10] hasn't made it to gmane or spinics servers.

Looking through the postfix logs, vger.kernel.org did accept the mail. My
guess is that it wasn't distributed (or indexed) because of its size.

I've put patch 6/10 at http://david.hardeman.nu/rc-proto.patch for now,
and I've included the patch description inline below:

Setting and getting keycodes in the input subsystem used to be done via
the EVIOC[GS]KEYCODE ioctl and "unsigned int[2]" (one int for scancode
and one for the keycode).

The interface has now been extended to use the EVIOC[GS]KEYCODE_V2 ioctl
which uses the following struct:

        struct input_keymap_entry {
                __u8  flags;
                __u8  len;
                __u16 index;
                __u32 keycode;
                __u8  scancode[32];
        };

(scancode can of course be even bigger, thanks to the len member).

This patch changes how the "input_keymap_entry" struct is interpreted
by rc-core by casting it to "rc_keymap_entry":

        struct rc_scancode {
                __u16 protocol;
                __u16 reserved[3];
                __u64 scancode;
        }

        struct rc_keymap_entry {
                __u8  flags;
                __u8  len;
                __u16 index;
                __u32 keycode;
                union {
                        struct rc_scancode rc;
                        __u8 raw[32];
                };
        };

The u64 scancode member is large enough for all current protocols and it
would be possible to extend it in the future should it be necessary for
some exotic protocol.

The main advantage with this change is that the protocol is made explicit,
which means that we're not throwing away data (the protocol type) and that
it'll be easier to support multiple protocols with one decoder (think rc5
and rc5-streamzap).

Further down the road we should also have a way to report the protocol of
a received keypress to userspace.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/dvb/dm1105/dm1105.c                  |    3
 drivers/media/dvb/dvb-usb/af9015.c                 |    4
 drivers/media/dvb/dvb-usb/anysee.c                 |    2
 drivers/media/dvb/dvb-usb/dib0700_core.c           |    2
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |   10 -
 drivers/media/dvb/dvb-usb/dvb-usb.h                |    2
 drivers/media/dvb/dvb-usb/lmedm04.c                |    2
 drivers/media/dvb/dvb-usb/ttusb2.c                 |    2
 drivers/media/dvb/mantis/mantis_input.c            |  117 +++---
 drivers/media/dvb/ttpci/budget-ci.c                |    7
 drivers/media/rc/imon.c                            |   11 -
 drivers/media/rc/ir-jvc-decoder.c                  |    4
 drivers/media/rc/ir-lirc-codec.c                   |    2
 drivers/media/rc/ir-nec-decoder.c                  |    4
 drivers/media/rc/ir-raw.c                          |    2
 drivers/media/rc/ir-rc5-decoder.c                  |   23 -
 drivers/media/rc/ir-rc5-sz-decoder.c               |    4
 drivers/media/rc/ir-rc6-decoder.c                  |    4
 drivers/media/rc/ir-sony-decoder.c                 |   26 +
 drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c    |   89 ++---
 drivers/media/rc/keymaps/rc-alink-dtu-m.c          |   37 +-
 drivers/media/rc/keymaps/rc-anysee.c               |   89 ++---
 drivers/media/rc/keymaps/rc-apac-viewcomp.c        |   65 ++--
 drivers/media/rc/keymaps/rc-asus-pc39.c            |   79 ++--
 drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c |   49 +--
 drivers/media/rc/keymaps/rc-avermedia-a16d.c       |   69 ++--
 drivers/media/rc/keymaps/rc-avermedia-cardbus.c    |  109 +++---
 drivers/media/rc/keymaps/rc-avermedia-dvbt.c       |   69 ++--
 drivers/media/rc/keymaps/rc-avermedia-m135a.c      |  187 +++++-----
 .../media/rc/keymaps/rc-avermedia-m733a-rm-k6.c    |   89 ++---
 drivers/media/rc/keymaps/rc-avermedia-rm-ks.c      |   55 +--
 drivers/media/rc/keymaps/rc-avermedia.c            |   73 ++--
 drivers/media/rc/keymaps/rc-avertv-303.c           |   73 ++--
 drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c   |  107 +++---
 drivers/media/rc/keymaps/rc-behold-columbus.c      |   73 ++--
 drivers/media/rc/keymaps/rc-behold.c               |   69 ++--
 drivers/media/rc/keymaps/rc-budget-ci-old.c        |   91 ++---
 drivers/media/rc/keymaps/rc-cinergy-1400.c         |   75 ++--
 drivers/media/rc/keymaps/rc-cinergy.c              |   73 ++--
 drivers/media/rc/keymaps/rc-dib0700-nec.c          |  141 ++++----
 drivers/media/rc/keymaps/rc-dib0700-rc5.c          |  361
++++++++++----------
 drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c  |   99 +++--
 drivers/media/rc/keymaps/rc-digittrade.c           |   57 ++-
 drivers/media/rc/keymaps/rc-dm1105-nec.c           |   63 ++-
 drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c      |   65 ++--
 drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c   |  107 +++---
 drivers/media/rc/keymaps/rc-em-terratec.c          |   57 ++-
 drivers/media/rc/keymaps/rc-encore-enltv-fm53.c    |   59 ++-
 drivers/media/rc/keymaps/rc-encore-enltv.c         |  131 ++++---
 drivers/media/rc/keymaps/rc-encore-enltv2.c        |   79 ++--
 drivers/media/rc/keymaps/rc-evga-indtube.c         |   33 +-
 drivers/media/rc/keymaps/rc-eztv.c                 |   89 ++---
 drivers/media/rc/keymaps/rc-flydvb.c               |   65 ++--
 drivers/media/rc/keymaps/rc-flyvideo.c             |   53 +--
 drivers/media/rc/keymaps/rc-fusionhdtv-mce.c       |  105 +++---
 drivers/media/rc/keymaps/rc-gadmei-rm008z.c        |   63 ++-
 drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c   |   65 ++--
 drivers/media/rc/keymaps/rc-gotview7135.c          |   69 ++--
 drivers/media/rc/keymaps/rc-hauppauge.c            |  287
++++++++--------
 drivers/media/rc/keymaps/rc-imon-mce.c             |  173 +++++-----
 drivers/media/rc/keymaps/rc-imon-pad.c             |  215 ++++++------
 drivers/media/rc/keymaps/rc-iodata-bctv7e.c        |   87 ++---
 drivers/media/rc/keymaps/rc-kaiomy.c               |   65 ++--
 drivers/media/rc/keymaps/rc-kworld-315u.c          |   65 ++--
 .../media/rc/keymaps/rc-kworld-plus-tv-analog.c    |   71 ++--
 drivers/media/rc/keymaps/rc-leadtek-y04g0051.c     |  101 +++---
 drivers/media/rc/keymaps/rc-lirc.c                 |    1
 drivers/media/rc/keymaps/rc-lme2510.c              |  133 ++++---
 drivers/media/rc/keymaps/rc-manli.c                |   97 +++--
 drivers/media/rc/keymaps/rc-msi-digivox-ii.c       |   37 +-
 drivers/media/rc/keymaps/rc-msi-digivox-iii.c      |   65 ++--
 drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c  |   89 ++---
 drivers/media/rc/keymaps/rc-msi-tvanywhere.c       |   49 +--
 drivers/media/rc/keymaps/rc-nebula.c               |  111 +++---
 .../media/rc/keymaps/rc-nec-terratec-cinergy-xs.c  |  121 +++----
 drivers/media/rc/keymaps/rc-norwood.c              |   69 ++--
 drivers/media/rc/keymaps/rc-npgtech.c              |   71 ++--
 drivers/media/rc/keymaps/rc-pctv-sedna.c           |   65 ++--
 drivers/media/rc/keymaps/rc-pinnacle-color.c       |  107 +++---
 drivers/media/rc/keymaps/rc-pinnacle-grey.c        |   83 ++---
 drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c     |   51 +--
 drivers/media/rc/keymaps/rc-pixelview-002t.c       |   53 +--
 drivers/media/rc/keymaps/rc-pixelview-mk12.c       |   63 ++-
 drivers/media/rc/keymaps/rc-pixelview-new.c        |   63 ++-
 drivers/media/rc/keymaps/rc-pixelview.c            |   77 ++--
 .../media/rc/keymaps/rc-powercolor-real-angel.c    |   71 ++--
 drivers/media/rc/keymaps/rc-proteus-2309.c         |   49 +--
 drivers/media/rc/keymaps/rc-purpletv.c             |   71 ++--
 drivers/media/rc/keymaps/rc-pv951.c                |   63 ++-
 drivers/media/rc/keymaps/rc-rc6-mce.c              |  151 ++++----
 .../media/rc/keymaps/rc-real-audio-220-32-keys.c   |   57 ++-
 drivers/media/rc/keymaps/rc-streamzap.c            |   71 ++--
 drivers/media/rc/keymaps/rc-tbs-nec.c              |   69 ++--
 drivers/media/rc/keymaps/rc-technisat-usb2.c       |   67 ++--
 drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c  |   95 +++--
 drivers/media/rc/keymaps/rc-terratec-slim-2.c      |   37 +-
 drivers/media/rc/keymaps/rc-terratec-slim.c        |   57 ++-
 drivers/media/rc/keymaps/rc-tevii-nec.c            |   95 +++--
 drivers/media/rc/keymaps/rc-total-media-in-hand.c  |   71 ++--
 drivers/media/rc/keymaps/rc-trekstor.c             |   57 ++-
 drivers/media/rc/keymaps/rc-tt-1500.c              |   79 ++--
 drivers/media/rc/keymaps/rc-twinhan1027.c          |  107 +++---
 drivers/media/rc/keymaps/rc-videomate-m1f.c        |  103 +++---
 drivers/media/rc/keymaps/rc-videomate-s350.c       |   89 ++---
 drivers/media/rc/keymaps/rc-videomate-tv-pvr.c     |   93 +++--
 drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c |   57 ++-
 drivers/media/rc/keymaps/rc-winfast.c              |  113 +++---
 drivers/media/rc/rc-core-priv.h                    |    1
 drivers/media/rc/rc-main.c                         |  229 +++++++++----
 drivers/media/video/bt8xx/bttv-input.c             |   10 -
 drivers/media/video/cx88/cx88-input.c              |   10 -
 drivers/media/video/em28xx/em28xx-cards.c          |   17 +
 drivers/media/video/em28xx/em28xx-input.c          |   34 +-
 drivers/media/video/em28xx/em28xx.h                |    1
 drivers/media/video/ir-kbd-i2c.c                   |   12 +
 drivers/media/video/saa7134/saa7134-input.c        |    6
 drivers/staging/tm6000/tm6000-cards.c              |    2
 drivers/staging/tm6000/tm6000-input.c              |   32 +-
 include/media/rc-core.h                            |   28 +-
 include/media/rc-map.h                             |   14 +
 120 files changed, 4121 insertions(+), 4078 deletions(-)

 

> Patchwork appears to be down again :(

Mauro told me that it is and that someone is working on it...


-- 
David Härdeman
