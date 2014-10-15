Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:40732 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbaJOPMz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Oct 2014 11:12:55 -0400
Message-ID: <543E8EEE.7080404@osg.samsung.com>
Date: Wed, 15 Oct 2014 09:12:46 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Shuah Khan <shuah.kh@samsung.com>
CC: Fabian Frederick <fabf@skynet.be>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] xc5000: use after free in release()
References: <20140925114008.GC3708@mwanda> <20141015134008.GO26918@mwanda>
In-Reply-To: <20141015134008.GO26918@mwanda>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/15/2014 07:40 AM, Dan Carpenter wrote:
> On Thu, Sep 25, 2014 at 02:40:08PM +0300, Dan Carpenter wrote:
>> I moved the call to hybrid_tuner_release_state(priv) after
>> "priv->firmware" dereference.
>>
>> Fixes: 5264a522a597 ('[media] media: tuner xc5000 - release firmwware from xc5000_release()')
> 
> We still need this patch.
> 

I didn't see it in media pull request for 3.18. Mauro probably
has this on his list for next round.

-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
