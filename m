Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62639 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1AGOCk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 09:02:40 -0500
Date: Fri, 7 Jan 2011 17:02:34 +0300
From: Vasiliy Kulikov <segooon@gmail.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Andreas Oberritter <obi@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] av7110: make array offset unsigned
Message-ID: <20110107140234.GA8107@albatros>
References: <20110106194059.GC1717@bicker>
 <4D270A9F.7080104@linuxtv.org>
 <20110107135122.GI1717@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107135122.GI1717@bicker>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Jan 07, 2011 at 16:51 +0300, Dan Carpenter wrote:
> But just for my own understanding, why is it wrong to change an int to
> an unsigned int in the userspace API?  Who would notice?

E.g. the same check in userspace (var < 0).  If var has changed the sign
then the result would differ.

-- 
Vasiliy
