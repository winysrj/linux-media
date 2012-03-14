Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f52.google.com ([209.85.213.52]:50980 "EHLO
	mail-yw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030943Ab2CNVli (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Mar 2012 17:41:38 -0400
Received: by yhpp61 with SMTP id p61so2886594yhp.11
        for <linux-media@vger.kernel.org>; Wed, 14 Mar 2012 14:41:38 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 14 Mar 2012 18:41:37 -0300
Message-ID: <CALF0-+WfFTGZZv5R-x+hDrG_T9FXPk8JM-aNAnRKdNa=QA4cXA@mail.gmail.com>
Subject: [Q] tracing/printing
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
To: linux-media <linux-media@vger.kernel.org>,
	kernelnewbies <kernelnewbies@kernelnewbies.org>,
	devel <devel@linuxdriverproject.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm writing a video capture device and have a doubt about how to
correctly print to screen.

First, I suppose I should follow the rule "don't print unless there is
something surprising to say", right?
Second, I've found I need to print in a very verbose manner
at developing stage so I should implement a debug param.
I will probably adopt videobuf2 way (like many others) of
defining a macro (dprintk or something).

However, reading the source I've found there isn't a unified
way to do this: some use printk (as defined macros), others
use v4l_xxx, others use dev_xxx.

I've adopted the latter, because I thought there could
be many devices plugged, and using dev_xxx with
the usb_device->dev helps seeing which is tracing.

I'm not really sure if it is ok so I would love to
hear some opinions about this sensible issue.

Thanks!
