Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:25049 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346AbaDKNWh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 09:22:37 -0400
Message-ID: <5347EC86.5070004@cisco.com>
Date: Fri, 11 Apr 2014 15:22:14 +0200
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
CC: pawel@osciak.com, sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	s.nawrocki@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv3 PATCH 09/13] vb2: add vb2_fileio_is_active and check
 it more often
References: <1397203879-37443-1-git-send-email-hverkuil@xs4all.nl> <1397203879-37443-10-git-send-email-hverkuil@xs4all.nl> <5347E894.5010401@samsung.com>
In-Reply-To: <5347E894.5010401@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/11/2014 03:05 PM, Tomasz Stanislawski wrote:
> Hi Hans,
> 
> On 04/11/2014 10:11 AM, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Added a vb2_fileio_is_active inline function that returns true if fileio
>> is in progress. Check for this too in mmap() (you don't want apps mmap()ing
>> buffers used by fileio) and expbuf() (same reason).
> 
> Why? I expect that there is no sane use case for using
> mmap() and expbuf in read/write mode but why forbidding this.
> 
> Could you provide a reason?

The buffer management is completely internal to vb2 for read()/write().
I think that allowing expbuf/mmap is just plain weird. I don't think
it would do any harm other than increasing the memory refcount, but
I very much prefer to block this.

The only ioctl allowed is querybuf, and that primarily for debugging.
Frankly, I wouldn't mind if that is blocked off as well but since it
is guaranteed to have no side-effects and it actually has a use-case
(debugging) I've left that in.

Personally I think the question is not: "why block this?", it is:
"why would you allow it?".

Regards,

	Hans
