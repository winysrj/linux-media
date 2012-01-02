Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab2ABIAD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Jan 2012 03:00:03 -0500
Message-ID: <4F01643D.5000404@redhat.com>
Date: Mon, 02 Jan 2012 09:01:01 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
CC: Jean-Francois Moine <moinejf@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH for 3.2 URGENT] gspca: Fix bulk mode cameras no longer
 working (regression fix)
References: <1325191002-25074-1-git-send-email-hdegoede@redhat.com> <1325191002-25074-2-git-send-email-hdegoede@redhat.com> <20111230112121.03e8b59b@tele> <4EFD985A.4050301@redhat.com> <alpine.LNX.2.00.1112311303100.30415@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.1112311303100.30415@banach.math.auburn.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 12/31/2011 08:08 PM, Theodore Kilgore wrote:

<snip>

> Jean-Francois, Hans,
>
> Without addressing finer points, please let me add the following:
>
> 1. I figured out what was holding me back from getting 3.2 to work (it was
> a config error, apparently originating between keyboard and chair).
>
> 2. Based upon my testing today, something like this patch is clearly
> necessary. Namely, I tested a mass storage camera. Without this patch it
> would not stream. When I applied the patch, it did.
>
> Therefore, I hope very much that the problem which occasioned this patch
> gets fixed.

No worries, this patch has already found its way into Linus' tree.

Regards,

Hans
