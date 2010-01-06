Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:63166 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767Ab0AFOmx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Jan 2010 09:42:53 -0500
Date: Wed, 6 Jan 2010 15:42:51 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Felix Wolfsteller <felix.wolfsteller@googlemail.com>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: IR device at I2C address 0x7a:
Message-ID: <20100106154251.2280705e@hyperion.delvare>
In-Reply-To: <47c78560912302318k6d662a44s736c96cc6a5a4409@mail.gmail.com>
References: <47c78560912302318k6d662a44s736c96cc6a5a4409@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Felix,

On Thu, 31 Dec 2009 08:18:51 +0100, Felix Wolfsteller wrote:
> Sorry to bump into you by mail directly. Feel free to redirect me to
> other channels and/or quote me.

Adding LMML to Cc.

> My tv card (asus digimatrix, card=62, tuner=66; i think) might exhibit
> the issue you discussed and apparently patched
> (http://osdir.com/ml/linux-media/2009-10/msg00078.html).
> At least I am getting the same error message as quoted. For more or
> less extensive hardware details, see:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/481449
> For the dmesg output containing the "adress 0x7a" line, see latest
> comments on that bug.
> 
> I hope I can help and get helped ;)

This error message will show on virtually every SAA713x-based board
with no known IR setup. It doesn't imply your board has any I2C device
at address 0x7a. So chances are that the message is harmless and you
can simply ignore it.

-- 
Jean Delvare
