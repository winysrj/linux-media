Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:38565 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725973AbeISNSc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Sep 2018 09:18:32 -0400
Subject: Re: RFC: stop support for 2.6 kernel in the daily build
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: "Jasmin J." <jasmin@anw.at>
References: <9e0a811d-f403-ae89-38fa-947356f2c026@xs4all.nl>
Message-ID: <8490e60c-8e43-c191-ec15-89cdffbb3c61@xs4all.nl>
Date: Wed, 19 Sep 2018 09:41:46 +0200
MIME-Version: 1.0
In-Reply-To: <9e0a811d-f403-ae89-38fa-947356f2c026@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/13/2018 08:49 AM, Hans Verkuil wrote:
> SUSE Linux Enterprise Server 12 is on kernel 3.12, and version 11 SP2 or up
> is on kernel 3.0.
> 
> Red Hat's RHEL 7 is on kernel 3.10.
> 
> I'm inclined to drop support for 2.6 altogether. If nothing else it
> simplifies the kernel version handling in media_build.
> 
> Whether we should also drop support for 3.0-3.9 is another matter.
> I wouldn't mind, 3.10 seems to be a reasonable minimum to me, but
> I might be too optimistic here.

Final reminder: unless someone objects I will drop support for kernels
3.0-3.9 from the daily build tomorrow.

Pre-3.0 kernels are already dropped.

Regards,

	hans
