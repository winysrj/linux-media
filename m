Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36730 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261Ab2IBRPo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Sep 2012 13:15:44 -0400
Received: by bkwj10 with SMTP id j10so1881154bkw.19
        for <linux-media@vger.kernel.org>; Sun, 02 Sep 2012 10:15:43 -0700 (PDT)
Message-ID: <5043943E.2090802@googlemail.com>
Date: Sun, 02 Sep 2012 19:15:42 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: moinejf@free.fr, hdegoede@redhat.com
Subject: gspca_pac7302 driver broken ?
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

can anyone who owns such a device confirm that the gspca_pac7302 driver
(kernel 3.6.0-rc1+) is fine ?

Today I stumbled over a webcam which we do not support yet. The Windows
driver of this device is called pac7302.sys, so I added it's USB-ID to
the gspca-driver but couldn't get the device working.
When I started capturing, the LED turned on for about a second and then
off again. No frames are received. There were no error messages.

I didn't have enough time for looking into this deeper today, but I
think I could borrow this device again in a few days.

Regards,
Frank Schäfer
