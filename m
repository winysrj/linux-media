Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:59693 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZIQVjL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2009 17:39:11 -0400
Received: by fxm17 with SMTP id 17so351365fxm.37
        for <linux-media@vger.kernel.org>; Thu, 17 Sep 2009 14:39:14 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 17 Sep 2009 21:39:14 +0000
Message-ID: <83bdafc0909171439g27347649r9d7001e14197e724@mail.gmail.com>
Subject: DVBWorld DVB-S 2102 USB2.0 - Unable to use network interface for
	multicasting
From: Ryan Waldron <ciaran29@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am trying to use a DVBWorld DVB-S 2102 USB2.0 device for multicast
data reception from EUMetCast. I have compiled the latest drivers from
Mecurial, and I can't seem to get the network device of the card to
work properly to setup reception for data via multiple channels.

<code>
[ 1148.757716] dvb-usb: found a 'DVBWorld DVB-S 2102 USB2.0' in cold
state, will try to load a firmware
[ 1148.757739] usb 1-2: firmware: requesting dvb-usb-dw2102.fw
[ 1148.791772] dvb-usb: downloading firmware from file 'dvb-usb-dw2102.fw'
[ 1148.920103] dvb-usb: found a 'DVBWorld DVB-S 2102 USB2.0' in warm state.
[ 1148.920254] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[ 1148.921437] dvb-usb: MAC address reading failed.
[ 1149.189422] dvb-usb: schedule remote query interval to 150 msecs.
[ 1149.189445] dvb-usb: DVBWorld DVB-S 2102 USB2.0 successfully
initialized and connected.
</code>

dvbnet then fails to be able to create any interfaces on the card, I
would assume due to the inability to find the card's MAC address. Any
help would be appreciated.
