Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:37890 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbaGHOwc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jul 2014 10:52:32 -0400
Received: by mail-oa0-f53.google.com with SMTP id l6so6510962oag.40
        for <linux-media@vger.kernel.org>; Tue, 08 Jul 2014 07:52:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140708143912.GA3436@kroah.com>
References: <20140701103432.12718.82795.stgit@patser> <20140702053758.GA7578@kroah.com>
 <CAKMK7uHZQjQ2m7KE22kTRVs-NtGguHREk24pSJiLbN7EoQLZ=g@mail.gmail.com>
 <20140707173052.GA8693@kroah.com> <20140708134427.GG17271@phenom.ffwll.local> <20140708143912.GA3436@kroah.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Tue, 8 Jul 2014 20:22:11 +0530
Message-ID: <CAO_48GHwJ4EuCKgLmZhEaEQqS9e7EVZP3hsivhRwLCNFhzAQVA@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] Updated fence patch series
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	"open list:GENERIC INCLUDE/A..." <linux-arch@vger.kernel.org>,
	Thomas Hellstrom <thellstrom@vmware.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"Clark, Rob" <robdclark@gmail.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Colin Cross <ccross@google.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 8 July 2014 20:09, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Jul 08, 2014 at 03:44:27PM +0200, Daniel Vetter wrote:
>> On Mon, Jul 07, 2014 at 10:30:52AM -0700, Greg KH wrote:
>> > On Mon, Jul 07, 2014 at 03:23:17PM +0200, Daniel Vetter wrote:
>> > > On Wed, Jul 2, 2014 at 7:37 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > > >> Android can expose fences to userspace. It's possible to make the new fence
>> > > >> mechanism expose the same fences to userspace by changing sync_fence_create
>> > > >> to take a struct fence instead of a struct sync_pt. No other change is needed,
>> > > >> because only the fence parts of struct sync_pt are used. But because the
>> > > >> userspace fences are a separate problem and I haven't really looked at it yet
>> > > >> I feel it should stay in staging, for now.
>> > > >
>> > > > Ok, that's reasonable.
>> > > >
>> > > > At first glance, this all looks "sane" to me, any objection from anyone
>> > > > if I merge this through my driver-core tree for 3.17?
>> > >
>> > > Ack from my side fwiw.
>> >
>> > Thanks, I'll queue it up later today.
>>
>> btw should we add you as a (co)maintainer for driver/core/dma-buf since
>> you seem to want to keep a closer tab on what the insane gfx folks are up
>> to in there?
>
> Sure, why not, what's one more maintainership...
>
> Oh, does that mean you want me to be the one collecting the patches and
> forwarding them on to Linus?  If so, that's fine, I can easily do that
> as well due to my infrastructure being set up for it.
>
If you're ok, I could continue to do the collecting / forwarding
business - I guess Daniel meant more from the 'not miss patches that
need review'!

Upto you!
> thanks,
>
> greg k-h
Thanks and best regards,
~Sumit


-- 
Thanks and regards,

Sumit Semwal
Graphics Engineer - Graphics working group
Linaro.org │ Open source software for ARM SoCs
