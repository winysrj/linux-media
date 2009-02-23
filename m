Return-path: <linux-media-owner@vger.kernel.org>
Received: from ayden.softclick-it.de ([217.160.202.102]:33406 "EHLO
	ayden.softclick-it.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbZBWPa2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 10:30:28 -0500
Message-ID: <49A2C0C2.4030703@to-st.de>
Date: Mon, 23 Feb 2009 16:29:06 +0100
From: Tobias Stoeber <tobi@to-st.de>
Reply-To: tobi@to-st.de
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Question regarding detail in dropping support for kernels < 2.6.22
 (related to Re: POLL: for/against dropping support for kernels < 2.6.22)
References: <48380.62.70.2.252.1235398197.squirrel@webmail.xs4all.nl>
In-Reply-To: <48380.62.70.2.252.1235398197.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

Hans Verkuil schrieb:
> We still need to support kernels from 2.6.22 onwards. Although I think the
> minimum supported kernel is something that needs a regular sanity check,
> right now there are no technical reasons that I am aware of to go to
> something newer than 2.6.22.
> 
> Whether we keep our current system or not is a separate discussion:
> whatever development system you choose there will be work involved in
> keeping up the backwards compatibility.

Just out of deep interesst:

Could you, Hans (or anyone else) just explain, what is / are the reason 
to draw the line between kernels 2.6.21 and 2.6.22?

What was the fundamental change there and do these changes as such apply 
to every supported device / driver?

As I understand you, although you drop backport efforts for kernels 
below 2.6.22, you are going to adopt an policy to - in a sense - waste 
development efforts / time on seven instead of 12 kernels?

Wouldn't it then not be more logical to support only the recent kernel 
and the kernel before, becaus in some month time 2.6.30 might include a 
major change which would force you to drop support for < 2.6.29 altogether?

Thanks for your patience and reply,

best regards, Tobias

