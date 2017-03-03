Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:35942 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751641AbdCCTSV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Mar 2017 14:18:21 -0500
Received: by mail-qk0-f179.google.com with SMTP id 1so72861579qkl.3
        for <linux-media@vger.kernel.org>; Fri, 03 Mar 2017 11:17:08 -0800 (PST)
Subject: Re: [RFC PATCH 11/12] staging: android: ion: Make Ion heaps
 selectable
To: Sumit Semwal <sumit.semwal@linaro.org>,
        Riley Andrews <riandrews@android.com>, arve@android.com,
        romlem@google.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Brian Starkey <brian.starkey@arm.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-mm@kvack.org
References: <1488491084-17252-1-git-send-email-labbott@redhat.com>
 <1488491084-17252-12-git-send-email-labbott@redhat.com>
 <20170303103304.nxfn7zlccx24b3xq@phenom.ffwll.local>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <2b0c35ce-be88-526c-e0ab-1707c191260d@redhat.com>
Date: Fri, 3 Mar 2017 11:10:55 -0800
MIME-Version: 1.0
In-Reply-To: <20170303103304.nxfn7zlccx24b3xq@phenom.ffwll.local>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/03/2017 02:33 AM, Daniel Vetter wrote:
> On Thu, Mar 02, 2017 at 01:44:43PM -0800, Laura Abbott wrote:
>>
>> Currently, all heaps are compiled in all the time. In switching to
>> a better platform model, let's allow these to be compiled out for good
>> measure.
>>
>> Signed-off-by: Laura Abbott <labbott@redhat.com>
> 
> I'm not the biggest fan of making everything Kconfig-selectable. And the
> #ifdef stuff doesn't look all that pretty. If we'd also use this
> opportunity to split each heap into their own file I think this patch here
> would be a lot more useful.
> 
> Anyway, no real opinion from me on this, just an idea.
> -Daniel
> 

My idea with the Kconfigs was that if platforms didn't want certain
heap types (e.g. chunk heap) they could just be turned off.
I do want to fully fix up the initialization better as well.

Thanks,
Laura
