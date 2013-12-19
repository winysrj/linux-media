Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60831 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab3LSNa7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Dec 2013 08:30:59 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MY2000U72VKUZ80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 19 Dec 2013 13:30:57 +0000 (GMT)
Message-id: <52B2F50C.1090705@samsung.com>
Date: Thu, 19 Dec 2013 14:30:52 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC v3] [RFC] v4l2: Support for multiple selections
References: <1380623614-26265-1-git-send-email-ricardo.ribalda@gmail.com>
 <5268F714.3090004@samsung.com>
 <CAPybu_2p4AYxze-QMOZhMq+EYCEXN1KazZdQckWKub9kpAESfg@mail.gmail.com>
 <5282411E.9060309@samsung.com>
 <CAPybu_3G335UteUzyYUg4JfLBYQb7Pj4FYZmNjL9oDHk=vbuzA@mail.gmail.com>
 <52B2D3EA.8010307@samsung.com> <52B2DC76.9040802@xs4all.nl>
In-reply-to: <52B2DC76.9040802@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
We've misunderstood. When I was saying 'overengineered'
I did not mean your RFC.
I was taking about this:

#define V4L2_SEL_TGT_CROP_COMPOSE    0x0200

struct v4l2_selection {
        __u32                   type;
        __u32                   target;
        __u32                   flags;
	union {
	        struct v4l2_rect        r;
		struct v4l2_ext_rect    *pr;
	};
        __u32                   flags2;
	union {
	        struct v4l2_rect        r2;
		struct v4l2_ext_rect    *pr2;
	};
	__u32			rectangles;
        __u32                   reserved[3];
};

This structure looks scary to me :).

> 
> I disagree. I implemented it in vivi and it turned out to be quite easy.
> 
> For the record: I'm talking about this RFC:
> 
> http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/71822
> 
>> I still does not solve problems with flipping and rotations, which may
>> have a huge impact on mulitrect cropping/composing limitations.
> 
> My proposal will make that much easier as well since flipping, rotating,
> cropping and composing are all controls/properties that can be set
> atomically (a control cluster). So drivers can create a single function
> that can handle all the relationships in one place, and applications can
> set all of these with one VIDIOC_S_EXT_CTRLS call.
> 

I think that your idea is quite good. Solve atomic configuration
in a different part of API (control cluster), not by making
properties larger.

As I said, there are multiple way to handle atomic configuration.
Using control API is one of them. Quite nice BTW :)

Regards,
Tomasz Stanislawski


