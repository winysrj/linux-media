Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39990 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab0EMVuN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 May 2010 17:50:13 -0400
Message-ID: <4BEC740E.6050005@iki.fi>
Date: Fri, 14 May 2010 00:50:06 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans van den Bogert <gandalf@unit-westland.nl>
CC: linux-media@vger.kernel.org
Subject: Re: anysee e30 suspend->resume causes wrong profiling of card.
References: <20120314155304.c347fb58@mail.interworx.nl>
In-Reply-To: <20120314155304.c347fb58@mail.interworx.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Terve Hans,

On 03/14/2012 05:53 PM, Hans van den Bogert wrote:
> The anysee driver works correctly from cold boot and reinsertion of the device, however, after a suspend resume cycle (S3),  the device suddenly is initated as dvb-t as where it was dvb-c before. Yes this is a combo device, so dvb T and C, but why does the profiling in anysee.c not handle this case? Obviously the following snippet produces a false positive on warm boot and resume:

This is known problem. Actually it is coming from wrong GPIOs / 
demodulator selection logic. I just guessed those in the time driver was 
made. Now I have also correct info. Unfortunately I don't even have this 
device currently... IIRC you can blacklist zl10353 driver as workaround.

regards
Antti
-- 
http://palosaari.fi/
