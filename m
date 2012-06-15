Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63832 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757954Ab2FOWLX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jun 2012 18:11:23 -0400
Received: by wibhn6 with SMTP id hn6so1117298wib.1
        for <linux-media@vger.kernel.org>; Fri, 15 Jun 2012 15:11:22 -0700 (PDT)
Message-ID: <1339798273.12274.21.camel@Route3278>
Subject: dvb_usb_v2: use pointers to properties[REGRESSION]
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Date: Fri, 15 Jun 2012 23:11:13 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti

You can't have dvb_usb_device_properties as constant structure pointer.

At run time it needs to be copied to a private area.

Two or more devices of the same type on the system will be pointing to
the same structure.

Any changes they make to the structure will be common to all.

Regards


Malcolm

