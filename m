Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:55597 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbZFZPXN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 11:23:13 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 26 Jun 2009 10:23:07 -0500
Subject: RE: [PATCH] mt9t031 - migration to sub device frame work
Message-ID: <A69FA2915331DC488A831521EAE36FE40139F9E115@dlee06.ent.ti.com>
References: <1245874609-15246-1-git-send-email-m-karicheri2@ti.com>
 <Pine.LNX.4.64.0906251944420.4663@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE40139F9DEC4@dlee06.ent.ti.com>
 <200906260847.19818.hverkuil@xs4all.nl>
 <Pine.LNX.4.64.0906260852290.4449@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE40139F9E0D9@dlee06.ent.ti.com>
 <Pine.LNX.4.64.0906261657170.4449@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0906261657170.4449@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi,

<snip>
>
>I thought you would be doing the latter part - v4l2-subdev conversion.
>Which is good. But, you wrote:
>
>> This patch migrates mt9t031 driver from SOC Camera interface to
>> sub device interface. This is sent to get a feedback about the
>> changes done since I am not sure if some of the functionality
>> that is removed works okay with SOC Camera bridge driver or
>> not. Following functions are to be discussed and added as needed:-
>
>which I understand like you probably have broken soc-camera functionality
>of this driver, which I cannot accept. Yes, I want to move forward to
>v4l2-subdev, but - we cannot introduce regressions!
>
That is why the review is done with your help to make sure there are no gaps.

<snip>
>> I don't see a point in duplicating the work already done by me.
>
>I don't like duplicating work either, and I don't think we're doing that.
>As I said, what I am doing at the moment is fixing all soc-camera drivers
>for proper cropping / scaling. In principle I welcome your help with the
>v4l2-subdev migration, but currently it conflicts with my above work, and
>it introduces a regression.
>
I see your point. I think what we could do is to keep this patch in our internal tree until you complete fixing the cropping/scaling issue. I will merge your future patches to this version. When you are ready to do the migration to sub device frame work, we could review this driver again and merge. Could you agree with this plan?

>> So could you
>> please work with me by reviewing this patch and then use this for your
>> work? I will take care of merging any updates to this based on your
>> patches (like the crop one)
>
>Unfortunately, I do not think I'll be able to review your patch today,
>will have to wait until the next week, sorry.
>
Any way there is no hurry since it will stay in our internal tree for the time being. So please review when you get a chance. I will post a patch based on Han's comment. 
>> >> > >>  {
>> >> > >> -    s32 data = i2c_smbus_read_word_data(client, reg);
>> >> > >> +    s32 data;
>> >> > >> +
>> >> > >> +    data = i2c_smbus_read_word_data(client, reg);
>> >> > >>      return data < 0 ? data : swab16(data);
>> >
>> >Looks like it will take me considerable time to review the patch and NAK
>> >all changes like this one...
>> >
>> I didn't get it. Are you referring to the 3 lines of code above? For
>> this patch this code change is unnecessary, but I have to do this if sd
>> is used as argument to this function as suggested by Hans.
>
>Exactly. It is _not_ needed for this patch. Only if we _do_ accept Hans'
>suggestion to use the subdev pointer all the way down to register-access
>functions, _then_ you might need to modify this code.
>
>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/

