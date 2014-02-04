Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway02.websitewelcome.com ([69.56.216.20]:34354 "EHLO
	gateway02.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933867AbaBDXK3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Feb 2014 18:10:29 -0500
Received: from gator3086.hostgator.com (ns6171.hostgator.com [50.87.144.121])
	by gateway02.websitewelcome.com (Postfix) with ESMTP id A041E56550DB1
	for <linux-media@vger.kernel.org>; Tue,  4 Feb 2014 17:10:28 -0600 (CST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 04 Feb 2014 17:10:27 -0600
From: Dean Anderson <linux-dev@sensoray.com>
To: <hverkuil@xs4all.nl>, <linux-dev@sensoray.com>,
	<linux-media@vger.kernel.org>
Subject: Re: [PATCH] s2255drv: file handle cleanup
In-Reply-To: <1391553393-17672-1-git-send-email-linux-dev@sensoray.com>
References: <1391553393-17672-1-git-send-email-linux-dev@sensoray.com>
Message-ID: <13a909e44a406b9b9e54c6941d853e7f@sensoray.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Please ignore and reject this patch. videobuf_queue_vmalloc_init needs 
to be in probe, not in open.

Let me know your thoughts on doing videobuf2 before s2255_fh removal so 
we don't have to work around or fix videobuf version one's deficiencies.

Thanks,




On 2014-02-04 16:36, Dean Anderson wrote:
> Removes most parameters from s2255_fh.  These elements belong in 
> s2255_ch.
> In the future, s2255_fh will be removed when videobuf2 is used. 
> videobuf2
> has convenient and safe functions for locking streaming resources.
> 
> The removal of s2255_fh (and s2255_fh->resources) was not done now to
> avoid using videobuf_queue_is_busy.
> 
> videobuf_queue_is busy may be unsafe as noted by the following comment
> in videobuf-core.c:
> "/* Locking: Only usage in bttv unsafe find way to remove */"
> 
> Signed-off-by: Dean Anderson <linux-dev@sensoray.com>
> ---
