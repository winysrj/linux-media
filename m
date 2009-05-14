Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:52444 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761639AbZENWxY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 18:53:24 -0400
Received: by fxm2 with SMTP id 2so1608665fxm.37
        for <linux-media@vger.kernel.org>; Thu, 14 May 2009 15:53:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <23be820f0905141410k3cc3840eyd17b95730ec91f5c@mail.gmail.com>
References: <23be820f0905141410k3cc3840eyd17b95730ec91f5c@mail.gmail.com>
Date: Fri, 15 May 2009 00:53:23 +0200
Message-ID: <23be820f0905141553t1829e70buc491fa28493d7334@mail.gmail.com>
Subject: Re: twinhan cards
From: Gregor Fuis <gujs.lists@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I managed to find a way to go further. I just commented out a code in
dvb_bt8xx.c which returns error and let it to run further.

        if (!(card->bt = dvb_bt8xx_878_match(card->bttv_nr, bttv_pci_dev))) {
                printk("dvb_bt8xx: unable to determine DMA core of card %d,\n",
                       card->bttv_nr);
                printk("dvb_bt8xx: if you have the ALSA bt87x audio driver "
                       "installed, try removing it.\n");

/*              kfree(card);
                return -EFAULT;*/
        }


And this work OK, but now I have new problem. DST module is not
recognising fronted all the time. Every boot some other card works:

[   17.290060] dst(0) dst_check_mb86a15: Cmd=[0x10], failed
[   17.290139] dst(0) dst_get_device_id: Unsupported
[   17.290195] DST type flags : 0x1 newtuner 0x1000 VLF 0x10 firmware
version = 2
[   17.335966] dst(0) dst_get_mac: MAC Address=[cd92b3ec]
[   17.336022] dst(0) dst_get_tuner_info: DST TYpe = MULTI FE
[   21.447662] dst_ca_attach: registering DST-CA device
[   21.447954] DVB: registering adapter 0 frontend 0 (DST DVB-S)...
[   21.448059] DVB: registering new adapter (bttv1)
[   25.652375] dst(1) dst_get_device_id: Recognise [DSTMCI]
[   25.711362] dst(1) dst_get_device_id: Unsupported
[   29.750044] dst(1) dst_check_mb86a15: Cmd=[0x10], failed
[   29.750100] dst(1) dst_get_device_id: Unsupported
[   29.750156] DST type flags : 0x1 newtuner 0x1000 VLF 0x10 firmware
version = 2
[   29.795932] dst(1) dst_get_mac: MAC Address=[ceccebec]
[   29.795988] dst(1) dst_get_tuner_info: DST TYpe = MULTI FE
[   33.870309] dst_ca_attach: registering DST-CA device
[   33.870615] DVB: registering adapter 1 frontend 0 (DST DVB-S)...
[   33.870698] DVB: registering new adapter (bttv2)
[   38.260053] dst(2) dst_probe: unknown device.
[   38.260436] frontend_init: Could not find a Twinhan DST.
[   38.260445] dvb-bt8xx: A frontend driver was not found for device
[109e:0878] subsystem [1822:0001]
[   38.260505] DVB: registering new adapter (bttv3)
[   42.650053] dst(3) dst_probe: unknown device.
[   42.650431] frontend_init: Could not find a Twinhan DST.
[   42.650440] dvb-bt8xx: A frontend driver was not found for device
[109e:0878] subsystem [1822:0001]


If I would be a better coder I would figure this out. I know that I
have to hardcode DSTMCI device detection in dst.c file, but don't know
where to put it.

Regards,
Gregor
