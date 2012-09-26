Return-path: <linux-media-owner@vger.kernel.org>
Received: from mxout-07.mxes.net ([216.86.168.182]:61195 "EHLO
	mxout-07.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab2IZGxx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 02:53:53 -0400
Message-ID: <5062A679.8090007@cybermato.com>
Date: Tue, 25 Sep 2012 23:53:45 -0700
From: Chris MacGregor <chris@cybermato.com>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans de Goede <hdegoede@redhat.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	linux-media <linux-media@vger.kernel.org>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: Re: Gain controls in v4l2-ctrl framework
References: <CA+V-a8vYDFhJzKVKsv7Q_JOQzDDYRyev15jDKio0tG2CP8iCCw@mail.gmail.com> <CA+V-a8v=_2vkuaYCAJNuyrqBX2bjU11KGASh7vkEQ4Qt2bFCGA@mail.gmail.com>
In-Reply-To: <CA+V-a8v=_2vkuaYCAJNuyrqBX2bjU11KGASh7vkEQ4Qt2bFCGA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All.

On 09/25/2012 11:44 PM, Prabhakar Lad wrote:
> Hi All,
>
> On Sun, Sep 23, 2012 at 4:56 PM, Prabhakar Lad
> <prabhakar.csengg@gmail.com> wrote:
>> Hi All,
>>
>> The CCD/Sensors have the capability to adjust the R/ye, Gr/Cy, Gb/G,
>> B/Mg gain values.
>> Since these control can be re-usable I am planning to add the
>> following gain controls as part
>> of the framework:
>>
>> 1: V4L2_CID_GAIN_RED
>> 2: V4L2_CID_GAIN_GREEN_RED
>> 3: V4L2_CID_GAIN_GREEN_BLUE
>> 4: V4L2_CID_GAIN_BLUE
>> 5: V4L2_CID_GAIN_OFFSET
>>
>> I need your opinion's to get moving to add them.
>>
> I am listing out the gain controls which is the outcome of above discussion:-
>
> 1: V4L2_CID_GAIN_RED
> 2: V4L2_CID_GAIN_GREEN_RED
> 3: V4L2_CID_GAIN_GREEN_BLUE
> 4: V4L2_CID_GAIN_BLUE
> 5: V4L2_CID_GAIN_OFFSET
> 6: V4L2_CID_BLUE_OFFSET
> 7: V4L2_CID_RED_OFFSET
> 8: V4L2_CID_GREEN_OFFSET
>
> Please let me know for any addition/deletion.

I thought the consensus was that we would also need a 
V4L2_CID_GAIN_GREEN, to handle devices for which there are not two 
separate greens.

Also, should there be a V4L2_CID_GREEN_RED_OFFSET and 
V4L2_CID_GREEN_BLUE_OFFSET, for consistency and to handle hardware that 
has such offsets?

(Perhaps I missed an email in this thread, but I thought I caught them all.)

> Regards,
> --Prabhakar Lad

Cheers,
     Chris MacGregor (the Seattle one)
