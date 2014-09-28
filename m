Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52590 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411AbaI1SOB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Sep 2014 14:14:01 -0400
Received: from dyn3-82-128-191-243.psoas.suomi.net ([82.128.191.243] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1XYIyu-0006s1-84
	for linux-media@vger.kernel.org; Sun, 28 Sep 2014 21:14:00 +0300
Message-ID: <54284FE7.5090805@iki.fi>
Date: Sun, 28 Sep 2014 21:13:59 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: Re: em28xx: Too many ISO frames scheduled when starting stream
References: <54284488.60404@iki.fi>
In-Reply-To: <54284488.60404@iki.fi>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/28/2014 08:25 PM, Antti Palosaari wrote:
> I want raise that bug:
> Too many ISO frames scheduled when starting stream
> https://bugzilla.kernel.org/show_bug.cgi?id=72891
>
> Is there anyone who cares to study it? It looks like em28xx driver bug
> or USB host controller driver or both.
>
> According to comments bug appeared on kernel 3.13.

em28xx didn't even get any notable changes at that time... I looked all 
the 3.13 em28xx patches and there is no patch that could cause issues 
listed. So root of cause is somewhere else or there is reports which has 
kernel with media_build installed.
Also, em28xx uses ISOC to data transferred, whilst most devices are 
using BULK. No other reports from other ISOC DVB devices so far though. 
I suspect it may be some compatibility issue with em28xx chip / em28xx 
driver / USB stack / USB host controller.

There were em28xx patches went to 3.13 (stable patches not included):
bdee6bd [media] em28xx-video: Swap release order to avoid lock nesting
6dbea9f [media] Add support for KWorld UB435-Q V2
be353fa [media] V4L2: em28xx: tell the ov2640 driver to balance clock 
enabling internally
fc5d0f8 [media] V4L2: em28xx: register a V4L2 clock source
032f1dd [media] em28xx: fix error path in em28xx_start_analog_streaming()
b68cafc [media] em28xx: fix and unify the coding style of the GPIO 
register write sequences
de0fc46 [media] em28xx: MaxMedia UB425-TC change demod settings
b6c7abb [media] em28xx: MaxMedia UB425-TC switch RF tuner driver to another
8d100b2 [media] em28xx: MaxMedia UB425-TC offer firmware for demodulator


> Is there anyone knowing em28xx internals who wants (non surely really
> want, but hates less to start examine) to look it?
>
> It is very near I will fork em28xx to DVB only driver and move devices
> there. Current em28xx is too complex for my taste and has had more bugs
> than any other DVB driver I have ever seen.


regards
Antti

-- 
http://palosaari.fi/
