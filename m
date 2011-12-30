Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534Ab1L3Kzm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 05:55:42 -0500
Message-ID: <4EFD98E6.6010107@redhat.com>
Date: Fri, 30 Dec 2011 11:56:38 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Theodore Kilgore <kilgota@banach.math.auburn.edu>
Subject: Re: [GIT PATCHES FOR 3.3] gspca patches and new jl2005bcd driver
References: <4EFD8494.4050506@redhat.com> <20111230112411.3089e281@tele>
In-Reply-To: <20111230112411.3089e281@tele>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 12/30/2011 11:24 AM, Jean-Francois Moine wrote:
> On Fri, 30 Dec 2011 10:29:56 +0100
> Hans de Goede<hdegoede@redhat.com>  wrote:
> 	[snip]
>> The following changes since commit 1a5cd29631a6b75e49e6ad8a770ab9d69cda0fa2:
>>
>>     [media] tda10021: Add support for DVB-C Annex C (2011-12-20 14:01:08 -0200)
>>
>> are available in the git repository at:
>>     git://linuxtv.org/hgoede/gspca.git media-for_v3.3
> 	[snip]
>> Theodore Kilgore (1):
>>         gspca: add jl2005bcd sub driver
> 	[snip]
>
> I have noticed some problems with the patch 2346c78dff71b003f:
>
> - there should be no change in gspca.h (addition of two empty lines)
>
> - there is no documentation about the new pixel format 'JL20'
>
> - in jl2005bcd.c, the macro 'err' is used instead of 'pr_err'
>    (there are also spaces at end of line, but this is less important..)
>

I took it as is from Theodore, I guess we should do a separate cleanup
patch on top to preserve the history / authorship. Since I'm busy testing
the new isoc bandwidth stuff today, could you perhaps do a cleanup patch for this?

Regards,

Hans
