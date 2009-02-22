Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55296 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551AbZBVMX1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 07:23:27 -0500
Message-ID: <49A1434C.4010008@redhat.com>
Date: Sun, 22 Feb 2009 13:21:32 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Adam Baker <linux@baker-net.org.uk>, linux-media@vger.kernel.org,
	Jean-Francois Moine <moinejf@free.fr>,
	kilgota@banach.math.auburn.edu,
	Olivier Lorin <o.lorin@laposte.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Trent Piepho <xyzzy@speakeasy.org>, linux-omap@vger.kernel.org
Subject: Re: [RFC] How to pass camera Orientation to userspace
References: <200902180030.52729.linux@baker-net.org.uk> <200902211253.58061.hverkuil@xs4all.nl> <49A13466.5080605@redhat.com> <200902221253.29719.hverkuil@xs4all.nl>
In-Reply-To: <200902221253.29719.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Hans Verkuil wrote:
> On Sunday 22 February 2009 12:17:58 Hans de Goede wrote:

<snipped a large part we agree upon (hurray!) >

>> Agreed, but it still is something which should be avoided if possible,
>> implementing polling also means adding a lot of IMHO unneeded code on the
>> userspace side.
>>
>> I would prefer to make the "realtime" pivotting state available to the
>> app by adding flags containing the pivotting state at frame capture to
>> the v4l2_buf flags.
>>
>> But if people dislike this, libv4l can simple poll the input now and
>> then.
> 
> I think this should be prototyped. Compare polling vs. putting the state in 
> the v4l2_buf flags and see if that makes a lot of difference in the user 
> experience compared to polling once a second. If it clearly improves things 
> for the user, then I have no objections to adding bits to v4l2_buf.
> 

This is were the difficulties start, doing this 1 per second requires making 
clock() calls and comparing timestamps (always tricky to get right). We could 
do this once every X frames, but framerates can vary wildly with webcams.

My biggest concern is not the user experience, but the fact that needing to 
poll uglyfies the userspace code. However thinking about this more, I guess we 
could just poll every frame. That makes the polling code simple and should give 
a good user experience.

<snip of more things we agree up on>

Regards,

Hans

