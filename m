Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2669 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab1DGHuY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Apr 2011 03:50:24 -0400
Message-ID: <058f16a20d747a5ef6b300e119fa69b4.squirrel@webmail.xs4all.nl>
In-Reply-To: <Pine.LNX.4.64.1104070914540.24325@axis700.grange>
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange>
    <201104051434.57489.hansverk@cisco.com>
    <Pine.LNX.4.64.1104061812560.22734@axis700.grange>
    <201104070906.00265.hverkuil@xs4all.nl>
    <Pine.LNX.4.64.1104070914540.24325@axis700.grange>
Date: Thu, 7 Apr 2011 09:50:13 +0200
Subject: Re: [PATCH/RFC 1/4] V4L: add three new ioctl()s for multi-size
 videobuffer management
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: "Hans Verkuil" <hansverk@cisco.com>,
	"Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> On Thu, 7 Apr 2011, Hans Verkuil wrote:
>
>> On Wednesday, April 06, 2011 18:19:18 Guennadi Liakhovetski wrote:
>> > On Tue, 5 Apr 2011, Hans Verkuil wrote:
>> >
>> > > On Tuesday, April 05, 2011 14:21:03 Laurent Pinchart wrote:
>> > > > On Friday 01 April 2011 10:13:02 Guennadi Liakhovetski wrote:
>> >
>> > [snip]
>> >
>> > > > >   *	I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
>> > > > >   *
>> > > > > @@ -1937,6 +1957,10 @@ struct v4l2_dbg_chip_ident {
>> > > > >  #define	VIDIOC_SUBSCRIBE_EVENT	 _IOW('V', 90, struct
>> > > > > v4l2_event_subscription) #define	VIDIOC_UNSUBSCRIBE_EVENT
>> _IOW('V', 91,
>> > > > > struct v4l2_event_subscription)
>> > > > >
>> > > > > +#define VIDIOC_CREATE_BUFS	_IOWR('V', 92, struct
>> v4l2_create_buffers)
>> > > > > +#define VIDIOC_DESTROY_BUFS	_IOWR('V', 93, struct
>> v4l2_buffer_span)
>> > > > > +#define VIDIOC_SUBMIT_BUF	 _IOW('V', 94, int)
>> > > > > +
>> > > >
>> > > > In case we later need to pass other information (such as flags) to
>> > > > VIDIOC_SUBMIT_BUF, you should use a structure instead of an int.
>> > >
>> > > I would just pass struct v4l2_buffer to this ioctl, just like
>> QBUF/DQBUF do.
>> >
>> > As I said, I didn't like this very much, because it involves redundant
>> > data, but if we want to call .buf_prepare() from it, then we need
>> > v4l2_buffer...
>>
>> I don't see a problem with this. Applications already *have* the
>> v4l2_buffer
>> after all. It's not as if they have to fill that structure just for this
>> call.
>>
>> Furthermore, you need all that data anyway because you need to do the
>> same
>> checks that vb2_qbuf does.
>>
>> Regarding DESTROY_BUFS: perhaps we should just skip this for now and
>> wait for
>> the first use-case. That way we don't need to care about holes. I don't
>> like
>> artificial restrictions like 'no holes'. If someone has a good use-case
>> for
>> selectively destroying buffers, then we need to look at this again.
>
> Sorry, skip what? skip the ioctl completely and rely on REQBUFS(0) /
> close()?

Yes.

       Hans


>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
>


