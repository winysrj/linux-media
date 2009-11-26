Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbZKZTGV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 14:06:21 -0500
Message-ID: <4B0ED19B.9030409@redhat.com>
Date: Thu, 26 Nov 2009 17:06:03 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Jarod Wilson <jarod@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <200910200956.33391.jarod@redhat.com>	<200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com>	<4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain>	<4B0AB60B.2030006@s5r6.in-berlin.de> <4B0AC8C9.6080504@redhat.com>	<m34oolrnwd.fsf@intrepid.localdomain> <4B0E71B6.4080808@redhat.com> <m3my29up3y.fsf@intrepid.localdomain>
In-Reply-To: <m3my29up3y.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Krzysztof Halasa wrote:
> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
> 
>> Technically, it is not hard to port this solution to the other
>> drivers, but the issue is that we don't have all those IR's to know
>> what is the complete scancode that each key produces. So, the hardest
>> part is to find a way for doing it without causing regressions, and to
>> find a group of people that will help testing the new way.
> 
> We don't want to "port it" to other drivers. We need to have a common
> module which does all RCx decoding. The individual drivers should be as
> simple as possible, something that I outlined in a previous mail.

With the current 7bits mask applied to almost all devices, it is probably not very
useful for those who want to use generic IRs. We really need to port the solution
we've done on dvb-usb to the other drivers, allowing them to have the entire
scancode at the tables while keep supporting table replacement. 

The issue is that we currently have only 7bits of the scan codes produced by the IR's.
So, we need to re-generate the keycode tables for each IR after the changes got applied.

With respect to a common module, unfortunately most of the work should be done on
each driver, since the code that communicates with the hardware is specific to each
device. There is a common code (at ir-common.ko) with helper decoding routines.

Please feel free to send us contributions to improve the current code.

Cheers,
Mauro.
