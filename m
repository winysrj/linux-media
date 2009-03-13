Return-path: <linux-media-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:47421 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751394AbZCMDdx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 23:33:53 -0400
Date: Thu, 12 Mar 2009 20:05:10 -0700
From: Greg KH <greg@kroah.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Michael Krufky <mkrufky@linuxtv.org>, stable@kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [stable] Fwd: [PATCH] 2.6.27.y: fix NULL ptr deref in cx23885
	video_open
Message-ID: <20090313030510.GA5543@kroah.com>
References: <200902241700.56099.jarod@redhat.com> <37219a840903121324q7b08c8d1ma6d0d3ec4f5eb278@mail.gmail.com> <20090313025051.GA5385@kroah.com> <49B9CC3B.4060300@wilsonet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B9CC3B.4060300@wilsonet.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 12, 2009 at 11:00:11PM -0400, Jarod Wilson wrote:
> Greg KH wrote:
>> On Thu, Mar 12, 2009 at 04:24:38PM -0400, Michael Krufky wrote:
>>> Can we have this merged into -stable?  Jarod Wilson sent this last
>>> month, but he left off the cc to stable@kernel.org
>> What is the git commit id of the patch in Linus's tree that matches up
>> with this?
>> thanks,
>> greg k-h
>
>
> Now that I look closer, seems there's an even more complete patch already 
> in linus' tree, commit id:
>
> cd8f894eacf13996d920fdd2aef1afc55156b191
>
> Shoulda just forwarded that along, but I was under the impression that area 
> of code had changed significantly in 2.6.28 and the patch was no longer 
> applicable. Maybe that was the v4l/dvb hg tree though... So I'd just grab 
> that, and add:
>
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

Ok, will do that.

thanks,

greg k-h
