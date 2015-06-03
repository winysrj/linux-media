Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:38593 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbbFCQor (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Jun 2015 12:44:47 -0400
Message-ID: <556F2EF0.9090903@gmail.com>
Date: Wed, 03 Jun 2015 17:44:32 +0100
From: Malcolm Priestley <tvboxspy@gmail.com>
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: crope@iki.fi, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] ts2020: Provide DVBv5 API signal strength
References: <556F1A02.9020203@gmail.com> <55677568.4070603@gmail.com> <5564C269.2000003@gmail.com> <20150526150400.10241.25444.stgit@warthog.procyon.org.uk> <20150526150407.10241.89123.stgit@warthog.procyon.org.uk> <360.1432807690@warthog.procyon.org.uk> <23160.1433326669@warthog.procyon.org.uk> <31746.1433349441@warthog.procyon.org.uk>
In-Reply-To: <31746.1433349441@warthog.procyon.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/06/15 17:37, David Howells wrote:
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
>

No, it is also allocated in ts2020_attach.

