Return-path: <linux-media-owner@vger.kernel.org>
Received: from void.printf.net ([89.145.121.20]:40646 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756444Ab2DZUOb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Apr 2012 16:14:31 -0400
From: Chris Ball <cjb@laptop.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] marvell-cam: Build fix: mcam->platform assignment
In-Reply-To: <20120426140824.446c8b0b@lwn.net> (Jonathan Corbet's message of
	"Thu, 26 Apr 2012 14:08:24 -0600")
References: <87ehra9s02.fsf@laptop.org> <20120426140824.446c8b0b@lwn.net>
Date: Thu, 26 Apr 2012 16:14:52 -0400
Message-ID: <87397q9rnn.fsf@laptop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Thu, Apr 26 2012, Jonathan Corbet wrote:
> On Thu, 26 Apr 2012 16:07:25 -0400
> Chris Ball <cjb@laptop.org> wrote:
>
>> It seems that this driver has never been buildable upstream, because it
>> was merged with this line included:
>> 
>>        mcam->platform = MHP_Armada610;
>
> Yes, that was from a badly cherry-picked change a while back.  I sent in a
> fix (the same as yours) about a week ago :)

So you did!  Ignore this patch, then -- sorry for the noise.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
