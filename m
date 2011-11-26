Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44444 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab1KZPA0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Nov 2011 10:00:26 -0500
Message-ID: <4ED0FF05.4020700@iki.fi>
Date: Sat, 26 Nov 2011 17:00:21 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Maik Zumstrull <maik@zumstrull.net>
CC: linux-media@vger.kernel.org
Subject: Re: Status of RTL283xU support?
References: <CAO=zWDJD19uCJJfdZQVQzHOSxLcXb11D+Avw--YV5mCk8qxPww@mail.gmail.com>
In-Reply-To: <CAO=zWDJD19uCJJfdZQVQzHOSxLcXb11D+Avw--YV5mCk8qxPww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/26/2011 02:47 PM, Maik Zumstrull wrote:
> Hi Antti,
>
> it seems I've found myself with an rtl2832u-based DVB-T USB stick. The
> latest news on that seems to be that you were working on cleaning up
> the code of the Realtek-provided GPL driver, with the goal of
> eventually getting it into mainline.
>
> Would you mind giving a short status update?

Shortly, It is error No time, -ENOTIME.

I have two LinuxTV related projects that are higher priority.
* AF9013 rewrite to optimize I2C IO
* Anysee smartcard reader


> Is there a working out-of-tree version somewhere I could build? I've
> tried the linuxtv.org build script against your tree, but it fails
> with git errors; possibly due to the recent outage of git.kernel.org.

I think my rtl28xx tree should be rebased to latest code. MFE support at 
least have made such changes it will not compile top of latest tree.

And the tree I have does support only very limited set of RTL2831U 
devices. It was Maxim Levitsky working for RTL2832U but he have given up.

regards
Antti

-- 
http://palosaari.fi/
