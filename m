Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:63794 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750839AbdIWOoA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Sep 2017 10:44:00 -0400
Subject: Re: [GIT PULL FOR v4.15] Cleanup fixes
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <7f18a823-3827-5a9c-053d-61f113a2d36f@xs4all.nl>
 <20170923093802.34b31c98@vento.lan>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <b33aac55-6749-3dc9-1258-c6518b05a94e@users.sourceforge.net>
Date: Sat, 23 Sep 2017 16:43:53 +0200
MIME-Version: 1.0
In-Reply-To: <20170923093802.34b31c98@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> coccinelle, checkpatch, coverity, etc.
…
> It **really** doesn't makes any sense to send patch bombs like that!

I got an other impression for this software development aspect.


> That pisses me off, as it requires a considerable amount of time from
> my side that could be used handling important stuff...

I can partly understand this view.


> You're even doing the same logical change on the same driver several times,
> like this one:
> 	atmel-isc: Delete an error message for a failed memory allocation in isc_formats_init()
> 	atmel-isi: Delete an error message for a failed memory allocation in two functions

Such a change approach can occasionally occur because of my selection
for a specific patch granularity.


> Please, never do this again.

I guess that it will happen more because there are so many results
to consider from source code analysis.


> Instead, group patches that do the same thing per subsystem.

I was also uncertain about the acceptance for the suggested
change patterns.


> This time, I was nice and I took some time doing:
> 
> 	$ quilt fold < `quilt next` && quilt delete `quilt next`
> 
> In order to merge the same logic change altogether, applied to all
> drivers at the subsystem.

Thanks for your constructive information.


> Next time, I'll just ignore the hole crap.

Do you want a “development pause” from my queue of change possibilities?

Regards,
Markus
