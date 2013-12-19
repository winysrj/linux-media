Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2863 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860Ab3LSNiI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Dec 2013 08:38:08 -0500
Message-ID: <52B2F69A.6010907@xs4all.nl>
Date: Thu, 19 Dec 2013 14:37:30 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC v3] [RFC] v4l2: Support for multiple selections
References: <1380623614-26265-1-git-send-email-ricardo.ribalda@gmail.com> <5268F714.3090004@samsung.com> <CAPybu_2p4AYxze-QMOZhMq+EYCEXN1KazZdQckWKub9kpAESfg@mail.gmail.com> <5282411E.9060309@samsung.com> <CAPybu_3G335UteUzyYUg4JfLBYQb7Pj4FYZmNjL9oDHk=vbuzA@mail.gmail.com> <52B2D3EA.8010307@samsung.com> <52B2DC76.9040802@xs4all.nl> <52B2F50C.1090705@samsung.com>
In-Reply-To: <52B2F50C.1090705@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/19/2013 02:30 PM, Tomasz Stanislawski wrote:
> Hi Hans,
> We've misunderstood. When I was saying 'overengineered'
> I did not mean your RFC.
> I was taking about this:
> 
> #define V4L2_SEL_TGT_CROP_COMPOSE    0x0200
> 
> struct v4l2_selection {
>         __u32                   type;
>         __u32                   target;
>         __u32                   flags;
> 	union {
> 	        struct v4l2_rect        r;
> 		struct v4l2_ext_rect    *pr;
> 	};
>         __u32                   flags2;
> 	union {
> 	        struct v4l2_rect        r2;
> 		struct v4l2_ext_rect    *pr2;
> 	};
> 	__u32			rectangles;
>         __u32                   reserved[3];
> };
> 
> This structure looks scary to me :).

Ah, yes. Implementing this as properties works much better.

And multi-selection can be done simply by making an array of crop and
compose rectangles.

Regards,

	Hans

> 
>>
>> I disagree. I implemented it in vivi and it turned out to be quite easy.
>>
>> For the record: I'm talking about this RFC:
>>
>> http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/71822
>>
>>> I still does not solve problems with flipping and rotations, which may
>>> have a huge impact on mulitrect cropping/composing limitations.
>>
>> My proposal will make that much easier as well since flipping, rotating,
>> cropping and composing are all controls/properties that can be set
>> atomically (a control cluster). So drivers can create a single function
>> that can handle all the relationships in one place, and applications can
>> set all of these with one VIDIOC_S_EXT_CTRLS call.
>>
> 
> I think that your idea is quite good. Solve atomic configuration
> in a different part of API (control cluster), not by making
> properties larger.
> 
> As I said, there are multiple way to handle atomic configuration.
> Using control API is one of them. Quite nice BTW :)
> 
> Regards,
> Tomasz Stanislawski
> 
> 

