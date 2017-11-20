Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:56168 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751151AbdKTLl2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Nov 2017 06:41:28 -0500
Date: Mon, 20 Nov 2017 11:41:17 +0000
From: Brian Starkey <brian.starkey@arm.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Gustavo Padovan <gustavo@padovan.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [RFC v5 07/11] [media] vb2: add in-fence support to QBUF
Message-ID: <20171120114101.GA37281@e107564-lin.cambridge.arm.com>
References: <20171115171057.17340-1-gustavo@padovan.org>
 <20171115171057.17340-8-gustavo@padovan.org>
 <422c5326-374b-487f-9ef1-594f239438f1@chromium.org>
 <20171117110025.2a49db49@vento.lan>
 <20171117130801.GH19033@jade>
 <20171117111905.5070bacd@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20171117111905.5070bacd@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 17, 2017 at 11:19:05AM -0200, Mauro Carvalho Chehab wrote:
>Em Fri, 17 Nov 2017 11:08:01 -0200
>Gustavo Padovan <gustavo@padovan.org> escreveu:
>
>> 2017-11-17 Mauro Carvalho Chehab <mchehab@osg.samsung.com>:
>>
>> > Em Fri, 17 Nov 2017 15:49:23 +0900
>> > Alexandre Courbot <acourbot@chromium.org> escreveu:
>> >
>> > > > @@ -178,6 +179,12 @@ static int vb2_queue_or_prepare_buf(struct
>> > > > vb2_queue *q, struct v4l2_buffer *b,
>> > > >  		return -EINVAL;
>> > > >  	}
>> > > >
>> > > > +	if ((b->fence_fd != 0 && b->fence_fd != -1) &&
>> > >
>> > > Why do we need to consider both values invalid? Can 0 ever be a valid fence
>> > > fd?
>> >
>> > Programs that don't use fences will initialize reserved2/fence_fd field
>> > at the uAPI call to zero.
>> >
>> > So, I guess using fd=0 here could be a problem. Anyway, I would, instead,
>> > do:
>> >
>> > 	if ((b->fence_fd < 1) &&
>> > 		...
>> >
>> > as other negative values are likely invalid as well.
>>
>> We are checking when the fence_fd is set but the flag wasn't. Checking
>> for < 1 is exactly the opposite. so we keep as is or do it fence_fd > 0.
>
>Ah, yes. Anyway, I would stick with:
>	if ((b->fence_fd > 0) &&
>		...
>

0 is a valid fence_fd right? If I close stdin, and create a sync_file,
couldn't I get a fence with fd zero?

-Brian

>>
>> Gustavo
>
>
>-- 
>Thanks,
>Mauro
