Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:46407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860Ab0JLNNF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Oct 2010 09:13:05 -0400
Date: Tue, 12 Oct 2010 09:12:57 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch -next] V4L/DVB: IR/streamzap: fix usec to nsec conversion
Message-ID: <20101012131257.GB4057@redhat.com>
References: <20101012060110.GA13176@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101012060110.GA13176@bicker>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Oct 12, 2010 at 08:01:11AM +0200, Dan Carpenter wrote:
> There is an integer overflow here because 0x03000000 * 1000 is too large
> for 31 bits.
> 
> rawir.duration should be in terms of nsecs.
> IR_MAX_DURATION and 0x03000000 are already in terms of nsecs.
> STREAMZAP_TIMEOUT and STREAMZAP_RESOLUTION are 255 and 256 respectively
> and are in terms of usecs.
> 
> The original code had a deadline of 1.005 seconds and the new code has a
> deadline of .065 seconds. 
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Nice catch, fix looks good.

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com

