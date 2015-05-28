Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:36832 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbbE1UHM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 16:07:12 -0400
Message-ID: <55677568.4070603@gmail.com>
Date: Thu, 28 May 2015 21:07:04 +0100
From: Malcolm Priestley <tvboxspy@gmail.com>
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: crope@iki.fi, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] ts2020: Provide DVBv5 API signal strength
References: <5564C269.2000003@gmail.com> <20150526150400.10241.25444.stgit@warthog.procyon.org.uk> <20150526150407.10241.89123.stgit@warthog.procyon.org.uk> <360.1432807690@warthog.procyon.org.uk>
In-Reply-To: <360.1432807690@warthog.procyon.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 28/05/15 11:08, David Howells wrote:
> Malcolm Priestley <tvboxspy@gmail.com> wrote:
>
>> Statistics polling can not be done by lmedm04 driver's implementation of
>> M88RS2000/TS2020 because I2C messages stop the devices demuxer.
>>
>> So any polling must be a config option for this driver.
>
> Ummm...  I presume a runtime config option is okay.

Yes, also, the workqueue appears not to be initialized when using the 
dvb attached method.

>
> Also, does that mean that the lmedm04 driver can't be made compatible with the
> DVBv5 API?

No, the driver will have to implement its own version. It doesn't need a 
polling thread it simply gets it directly from its interrupt urb buffer.


Malcolm
