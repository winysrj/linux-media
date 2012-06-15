Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3401 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab2FOLfN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jun 2012 07:35:13 -0400
Message-ID: <4FDB1DAC.40908@xs4all.nl>
Date: Fri, 15 Jun 2012 13:34:04 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Scott Jiang <scott.jiang.linux@gmail.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	LMML <linux-media@vger.kernel.org>,
	uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: extend v4l2_mbus_framefmt
References: <CAHG8p1AW6577=oGPo3o8S0LgF2p8_cfmLLnvYbikk7kEaYdxzw@mail.gmail.com> <201206111033.47369.hverkuil@xs4all.nl> <CAHG8p1Dc_FtTh4DOZO92VbJikk43CgVhQidXPjNwN3VcHrtKvA@mail.gmail.com> <201206131553.23161.hverkuil@xs4all.nl> <CAHG8p1AYHVJaqjQRa2P6_+VoZG0+StJgoTXA1Md9L7qG=Eb50w@mail.gmail.com>
In-Reply-To: <CAHG8p1AYHVJaqjQRa2P6_+VoZG0+StJgoTXA1Md9L7qG=Eb50w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14/06/12 05:17, Scott Jiang wrote:
>>>
>>>> I would expect that the combination of v4l2_mbus_framefmt + v4l2_dv_timings
>>>> gives you the information you need.
>>>>
>>> I can solve this problem in HD, but how about SD? Add a fake
>>> dv_timings ops in SD decoder driver?
>>>
>>
>> No, you add g/s_std instead. SD timings are set through that API. It is not so
>> much that you give explicit timings, but that you give the SD standard. And from
>> that you can derive the timings (i.e., one for 60 Hz formats, and one for 50 Hz
>> formats).
>>
> Yes, it's a solution for decoder. I can convert one by one. But how
> about sensors?They can output VGA, QVGA or any manual resolution.
> My question is why we can't add these blanking details in
> v4l2_mbus_framefmt? This structure is used to describe frame format on
> media bus. And I believe blanking data also transfer on this bus. I
> know most hardwares don't care about blanking areas, but some hardware
> such as PPI does. PPI can capture ancillary data both in herizontal
> and vertical interval. Even it works in active video only mode, it
> expects to get total timing info.

Since I don't know what you are trying to do, it is hard for me to give
a good answer.

So first I'd like to know if this is related to the adv7842 chip? I think
you are talking about how this is done in general, and not specifically in
relationship to the adv7842. At least, I can't see how/why you would
hook up a sensor to the adv7842.

Sensor configuration is a separate topic, and something I am not an
expert on. People like Sakari Ailus and Laurent Pinchart know much
more about that than I do.

I know that there is some support for blanking through low-level image source
controls:

http://hverkuil.home.xs4all.nl/spec/media.html#image-source-controls

This is experimental and if this is insufficient for your requirements than
I suggest posting a message where you explain what you need, CC-ing the people
I mentioned,

Most of these APIs are quite new and by marking them as experimental we can
make changes later if it turns out it is not good enough.

Regards,

	Hans
