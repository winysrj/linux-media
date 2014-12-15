Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:61171 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaLOXNg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 18:13:36 -0500
Received: by mail-wi0-f177.google.com with SMTP id l15so10713481wiw.16
        for <linux-media@vger.kernel.org>; Mon, 15 Dec 2014 15:13:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEzPJ9M=uOY_ujbp7XtrRq3N4jq6L3r_84qggfbQ4xEpX12u-w@mail.gmail.com>
References: <CAEzPJ9M=uOY_ujbp7XtrRq3N4jq6L3r_84qggfbQ4xEpX12u-w@mail.gmail.com>
Date: Tue, 16 Dec 2014 00:13:34 +0100
Message-ID: <CAEzPJ9NqYNo2BV0j2jujVO+p3w73qxZOoM3K8J+yebFMVwwhWQ@mail.gmail.com>
Subject: Fwd: Instalation issue on S960
From: Carlos Diogo <cdiogo@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear support team ,
i have spent 4 days trying to get my S960 setup in my raspberrry Pi

I have tried multiple options and using the linuxtv.org drivers the
power light switches on but then i get the below message



[    8.561909] usb 1-1.5: dvb_usb_v2: found a 'DVBSky S960/S860' in warm state
[    8.576865] usb 1-1.5: dvb_usb_v2: will pass the complete MPEG2
transport stream to the software demuxer
[    8.591803] DVB: registering new adapter (DVBSky S960/S860)
[    8.603974] usb 1-1.5: dvb_usb_v2: MAC address: 00:18:42:54:96:0c
[    8.650257] DVB: Unable to find symbol m88ds3103_attach()
[    8.661452] usb 1-1.5: dvbsky_s960_attach fail.
[    8.683560] usbcore: registered new interface driver dvb_usb_dvbsky

I have tried googling it but i have found nothing about this

i'm using raspbian , with kernel 3.12.34

Any help here?

Thanks in advance
Carlos


-- 
Os meus cumprimentos / Best regards /  Mit freundlichen Grüße
Carlos Diogo
