Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40243 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbaEUSjD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 May 2014 14:39:03 -0400
Message-ID: <537CF2C4.6030302@iki.fi>
Date: Wed, 21 May 2014 21:39:00 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Michael Durkin <kc7noa@gmail.com>, linux-media@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: am i in the right list?
References: <CAC8M0EtVTh+EmDaJa-Xmtm17x8VK6ozzw2A56Et_aj_m8ZFdpw@mail.gmail.com>
In-Reply-To: <CAC8M0EtVTh+EmDaJa-Xmtm17x8VK6ozzw2A56Et_aj_m8ZFdpw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka

On 05/21/2014 09:28 PM, Michael Durkin wrote:
> Im looking for support for a Fresco logic FL2000 USB to VGA adapter ...
> Is any one already working on this or am i in the wrong list?

List is right AFAIK. In my understanding it should be implement as a 
V4L2 device which sends picture, like a analog RV modulator. I am not 
sure if there is any existing driver. There is modulator driver for 
audio transmitters, though.

Hans Verkuil is correct person to answer that as he known about 
everything from V4L2.

regards
Antti

-- 
http://palosaari.fi/
