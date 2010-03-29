Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3260 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab0C2MFl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Mar 2010 08:05:41 -0400
Message-ID: <a685d91d0fca5abb6895959636041b26.squirrel@webmail.xs4all.nl>
In-Reply-To: <19F8576C6E063C45BE387C64729E7394044DEBF0BC@dbde02.ent.ti.com>
References: <1269848207-2325-1-git-send-email-p.osciak@samsung.com>
    <19F8576C6E063C45BE387C64729E7394044DEBF0BC@dbde02.ent.ti.com>
Date: Mon, 29 Mar 2010 14:05:31 +0200
Subject: RE: [PATCH v3 0/2] Mem-to-mem device framework
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Cc: "Pawel Osciak" <p.osciak@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>
>> -----Original Message-----
>> From: Pawel Osciak [mailto:p.osciak@samsung.com]
>> Sent: Monday, March 29, 2010 1:07 PM
>> To: linux-media@vger.kernel.org
>> Cc: p.osciak@samsung.com; m.szyprowski@samsung.com;
>> kyungmin.park@samsung.com; Hiremath, Vaibhav
>> Subject: [PATCH v3 0/2] Mem-to-mem device framework
>>
>> Hello,
>>
>> this is the third version of the mem-to-mem memory device framework.
>> It addresses previous comments and issues raised in Norway as well.
>>
>> It is rather independent from videobuf so I believe it can be merged
>> separately.
>>
>> Changes in v3:
>> - streamon, streamoff now have to be called for both queues separately
>> - added automatic rescheduling of an instance after finish (if ready)
>> - tweaked up locking
>> - addressed Andy Walls' comments
>>
>> We have been using v2 for three different devices on an embedded system.
>> I did some additional testing of v3 on a 4-core SMP as well.
>>
>> The series contains:
>>
>> [PATCH v3 1/2] v4l: Add memory-to-memory device helper framework for
>> videobuf.
>> [PATCH v3 2/2] v4l: Add a mem-to-mem videobuf framework test device.
>>
> [Hiremath, Vaibhav] pawel,
>
> Thanks for the updated patch series; I will rebase my code onto this.
>
> As I mentioned I had started with migrating OMAP Resizer module to this
> framework (V2) and I could use it without any major issues.
>
> I am now cleaning up the patches and also before submitting the patch I
> had to merge/rebase it with Sakari's omap3camer/devel branch, since I have
> my version of ISP (required for Resizer module and bit hard-coded) which I
> think need to merge.
>
> Today I have pulled in latest changes from Sakari's branch, I am working
> on this and soon I will post patches for the same.
>
> Also, I have done some minor cleanups in your patches which also I will
> submit.

Hiremath,

Be aware that the omap3 tree with media controller support that Laurent is
working on does not use these mem-to-mem devices. Instead you have
separate input and output devices. You should probably talk to Laurent
about this before you do work that will not be needed eventually.

Regards,

         Hans

>
> Thanks,
> Vaibhav Hiremath
>
>>
>> Best regards
>> --
>> Pawel Osciak
>> Linux Platform Group
>> Samsung Poland R&D Center
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

