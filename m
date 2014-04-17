Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:52616 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaDQX1L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 19:27:11 -0400
Message-id: <5350634A.2030608@samsung.com>
Date: Thu, 17 Apr 2014 17:27:06 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
MIME-version: 1.0
To: Tejun Heo <tj@kernel.org>
Cc: gregkh@linuxfoundation.org, m.chehab@samsung.com,
	rafael.j.wysocki@intel.com, linux@roeck-us.net, toshi.kani@hp.com,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	shuahkhan@gmail.com, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [RFC PATCH 2/2] drivers/base: add managed token devres interfaces
References: <cover.1397050852.git.shuah.kh@samsung.com>
 <5f21c7e53811aba63f86bcf3e3bfdfdd5aeedf59.1397050852.git.shuah.kh@samsung.com>
 <20140416215821.GG26632@htj.dyndns.org> <5350331C.7010602@samsung.com>
 <20140417201034.GT15326@htj.dyndns.org> <20140417202221.GU15326@htj.dyndns.org>
In-reply-to: <20140417202221.GU15326@htj.dyndns.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/17/2014 02:22 PM, Tejun Heo wrote:
> On Thu, Apr 17, 2014 at 04:10:34PM -0400, Tejun Heo wrote:
Please do not implement locking
> primitive directly if at all avoidable.  Why can't it use a mutex
> embedded in the data area of a devres entry?  And if you for some
> reason have to implement it directly, at least add lockdep
> annotations.
>

Thanks. This is helpful. Yes it does simplify the code with mutex
embedded in the devres data area. I am working on a v2 patch with
that change.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
