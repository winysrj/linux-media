Return-path: <linux-media-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:53416 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbZBER5d (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Feb 2009 12:57:33 -0500
Message-ID: <498B27DB.9000808@zytor.com>
Date: Thu, 05 Feb 2009 09:54:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>, mingo@elte.hu,
	x86@kernel.org, sam@ravnborg.org, jirislaby@gmail.com,
	gregkh@suse.de, davem@davemloft.net, xyzzy@speakeasy.org,
	mchehab@infradead.org, jens.axboe@oracle.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] Make exported headers use strict posix types
References: <20090204064307.GA18415@gondor.apana.org.au> <200902051530.25897.arnd@arndb.de> <498B0315.5080804@zytor.com> <200902051707.55457.arnd@arndb.de>
In-Reply-To: <200902051707.55457.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Arnd Bergmann wrote:
> A number of standard posix types are used in exported headers, which
> is not allowed if __STRICT_KERNEL_NAMES is defined. Change them all
> to use the safe __kernel variant so that we can make __STRICT_KERNEL_NAMES
> the default.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> ---
> On Thursday 05 February 2009, H. Peter Anvin wrote:
> 
>> I have been advocating for hacking headers_install for a while.  That
>> takes care of the 106.  The 15 *need* to be audited immediately, because
>> that is even likely to be actual manifest bugs.
> 
> This is what I found, please review.
> 

Indeed a lot of these look like real bugs, e.g. the use of off_t (which 
may be 32 bits in userspace while __kernel_off_t is 64 bits.)

So these are, indeed, critical bug fixes and should go into 2.6.29.

Some of these changes may require changes in userspace code if userspace 
has hacked around the problems.  Those changes, though, really should 
happen, too.

	-hpa
