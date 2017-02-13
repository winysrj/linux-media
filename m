Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:36648 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751950AbdBMTBU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 14:01:20 -0500
Received: by mail-qk0-f179.google.com with SMTP id 11so102341185qkl.3
        for <linux-media@vger.kernel.org>; Mon, 13 Feb 2017 11:01:19 -0800 (PST)
Subject: Re: [RFC simple allocator v2 0/2] Simple allocator
To: Mark Brown <broonie@kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
References: <1486997106-23277-1-git-send-email-benjamin.gaignard@linaro.org>
 <20170213181842.tn3nf7ogrwnzje2p@sirena.org.uk>
Cc: linaro-kernel@lists.linaro.org, arnd@arndb.de,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, daniel.vetter@ffwll.ch,
        laurent.pinchart@ideasonboard.com, robdclark@gmail.com,
        akpm@linux-foundation.org, hverkuil@xs4all.nl
From: Laura Abbott <labbott@redhat.com>
Message-ID: <8d85ac42-9e42-ba1b-9d98-8e08a44572da@redhat.com>
Date: Mon, 13 Feb 2017 11:01:14 -0800
MIME-Version: 1.0
In-Reply-To: <20170213181842.tn3nf7ogrwnzje2p@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/13/2017 10:18 AM, Mark Brown wrote:
> On Mon, Feb 13, 2017 at 03:45:04PM +0100, Benjamin Gaignard wrote:
> 
>> An other question is: do we have others memory regions that could be interested
>> by this new framework ? I have in mind that some title memory regions could use
>> it or replace ION heaps (system, carveout, etc...).
>> Maybe it only solve CMA allocation issue, in this case there is no need to create
>> a new framework but only a dedicated ioctl.
> 
> The software defined networking people seemed to think they had a use
> case for this as well.  They're not entirely upstream of course but
> still...
> 

This is the first I've heard of anything like this. Do you have any more
details/reading?

Thanks,
Laura
