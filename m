Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38172 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112AbZBNC3p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2009 21:29:45 -0500
Message-ID: <49962C97.4000207@iki.fi>
Date: Sat, 14 Feb 2009 04:29:43 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Tanguy Pruvot <tanguy.pruvot@gmail.com>
CC: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] EC168
References: <457563803.20081123042151@gmail.com> <1766329077.20081126030346@gmail.com> <4991EE34.3040507@iki.fi> <49962063.4030008@iki.fi>
In-Reply-To: <49962063.4030008@iki.fi>
Content-Type: text/plain; charset=windows-1250; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti Palosaari wrote:
> I have done some work but not very much. Basically it now loads firmware 
> and and have some basic demod and tuner stuff. I have now one one 
> problem that I have no idea why. After firmware download device 
> reconnects (upon request as seen from sniff) with vendor and product ID 
> having both 0. :(

Problem resolved. Windows driver patch firmware before download to the 
device. Still help is welcome...

Antti
-- 
http://palosaari.fi/
