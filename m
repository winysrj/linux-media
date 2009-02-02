Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallbackmx07.syd.optusnet.com.au ([211.29.132.9]:44510 "EHLO
	fallbackmx07.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419AbZBBB1B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Feb 2009 20:27:01 -0500
Received: from mail05.syd.optusnet.com.au (mail05.syd.optusnet.com.au [211.29.132.186])
	by fallbackmx07.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id n121QuIU002489
	for <linux-media@vger.kernel.org>; Mon, 2 Feb 2009 12:26:58 +1100
Received: from blackpaw.dyndns.org (c122-108-213-22.rochd4.qld.optusnet.com.au [122.108.213.22])
	(authenticated sender lindsay.mathieson)
	by mail05.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id n121OkOD007471
	for <linux-media@vger.kernel.org>; Mon, 2 Feb 2009 12:24:47 +1100
From: "Lindsay Mathieson" <lindsay.mathieson@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Subject: TinyTwin (af9015) - tuner 0 not working
Date: Mon, 02 Feb 2009 11:24:43 +1000
Message-id: <49864b5b.104.2583.763472724@blackpaw.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've had a DigitalNow TinyTwin dual usb tuner working on my
mythbox for a week now (latest v4l-dvb trunk).

A odd problem with the tuner has surfaced. Today Tuner 0
stopped getting a lock on any channel. Signal strength is
95%+, Bit Errors are Zero.

However Tuner 1 is locking on and displaying channels just
fine. Tuner 0 used to work fine. I've rebooted, but the
problem hasn't gone away.

Any suggestions?

Thanks - Lindsay

Lindsay Mathieson
http://members.optusnet.com.au/~blackpaw1/album
