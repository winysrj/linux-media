Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61513 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab1G0Upj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 16:45:39 -0400
Received: by fxh19 with SMTP id 19so572223fxh.19
        for <linux-media@vger.kernel.org>; Wed, 27 Jul 2011 13:45:38 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 27 Jul 2011 22:45:37 +0200
Message-ID: <CAMyVd1oipP4EaBab730oFWu5EDzDvz5wjUATGnH-q+1dDQpB+Q@mail.gmail.com>
Subject: [GIT PATCHES FOR 3.1] Updates for the gspca-stv06xx driver
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,
Long time no code. :)
Here are some updates to the stv06xx driver.

The following changes since commit b0189cd087aa82bd23277cb5c8960ab030e13e5c:

  Merge branch 'next/devel2' of
git://git.kernel.org/pub/scm/linux/kernel/git/arm/linux-arm-soc
(2011-07-26 17:42:18 -0700)

are available in the git repository at:

  http://git.linuxtv.org/eandren/v4l-dvb-stv06xx.git media-for_v3.1

Erik Andrén (5):
      gspca-stv06xx: Simplify register writes by avoiding special data
structures
      gspca-stv06xx: Simplify stv_init struct and vv6410 bridge init.
      gspca-stv06xx: Fix sensor init indentation.
      gspca-stv06xx: Remove writes to read-only registers
      gspca-stv06xx: Triple frame rate by decreasing the scan rate.

Regards,
Erik
