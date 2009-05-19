Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110808.mail.gq1.yahoo.com ([67.195.13.231]:23204 "HELO
	web110808.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752392AbZESUKK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 16:10:10 -0400
Message-ID: <492881.32224.qm@web110808.mail.gq1.yahoo.com>
Date: Tue, 19 May 2009 13:10:11 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: Re: Recent Siano patches - testing required
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Steven Toth <stoth@kernellabs.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>




--- On Tue, 5/19/09, Steven Toth <stoth@kernellabs.com> wrote:

> From: Steven Toth <stoth@kernellabs.com>
> Subject: Recent Siano patches - testing required
> To: urishk@yahoo.com, "Mauro Carvalho Chehab" <mchehab@infradead.org>
> Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
> Date: Tuesday, May 19, 2009, 10:15 PM
> Mauro please review.
> 
> Uri,
> 
> Firstly I'd like to thank you and Siano for patching and
> helping to maintain the driver. :)
> 
> Second, this is a heck of a lot of change for the list to
> review! It's impossible to digest the level of rework and
> potential regressions.
> 
> I'd suggest you either host your own mercurial server and
> have testers pull your trees, helping to regression test
> your changes or ... someone gives you access to create trees
> at LinuxTV.org, then you can solicit testers feedback on the
> mailing list.
> 
> Either way, it's unusual for this amount of change to be
> merged without having some positive feedback from the Linux
> community of testers. If you have confirmation that all of
> the current devices are still working correct, without
> regression, then please indicate this in your patches /
> email.
> 
> If not, the patches should be hosted somewhere for test and
> review.
> 
> -- Steven Toth - Kernel Labs
> http://www.kernellabs.com
> 


Steven,

Thanks for your comments.

Brief history about Siano's Linux kernel drivers...

First set of Siano's based receivers drivers has been introduced at the first half of 2008.

Since mid-2008 till about little more than a month ago, from various reasons, (most of these reasons were unrelated to Siano's intentions), there were no submissions to the LinuxTV mercurial.

However, lots of progress with Linux drivers has been achieved. Some of it within the Linux various communities (for example with the MMC maintainer, and members of this mailing list based on direct contacts) but primarily with Siano's commercial customers which based their products on Linux OS or it derivatives (such as Google's Android). 

Note that the recent month' patches came to bring the LinuxTV mercurial (and kernel's git as a result) up to the state of Siano's internal Subversion repository. Meaning, the patches are not new code / new bugs fixes etc. but rather up-stream from Siano's repository to LinuxTV's (same as it done from each sub-kernel system (including LinuxTV) to the kernel git).

The Siano's drivers have been tested thoroughly, both in Siano's QA departments (where a full time QA engineer is tasked to test various Linux/SMS based setups) and in customers sites as well.

Note that the current Siano's Linux drivers set is been used by many dozens of commercial products (including tear-1 companies' products), which of course have been tested thoroughly that offering, and it is a production level code (literally).

The risks as I see them with all those patches, are that some work (minor) has been done in order to make these patches appropriate to be submitted (per all rules of patches submission to LinuxTV / Linux kernel). 

Another problem is that I find it hard to believe that there will be many testers available from this mailing list. True that there are some dongle and mini-cards based on Siano's chip-set which these devices' manufacturers representatives are on this list, orsome people may own these, but the vast majority of Siano's based products are embedded based devices (including multiple tablet/UMPC PCs, cellular phones, PDAs, navigation devices, DVD/BR players, gaming devices and many others), so unless someone will hack those devices and will replace the installed drivers (kernel image actually, since most of these fixed-targets developers build the Siano's modules to be included within the kernel image) there is no much hope for comprehensive o"open testers" test.

However any test that will be performed, will benefit all (including Siano.... :-)

It's true that is the recent past, Siano equipped some volunteers from this community with devices (free of charge), but it had been done base on Siano's "selfish" objectives, which at the time suited various individuals.
I find it hard to believe that Siano will equip anyone just for "random" testing, since we have enough brimful testing environments.


Best Regards,

Uri

 


      
