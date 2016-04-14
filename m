Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:32780 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbcDNWSU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Apr 2016 18:18:20 -0400
Reply-To: shuah.kh@samsung.com
Subject: Re: [PATCH] media: saa7134 fix media_dev alloc error path to not free
 when alloc fails
References: <1460651480-6935-1-git-send-email-shuahkh@osg.samsung.com>
 <20160414180858.43c8620b@recife.lan>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
Cc: nenggun.kim@samsung.com, akpm@linux-foundation.org,
	jh1009.sung@samsung.com, inki.dae@samsung.com, arnd@arndb.de,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Shuah Khan <shuah.kh@samsung.com>
Message-ID: <57101729.1030909@samsung.com>
Date: Thu, 14 Apr 2016 16:18:17 -0600
MIME-Version: 1.0
In-Reply-To: <20160414180858.43c8620b@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/14/2016 03:08 PM, Mauro Carvalho Chehab wrote:
> Em Thu, 14 Apr 2016 10:31:20 -0600
> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> 
>> media_dev alloc error path does kfree when alloc fails. Fix it to not call
>> kfree when media_dev alloc fails.
> 
> No need. kfree(NULL) is OK.

Agreed.

> 
> Adding a label inside a conditional block is ugly.

In this case, if label is in normal path, we will see defined, but not
used warnings when condition isn't defined. We seem to have many such
cases for CONFIG_MEDIA_CONTROLLER :(

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 217-8978
