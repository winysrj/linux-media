Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:54978 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab0FERqn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Jun 2010 13:46:43 -0400
Message-ID: <4C0A8CB3.7070502@s5r6.in-berlin.de>
Date: Sat, 05 Jun 2010 19:43:15 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Jarod Wilson <jarod@wilsonet.com>, Jarod Wilson <jarod@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	linux-media@vger.kernel.org,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Subject: Re: [PATCH 1/3] IR: add core lirc device interface
References: <BQCH7Bq3jFB@christoph>	<4C09482B.8030404@redhat.com>	<AANLkTikr49GiEcENLb6n1shtCkWrDhMXoYh4VJ4IPtdQ@mail.gmail.com>	<20100604201733.GJ23375@redhat.com>	<AANLkTimrV3zUg1yqtWCROtUqY4AfvfXrv81BVmh8HHlk@mail.gmail.com> <AANLkTimFzEEPYnKEsUsd42ny1z1DPnhbPhUIwW_6E5rb@mail.gmail.com>
In-Reply-To: <AANLkTimFzEEPYnKEsUsd42ny1z1DPnhbPhUIwW_6E5rb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jon Smirl wrote:
> On Fri, Jun 4, 2010 at 5:17 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
>> Hrm, struct file_operations specifies an unsigned long for the ioctl
>> args, so doesn't that mean we're pretty much stuck with only 32-bit
>> for the ioctls?
> 
> I haven't written an IOCTL in a while, but how would you pass a 64b
> memory address?

On architectures with 64 bits wide memory addresses, unsigned long
happens to be 64 bits wide too. :-)  IOW unsigned long is defined such
that casts from and to void * are lossless.

This is not universal though.  E.g. Microsoft compilers define unsigned
long always only as 32 bits wide AFAIK.
-- 
Stefan Richter
-=====-==-=- -==- --=-=
http://arcgraph.de/sr/
