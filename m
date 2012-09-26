Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51990 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab2IZHq3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 03:46:29 -0400
Received: by obbuo13 with SMTP id uo13so271858obb.19
        for <linux-media@vger.kernel.org>; Wed, 26 Sep 2012 00:46:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120926074240.GM12025@valkosipuli.retiisi.org.uk>
References: <CA+V-a8vYDFhJzKVKsv7Q_JOQzDDYRyev15jDKio0tG2CP8iCCw@mail.gmail.com>
 <CA+V-a8v=_2vkuaYCAJNuyrqBX2bjU11KGASh7vkEQ4Qt2bFCGA@mail.gmail.com> <20120926074240.GM12025@valkosipuli.retiisi.org.uk>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 26 Sep 2012 13:16:08 +0530
Message-ID: <CA+V-a8vBXP=af_zWgiQzUhNBvexC6joddW7hioMqGziSTK9Dqw@mail.gmail.com>
Subject: Re: Gain controls in v4l2-ctrl framework
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans de Goede <hdegoede@redhat.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	linux-media <linux-media@vger.kernel.org>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Chris MacGregor <chris@cybermato.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Wed, Sep 26, 2012 at 1:12 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> On Wed, Sep 26, 2012 at 12:14:36PM +0530, Prabhakar Lad wrote:
>> Hi All,
>>
>> On Sun, Sep 23, 2012 at 4:56 PM, Prabhakar Lad
>> <prabhakar.csengg@gmail.com> wrote:
>> > Hi All,
>> >
>> > The CCD/Sensors have the capability to adjust the R/ye, Gr/Cy, Gb/G,
>> > B/Mg gain values.
>> > Since these control can be re-usable I am planning to add the
>> > following gain controls as part
>> > of the framework:
>> >
>> > 1: V4L2_CID_GAIN_RED
>> > 2: V4L2_CID_GAIN_GREEN_RED
>> > 3: V4L2_CID_GAIN_GREEN_BLUE
>> > 4: V4L2_CID_GAIN_BLUE
>> > 5: V4L2_CID_GAIN_OFFSET
>> >
>> > I need your opinion's to get moving to add them.
>> >
>>
>> I am listing out the gain controls which is the outcome of above discussion:-
>>
>> 1: V4L2_CID_GAIN_RED
>> 2: V4L2_CID_GAIN_GREEN_RED
>> 3: V4L2_CID_GAIN_GREEN_BLUE
>> 4: V4L2_CID_GAIN_BLUE
>> 5: V4L2_CID_GAIN_OFFSET
>> 6: V4L2_CID_BLUE_OFFSET
>> 7: V4L2_CID_RED_OFFSET
>> 8: V4L2_CID_GREEN_OFFSET
>
> Hi Prabhakar,
>
> As these are low level controls, I wonder whether it would make sense to
> make a difference between digital and analogue gain. I admit I'm not quite
> as certain whether there's such a large difference as there is for global
> gains for the camera control algorithms.
>
> Which ones do you need now?
>
Currently I am need of following,

 1: V4L2_CID_GAIN_RED
 2: V4L2_CID_GAIN_GREEN_RED
 3: V4L2_CID_GAIN_GREEN_BLUE
 4: V4L2_CID_GAIN_BLUE
 5: V4L2_CID_GAIN_OFFSET

Regards,
--Prabhakar Lad

> Kind regards,
>
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk
