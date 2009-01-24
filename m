Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37876 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbZAXPwN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Jan 2009 10:52:13 -0500
Message-ID: <497B2AD1.6090503@iki.fi>
Date: Sat, 24 Jan 2009 16:50:57 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Felipe Morales <felipe.morales.moreno@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Volar X remote control problem
References: <6fd6e6490901240056u59e275b2nc82e755123ffc87b@mail.gmail.com>
In-Reply-To: <6fd6e6490901240056u59e275b2nc82e755123ffc87b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Felipe Morales wrote:
> The same behavior repeats in the eeepc 1000H. I'm using Debian testing
> on the three machines, with the same 2.6.26 kernel. The drivers I've
> tried are the ones from
> http://linuxtv.org/hg/v4l-dvb/archive/tip.tar.gz, with the Volar X
> RM-KS patch applied.
> 
> Does anybody have any clue why this happens?

Looks like it is buggy HID.
http://www.linuxtv.org/pipermail/linux-dvb/2008-November/030292.html

Antti
-- 
http://palosaari.fi/
