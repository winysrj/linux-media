Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbZKZWOZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 17:14:25 -0500
Message-ID: <4B0EFDBA.8000905@redhat.com>
Date: Thu, 26 Nov 2009 20:14:18 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Christoph Bartelmus <lirc@bartelmus.de>
CC: dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDccCqq3jFB@christoph>
In-Reply-To: <BDccCqq3jFB@christoph>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Christoph Bartelmus wrote:
> Hi Mauro,
> 
> on 26 Nov 09 at 18:59, Mauro Carvalho Chehab wrote:
>> Christoph Bartelmus wrote:
> [...]
>>>> lircd supports input layer interface. Yet, patch 3/3 exports both devices
>>>> that support only pulse/space raw mode and devices that generate scan
>>>> codes via the raw mode interface. It does it by generating artificial
>>>> pulse codes.
>>> Nonsense! There's no generation of artificial pulse codes in the drivers.
>>> The LIRC interface includes ways to pass decoded IR codes of arbitrary
>>> length to userspace.
> 
>> I might have got wrong then a comment in the middle of the
>> imon_incoming_packet() of the SoundGraph iMON IR patch:
> 
> Indeed, you got it wrong.
> As I already explained before, this device samples the signal at a  
> constant rate and delivers the current level in a bit-array. This data is  
> then condensed to pulse/space data.

Ah, ok. It is now clear to me. 

IMHO, it would be better to explain this at the source code, since the 
imon_incoming_packet() is a little complex. 

It would help the review process if those big routines could be broken into
 a few functions. While this improves code readability, it shouldn't 
affect performance, as gcc will handle the static functions used only once
as inline.

> Christoph

Cheers,
Mauro.
