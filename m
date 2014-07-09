Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58801 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932289AbaGITTH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Jul 2014 15:19:07 -0400
Message-ID: <53BD95A3.2050509@iki.fi>
Date: Wed, 09 Jul 2014 22:18:59 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Andre Newman <linux-media@dinkum.org.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: PCTV T292e whole DVBT2 mux/Ultra HD performance question
References: <35906397-E8F4-4229-966F-7ED578441C10@dinkum.org.uk>
In-Reply-To: <35906397-E8F4-4229-966F-7ED578441C10@dinkum.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka


On 07/09/2014 04:14 PM, Andre Newman wrote:
> I’m using a T290e for whole mux DVBT2 capture, using this to record the current BBC World Cup Ultra HD tests, works well. :-)
>
> It seems impossible to buy more T290e’s, everyone want to sell me a T292e, I understand there is a driver now, thanks Antti. I read on Antti’s blog that there is a limit on raw TS performance with the T292, that it didn’t work well with QAM256 because of this...
>
> I am wondering if this is a hardware limit, or a performance problem that may have been resolved now the driver is a little tiny bit more mature?
>
> I am very happy to get a T292e and make some tests, help debug if there is a hope that it can handle 40Mbps in hardware.If there is a hardware limit I’d rather not be stuck with a limited tuner!
>
> The mux I need to record is QAM256 at ~40Mbps and the UHD video is ~36Mbps of this.
>
> Otherwise what other DVBT2 tuners are there that can capture a raw QAM256 mux at 40Mbps?

You simply confused two different devices. There is no such limit on 
PCTV 292e as far as I know. It is another DVB-T2 device having RTL2832P 
bridge having problem with stream bandwidth.

regards
Antti


-- 
http://palosaari.fi/
