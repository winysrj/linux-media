Return-path: <mchehab@pedra>
Received: from 5571f1ba.dsl.concepts.nl ([85.113.241.186]:53816 "EHLO
	his10.hoogenraad.info" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751150Ab1BIGuJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Feb 2011 01:50:09 -0500
Message-ID: <4D5236E5.8060207@hoogenraad.net>
Date: Wed, 09 Feb 2011 07:40:37 +0100
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: firedtv and removal of old IEEE1394 stack
References: <201102031706.12714.hverkuil@xs4all.nl>	<20110205152122.3b566ef0@stein> <20110205153215.03d55743@stein>
In-Reply-To: <20110205153215.03d55743@stein>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

For a problem description, and workaround, see:

http://linuxtv.org/hg/~jhoogenraad/ubuntu-firedtv/

and

https://bugs.launchpad.net/ubuntu/+source/linux-kernel-headers/+bug/134222


Stefan Richter wrote:
> On Feb 05 Stefan Richter wrote:
>> On Feb 03 Hans Verkuil wrote:
>>> It would be nice to remove this since building the firedtv driver for older kernels
>>> always gives problems on ubuntu due to some missing ieee1394 headers.
>>
>> How so?  Then there is something wrong with the backported sources.
>
> Or with the backports' build system perhaps.


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
