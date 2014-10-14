Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f52.google.com ([209.85.213.52]:57345 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbaJNLsX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Oct 2014 07:48:23 -0400
Received: by mail-yh0-f52.google.com with SMTP id f10so4738846yha.25
        for <linux-media@vger.kernel.org>; Tue, 14 Oct 2014 04:48:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BLU437-SMTP32BE04CD60AF807B75686C5AC0@phx.gbl>
References: <543C5B34.5090002@outlook.com>
	<BLU437-SMTP32BE04CD60AF807B75686C5AC0@phx.gbl>
Date: Tue, 14 Oct 2014 07:48:22 -0400
Message-ID: <CALzAhNUm53w65BJPgSitpVcf3VrUdTAX09quT4s+xtre24u1Hw@mail.gmail.com>
Subject: Re: Hauppauge HVR-2200 (saa7164) problems (on Linux Mint 17)
From: Steven Toth <stoth@kernellabs.com>
To: serrin <serrin19@outlook.com>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please keep the discussion on the mailing list at all times.

> I couldn't figure out how to apply the patch using the patch file, so I
> manually edited the file (drivers/media/pci/saa7164/saa7164-fw.c), but I
> kept getting the image corrupt message.

That's probably the issue. Assuming you have the patch applied and are
using the firmware it will work for you.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
