Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:33663 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726831AbeINLsc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 07:48:32 -0400
Subject: Re: RFC: stop support for 2.6 kernel in the daily build
To: "Jasmin J." <jasmin@anw.at>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <9e0a811d-f403-ae89-38fa-947356f2c026@xs4all.nl>
 <ae5e070e-4d5c-801a-cdde-120e312b10cf@anw.at>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c9cd2bee-2a19-e96b-272c-ad4e2894d317@xs4all.nl>
Date: Fri, 14 Sep 2018 08:35:27 +0200
MIME-Version: 1.0
In-Reply-To: <ae5e070e-4d5c-801a-cdde-120e312b10cf@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/13/2018 11:32 PM, Jasmin J. wrote:
> Hello Hans!
> 
>> I'm inclined to drop support for 2.6 altogether.
> RHEL 6 is on kernel 2.6.32, which we do not support since long time.
> Most other distributions switched to 3.x also years in the past.
> So lets drop 2.6.x then!

OK, I'll do that in the next few days.

> As you know I maintain a media-tree DKMS package and this should work for older
> Kernels. I personally have a VDR based on Ubuntu 14.04 system with the original
> 3.13 Kernel. So this is the minimum version for me.
> 
> When you want to support RHEL 7, then the version goes down to 3.10.
> 
>> Whether we should also drop support for 3.0-3.9 is another matter.
> We can decide now to remove those versions also and wait if people are
> complaining. At least this is what I would do.
> 
> I would suggest to remove all kernels prior to 3.10 from your build system and
> wait what people will say over the next months.

I'll wait a few days if I get any other comments about this, and if not I will
kill 3.0-3.9.

Regards,

	Hans
