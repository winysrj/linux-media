Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:57982 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbZJXTje (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Oct 2009 15:39:34 -0400
Message-ID: <4AE357F6.7030600@googlemail.com>
Date: Sat, 24 Oct 2009 21:39:34 +0200
From: Gonsolo <gonsolo@gmail.com>
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Gonsolo <gonsolo@gmail.com>, mchehab@infradead.org,
	pboettcher@dibcom.fr, linux-media@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: DVB-T dib0700 one minute hang when resuming
References: <4AE32EF2.2040508@googlemail.com> <200910242014.18785.oliver@neukum.org>
In-Reply-To: <200910242014.18785.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 24.10.2009 20:14, schrieb Oliver Neukum:
> Am Samstag, 24. Oktober 2009 18:44:34 schrieb Gonsolo:
>> Hi!
>>
>> The following script fixes an annoying 62 second hang when resuming
>> while my Nova-T stick is connected to my notebook.
>>
> Do you have any idea why it doesn't find its firmware?

Don't know. Maybe it's because it is not included in initrd or user 
space is still not available when resuming. In the first case it is a 
Ubuntu Kernel bug, in the second case the driver has to be fixed by 
using request_firmware_nowait. But please notice that I am absolutely 
not qualified to answer this question. I was hoping to get an answer on 
that issue since this is the last annoying bug that keeps my 
Ubuntu/Debian/Gnome/GNU/Linux distribution from being perfect. :)

g

