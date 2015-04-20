Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:46951 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752640AbbDTJRV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2015 05:17:21 -0400
Message-ID: <5534C405.9010307@xs4all.nl>
Date: Mon, 20 Apr 2015 11:16:53 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-api@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH/RFC 0/2] Repurpose the v4l2_plane data_offset field
References: <1429040689-23808-1-git-send-email-laurent.pinchart@ideasonboard.com> <5530E01D.3050105@xs4all.nl> <20150418130415.GM27451@valkosipuli.retiisi.org.uk>
In-Reply-To: <20150418130415.GM27451@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 04/18/2015 03:04 PM, Sakari Ailus wrote:
> Hi Hans,
> 
> On Fri, Apr 17, 2015 at 12:27:41PM +0200, Hans Verkuil wrote:
>> Hi Laurent,
>>
>> On 04/14/2015 09:44 PM, Laurent Pinchart wrote:
>>> Hello,
>>>
>>> The v4l2_plane data_offset field has been introduced at the same time as the
>>> the multiplane API to convey header size information between kernelspace and
>>> userspace.
>>>
>>> The API then became slightly controversial, both because different developers
>>> understood the purpose of the field differently (resulting for instance in an
>>> out-of-tree driver abusing the field for a different purpose), and because of
>>> competing proposals (see for instance "[RFC] Multi format stream support" at
>>> http://www.spinics.net/lists/linux-media/msg69130.html).
>>>
>>> Furthermore, the data_offset field isn't used by any mainline driver except
>>> vivid (for testing purpose).
>>>
>>> I need a different data offset in planes to allow data capture to or data
>>> output from a userspace-selected offset within a buffer (mainly for the
>>> DMABUF and MMAP memory types). As the data_offset field already has the
>>> right name, is unused, and ill-defined, I propose repurposing it. This is what
>>> this RFC is about.
>>>
>>> If the proposal is accepted I'll add another patch to update data_offset usage
>>> in the vivid driver.
>>
>> I am skeptical about all this for a variety of reasons:
>>
>> 1) The data_offset field is well-defined in the spec. There really is no doubt
>> about the meaning of the field.
> 
> I think that's debatable. :-) The specification doesn't say much what the
> data_offset is really about. For instance, it does not specify what may be
> in the buffer before data_offset.

That's correct. Now, it is my view that, while it would be nice if a fourcc like
value would be available to tell the format of that header, in practice that format
is so tied to a specific type of hardware that you either know it (i.e. it is a custom
app for that hardware), or you ignore it altogether. There may be some exceptions for
somewhat standardized types of metadata (SMIA), but those never materialized as actual
code.

> The kerneldoc documentation next to struct v4l2_plane suggests there might
> be a header, but that's primarily for driver developers rather than users.
> 
> I, for instance, understood data_offset to mean essentially how this set
> "re-purposes" it. I wonder if there are others who have originally
> understood it as such.

I know it was mis-understood, the spec was fairly vague in the past, and while more
specific you are right in that it does not actually tell the reason for the field
(i.e. skip headers).

In no way can you re-purpose the field, though.

1) It is in use.
2) If you thought it was confusing today, then that's nothing compared to the confusion
   once you change the meaning from one kernel to another.

Either keep the current meaning and improve the specification, or deprecate it: warn
when it is non-zero and just mark it as 'don't use' in the spec.

> 
>>
>> 2) We really don't know who else might be using it, or which applications might
>> be using it (a lot of work was done in gstreamer recently, I wonder if data_offset
>> support was implemented there).
>>
>> 3) You offer no alternative to this feature. Basically this is my main objection.
>> It is not at all unusual to have headers in front of the frame data. We (Cisco)
>> use it in one of our product series for example. And I suspect it is something that
>> happens especially in systems with an FPGA that does custom processing, and those
>> systems are exactly the ones that are generally not upstreamed and so are not
>> visible to us.
> 
> If you have a header before the image, the header probably has a format as
> well. Some headers are device specific whereas some are more generic. The
> SMIA standard, for example, does specify a metadata (header or footer!)
> format.
> 
> It'd be useful to be able to tell the user what kind of header there is. For
> that, the header could be located on a different plane, with a specific
> format.
> 
> There's room for format information in struct v4l2_plane_pix_format but
> hardly much else. It still would cover a number of potential use cases.
> 
> I might still consider making the planes independent of each other;
> conveniently there's 8 bytes of free space in struct v4l2_pix_format_mplane
> for alternative plane related information. It'd be nice to be able to do
> this without an additional buffer type since that's visible in a large
> number of other places: there's plenty of room in struct v4l2_plane for
> any video buffer related information.

Please don't confuse things: each struct v4l2_plane_pix_format relates to a
single buffer that contains the data for that plane. If one buffer contains
both metadata and actual image data, then that's all part of the same plane
since it was all transferred to the buffer with the same DMA transfer.

You cannot put the header/footer into separate planes since the only way to
achieve that would be a memcpy and the header/footer would still be part of
the actual plane data.

If the metadata arrives through its own DMA channel, then I would have no
objection to seeing that as a separate plane. But I think in general that
might be a bad idea because such metadata may come at an earlier/later time
compared to the image data, and usually apps want to receive things asap.

I still see it as a simple problem: I have a buffer, it contains a picture
of a given pixel format, but there may be a header and (currently not implemented)
a footer. Header and/or footer may have a format (also not implemented yet).

Applications can use the offsets to ignore all those headers/footers and just
go straight to the image data. Or they use it to interpret the data in the
headers/footers.

Perhaps it is a total lack of imagination, but I really cannot see what else
it is you would need. Of course, you can think of really crazy schemes, but
then you likely need to just use a new pixelformat since it is so crazy that
it doesn't fit into anything existing.

The whole point of data_offset was that it is nuts to have to come up with a
new pixelformat for otherwise standard pixelformats that just happen to have
a header in front of them. You can't duplicate all pixel formats just for that.

> Frame descriptors are not needed for this --- you're quite right in that.
> But the frame descriptors, when implemented, will very probably need plane
> specific formats in the end as not many receivers are able to separate
> different parts of the image to different buffers.
> 
>>
>> IMHO the functionality it provides is very much relevant, and I would like to see
>> an alternative in place before it is repurposed.
>>
>> But frankly, I really don't see why you would want to repurpose it. Adding a new
>> field (buf_offset) would do exactly what you want it to do without causing an ABI
>> change.
> 
> I said I ok with adding buf_offset field, but it might not be the best
> choice we can make: it's a temporary solution for a very specific problem,
> leaves the API with similar field names with different meanings (data_offset
> vs. buf_offset, where the other is about the header and the other about the
> data) and is not extensible. In addition, the size of the header is not
> specified; it might be smaller than what's between buf_offset and
> data_offset. Some devices produce footers as well; currently we have no way
> to specify how they are dealt with.
> 
> I'd like to at least investigate if we could have something more
> future-proof for this purpose.
> 

Proposals welcome!

Regards,

	Hans
