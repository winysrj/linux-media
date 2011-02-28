Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39429 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab1B1M6j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 07:58:39 -0500
Received: by iyb26 with SMTP id 26so2848614iyb.19
        for <linux-media@vger.kernel.org>; Mon, 28 Feb 2011 04:58:38 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 28 Feb 2011 13:58:38 +0100
Message-ID: <AANLkTikMHa6OQ0uwZZPO0fQc03T0itPJuKbj0=fZ=MKV@mail.gmail.com>
Subject: tuner and PAL decoder - runtime suspend
From: Raffaele Recalcati <lamiaposta71@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I'm trying to develop the tda9885 poweron + setting paramteres driver,
using the v4l2 structure, that feeds a tvp5151.
I can declare a tvp5151 input as V4L2_INPUT_TYPE_TUNER and than create
a v4l2 subdev driver for tda9885.
I don't know if I need to put code in tvp5151 driver in order to
trigger the tda9885 power on + setting parameters
(v4l2_device_call_all), or if there is an automatic way (I think so)
to do it.
Finally I'll add runtime suspend and resume code for tda9885 and tvp5151.
Is there any recommendation to do this in the right way?

Thx,
Raffaele
