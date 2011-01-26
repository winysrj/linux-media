Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:56840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab1AZJHd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jan 2011 04:07:33 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0Q97X2Y002105
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 26 Jan 2011 04:07:33 -0500
Message-ID: <4D3FE453.6080307@redhat.com>
Date: Wed, 26 Jan 2011 07:07:31 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: What to do with videodev.h
References: <4D3FDAAC.2020303@redhat.com>
In-Reply-To: <4D3FDAAC.2020303@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

Em 26-01-2011 06:26, Hans de Goede escreveu:
> Hi All,
> 
> With v4l1 support going completely away, the question is
> raised what to do with linux/videodev.h .
> 
> Since v4l1 apps can still use the old API through libv4l1,
> these apps will still need linux/videodev.h to compile.
> 
> So I see 3 options:
> 1) Keep videodev.h in the kernel tree even after we've dropped
> the API support at the kernel level (seems like a bad idea to me)

That's a bad idea.

> 2) Copy videodev.h over to v4l-utils as is (under a different name)
> and modify the #include in libv4l1.h to include it under the
> new name
> 3) Copy the (needed) contents of videodev.h over to libv4l1.h

I would do (3). This provides a clearer signal that V4L1-only apps need
to use libv4l1, or otherwise will stop working.

Of course, the better is to remove V4L1 support from those old apps.
There are a number of applications that support both API's. So, it
is time to remove V4L1 support from them.

> I'm not sure where I stand wrt 2 versus 3. Comments anyone?

Cheers,
Mauro
