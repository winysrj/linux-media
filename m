Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:53546 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbZFZOur convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 10:50:47 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 26 Jun 2009 09:50:32 -0500
Subject: RE: [PATCH] mt9t031 - migration to sub device frame work
Message-ID: <A69FA2915331DC488A831521EAE36FE40139F9E0D9@dlee06.ent.ti.com>
References: <1245874609-15246-1-git-send-email-m-karicheri2@ti.com>
 <Pine.LNX.4.64.0906251944420.4663@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE40139F9DEC4@dlee06.ent.ti.com>
 <200906260847.19818.hverkuil@xs4all.nl>
 <Pine.LNX.4.64.0906260852290.4449@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0906260852290.4449@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>
>). I started by converting mx3-camera and mt9t031, and I shall upload an
>incomplete patch, converting only these drivers to my "testing" area,
>while I shall start converting the rest of the drivers... So, it is
>advisable to wait for that patch to appear and base any future (including
>this one) work on it, because it is a pretty big change and merging would
>be non-trivial.
>
I thought you wanted to offload some of the migration work and I had volunteered to do this since it is of interest to vpfe-capture. I don't see a point in duplicating the work already done by me. So could you please work with me by reviewing this patch and then use this for your work? I will take care of merging any updates to this based on your patches (like the crop one)

>
>> > >>  {
>> > >> -    s32 data = i2c_smbus_read_word_data(client, reg);
>> > >> +    s32 data;
>> > >> +
>> > >> +    data = i2c_smbus_read_word_data(client, reg);
>> > >>      return data < 0 ? data : swab16(data);
>
>Looks like it will take me considerable time to review the patch and NAK
>all changes like this one...
>
I didn't get it. Are you referring to the 3 lines of code above? For this patch this code change is unnecessary, but I have to do this if sd is used as argument to this function as suggested by Hans. 

>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/

