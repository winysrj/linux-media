Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:43487 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276Ab3FZIAs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jun 2013 04:00:48 -0400
Message-ID: <1372233640.24799.52.camel@smile>
Subject: Re: [patch] [media] staging: lirc: clean error handling in probe()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	YAMANE Toshiaki <yamanetoshi@gmail.com>,
	linux-media@vger.kernel.org
Date: Wed, 26 Jun 2013 11:00:40 +0300
In-Reply-To: <20130626075358.GC1895@elgon.mountain>
References: <20130626075358.GC1895@elgon.mountain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2013-06-26 at 10:53 +0300, Dan Carpenter wrote: 
> I have reorganized the error handling into a simpler and more canonical
> format.

Since you reorganize error handling, might be worth to convert it to
devm_*? 

If you want I could do the patch.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
