Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f169.google.com ([209.85.160.169]:46235 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbbCATJy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Mar 2015 14:09:54 -0500
Received: by ykq142 with SMTP id 142so11541557ykq.13
        for <linux-media@vger.kernel.org>; Sun, 01 Mar 2015 11:09:53 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 1 Mar 2015 14:09:53 -0500
Message-ID: <CALzAhNVnmCFTM6ymqVJJrcwCfw35N1-ejLmWibMjo6EDEj0uog@mail.gmail.com>
Subject: SMS / DVB / media_graph issue - tip fails to compile
From: Steven Toth <stoth@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Someone broke tip.

  CC [M]  drivers/media/common/siano/smsdvb-main.o
drivers/media/common/siano/smsdvb-main.c: In function
‘smsdvb_media_device_unregister’:
drivers/media/common/siano/smsdvb-main.c:614:27: warning: unused
variable ‘coredev’ [-Wunused-variable]
  struct smscore_device_t *coredev = client->coredev;
                           ^

drivers/media/common/siano/smsdvb-main.c: In function ‘smsdvb_hotplug’:
drivers/media/common/siano/smsdvb-main.c:1188:32: error: ‘struct
smscore_device_t’ has no member named ‘media_dev’
  dvb_create_media_graph(coredev->media_dev);
                                ^

make[4]: *** [drivers/media/common/siano/smsdvb-main.o] Error 1
make[3]: *** [drivers/media/common/siano] Error 2
make[2]: *** [drivers/media/common] Error 2

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
