Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:59293
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbZCMDIM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 23:08:12 -0400
Message-ID: <49B9CC3B.4060300@wilsonet.com>
Date: Thu, 12 Mar 2009 23:00:11 -0400
From: Jarod Wilson <jarod@wilsonet.com>
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Michael Krufky <mkrufky@linuxtv.org>, stable@kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [stable] Fwd: [PATCH] 2.6.27.y: fix NULL ptr deref in cx23885
 video_open
References: <200902241700.56099.jarod@redhat.com> <37219a840903121324q7b08c8d1ma6d0d3ec4f5eb278@mail.gmail.com> <20090313025051.GA5385@kroah.com>
In-Reply-To: <20090313025051.GA5385@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greg KH wrote:
> On Thu, Mar 12, 2009 at 04:24:38PM -0400, Michael Krufky wrote:
>> Can we have this merged into -stable?  Jarod Wilson sent this last
>> month, but he left off the cc to stable@kernel.org
> 
> What is the git commit id of the patch in Linus's tree that matches up
> with this?
> 
> thanks,
> 
> greg k-h


Now that I look closer, seems there's an even more complete patch 
already in linus' tree, commit id:

cd8f894eacf13996d920fdd2aef1afc55156b191

Shoulda just forwarded that along, but I was under the impression that 
area of code had changed significantly in 2.6.28 and the patch was no 
longer applicable. Maybe that was the v4l/dvb hg tree though... So I'd 
just grab that, and add:

Signed-off-by: Jarod Wilson <jarod@redhat.com>


--jarod
