Return-path: <linux-media-owner@vger.kernel.org>
Received: from as-10.de ([212.112.241.2]:34396 "EHLO mail.as-10.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbZFSLtg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 07:49:36 -0400
Date: Fri, 19 Jun 2009 13:49:37 +0200
From: Halim Sahin <halim.sahin@t-online.de>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: ok more details: Re: bttv problem loading takes about several
	minutes
Message-ID: <20090619114937.GA4493@halim.local>
References: <28237.62.70.2.252.1245331454.squirrel@webmail.xs4all.nl> <20090618140129.GA13370@halim.local> <1245352904.3924.3.camel@pc07.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245352904.3924.3.camel@pc07.localdom.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
Ok I have tested 
modprobe bttv audiodev=-1 card=34 tuner=24 gbuffers=16

I am seeing again the delay.
More ideas?
Regards
Halim


-- 
Halim Sahin
E-Mail:				
halim.sahin (at) t-online.de
