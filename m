Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2733 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbZDONog (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Apr 2009 09:44:36 -0400
Message-ID: <47909.62.70.2.252.1239803073.squirrel@webmail.xs4all.nl>
Date: Wed, 15 Apr 2009 15:44:33 +0200 (CEST)
Subject: RE: [PATCH 3/3] V4L2 Driver for OMAP3/3 DSS.
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Shah, Hardik" <hardik.shah@ti.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>
>
>> -----Original Message-----
>> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
>> Sent: Monday, April 06, 2009 8:27 PM
>> To: Shah, Hardik
>> Cc: linux-media@vger.kernel.org; linux-omap@vger.kernel.org; Jadav,
>> Brijesh R;
>> Hiremath, Vaibhav
>> Subject: RE: [PATCH 3/3] V4L2 Driver for OMAP3/3 DSS.
>>
>>
>> > Hi Hans,
>> > Please find my comments inline. Most of the comments are taken care
>> of.
>>
>> > 2.  In DSS rotation is accomplished by some memory algorithm but its
>> quite
>> > costly so -1 is essentially same as 0 degree but with out the
>> overhead.
>> > But if mirroring is on then we have to do the 0 degree rotation with
>> > overhead using some memory techniques.  So from user point of view he
>> will
>> > only be setting 0 but internally driver will take it as -1 or 0
>> depending
>> > upon the mirroring selected.
>>
>> Hi Hardik,
>>
>> I just looked over these comments and I'll do a full review in the
>> weekend
>> when I'm back from San Francisco. But just one quick remark regarding
>> this
>> magic -1 number: wouldn't it be better to write a small inline function
>> like this:
>>
>> /* return true if we need to rotate or mirror, return false if we
>>    don't have to do anything here. */
>> static inline int needs_rotate(struct foo *foo)
>> {
>>     return foo->rotate != 0 || foo->mirror;
>> }
>>
>> I think this is much more understandable. It's up to you, though.
>>
>> Regards,
> [Shah, Hardik] Hi All,
> Any comment on this series of patches will be appreciated.
>
> Hans,
> Did you get a chance to look at it?

No, but I hope to go through it this weekend.

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

