Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:41187 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbZIGIkN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2009 04:40:13 -0400
Received: by fxm17 with SMTP id 17so1838320fxm.37
        for <linux-media@vger.kernel.org>; Mon, 07 Sep 2009 01:40:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <aa09d86e0909070139h770f90bfn510c711b6a50ba11@mail.gmail.com>
References: <aa09d86e0909070139h770f90bfn510c711b6a50ba11@mail.gmail.com>
Date: Mon, 7 Sep 2009 12:40:14 +0400
Message-ID: <aa09d86e0909070140u3cf4b215qf3f143f2e9ea43d2@mail.gmail.com>
Subject: [LinuxDVB] dma-capable ringbuffer
From: =?KOI8-R?B?88XSx8XKIO3J0s/Oz9c=?= <ierton@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello! I am developing driver for my company's device. This device is
designed with performance in mind and has capability of assigning
separate dma channels to hardware pid filters.  (relationship between
dma channels and hw pid filters is many-to-many. For example, i can
request the device to filter pids 3, 88 and 222 and redirect result
either to single dma channel number 5 or to separate channels 1, 2 and
3)

But i found that dmxdev's buffers of type dvb_ringbuffer are not
designed for dma input. For example, dmxdev.c uses vmalloc() to
allocate memory.

Should i think about rewriting dmxdev.c or this job is already done in
some of current/unstable branches?

--
Thanks, Sergey
