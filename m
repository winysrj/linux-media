Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507Ab1L3LiH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 06:38:07 -0500
Message-ID: <4EFDA2D6.7000202@redhat.com>
Date: Fri, 30 Dec 2011 12:39:02 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Theodore Kilgore <kilgota@banach.math.auburn.edu>
Subject: Re: [GIT PATCHES FOR 3.3] gspca patches and new jl2005bcd driver
References: <4EFD8494.4050506@redhat.com> <20111230112411.3089e281@tele> <4EFD98E6.6010107@redhat.com> <20111230122608.7f08efe7@tele>
In-Reply-To: <20111230122608.7f08efe7@tele>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 12/30/2011 12:26 PM, Jean-Francois Moine wrote:
> On Fri, 30 Dec 2011 11:56:38 +0100
> Hans de Goede<hdegoede@redhat.com>  wrote:
>
>> I took it as is from Theodore, I guess we should do a separate cleanup
>> patch on top to preserve the history / authorship. Since I'm busy testing
>> the new isoc bandwidth stuff today, could you perhaps do a cleanup patch for this?
>
> Yes, but the first step is to remove this patch from the pull request, and only you may do it (it is only 3 git commands and an email - otherwise, it has no sense to add two empty lines in a patch and to remove them in an other one!).

Done.

I'll re-add it later, squashing the white-space fixes into the
patch and adding a patch on top to fix:
-err versus pr_err
-PDEBUG used with D_ERR everywhere where most cases should have
  a different level
-the missing pixfmt documentation

Regards,

Hans
