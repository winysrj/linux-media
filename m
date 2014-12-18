Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:54923 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752642AbaLROLf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 09:11:35 -0500
Message-ID: <5492E091.1060404@xs4all.nl>
Date: Thu, 18 Dec 2014 15:11:29 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Florian Echtler <floe@butterbrot.org>,
	linux-input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: [RFC] [Patch] implement video driver for sur40
References: <5492D7E8.504@butterbrot.org>
In-Reply-To: <5492D7E8.504@butterbrot.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/18/14 14:34, Florian Echtler wrote:
> Hello everyone,
> 
> as promised, I've finally implemented the missing raw video feature for
> the SUR40 touchscreen. Since this is a bit of a weird hybrid device
> (multitouch input as well as video), I'm hoping for comments from both
> communities (linux-input and linux-media). I'm also attaching the full
> source code for the moment (not yet a proper patch submission) so it's
> perhaps easier to get a view of the whole thing.
> 
> There's definitely some obvious cleanup still to be done (e.g. endpoint
> selection), but I'd like to ask for feedback early so I can get most
> issues fixed before really submitting a patch.
> 
> Thanks & best regards, Florian
> 

One thing you should do is to run the v4l2-compliance utility. Available
here: http://git.linuxtv.org/cgit.cgi/v4l-utils.git/

Compile from the git repo to ensure you have the latest version.

Run as 'v4l2-compliance -s' (-s starts streaming tests as well and it
assumes you have a valid input signal).

The driver shouldn't give any failures. When you post the actual patch,
then make sure you also paste in the output of 'v4l2-compliance -s' as
I'd like to see what it says.

Mail if you have any questions about the v4l2-compliance output. The failure
messages expect you to look at the v4l2-compliance source code as well,
but even than it is not always clear what is going on.

Regards,

	Hans
