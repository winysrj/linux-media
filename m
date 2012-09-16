Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34192 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab2IPB1F (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 21:27:05 -0400
Message-ID: <50552AD4.4020100@iki.fi>
Date: Sun, 16 Sep 2012 04:26:44 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?UsOpbWkgQ2FyZG9uYQ==?= <remi.cardona@smartjog.com>
CC: linux-media@vger.kernel.org, liplianin@me.by
Subject: Re: [PATCH v2 0/6] ds3000 improvements
References: <1347614846-19046-1-git-send-email-remi.cardona@smartjog.com>
In-Reply-To: <1347614846-19046-1-git-send-email-remi.cardona@smartjog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/14/2012 12:27 PM, Rémi Cardona wrote:
> Hi all,
>
> Here is an updated and more complete patch series for ds3000. I've
> done my testing on top of kernel 3.5.2 and things look ok so far.
>
> Reviews and comments are again more than welcome.

I reviewed it and I was near to test it also, but patches didn't apply. 
driver/media directory structure is changed recently.

Is it possible you to rebase it top of latest tree and resend?

http://git.linuxtv.org/media_tree.git/shortlog/refs/heads/staging/for_v3.7

I have few comments too, IMHO nothing you must fix but feel free to do 
if you wish. Comments will follow per patch.

regards
Antti

-- 
http://palosaari.fi/
