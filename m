Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54441 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab3HSJZF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 05:25:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1VBLhv-0002fX-Cz
	for linux-media@vger.kernel.org; Mon, 19 Aug 2013 11:25:03 +0200
Received: from g224152115.adsl.alicedsl.de ([92.224.152.115])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 19 Aug 2013 11:25:03 +0200
Received: from rio by g224152115.adsl.alicedsl.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 19 Aug 2013 11:25:03 +0200
To: linux-media@vger.kernel.org
From: Christoph Pegel <rio@eta-ori.net>
Subject: Hauppauge WinTV MiniStick firmware not loading
Date: Mon, 19 Aug 2013 10:54:15 +0200
Message-ID: <kusmcp$uip$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a Hauppauge WinTV MiniStick that wouldn't work anymore with
recent linux kernels. Right now I'm running kernel version 3.10.6 in
Arch Linux. Plugging the device results in

usb 1-1.5.1: new high-speed USB device number 9 using ehci-pci
smscore_load_firmware_family2: line: 986: sending
MSG_SMS_DATA_VALIDITY_REQ expecting 0xcfed1755
smscore_onresponse: line: 1565: MSG_SMS_DATA_VALIDITY_RES, checksum =
0xcfed1755

instead of

smscore_set_device_mode: firmware download success:
sms1xxx-hcw-55xxx-dvbt-02.fw

Other people reported the same issue:
* https://bbs.archlinux.org/viewtopic.php?pid=1309369
* https://bugzilla.kernel.org/show_bug.cgi?id=60645

I would appreciate any help on getting this problem fixed.

Thanks,
Christoph

