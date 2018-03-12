Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:39479 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932178AbeCLQu3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Mar 2018 12:50:29 -0400
To: linux-media@vger.kernel.org, linux-usb@vger.kernel.org
From: "rwarsow@gmx.de" <rwarsow@gmx.de>
Subject: help needed: dvb-usb: recv bulk message failed: -110 AND dw2102: i2c
 transfer failed
Message-ID: <6a9f4312-061c-d567-dc0d-048f8b5913f7@gmx.de>
Date: Mon, 12 Mar 2018 17:50:27 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hallo

I get this with kernel 4.15.8 and 4.16-rc5

...
[ 166.277588] dvb-usb: Terratec Cinergy S2 USB BOX successfully 
deinitialized and disconnected.

[ 168.406828] usb 1-1: new high-speed USB device number 6 using xhci_hcd

[ 168.534421] dw2102: su3000_identify_state

[ 168.534424] dvb-usb: found a 'Terratec Cinergy S2 USB BOX' in warm state.

[ 168.534433] dw2102: su3000_power_ctrl: 1, initialized 0

[ 168.534642] dvb-usb: will pass the complete MPEG2 transport stream to 
the software demuxer.

[ 168.534708] dvbdev: DVB: registering new adapter (Terratec Cinergy S2 
USB BOX)

[ 168.538862] dvb-usb: MAC address: bc:ea:2b:46:13:a5

[ 168.849764] m88ds3103 5-0068: Unknown device. Chip_id=52

[ 168.849816] dvb-usb: no frontend was attached by 'Terratec Cinergy S2 
USB BOX'

[ 168.849945] Registered IR keymap rc-tt-1500

[ 168.850002] rc rc0: Terratec Cinergy S2 USB BOX as 
/devices/pci0000:00/0000:00:14.0/usb1/1-1/rc/rc0

[ 168.850084] input: Terratec Cinergy S2 USB BOX as 
/devices/pci0000:00/0000:00:14.0/usb1/1-1/rc/rc0/input20

[ 168.850287] dvb-usb: schedule remote query interval to 250 msecs.

[ 168.850291] dw2102: su3000_power_ctrl: 0, initialized 1

[ 168.850293] dvb-usb: Terratec Cinergy S2 USB BOX successfully 
initialized and connected.

[ 171.141939] dvb-usb: recv bulk message failed: -110

[ 171.141949] dw2102: i2c transfer failed.


more to read:
https://forum.libreelec.tv/thread/11784-does-this-dvb-s2-tuner-work/?pageNo=4

-- 

Greeting

Ronald
