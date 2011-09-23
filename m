Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36345 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290Ab1IWWGX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 18:06:23 -0400
Message-ID: <4E7D02DC.3010201@iki.fi>
Date: Sat, 24 Sep 2011 01:06:20 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jin Kazama <jin.ml@skynet.fr>
CC: linux-media@vger.kernel.org
Subject: Re: af9015/tda18218: Multiples (separates) usb devices errors/conflicts
References: <S1752295Ab1IWUja/20110923203930Z+74@vger.kernel.org> <4E7CF4DA.5020607@skynet.fr>
In-Reply-To: <4E7CF4DA.5020607@skynet.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/24/2011 12:06 AM, Jin Kazama wrote:
> Hello,
> I've been testing af9015/tda18218 based usb DVB-T tuners on a 2.6.39.4
> kernel with the latest v4l drivers avaiable (from git).
> When I'm using a single USB module, (listed as /dev/dvb/adapter0),
> everything works fine.
> When I'm plugging another module, at first it looks like everything's ok
> (/dev/dvb/adapter1) and if I try to use this module while the adapter0
> is not been used, it works - but if try to use both modules at the same
> time, I get garbage output on both cards (error: warning: discontinuity
> for PID... with dvblast on both cards.
> Does anyone have any idea on how to fix this problem?

Feel free to fix it. I am too busy currently.

Antti


-- 
http://palosaari.fi/
