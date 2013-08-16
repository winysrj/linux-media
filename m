Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:64779 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab3HQAmI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Aug 2013 20:42:08 -0400
Received: by mail-ea0-f178.google.com with SMTP id a15so1287736eae.37
        for <linux-media@vger.kernel.org>; Fri, 16 Aug 2013 17:42:06 -0700 (PDT)
Message-ID: <520E76E7.30201@googlemail.com>
Date: Fri, 16 Aug 2013 21:00:55 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: em28xx + ov2640 and v4l2-clk
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

since commit 9aea470b399d797e88be08985c489855759c6c60 "soc-camera:
switch I2C subdevice drivers to use v4l2-clk", the em28xx driver fails
to register the ov2640 subdevice (if needed).
The reason is that v4l2_clk_get() fails in ov2640_probe().
Does the em28xx driver have to register a (pseudo ?) clock first ?

Regards,
Frank

