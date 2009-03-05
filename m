Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38806 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbZCEGzC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Mar 2009 01:55:02 -0500
Message-ID: <49AF78AC.3000605@redhat.com>
Date: Thu, 05 Mar 2009 08:01:00 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Kyle Guinn <elyk03@gmail.com>
CC: kilgota@banach.math.auburn.edu,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: RFC on proposed patches to mr97310a.c for gspca and v4l
References: <20090217200928.1ae74819@free.fr> <200903032050.13915.elyk03@gmail.com> <49AE3E2F.70905@redhat.com> <200903041933.29491.elyk03@gmail.com>
In-Reply-To: <200903041933.29491.elyk03@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Kyle Guinn wrote:
> On Wednesday 04 March 2009 02:39:11 Hans de Goede wrote:
>> Which also makes me wonder about the same change for the mr97310a, is that
>> cam already supported in a released kernel ?
>>
>> If not we MUST make sure we get this change in before 2.6.29 final, if it
>> is I'm afraid we cannot make these changes. In that case if we ever need to
>> header data we need to define a new PIXFMT for mr97310a with the header
>> data, and deprecate the old one.
>>
> 
> I don't believe the driver has made it to any kernel yet.  Even if it has, the 
> user would need to have an unreleased version of libv4l.  I think this change 
> would inconvenience me and Theodore at most.  Let's change it now.
> 

+1

Regards,

Hans
