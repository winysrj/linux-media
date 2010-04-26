Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584Ab0DZHn7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Apr 2010 03:43:59 -0400
Message-ID: <4BD544A3.50604@redhat.com>
Date: Mon, 26 Apr 2010 09:45:39 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Chicken Shack <chicken.shack@gmx.de>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Xawtv version 3.96
References: <4BD19F77.2020303@redhat.com> <1272035901.4167.5.camel@brian.bconsult.de>
In-Reply-To: <1272035901.4167.5.camel@brian.bconsult.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 04/23/2010 05:18 PM, Chicken Shack wrote:
>
> It would make much more sense to complete (or at least try to complete)
> xawtv 4.0 pre instead of fixing bugs in 3.96.
>
> Reasons why?
>
> 1. 4.0 pre contains more innovation, new ideas.
> 2. 3.96 s analogue only, not DVB.
> 3. Both the analogue AND the DVB driver development section do need
> reference applications for driver development: 4.0 pre contains BOTH:
> reference apps for analogue AND DVB driver development.
>

We're currently mainly working on collecting distro patches for 3.xx so
as to have a 3.xx upstream with all known issues fixed, and to have a
source of xawtv-3.xx which will work out of the box on recent distro's

When setting up 3.xx git, we've also set up a 4.xx git, so that
interested parties can work on it. As you seem interested, feel free
to submit patches and / or apply for direct commit access to 4.xx git.

Regards,

Hans
