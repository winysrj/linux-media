Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4135 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab0IPKgk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 06:36:40 -0400
Message-ID: <c41fd486bf84d84b14b316e9aed099f8.squirrel@webmail.xs4all.nl>
In-Reply-To: <201009161140.36383.laurent.pinchart@ideasonboard.com>
References: <A24693684029E5489D1D202277BE894472336FC3@dlee02.ent.ti.com>
    <4C8E42F8.1080201@maxwell.research.nokia.com>
    <201009131906.20757.hverkuil@xs4all.nl>
    <201009161140.36383.laurent.pinchart@ideasonboard.com>
Date: Thu, 16 Sep 2010 12:36:34 +0200
Subject: Re: [Query] Is there a spec to request video sensor information?
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Cc: "Sakari Ailus" <sakari.ailus@maxwell.research.nokia.com>,
	"Aguirre, Sergio" <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Ivan Ivanov" <iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> Hi Hans,
>
> On Monday 13 September 2010 19:06:20 Hans Verkuil wrote:
>> On Monday, September 13, 2010 17:27:52 Sakari Ailus wrote:
>> > Aguirre, Sergio wrote:
>> > > I was wondering if there exists a current standard way to query a
>> > > Imaging sensor driver for knowing things like the signal vert/horz
>> > > blanking time.
>> > >
>> > > In an old TI custom driver, we used to have a private IOCTL in the
>> > > sensor Driver we interfaced with the omap3 ISP, which was basically
>> > > reporting:
>> > >
>> > > - Active resolution (Actual image size)
>> > > - Full resolution (Above size + dummy pixel columns/rows
>> representing
>> > > blanking times)
>> > >
>> > > However I resist to keep importing that custom interface, since I
>> think
>> > > its Something that could be already part of an standard API.
>> >
>> > The N900 sensor drivers currently use private controls for this
>> purpose.
>> > That is an issue which should be resolved. I agree there should be a
>> > uniform, standard way to access this information.
>> >
>> > What we currently have is this, not in upstream:
>> >
>> > ---
>> > /* SMIA-type sensor information */
>> > #define V4L2_CID_MODE_CLASS_BASE            (V4L2_CTRL_CLASS_MODE |
>> 0x900)
>> > #define V4L2_CID_MODE_CLASS                 (V4L2_CTRL_CLASS_MODE | 1)
>> > #define V4L2_CID_MODE_FRAME_WIDTH
>> (V4L2_CID_MODE_CLASS_BASE+1)
>> > #define V4L2_CID_MODE_FRAME_HEIGHT
>> (V4L2_CID_MODE_CLASS_BASE+2)
>> > #define V4L2_CID_MODE_VISIBLE_WIDTH
>> (V4L2_CID_MODE_CLASS_BASE+3)
>> > #define V4L2_CID_MODE_VISIBLE_HEIGHT
>> (V4L2_CID_MODE_CLASS_BASE+4)
>> > #define V4L2_CID_MODE_PIXELCLOCK
>> (V4L2_CID_MODE_CLASS_BASE+5)
>> > #define V4L2_CID_MODE_SENSITIVITY
>> (V4L2_CID_MODE_CLASS_BASE+6)
> ---
>> >
>> > The pixel clock is read-only but some of the others should likely be
>> > changeable.
>>
>> It is very similar to the VIDIOC_G/S_DV_TIMINGS ioctls. I think we
>> should
>> look into adding an e.g. V4L2_DV_SMIA_SENSOR type or something along
>> those
>> lines.
>
> I'm not sure if sensivity would fit in there. The rest probably would.
>
>> I'm no sensor expert, so I don't know what sort of timing information is
>> needed for the various sensor types. But I'm sure there are other people
>> who have this knowledge. It would be useful if someone can list the
>> information that you need from the various sensor types. Based on that
>> we
>> can see if this ioctl is a good fit.
>
> Another possibility could be to report the information using the media
> controller framework and an upcoming MEDIA_IOC_ENTITY_INFO ioctl.

Are you talking about timing information? That doesn't belong in the media
framework. But I think I didn't quite understood what you meant here.

Regards,

         Hans

>
> --
> Regards,
>
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

