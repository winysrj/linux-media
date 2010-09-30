Return-path: <mchehab@pedra>
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:36985 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751603Ab0I3J4E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Sep 2010 05:56:04 -0400
Message-ID: <4CA45EB0.30002@xyzw.org>
Date: Thu, 30 Sep 2010 02:56:00 -0700
From: Brian Rogers <brian@xyzw.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for 2.6.36] V4L/DVB fixes
References: <4CA10545.4010204@redhat.com> <AANLkTikYyEPAHq5rYzzckExTSFFCAj_DUqAZEvoeU0WD@mail.gmail.com> <4CA13893.8050409@redhat.com>
In-Reply-To: <4CA13893.8050409@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

  On 09/27/2010 05:36 PM, Mauro Carvalho Chehab wrote:
> I'll clean up the mess and prepare a new pull request in the next days.

Can you look at including "ir-core: Fix null dereferences in the 
protocols sysfs interface"? I never got a response to that, and it's a 
regression fix for 2.6.36.

https://patchwork.kernel.org/patch/199002/

