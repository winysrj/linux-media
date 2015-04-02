Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:39849 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752619AbbDBP0V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Apr 2015 11:26:21 -0400
Message-ID: <551D5F7C.4080400@xs4all.nl>
Date: Thu, 02 Apr 2015 17:25:48 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>, linux-media@vger.kernel.org
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
	David Airlie <airlied@linux.ie>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
Subject: Re: [PATCH 0/9 v2] Helper to abstract vma handling in media layer
References: <1426593399-6549-1-git-send-email-jack@suse.cz> <20150402150258.GA31277@quack.suse.cz>
In-Reply-To: <20150402150258.GA31277@quack.suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/02/2015 05:02 PM, Jan Kara wrote:
>   Hello,
> 
> On Tue 17-03-15 12:56:30, Jan Kara wrote:
>>   After a long pause I'm sending second version of my patch series to abstract
>> vma handling from the various media drivers. After this patch set drivers have
>> to know much less details about vmas, their types, and locking. My motivation
>> for the series is that I want to change get_user_pages() locking and I want to
>> handle subtle locking details in as few places as possible.
>>
>> The core of the series is the new helper get_vaddr_pfns() which is given a
>> virtual address and it fills in PFNs into provided array. If PFNs correspond to
>> normal pages it also grabs references to these pages. The difference from
>> get_user_pages() is that this function can also deal with pfnmap, mixed, and io
>> mappings which is what the media drivers need.
>>
>> I have tested the patches with vivid driver so at least vb2 code got some
>> exposure. Conversion of other drivers was just compile-tested so I'd like to
>> ask respective maintainers if they could have a look.  Also I'd like to ask mm
>> folks to check patch 2/9 implementing the helper. Thanks!
>   Ping? Any reactions?

For patch 1/9:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

For the other patches I do not feel qualified to give Acks. I've Cc-ed Pawel and
Marek who have a better understanding of the mm internals than I do. Hopefully
they can review the code.

It definitely looks like a good idea, and if nobody else will comment on the vb2
patches in the next 2 weeks, then I'll try to review it myself (for whatever that's
worth).

Regards,

	Hans
