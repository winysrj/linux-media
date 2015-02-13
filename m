Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:41771 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbbBMLr6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 06:47:58 -0500
Received: by mail-pa0-f54.google.com with SMTP id kx10so18366192pab.13
        for <linux-media@vger.kernel.org>; Fri, 13 Feb 2015 03:47:57 -0800 (PST)
Message-ID: <54DDE468.1070206@gmail.com>
Date: Fri, 13 Feb 2015 20:47:52 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
CC: m.chehab@samsung.com
Subject: Re: [PATCH v3] dvb-core: add template code for i2c binding model
References: <1421406888-8874-1-git-send-email-tskd08@gmail.com> <54D57112.5020100@iki.fi>
In-Reply-To: <54D57112.5020100@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka,
thank you for the comment.
(and sorry for the late reply. I was off from work until recently.)

> Basically the issue is registering I2C driver and after that reference counting it as there is dvb frontend ops which are called.

In current DVB drivers, "struct dvb_frontend"s can be alloc'ed in two places,
in FE driver itself and in the client(adapter) driver,
but the patch alloc's the struct dvb_frontned in the probe() helper function,
so you cannot access frontend ops before registering the driver module. 

The probe() helper function ref-counts the driver module as well,
so from clients' point of views,
the driver registering and the ref-counting are done at the same time.

> 
> Did you make study how the others have resolved that issue? Could you list already used methods?

I just read through the V4L2-core i2c subdev code and
did not studied much on other modules, tbh:P

Regards,
akihiro
