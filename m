Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:45436 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757478AbZCDSee (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 13:34:34 -0500
Date: Wed, 4 Mar 2009 12:46:36 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Hans de Goede <hdegoede@redhat.com>
cc: Kyle Guinn <elyk03@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: RFC on proposed patches to mr97310a.c for gspca and v4l
In-Reply-To: <49AE3E2F.70905@redhat.com>
Message-ID: <alpine.LNX.2.00.0903041243240.22500@banach.math.auburn.edu>
References: <20090217200928.1ae74819@free.fr> <200902171907.40054.elyk03@gmail.com> <alpine.LNX.2.00.0903031746030.21483@banach.math.auburn.edu> <200903032050.13915.elyk03@gmail.com> <49AE3E2F.70905@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Wed, 4 Mar 2009, Hans de Goede wrote:

>
>
> Kyle Guinn wrote:
>> On Tuesday 03 March 2009 18:12:33 kilgota@banach.math.auburn.edu wrote:
>
> <snip>
>
>> Just a random thought, but maybe the pac207 driver can benefit from such a 
>> change as well?
>
> It could, but it is to late for that, the pac207 driver and corresponding 
> libv4l
> functionality has been out there for 2 kernel releases now, so we cannot 
> change that.

Pretty much what I said. It would have been better so, but done is done.

>
> Which also makes me wonder about the same change for the mr97310a, is that 
> cam already
> supported in a released kernel ?

Someone else may know better than I do, but since it was only added quite 
recently, surely not?

>
> If not we MUST make sure we get this change in before 2.6.29 final, if it is 
> I'm afraid
> we cannot make these changes. In that case if we ever need to header data we 
> need to
> define a new PIXFMT for mr97310a with the header data, and deprecate the old 
> one.

I do not quite understand. Why not just do it right away. especially if 
this has not appeared yet in any kernel?

Theodore Kilgore
