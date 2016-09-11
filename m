Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:60270 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752264AbcIKKNx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Sep 2016 06:13:53 -0400
Subject: Re: DVB: Unable to find symbol dib7000p_attach()
To: linux-media@vger.kernel.org
References: <fcfb7b2b-bd98-d847-8f07-ef3d018f5c19@gmx.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
From: =?UTF-8?Q?Toralf_F=c3=b6rster?= <toralf.foerster@gmx.de>
Message-ID: <bc964489-498f-6f40-e764-d8b4a869b38a@gmx.de>
Date: Sun, 11 Sep 2016 12:13:48 +0200
MIME-Version: 1.0
In-Reply-To: <fcfb7b2b-bd98-d847-8f07-ef3d018f5c19@gmx.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/25/2016 08:31 PM, Toralf Förster wrote:
> Aug 25 20:28:27 t44 kernel: DVB: registering new adapter (Terratec Cinergy T USB XXS (HD)/ T3)
> Aug 25 20:28:27 t44 kernel: DVB: Unable to find symbol dib7000p_attach()
> Aug 25 20:28:27 t44 kernel: dvb-usb: no frontend was attached by 'Terratec Cinergy T USB XXS (HD)/ T3'

Well, "solved" this with:

CONFIG_TRIM_UNUSED_KSYMS=y

/me wonders if that kernel options should be mandatory for the DVB-T adapter to not break functionality ?

-- 
Toralf
PGP: C4EACDDE 0076E94E, OTR: 420E74C8 30246EE7
