Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:50109 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498AbZCBWeR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2009 17:34:17 -0500
Date: Mon, 2 Mar 2009 16:46:28 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
Subject: Re: Results of the 'dropping support for kernels <2.6.22' poll
In-Reply-To: <200903022218.24259.hverkuil@xs4all.nl>
Message-ID: <alpine.LNX.2.00.0903021610280.16643@banach.math.auburn.edu>
References: <200903022218.24259.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 2 Mar 2009, Hans Verkuil wrote:

<snip>
> [...] The one argument I've seen that I thought had merit
> was with regards to netbooks, and the Asus eeePC in particular. Apparently
> that distro uses 2.6.21 and whether that will be upgraded to a newer kernel
> in the future is dubious.
>
> But in the end it is really the same story: where do you put the line? If
> the eeePC will never receive an update, does that mean we have to keep
> maintaining support for 2.6.21 for many years to come? That's ridiculous
> IMHO.

Hans,

Just one comment. IIRC, I was the one who mentioned the eeePC, having 
recently bought one. I mentioned it, not because I disagree with anything 
else you write here, but because, in fact, I agree. Frankly, I think the 
use of the 2.6.21 kernel in the eeePC is somewhat perverse and just a 
little bit weird.

Essentially, the eeePC and the other Intel-based netbooks are not some 
kind of exotic hardware platforms, which might provide an explanation or 
excuse for using some "specially crafted" but old kernel. No. In fact, the 
eeePC and almost all the other current netbooks are just a new (and 
attractive) combination of some fairly standard types of hardware. 
Practically every hardware component in them is better supported in more 
recent kernels, with the possible exception of a wireless device which may 
not yet be supported in any kernel, new or old. Therefore, instead of 
worrying about whether to support and provide indulgence for apparently 
inexplicable behavior, let us hope that a decision of this nature will 
serve as a needed message.

Theodore Kilgore
