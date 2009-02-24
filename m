Return-path: <linux-media-owner@vger.kernel.org>
Received: from fortimail.matc.edu ([148.8.129.21]:33447 "EHLO matc.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751066AbZBXVRR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 16:17:17 -0500
Received: from GWISE1.matc.edu (gwise1.matc.edu [148.8.29.22])
	by Fortimail2000-2.fortimail.matc.edu  with ESMTP id n1OKhqGH004550
	for <linux-media@vger.kernel.org>; Tue, 24 Feb 2009 14:43:52 -0600
Message-Id: <49A407B0.8C56.0056.0@matc.edu>
Date: Tue, 24 Feb 2009 14:43:43 -0600
From: "Jonathan Johnson" <johnsonn@matc.edu>
To: <linux-media@vger.kernel.org>, "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
References: <200902221115.01464.hverkuil@xs4all.nl>
 <200902242119.17436.hverkuil@xs4all.nl>
In-Reply-To: <200902242119.17436.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

My vote is YES, why haven't we done this already??

My understanding is that we are just drop old kernel support and retaining the vast majority of the drivers.
If anyone tallied the total number CVE listed vulernabilites and other problems fixed since then they would probably be shocked.
Unless for some reason your hardware is so old that it does support 2.6.28.7, this is the version you should run.

Later,
Jonathan

>>> Hans Verkuil <hverkuil@xs4all.nl> 2/24/2009 2:19 PM >>>
Please reply to this poll if you haven't done so yet. I only count clear 
yes/no answers, so if you replied earlier to this in order to discuss a 
point then I haven't counted that.

Currently it's 16 yes and 2 no votes, but I'd really like to see some more 
input. I want to post the final results on Sunday.

Regards,

	Hans

On Sunday 22 February 2009 11:15:01 you wrote:
> Hi all,
>
> There are lot's of discussions, but it can be hard sometimes to actually
> determine someone's opinion.
>
> So here is a quick poll, please reply either to the list or directly to
> me with your yes/no answer and (optional but welcome) a short explanation
> to your standpoint. It doesn't matter if you are a user or developer, I'd
> like to see your opinion regardless.
>
> Please DO NOT reply to the replies, I'll summarize the results in a
> week's time and then we can discuss it further.
>
> Should we drop support for kernels <2.6.22 in our v4l-dvb repository?
>
> _: Yes
> _: No
>
> Optional question:
>
> Why:
>
>
>
> Thanks,
>
> 	Hans



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org 
More majordomo info at  http://vger.kernel.org/majordomo-info.html

