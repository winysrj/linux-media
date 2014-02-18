Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:41294 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbaBROrG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Feb 2014 09:47:06 -0500
Received: by mail-wi0-f171.google.com with SMTP id cc10so3562907wib.10
        for <linux-media@vger.kernel.org>; Tue, 18 Feb 2014 06:47:04 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 18 Feb 2014 15:47:04 +0100
Message-ID: <CAMhOHA6NhtpauQ_WrO09hnK0jCUciH8OOREGrLjnLmqKfSwAyQ@mail.gmail.com>
Subject: Pinnacle PCTV 340e no longer working in kernel 3.11
From: Alfonso Garcia <barbolani@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This USB stick was working with 3.8, now with 3.11 the kernel loads
the driver correctly but you can't tune any channels (tried with
kaffeine, tv-me and VLC)

I've loaded the xc4000 driver enabling verbose output and no error
messages appear during scanning, merely it does not detect any signal.
I haven't tried any other kernel than these, however. Anyone had any
luck making it work with the 3.11 kernel?

Thanks
