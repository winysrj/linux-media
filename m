Return-path: <linux-media-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:39422 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbZGSUOv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 16:14:51 -0400
Message-ID: <4A637EB9.5040004@rtr.ca>
Date: Sun, 19 Jul 2009 16:14:49 -0400
From: Mark Lord <lkml@rtr.ca>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>, Andy Walls <awalls@radix.net>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Mike Isely <isely@pobox.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Janne Grunau <j@jannau.net>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-input@vger.kernel.org
Subject: Re: Regression 2.6.31:  ioctl(EVIOCGNAME) no longer returns device
 name
References: <1247862937.10066.21.camel@palomino.walls.org> <20090719144749.689c2b3a@hyperion.delvare> <4A6316F9.4070109@rtr.ca> <20090719145513.0502e0c9@hyperion.delvare> <4A631B41.5090301@rtr.ca> <4A631CEA.4090802@rtr.ca> <4A632FED.1000809@rtr.ca> <20090719190833.29451277@hyperion.delvare> <4A63656D.4070901@rtr.ca> <4A637212.2000002@rtr.ca> <20090719193952.GC17495@dtor-d630.eng.vmware.com>
In-Reply-To: <20090719193952.GC17495@dtor-d630.eng.vmware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitry Torokhov wrote:
> On Sun, Jul 19, 2009 at 03:20:50PM -0400, Mark Lord wrote:
>> Mark Lord wrote:
>>> (resending.. somebody trimmed linux-kernel from the CC: earlier)
>>>
>>> Jean Delvare wrote:
>>>> On Sun, 19 Jul 2009 10:38:37 -0400, Mark Lord wrote:
>>>>> I'm debugging various other b0rked things in 2.6.31 here right now,
>>>>> so I had a closer look at the Hauppauge I/R remote issue.
>>>>>
>>>>> The ir_kbd_i2c driver *does* still find it after all.
>>>>> But the difference is that the output from 'lsinput' has changed
>>>>> and no longer says "Hauppauge".  Which prevents the application from
>>>>> finding the remote control in the same way as before.
>>>> OK, thanks for the investigation.
>>>>
>>>>> I'll hack the application code here now to use the new output,
>>>>> but I wonder what the the thousands of other users will do when
>>>>> they first try 2.6.31 after release ?
>> ..
>>
>> Mmm.. appears to be a systemwide thing, not just for the i2c stuff.
>> *All* of the input devices now no longer show their real names
>> when queried with ioctl(EVIOCGNAME).  This is a regression from 2.6.30.
>> Note that the real names *are* still stored somewhere, because they
>> do still show up correctly under /sys/
>>
> 
> Should be fixed by f936601471d1454dacbd3b2a961fd4d883090aeb in the
> for-linus branch of my tree.
..

Peachy.  Push it, or post it here and I can re-test with it.

(does anyone else find it spooky that a google search for the
 above commit id actually finds Dmitry's email quoted above ?
 Mere seconds after he posted it for the very first time ??)
