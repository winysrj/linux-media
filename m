Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33394 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaIEFa1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Sep 2014 01:30:27 -0400
Received: by mail-pa0-f41.google.com with SMTP id lj1so21906280pab.0
        for <linux-media@vger.kernel.org>; Thu, 04 Sep 2014 22:30:26 -0700 (PDT)
Message-ID: <54094A6C.6050203@gmail.com>
Date: Fri, 05 Sep 2014 14:30:20 +0900
From: Daniel Jeong <gshark.jeong@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [PATCH 28/46] [media] lm3560: simplify boolean tests
References: <cover.1409775488.git.m.chehab@samsung.com> <4e97984ba765f3811f32615b388e698e699b34af.1409775488.git.m.chehab@samsung.com> <20140904070852.GK30024@valkosipuli.retiisi.org.uk>
In-Reply-To: <20140904070852.GK30024@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.

> On Wed, Sep 03, 2014 at 05:33:00PM -0300, Mauro Carvalho Chehab wrote:
>> Instead of using if (on == true), just use
>> if (on).
>>
>> That allows a faster mental parsing when analyzing the
>> code.
>>
>> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>
I will keep it in my mind for my next patch files.

Thank you.

Acked-by: Daniel Jeong <gshark.jeong@gmail.com>

