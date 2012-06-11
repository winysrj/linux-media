Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43250 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab2FKITk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jun 2012 04:19:40 -0400
Received: by wibhj8 with SMTP id hj8so2584759wib.1
        for <linux-media@vger.kernel.org>; Mon, 11 Jun 2012 01:19:39 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 11 Jun 2012 16:19:39 +0800
Message-ID: <CALxrGmVo1TZTdvA_QwzjBvyA4WXYV0Cpavr5mC5d3BXCwm5CMQ@mail.gmail.com>
Subject: [media] soc_camera: suggest to postpone applying default format
From: Su Jiaquan <jiaquan.lnx@gmail.com>
To: g.liakhovetski@gmx.de
Cc: linux-media <linux-media@vger.kernel.org>,
	twang13 <twang13@marvell.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

         I found in soc_camera when video device is opened, default
format is applied sensor. I think this is the right thing to do, be it
also means a lot of i2c transactions.

I think in case of app wants to query drivers capability, it do a
quick “open-query-close”, expecting only to get some information
rather than really configuring camera. So maybe this is a point that
can be optimize.

Have you consider postpone it to some point later, how about, say,
before stream_on? At that point we can check if VIDIOC_S_FMT is
called, if yes, we do nothing, if no, we can configure the default
format.

         I simply move some code from soc_camera_open() to
soc_camera_set_fmt(), just a few changes, do you think it OK to make
this adjustment?

         Thanks!
Jiaquan
