Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:32916 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646AbbFCP5O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Jun 2015 11:57:14 -0400
Message-ID: <556F23CF.8030707@gmail.com>
Date: Wed, 03 Jun 2015 16:57:03 +0100
From: Malcolm Priestley <tvboxspy@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] ts2020: Provide DVBv5 API signal strength
References: <5564C269.2000003@gmail.com> <20150526150400.10241.25444.stgit@warthog.procyon.org.uk> <20150526150407.10241.89123.stgit@warthog.procyon.org.uk> <360.1432807690@warthog.procyon.org.uk> <55677568.4070603@gmail.com> <556EE155.1000508@iki.fi>
In-Reply-To: <556EE155.1000508@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/06/15 12:13, Antti Palosaari wrote:
> On 05/28/2015 11:07 PM, Malcolm Priestley wrote:
>> On 28/05/15 11:08, David Howells wrote:
>>> Malcolm Priestley <tvboxspy@gmail.com> wrote:
>>>
>>>> Statistics polling can not be done by lmedm04 driver's
>>>> implementation of
>>>> M88RS2000/TS2020 because I2C messages stop the devices demuxer.
>
> I did make tests (using that same lme2510 + rs2000 device) and didn't
> saw the issue TS was lost. Could test and and tell me how to reproduce it?
> Signal strength returned was quite boring though, about same value all
> the time, but it is different issue...
Hi Antti

The workqueue is not working because ts2020_probe() isn't called.

I am thinking that other drivers that still use dvb_attach may be broken.

It will become an issue when the driver is converted to I2C binding.

Regards


Malcolm
