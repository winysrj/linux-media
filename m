Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56186 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab2HPApq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 20:45:46 -0400
Received: by lbbgj3 with SMTP id gj3so1197147lbb.19
        for <linux-media@vger.kernel.org>; Wed, 15 Aug 2012 17:45:45 -0700 (PDT)
Message-ID: <502C42A9.40009@iki.fi>
Date: Thu, 16 Aug 2012 03:45:29 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: Re: [PATCH 0/5] dvb-frontend statistic IOCTL validation
References: <1345076921-9773-1-git-send-email-crope@iki.fi>
In-Reply-To: <1345076921-9773-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/16/2012 03:28 AM, Antti Palosaari wrote:
> Take two.
>
> I added some logic to prevent statistic queries in case demodulator is clearly in state statistic query is invalid. Currently there could be checks in device driver but usually not. Gar
> bage is usually returned and in some cases even I/O errors are generated as demod is put sleep and cannot answer any request.
>
> I changed error code EPERM to EAGAIN. What I looked existing demodulator drivers there was multiple error codes used. EAGAIN was one, at least DRX-K uses it.

oops, this could be understood wrong. Originally no standardized error 
code at all, it was responsibility of each driver to return what they 
wish - and surely they did it :]

EPERM was used first version of that patch series, but got feedback from 
Mauro it is not suitable as it is documented:
"Permission denied. Can be returned if the device needs write 
permission, or some special capabilities is needed (e. g. root)"

Thus EAGAIN. Hope this is now better.


>
> Also documentation is updated according to new situation.
>
> Antti Palosaari (5):
>    dvb_frontend: use Kernel dev_* logging
>    dvb_frontend: return -ENOTTY for unimplement IOCTL
>    dvb_frontend: do not allow statistic IOCTLs when sleeping
>    DocBook: update ioctl error codes EAGAIN, ENOSYS, EOPNOTSUPP
>    rtl2832: remove dummy callback implementations
>
>   Documentation/DocBook/media/v4l/gen-errors.xml |  12 +-
>   drivers/media/dvb-core/dvb_frontend.c          | 266 +++++++++++++------------
>   drivers/media/dvb-frontends/rtl2832.c          |  29 ---
>   3 files changed, 151 insertions(+), 156 deletions(-)
>


-- 
http://palosaari.fi/
