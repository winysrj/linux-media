Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:44336 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbZF3O0R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jun 2009 10:26:17 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: David Brownell <david-b@pacbell.net>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 30 Jun 2009 09:26:09 -0500
Subject: RE: [PATCH 3/3 - v0] davinci: platform changes to support vpfe
 camera capture
Message-ID: <A69FA2915331DC488A831521EAE36FE401448CE3AA@dlee06.ent.ti.com>
References: <1246053948-8371-1-git-send-email-m-karicheri2@ti.com>
 <200906291043.43140.david-b@pacbell.net>
 <A69FA2915331DC488A831521EAE36FE401448CE221@dlee06.ent.ti.com>
 <200906291555.35568.david-b@pacbell.net>
In-Reply-To: <200906291555.35568.david-b@pacbell.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> to the DaVinci tree and then creating new patches based on
>> that. That is why my note clearly says " Depends on v3 version
>> of vpfe capture driver patch"
>
>Maybe you're not getting my point:  that submitting a patch
>series against mainline (or almost-mainline) means you don't
>trip across goofs like the one I first noted.  That one was
>pretty obvious.  The more subtle problems are harder to see...
>
>In this case, your patch ignored a driver that's been in GIT
>since December.  Which means that you're developing against
>a code base that's ... pretty old, not nearly current enough.
>
Excuse me! Please don't make such unhealthy comments which doesn't
help anyone. How can you say that "you're developing against
a code base that's ... pretty old, not nearly current enough"?

The code that I am developing is most up to date and is written
against the latest tree. The reason that you have written a driver
for msp430 under driver/mfd/ doesn't mean that it will be seen by
everyone. You cannot make this as a reason to blame someone of
developing code against an outdated tree. The reviewers can help
in such cases to point to the driver, as you have done in this case,
but please avoid making such unhealthy remarks such as this one.

This is a forum where developers help each other by reviewing the
code, making suggestions etc., but making remarks like this is
not a good idea.

Murali

>I fully understand that all this video stuff is a large and
>complex chunk of driver code.  That's *ALL THE MORE REASON* to
>be sure you're tracking mainline (or in some cases the DaVinci
>platform code) very closely when you send patches upstream.
>Because all kinds of stuff will have changed between six months
>ago and today.  Standard policy is to develop such merge patches
>with more or less bleeding edge code, so integration issues
>show up (and get resolved) ASAP.
You got to be 
>- Dave
>

