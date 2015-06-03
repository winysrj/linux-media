Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36244 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758431AbbFCQnf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jun 2015 12:43:35 -0400
Message-ID: <556F2EB4.6030108@iki.fi>
Date: Wed, 03 Jun 2015 19:43:32 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>,
	Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] ts2020: Provide DVBv5 API signal strength
References: <556F1A02.9020203@gmail.com> <55677568.4070603@gmail.com> <5564C269.2000003@gmail.com> <20150526150400.10241.25444.stgit@warthog.procyon.org.uk> <20150526150407.10241.89123.stgit@warthog.procyon.org.uk> <360.1432807690@warthog.procyon.org.uk> <23160.1433326669@warthog.procyon.org.uk> <31746.1433349441@warthog.procyon.org.uk>
In-Reply-To: <31746.1433349441@warthog.procyon.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/03/2015 07:37 PM, David Howells wrote:
> Malcolm Priestley <tvboxspy@gmail.com> wrote:
>
>>>> Yes, also, the workqueue appears not to be initialized when using the dvb
>>>> attached method.
>>>
>>> I'm not sure what you're referring to.  It's initialised in ts2020_probe()
>>> just after the ts2020_priv struct is allocated - the only place it is
>>> allocated.
>>>
>> ts2020_probe() isn't touched by devices not converted to I2C binding.
>
> Hmmm...  Doesn't that expose a larger problem?  The only place the ts2020_priv
> struct is allocated is in ts2020_probe() within ts2020.c and the struct
> definition is private to that file and so it can't be allocated from outside.
> So if you don't pass through ts2020_probe(), fe->tuner_priv will remain NULL
> and the driver will crash.

Malcolm misses some pending patches where attach() is wrapped to I2C 
model probe().
http://git.linuxtv.org/cgit.cgi/anttip/media_tree.git/log/?h=ts2020

regards
Antti

-- 
http://palosaari.fi/
