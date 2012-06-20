Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:57676 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799Ab2FTJFg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jun 2012 05:05:36 -0400
Received: by gglu4 with SMTP id u4so5437909ggl.19
        for <linux-media@vger.kernel.org>; Wed, 20 Jun 2012 02:05:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FDB1DAC.40908@xs4all.nl>
References: <CAHG8p1AW6577=oGPo3o8S0LgF2p8_cfmLLnvYbikk7kEaYdxzw@mail.gmail.com>
	<201206111033.47369.hverkuil@xs4all.nl>
	<CAHG8p1Dc_FtTh4DOZO92VbJikk43CgVhQidXPjNwN3VcHrtKvA@mail.gmail.com>
	<201206131553.23161.hverkuil@xs4all.nl>
	<CAHG8p1AYHVJaqjQRa2P6_+VoZG0+StJgoTXA1Md9L7qG=Eb50w@mail.gmail.com>
	<4FDB1DAC.40908@xs4all.nl>
Date: Wed, 20 Jun 2012 17:05:35 +0800
Message-ID: <CAHG8p1CEPKXs+febefA5LDPU=Zicbpm-GYLpkfuOGrhpK6SHvw@mail.gmail.com>
Subject: Re: extend v4l2_mbus_framefmt
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	LMML <linux-media@vger.kernel.org>,
	uclinux-dist-devel@blackfin.uclinux.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>>>> I would expect that the combination of v4l2_mbus_framefmt +
>>>>> v4l2_dv_timings
>>>>> gives you the information you need.
>>>>>
>>>> I can solve this problem in HD, but how about SD? Add a fake
>>>> dv_timings ops in SD decoder driver?
>>>>
>>>
>>> No, you add g/s_std instead. SD timings are set through that API. It is
>>> not so
>>> much that you give explicit timings, but that you give the SD standard.
>>> And from
>>> that you can derive the timings (i.e., one for 60 Hz formats, and one for
>>> 50 Hz
>>> formats).
>>>
>> Yes, it's a solution for decoder. I can convert one by one. But how
>> about sensors?They can output VGA, QVGA or any manual resolution.
>> My question is why we can't add these blanking details in
>> v4l2_mbus_framefmt? This structure is used to describe frame format on
>> media bus. And I believe blanking data also transfer on this bus. I
>> know most hardwares don't care about blanking areas, but some hardware
>> such as PPI does. PPI can capture ancillary data both in herizontal
>> and vertical interval. Even it works in active video only mode, it
>> expects to get total timing info.
>
>
> Since I don't know what you are trying to do, it is hard for me to give
> a good answer.
>
> So first I'd like to know if this is related to the adv7842 chip? I think
> you are talking about how this is done in general, and not specifically in
> relationship to the adv7842. At least, I can't see how/why you would
> hook up a sensor to the adv7842.
Yes, I want to have a general solution.

>
> Sensor configuration is a separate topic, and something I am not an
> expert on. People like Sakari Ailus and Laurent Pinchart know much
> more about that than I do.
>
> I know that there is some support for blanking through low-level image
> source
> controls:
>
> http://hverkuil.home.xs4all.nl/spec/media.html#image-source-controls
>
> This is experimental and if this is insufficient for your requirements than
> I suggest posting a message where you explain what you need, CC-ing the
> people
> I mentioned,
>
> Most of these APIs are quite new and by marking them as experimental we can
> make changes later if it turns out it is not good enough.
I remember I have discussed this topic with Sakari before but without
working out a solution.
In conclusion, my current solution is:
if (HD)
    dv_timings
else if (SD)
    fill in according to PAL/NTSC timings
else
    get control of V4L2_CID_HBLANK/V4L2_CID_VBLANK

I guess this can solve my problem. But it's a bit complicated. If
v4l2_mbus_framefmt contains thes members, it's convenient and simple.
