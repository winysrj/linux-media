Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:42341 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758748Ab3DYUxj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 16:53:39 -0400
Received: by mail-qc0-f180.google.com with SMTP id b40so1750824qcq.39
        for <linux-media@vger.kernel.org>; Thu, 25 Apr 2013 13:53:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <001901ce41f5$c4da31f0$4e8e95d0$@vizexperts.com>
References: <001901ce41f5$c4da31f0$4e8e95d0$@vizexperts.com>
Date: Thu, 25 Apr 2013 16:53:37 -0400
Message-ID: <CAGoCfizbP4F-OEJ25cFevcUgDL9AaBVroGF6Su9rhsi1=AqdOA@mail.gmail.com>
Subject: Re: Video Signal Type in V4L
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Abhishek Bansal <abhishek@vizexperts.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Is there any way by which I can know Input signal type (in terms of
> DVI/Composite/USB/SDI) and refresh rate from a V4L video capture device.
> Any available V4L Structure/Flag from which I can deduce this information.
> Please help !

The extent to which the data is available is the name field in the G_FMT call:

http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-enuminput.html

For most devices, the driver developer names the individual inputs
"Composite", "S-Video", "Tuner", etc.

The only level of distinction other than the name is the type field,
which today is V4L2_INPUT_TYPE_TUNER for an RF tuner and
V4L2_INPUT_TYPE_CAMERA for everything else.

To my knowledge there aren't any current drivers in the main tree that
support DVI or SDI capture, so nobody has really cared to make the API
more flexible to extend the "type" field with other values (which
would both be easier to machine parse, localize, and be consistent
across boards).

Devin

--
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
