Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab2ETPSY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 May 2012 11:18:24 -0400
Message-ID: <4FB90B2A.709@redhat.com>
Date: Sun, 20 May 2012 12:18:02 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Daniel Drake <dsd@laptop.org>
CC: Jonathan Corbet <corbet@lwn.net>, mchehab@infradead.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] mmp-camera: specify XO-1.75 clock speed
References: <20120515194331.77C519D401E@zog.reactivated.net> <20120516151253.24d12245@lwn.net> <CAMLZHHTb+wgRiefVrA2rq0GCUPiBj4jm=kU2QGq1JGq+=6yCuA@mail.gmail.com>
In-Reply-To: <CAMLZHHTb+wgRiefVrA2rq0GCUPiBj4jm=kU2QGq1JGq+=6yCuA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 16-05-2012 18:15, Daniel Drake escreveu:
> On Wed, May 16, 2012 at 3:12 PM, Jonathan Corbet <corbet@lwn.net> wrote:
>> On Tue, 15 May 2012 20:43:31 +0100 (BST)
>> Daniel Drake <dsd@laptop.org> wrote:
>>
>>> Jon, is it OK to assume that XO-1.75 is the only mmp-camera user?
>>
>> It's the only one I know of at the moment, certainly.
>>
>> Even so, I think it would be a lot better to put this parameter into the
>> mmp_camera_platform_data structure instead of wiring it into the driver
>> source; it could then be set in olpc-xo-1-75.c with the other relevant
>> parameters.  I won't oppose the inclusion of this patch, but...any chance
>> it could be done that way?
> 
> I'll look into it. Please put this patch on pause for now.

I've marked this patch as "changes requested" at patchwork:
	http://patchwork.linuxtv.org/patch/11270/

I agree with Jon: adding such config stuff at platform data is better.

Regards,
Mauro
