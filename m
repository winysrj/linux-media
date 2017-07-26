Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:54701 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751585AbdGZLeb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Jul 2017 07:34:31 -0400
Subject: Re: distro-specific hint for Raspbian
To: Christoph Wempe <christoph@wempe.net>, linux-media@vger.kernel.org
References: <ee2b53ed-7436-d310-1055-65062c10db2f@wempe.net>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <bbc63958-ca76-eca6-5f3f-011f1db2aca9@xs4all.nl>
Date: Wed, 26 Jul 2017 13:27:20 +0200
MIME-Version: 1.0
In-Reply-To: <ee2b53ed-7436-d310-1055-65062c10db2f@wempe.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/26/17 09:06, Christoph Wempe wrote:
> Hello,
> 
> I want to suggest to add a "distro-specific hint" for Raspbian.
> 
> I got this message:
> --- snip ---
> Checking if the needed tools for Raspbian GNU/Linux 8.0 (jessie) are 
> available
> ERROR: please install "lsdiff", otherwise, build won't work.
> ERROR: please install "Proc::ProcessTable", otherwise, build won't work.
> I don't know distro Raspbian GNU/Linux 8.0 (jessie). So, I can't provide 
> you a hint with the package names.
> --- snip ---
> 
> I solved the dependencies like suggested here: 
> https://patchwork.linuxtv.org/patch/7067/ 
> <https://patchwork.linuxtv.org/patch/7067/>
> 
> Since Raspbian is based on Debian, I guess it would be save to link this 
> to `give_ubuntu_hints`.

Done.

Thanks,

	Hans
