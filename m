Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49648 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab2FNDRN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 23:17:13 -0400
Received: by obbtb18 with SMTP id tb18so1770322obb.19
        for <linux-media@vger.kernel.org>; Wed, 13 Jun 2012 20:17:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201206131553.23161.hverkuil@xs4all.nl>
References: <CAHG8p1AW6577=oGPo3o8S0LgF2p8_cfmLLnvYbikk7kEaYdxzw@mail.gmail.com>
	<201206111033.47369.hverkuil@xs4all.nl>
	<CAHG8p1Dc_FtTh4DOZO92VbJikk43CgVhQidXPjNwN3VcHrtKvA@mail.gmail.com>
	<201206131553.23161.hverkuil@xs4all.nl>
Date: Thu, 14 Jun 2012 11:17:12 +0800
Message-ID: <CAHG8p1AYHVJaqjQRa2P6_+VoZG0+StJgoTXA1Md9L7qG=Eb50w@mail.gmail.com>
Subject: Re: extend v4l2_mbus_framefmt
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	LMML <linux-media@vger.kernel.org>,
	uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>
>> > I would expect that the combination of v4l2_mbus_framefmt + v4l2_dv_timings
>> > gives you the information you need.
>> >
>> I can solve this problem in HD, but how about SD? Add a fake
>> dv_timings ops in SD decoder driver?
>>
>
> No, you add g/s_std instead. SD timings are set through that API. It is not so
> much that you give explicit timings, but that you give the SD standard. And from
> that you can derive the timings (i.e., one for 60 Hz formats, and one for 50 Hz
> formats).
>
Yes, it's a solution for decoder. I can convert one by one. But how
about sensors?They can output VGA, QVGA or any manual resolution.
My question is why we can't add these blanking details in
v4l2_mbus_framefmt? This structure is used to describe frame format on
media bus. And I believe blanking data also transfer on this bus. I
know most hardwares don't care about blanking areas, but some hardware
such as PPI does. PPI can capture ancillary data both in herizontal
and vertical interval. Even it works in active video only mode, it
expects to get total timing info.

Thanks,
Scott
