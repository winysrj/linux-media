Return-path: <mchehab@pedra>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1079 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab1AZJrv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jan 2011 04:47:51 -0500
Message-ID: <613f734c5a59a342c587769455e939af.squirrel@webmail.xs4all.nl>
In-Reply-To: <4D3FE453.6080307@redhat.com>
References: <4D3FDAAC.2020303@redhat.com> <4D3FE453.6080307@redhat.com>
Date: Wed, 26 Jan 2011 10:47:38 +0100
Subject: Re: What to do with videodev.h
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
Cc: "Hans de Goede" <hdegoede@redhat.com>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> Hi Hans,
>
> Em 26-01-2011 06:26, Hans de Goede escreveu:
>> Hi All,
>>
>> With v4l1 support going completely away, the question is
>> raised what to do with linux/videodev.h .
>>
>> Since v4l1 apps can still use the old API through libv4l1,
>> these apps will still need linux/videodev.h to compile.
>>
>> So I see 3 options:
>> 1) Keep videodev.h in the kernel tree even after we've dropped
>> the API support at the kernel level (seems like a bad idea to me)
>
> That's a bad idea.
>
>> 2) Copy videodev.h over to v4l-utils as is (under a different name)
>> and modify the #include in libv4l1.h to include it under the
>> new name
>> 3) Copy the (needed) contents of videodev.h over to libv4l1.h
>
> I would do (3). This provides a clearer signal that V4L1-only apps need
> to use libv4l1, or otherwise will stop working.

I agree with this.

> Of course, the better is to remove V4L1 support from those old apps.
> There are a number of applications that support both API's. So, it
> is time to remove V4L1 support from them.

So who is going to do that work? That's the problem...

But ensuring that they no longer compile is a good start :-)

Although most have a private copy of videodev.h as part of their sources.

Regards,

     Hans

>> I'm not sure where I stand wrt 2 versus 3. Comments anyone?
>
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Hans Verkuil - video4linux developer - sponsored by Cisco

