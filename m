Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:54736 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935036AbdCJKbc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 05:31:32 -0500
Date: Fri, 10 Mar 2017 10:31:13 +0000
From: Brian Starkey <brian.starkey@arm.com>
To: Laura Abbott <labbott@redhat.com>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Riley Andrews <riandrews@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Rom Lemarchand <romlem@google.com>, devel@driverdev.osuosl.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@intel.com>, linux-mm@kvack.org
Subject: Re: [RFC PATCH 00/12] Ion cleanup in preparation for moving out of
 staging
Message-ID: <20170310103112.GA15945@e106950-lin.cambridge.arm.com>
References: <1488491084-17252-1-git-send-email-labbott@redhat.com>
 <20170303132949.GC31582@dhcp22.suse.cz>
 <cf383b9b-3cbc-0092-a071-f120874c053c@redhat.com>
 <20170306074258.GA27953@dhcp22.suse.cz>
 <20170306104041.zghsicrnadoap7lp@phenom.ffwll.local>
 <20170306105805.jsq44kfxhsvazkm6@sirena.org.uk>
 <20170306160437.sf7bksorlnw7u372@phenom.ffwll.local>
 <CA+M3ks77Am3Fx-ZNmgeM5tCqdM7SzV7rby4Es-p2F2aOhUco9g@mail.gmail.com>
 <26bc57ae-d88f-4ea0-d666-2c1a02bf866f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <26bc57ae-d88f-4ea0-d666-2c1a02bf866f@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Thu, Mar 09, 2017 at 09:38:49AM -0800, Laura Abbott wrote:
>On 03/09/2017 02:00 AM, Benjamin Gaignard wrote:

[snip]

>>
>> For me those patches are going in the right direction.
>>
>> I still have few questions:
>> - since alignment management has been remove from ion-core, should it
>> be also removed from ioctl structure ?
>
>Yes, I think I'm going to go with the suggestion to fixup the ABI
>so we don't need the compat layer and as part of that I'm also
>dropping the align argument.
>

Is the only motivation for removing the alignment parameter that
no-one got around to using it for something useful yet?
The original comment was true - different devices do have different
alignment requirements.

Better alignment can help SMMUs use larger blocks when mapping,
reducing TLB pressure and the chance of a page table walk causing
display underruns.

-Brian
