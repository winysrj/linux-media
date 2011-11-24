Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab1KXQiV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 11:38:21 -0500
Message-ID: <4ECE72F5.4080107@redhat.com>
Date: Thu, 24 Nov 2011 14:38:13 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Lawrence Rust <lawrence@softsystem.co.uk>
CC: Andreas Oberritter <obi@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Revert most of 15cc2bb [media] DVB: dtv_property_cache_submit
 shouldn't modifiy the cache
References: <1320506379.1731.12.camel@gagarin>  <4EB566CD.7050704@linuxtv.org> <1320513624.1731.20.camel@gagarin>  <4EB574A3.8050503@linuxtv.org> <1320515855.1731.28.camel@gagarin>
In-Reply-To: <1320515855.1731.28.camel@gagarin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 05-11-2011 15:57, Lawrence Rust escreveu:
> On Sat, 2011-11-05 at 18:38 +0100, Andreas Oberritter wrote:
> [snip]
>> I don't get how this could be useful. MythTV knows what delivery system
>> it wants to use, so it should pass this information to the kernel.
>> Trying to set an invalid delivery system must fail.
>>
>> Using SYS_UNDEFINED as a pre-set default is different from setting
>> SYS_UNDEFINED from userspace, which should always generate an error IMO,
>> unless this is documented otherwise in the API specification.
> 
> It's not ideal that MythTV is setting DTV_DELIVERY_SYSTEM to 0 and I
> have filed a bug against this.  But that doesn't change the fact that
> the original patch significantly changed user parameter handling for no
> significant benefit.  MythTV is probably the biggest client of v4l and
> will greatly hinder users upgrading to (Myth)Ubuntu 12.04 or Fedora 16
> both of which use Linux 3.x.

Regression is a bad thing. However, in this specific case, I agree with
Andreas: an assumption that the Kernel will replace SYS_UNDEFINED by something
else is a very bad thing. It also hides a bug, as there are no way for devices 
that support more than one delivery system to properly select the desired
one. 

So, this patch won't fix it.

So, I suspect that you'll need to open a BZ also at Ubuntu and Fedora, in
order to backport the MythTV fix into them.

Regards,
Mauro





