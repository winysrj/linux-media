Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57671 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbbFCLN2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jun 2015 07:13:28 -0400
Message-ID: <556EE155.1000508@iki.fi>
Date: Wed, 03 Jun 2015 14:13:25 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>,
	David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] ts2020: Provide DVBv5 API signal strength
References: <5564C269.2000003@gmail.com> <20150526150400.10241.25444.stgit@warthog.procyon.org.uk> <20150526150407.10241.89123.stgit@warthog.procyon.org.uk> <360.1432807690@warthog.procyon.org.uk> <55677568.4070603@gmail.com>
In-Reply-To: <55677568.4070603@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/28/2015 11:07 PM, Malcolm Priestley wrote:
> On 28/05/15 11:08, David Howells wrote:
>> Malcolm Priestley <tvboxspy@gmail.com> wrote:
>>
>>> Statistics polling can not be done by lmedm04 driver's implementation of
>>> M88RS2000/TS2020 because I2C messages stop the devices demuxer.

I did make tests (using that same lme2510 + rs2000 device) and didn't 
saw the issue TS was lost. Could test and and tell me how to reproduce it?
Signal strength returned was quite boring though, about same value all 
the time, but it is different issue...

>>>
>>> So any polling must be a config option for this driver.
>>
>> Ummm...  I presume a runtime config option is okay.
>
> Yes, also, the workqueue appears not to be initialized when using the
> dvb attached method.
>
>>
>> Also, does that mean that the lmedm04 driver can't be made compatible
>> with the
>> DVBv5 API?
>
> No, the driver will have to implement its own version. It doesn't need a
> polling thread it simply gets it directly from its interrupt urb buffer.

I assume lme2510 firmware will read signal strength from rs2000 and it 
is returned then directly by USB interface.

regards
Antti

-- 
http://palosaari.fi/
