Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfe05.c2i.net ([212.247.154.130]:59866 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757532Ab1IIHyh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Sep 2011 03:54:37 -0400
From: Hans Petter Selasky <hselasky@c2i.net>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: recursive locking problem
Date: Fri, 9 Sep 2011 09:51:51 +0200
Cc: linux-media@vger.kernel.org
References: <4E68EE98.90201@iki.fi>
In-Reply-To: <4E68EE98.90201@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109090951.51252.hselasky@c2i.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 08 September 2011 18:34:32 Antti Palosaari wrote:
> lock() + lock() + unlock() == free.

Hi,

As far as I can see the Linux kernel's mutex API doesn't have support for 
checking if a mutex is owned. I guess you would have to do something like:

while (mutex_owned(&xxx))
	mutex_unlock(&xxx);

--HPS
