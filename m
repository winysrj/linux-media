Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:55359 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab1AHRu6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 12:50:58 -0500
Received: by qyj19 with SMTP id 19so410971qyj.19
        for <linux-media@vger.kernel.org>; Sat, 08 Jan 2011 09:50:57 -0800 (PST)
Subject: Re: difference mchehab/new_build.git  to media_build.git ?
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <201101081847.06814.martin.dauskardt@gmx.de>
Date: Sat, 8 Jan 2011 12:50:54 -0500
Cc: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <FA1BDB57-229C-424E-A109-6887C4C5CFAC@wilsonet.com>
References: <201101081847.06814.martin.dauskardt@gmx.de>
To: Martin Dauskardt <martin.dauskardt@gmx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jan 8, 2011, at 12:47 PM, Martin Dauskardt wrote:

> Since some months I didn't test any new drivers, because I don't  want to run 
> an unstable kernel. The v4l-dvb hg is obviously dead, although I never read a 
> formally announcement. Requests remain unanswered 
> (http://article.gmane.org/gmane.linux.drivers.video-input-
> infrastructure/27069/)
> 
> In the german vdrportal forum we recently "discovered"  
> git://linuxtv.org/mchehab/new_build.git as a possibility to build and test 
> current drivers with the kernels in current Distributions.
> 
> Now I see a discussion about media_built, which seems to be 
> git://linuxtv.org/media_build.git. 
> 
> What is the difference between media_build and new_build?

There's no difference. It started out at mchehab/new_build.git, then got moved
to media_build.git, but there's a symlink in place to keep from breaking things
for people who originally checked it out at the old location.

The move essentially promoted it from "something Mauro's tinkering with" to
"something generally useful for a wider audience". And its also being worked on
by more people than just Mauro now (myself included).

-- 
Jarod Wilson
jarod@wilsonet.com



