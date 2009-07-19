Return-path: <linux-media-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:64567 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbZGSTbJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 15:31:09 -0400
Date: Sun, 19 Jul 2009 12:31:04 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Jean Delvare <khali@linux-fr.org>, Andy Walls <awalls@radix.net>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Mike Isely <isely@pobox.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Janne Grunau <j@jannau.net>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] ir-kbd-i2c: Allow use of ir-kdb-i2c internal
	get_key funcs and set ir_type
Message-ID: <20090719193104.GA17495@dtor-d630.eng.vmware.com>
References: <1247862585.10066.16.camel@palomino.walls.org> <1247862937.10066.21.camel@palomino.walls.org> <20090719144749.689c2b3a@hyperion.delvare> <4A6316F9.4070109@rtr.ca> <20090719145513.0502e0c9@hyperion.delvare> <4A631B41.5090301@rtr.ca> <4A631CEA.4090802@rtr.ca> <4A632FED.1000809@rtr.ca> <20090719190833.29451277@hyperion.delvare> <4A63656D.4070901@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A63656D.4070901@rtr.ca>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jul 19, 2009 at 02:26:53PM -0400, Mark Lord wrote:
> (resending.. somebody trimmed linux-kernel from the CC: earlier)
>
> Jean Delvare wrote:
>> On Sun, 19 Jul 2009 10:38:37 -0400, Mark Lord wrote:
>>> I'm debugging various other b0rked things in 2.6.31 here right now,
>>> so I had a closer look at the Hauppauge I/R remote issue.
>>>
>>> The ir_kbd_i2c driver *does* still find it after all.
>>> But the difference is that the output from 'lsinput' has changed
>>> and no longer says "Hauppauge".  Which prevents the application from
>>> finding the remote control in the same way as before.
>>
>> OK, thanks for the investigation.
>>
>>> I'll hack the application code here now to use the new output,
>>> but I wonder what the the thousands of other users will do when
>>> they first try 2.6.31 after release ?
>>
>> Where does lsinput get the string from?
> ..
>
> Here's a test program for you:
>

And I  think have a fix for that, commit

f936601471d1454dacbd3b2a961fd4d883090aeb

in the for-linus branch of my tree.

-- 
Dmitry
