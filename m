Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:40716 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750763Ab2APFgN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 00:36:13 -0500
Received: by mail-tul01m020-f181.google.com with SMTP id up10so4969061obb.12
        for <linux-media@vger.kernel.org>; Sun, 15 Jan 2012 21:36:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB2ybb83ub=A45-m6o+RXqFOTUmXCgeFqs03WZDHeWeLe2+29w@mail.gmail.com>
References: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com>
 <1325760118-27997-3-git-send-email-sumit.semwal@ti.com> <4F11E7D4.4050906@iki.fi>
 <CAB2ybb83ub=A45-m6o+RXqFOTUmXCgeFqs03WZDHeWeLe2+29w@mail.gmail.com>
From: "Semwal, Sumit" <sumit.semwal@ti.com>
Date: Mon, 16 Jan 2012 11:05:52 +0530
Message-ID: <CAB2ybb-WyxnY+zw-_cAQYXQP2TWqJcBQ5hPGYCN3TLBnR7wHFA@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFCv1 2/4] v4l:vb2: add support for shared
 buffer (dma_buf)
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	arnd@arndb.de, patches@linaro.org, jesse.barker@linaro.org,
	daniel@ffwll.ch,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hiroshi Doyu <hiroshi.doyu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 16, 2012 at 11:03 AM, Semwal, Sumit <sumit.semwal@ti.com> wrote:
>
> On Sun, Jan 15, 2012 at 2:08 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>>
>> Hi Sumit,
>>
>> Thanks for the patch!
>
Hi Sakari,

Thanks for reviewing this :)
>>
>>
>> <snip>
>> Shouldn't the buffer mapping only be done at the first call to
>> __qbuf_dmabuf()? On latter calls, the cache would need to be handled
>> according to presence of V4L2_BUF_FLAG_NO_CACHE_CLEAN /
>> V4L2_BUF_FLAG_NO_CACHE_INVALIDATE in v4l2_buffer.
>
Well, the 'map / unmap' implementation is by design exporter-specific;
so the exporter of the buffer may choose to, depending on the use
case, 'map-and-keep' on first call to map_dmabuf, and do actual unmap
only at 'release' time. This will mean that the {map,unmap}_dmabuf
calls will be used mostly for 'access-bracketing' between multiple
users, and not for actual map/unmap each time.
Again, the framework is flexible enough to allow exporters to actually
map/unmap as required (think cases where backing-storage migration
might be needed while buffers are in use - in that case, when all
current users have called unmap_XXX() on a buffer, it can be migrated,
and the next map_XXX() calls could give different mappings back to the
users).
> The kernel 'users' of dma-buf [in case of this RFC, v4l2] should not ideally need to worry about the actual mapping/unmapping that is done; the buffer exporter in a particular use-case should be able to handle it.
> <snip>
>>
>> Same here, except reverse: this only should be done when the buffer is
>> destroyed --- either when the user explicitly calls reqbufs(0) or when
>> the file handle owning this buffer is being closed.
>>
>> Mapping buffers at every prepare_buf and unmapping them in dqbuf is
>> prohibitively expensive. Same goes for many other APIs than V4L2, I think.
>>
>> I wonder if the means to do this exists already.
>>
>> I have to admit I haven't followed the dma_buf discussion closely so I
>> might be missing something relevant here.
>
Hope the above explanation helps. Please do not hesitate to contact if
you need more details.
>>
>>
>> Kind regards,
>>
>> --
>> Sakari Ailus
>> sakari.ailus@iki.fi

Best regards,
~Sumit.
