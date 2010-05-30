Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56860 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab0E3WWJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 18:22:09 -0400
Received: by wyb36 with SMTP id 36so926298wyb.19
        for <linux-media@vger.kernel.org>; Sun, 30 May 2010 15:22:07 -0700 (PDT)
Subject: [PATH 0/3] gspca-gl860 driver update
From: Olivier Lorin <olorin75@gmail.com>
To: V4L Mailing List <linux-media@vger.kernel.org>
Cc: Jean-Francois Moine <moinejf@free.fr>
Content-Type: text/plain
Date: Mon, 31 May 2010 00:21:54 +0200
Message-Id: <1275258114.18267.20.camel@miniol>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

Here is three patches for the gspca_gl860 driver.
The main patch is the second one, it is a rewrite for the sensor MI2020.

These patches have been proposed on February 28th and refused some days
later because of a concern about the use of "udelay" instead of
"msleep".
Compared to February, there is no more use of "udelay". I also 
mapped a new setting to an already existing one in V4L2 instead of the
new one.

