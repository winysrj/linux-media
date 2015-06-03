Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:33824 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbbFCEZh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Jun 2015 00:25:37 -0400
Received: by pdbki1 with SMTP id ki1so147817124pdb.1
        for <linux-media@vger.kernel.org>; Tue, 02 Jun 2015 21:25:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <46233666.tCPCuE4QYo@avalon>
References: <556C2993.4030708@xs4all.nl> <46233666.tCPCuE4QYo@avalon>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Wed, 3 Jun 2015 09:55:15 +0530
Message-ID: <CAO_48GHRaD5AEStaX+eQWftBr-wigUJYbQu0Yr=NPH+Md4T7aQ@mail.gmail.com>
Subject: Re: [RFC] Export alignment requirements for buffers
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for looping me into this email chain, and apologies about not
responding earlier; it just got lost in the barrage of things.

On 1 June 2015 at 21:20, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Hans,
>
> On Monday 01 June 2015 11:44:51 Hans Verkuil wrote:
>> One of the things that is really irritating is the fact that drivers that
>> use contig-dma sometimes want to support USERPTR, allowing applications to
>> pass pointers to the driver that point to physically contiguous memory that
>> was somehow obtained, and that userspace has no way of knowing whether the
>> driver has this requirement or not.
>>
>> A related issue is that, depending on the DMA engine, the user pointer might
>> have some alignment requirements (page aligned, or at minimum 16 bytes
>> aligned) that userspace has no way of knowing.
>>
>> The same alignment issue is present also for dma-buf.
>
> Doesn't the first issue also apply to DMABUF ?
>
> As you already know, I'm not a big fan of USERPTR when used for sharing
> buffers between devices. DMABUF is a much better choice there. USERPTR can
> still be helpful for other use cases though. One of them that comes to my mind
> is to capturing directly buffers allocated by a software codec (or another
> similar userspace library) that doesn't support externally allocated memory
> (although the core issue there would be the library design).
>
> Anyway, the problem of conveying memory constraints is identical in the DMABUF
> case, so a solution is needed.

Yes, +1 on that.

The problem posed here is similar in the sense of requirement of
conveying memory constraints, but the key is probably the reverse
direction - the userspace here *needs* to share constraints of
_buffers_ obtained from elsewhere.

>
>> I propose to take one reserved field from struct v4l2_create_buffers and
>> from struct v4l2_requestbuffers and change it to this:
>>
>>       __u32 flags;
>>
>> #define V4L2_REQBUFS_FL_ALIGNMENT_MSK 0x3f
>> #define V4L2_REQBUFS_FL_PHYS_CONTIG   (1 << 31)
>>
>> Where the alignment is a power of 2 (and if 0 the alignment is unknown). The
>> max is 2^63, which should be enough for the foreseeable future :-)
>>
>> If the physically contiguous flag is set, then the buffer must be physically
>> contiguous.
>>
>> These flags can be set for every vb2 dma implementation:
>>
>> dma-contig: the PHYS_CONTIG flag is always set and the alignment is (unless
>> overridden by the driver) page aligned.
>>
>> dma-sg: the PHYS_CONTIG flag is 0 and the alignment will depend on the
>> driver DMA implementation. Note: malloc will align the buffer to 8 bytes on
>> a 32 bit OS and 16 bytes on a 64 bit OS.
>>
>> vmalloc: PHYS_CONFIG is 0 and the alignment should be 3 (2^3 == 8) for 32
>> bit and 4 (2^4=16) for 64 bit OS. This matches malloc() which will align
>> the buffer to 8 bytes on a 32 bit OS and 16 bytes on a 64 bit OS.
>>
>> The flags field can be extended with things like OPAQUE if the buffers
>> cannot be mmapped (since they are in protected memory).
>>
>> Comments? Alternative solutions?
>
> The question of conveying memory constraints has been raised several times in
> the past, without any solutions being merged. The work has been revived
> recently, see http://lists.freedesktop.org/archives/dri-devel/2015-February/076862.html for instance.
>
> Even if the API proposed here is specific to V4L2, and even if the patch set I
> linked to addresses a different problem, I believe it would be wise to widen
> the audience to make sure the solutions we come up with are at least aligned
> between subsystems. I've thus CC'ed Sumit to this e-mail as a start.
>

So I've been (trying to) work out some way of conveying memory
constraints between devices, and our idea was to get that added to
struct device->dma_parameters; that ways, the userspace doesn't have
to necessarily know of the constraints, and some negotiation can
happen in the kernel itself. It doesn't at the moment concern with
taking care of sharing those back to userspace, but I think that's an
orthogonal thing to handle.

Absolutely, it'd be great if we can come up with some aligned way of
conveying these constraints.
> --
> Regards,
>
> Laurent Pinchart
>



-- 
Thanks and regards,

Sumit Semwal
Kernel SubTeam Lead - Linaro Mobile Group
Linaro.org │ Open source software for ARM SoCs
