Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:58132 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932936AbeFUXgZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 19:36:25 -0400
Subject: Re: [ANN] edid-decode maintenance info
To: Hans Verkuil <hansverk@cisco.com>, xorg-devel@lists.x.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4f89ae25-4ae6-3530-a8f9-171dd39dceb0@cisco.com>
From: Alan Coopersmith <alan.coopersmith@oracle.com>
Message-ID: <85fdad02-5b68-1e62-cc59-d4dd6a33759b@oracle.com>
Date: Thu, 21 Jun 2018 16:36:18 -0700
MIME-Version: 1.0
In-Reply-To: <4f89ae25-4ae6-3530-a8f9-171dd39dceb0@cisco.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/21/18 01:59 AM, Hans Verkuil wrote:
> Hi all,
> 
> As Adam already announced earlier this week I'm taking over maintenance of
> the edid-decode utility.
> 
> Since I am already maintaining other utilities on git.linuxtv.org I decided
> to move the edid-decode git repo to linuxtv.org as well. It is now available
> here: https://git.linuxtv.org/edid-decode.git/
> 
> Patches, bug reports, etc. should be mailed to linux-media@vger.kernel.org
> (see https://linuxtv.org/lists.php). Please make sure the subject line
> contains 'edid-decode'.
> 
> One thing I would like to tackle in the very near future is to add support for
> the new HDMI 2.1b EDID additions.
> 
> I also know that some patches for edid-decode were posted to xorg-devel that
> were never applied. I will try to find them, but to be safe it is best to
> repost them to linux-media.

Thanks - there's also a handful of open bug reports against edid-decode in
our bugzilla as well, some of which have patches attached:

https://bugs.freedesktop.org/buglist.cgi?component=App%2Fedid-decode

-- 
	-Alan Coopersmith-               alan.coopersmith@oracle.com
	 Oracle Solaris Engineering - https://blogs.oracle.com/alanc
