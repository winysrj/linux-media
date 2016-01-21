Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:36274 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbcAURDw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2016 12:03:52 -0500
Received: by mail-io0-f180.google.com with SMTP id g73so62118673ioe.3
        for <linux-media@vger.kernel.org>; Thu, 21 Jan 2016 09:03:52 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 21 Jan 2016 12:03:51 -0500
Message-ID: <CAJ2oMh+tSJX4FSFduRG-p36YHxDBqi3c8hd0JDLJttWN9b2w-Q@mail.gmail.com>
Subject: Debugging v4l-pci driver without real HW
From: Ran Shalit <ranshalit@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I would like to ask if it is possible in some way or other to start
debugging the pci driver without the real hardware available.
I've decided to use solo6x10 driver (I hope it's a good decision) as a
template for our coming hardware.
The thing is that I don't have hardware yet. I expect to purchase it
in the coming days, but wanted to start debugging code even before
that.
Is it possible in some way or other to make the driver think that the
pci board is connected to pci HW ?

Thank you,
Ran
