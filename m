Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37969 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab1KEEBC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Nov 2011 00:01:02 -0400
Received: by qabj40 with SMTP id j40so2640123qab.19
        for <linux-media@vger.kernel.org>; Fri, 04 Nov 2011 21:01:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAN7ACRw1nGXRgs6Mtx4x-0USWMMohH0WrW4H7XEhMVnFaVSLw@mail.gmail.com>
References: <CAAN7ACRw1nGXRgs6Mtx4x-0USWMMohH0WrW4H7XEhMVnFaVSLw@mail.gmail.com>
Date: Fri, 4 Nov 2011 21:01:01 -0700
Message-ID: <CAAN7ACQQLAao2rGp2zWgob0mBSs+DUqd1SLkBgzZW-poRBDVsA@mail.gmail.com>
Subject: Re: mt9p031 driver source.
From: Andrew Tubbiolo <andrew.tubbiolo@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All:

   I've been playing with the mt9p031 for some time now. Last weekend
I got the raw 12 bit data dump I've been wanting for some time. As of
now the module I'm using only works if it is included in the kernel. I
cannot obtain functionality or enumeration on the i2c bus if I insert
it as a module. I think some of the init code is missing in the
version of the driver I've been working with. Can folks who are
working with the aptina mt9p031.c driver tell me the location from
which you obtained your source? I need a driver that is compatiable
with linux 2.6.39 and ready to respond to commands from media-ctl.

Thanks
Andrew
