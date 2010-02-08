Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:44298 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753713Ab0BHUFF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2010 15:05:05 -0500
Message-ID: <4B706E48.9010407@arcor.de>
Date: Mon, 08 Feb 2010 21:04:24 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org, dheitmueller@kernellabs.com
Subject: zl10335 with tm6010 or tm6000
References: <1265410096-11788-1-git-send-email-stefan.ringel@arcor.de> <1265410096-11788-2-git-send-email-stefan.ringel@arcor.de> <1265410096-11788-3-git-send-email-stefan.ringel@arcor.de> <1265410096-11788-4-git-send-email-stefan.ringel@arcor.de> <1265410096-11788-5-git-send-email-stefan.ringel@arcor.de> <4B6FF3C9.2010804@redhat.com> <4B704A2D.5000100@arcor.de> <4B7054A0.8050001@redhat.com> <4B7060DC.5030006@arcor.de> <4B706347.9020400@redhat.com>
In-Reply-To: <4B706347.9020400@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have switched from hack to zl10353 module, and  I have tested more
different setups. I have found what wrong is, in function
tl10353_read_status() and zl10353_read_snr(), not positive value.

zl10353_read_status()

reg                        has digital                            hasn't
digital

0x05                    0x40                                    0x00
0x06                    0x00                                    0x21
0x07                    0x33                                    0x03
0x08                    0x00                                    0x00
more than 0x00
0x09                    0x58                                    0x00

zl10353_read_snr()

reg                        has digital                            hasn't
digital

0x0f                     0x28   inv ( 0xd8) =^87%    0x2b  inv (0xd5) =^ 84%
0x10                    0x00                                    0x00


the function set_parameters is working. I have added (only for test) a
full HAS_FE_* status, so that I tested the set_parameter function.

-- 
Stefan Ringel <stefan.ringel@arcor.de>

