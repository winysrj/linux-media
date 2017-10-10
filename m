Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:35253 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755134AbdJJIgT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 04:36:19 -0400
Date: Tue, 10 Oct 2017 05:36:13 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v7 1/7] media: add glossary.rst with a glossary of terms
 used at V4L2 spec
Message-ID: <20171010053613.05809408@vento.lan>
In-Reply-To: <9629017a-99ca-f641-00fa-f6d076f9532c@xs4all.nl>
References: <cover.1506550930.git.mchehab@s-opensource.com>
        <047245414a82a6553361b1dd3497f796855a657d.1506550930.git.mchehab@s-opensource.com>
        <c48ca345-538d-df3f-8888-b207e91e4457@xs4all.nl>
        <20171010052000.322de12f@vento.lan>
        <9629017a-99ca-f641-00fa-f6d076f9532c@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 10 Oct 2017 10:27:12 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> > +    V4L2 sub-device driver
> > +	Part of the media hardware that implements support for
> > +	a hardware component.  
> 
> The description now no longer fits the term. I suggest:
> 
> "The V4L2 driver that implements support for a hardware component."

Look how we defined the term driver:

    Driver
	The part of the Linux Kernel that implements support
        for a hardware component.

If we define sub-device driver as you're proposing, we're basically
saying that:
	sub-device driver == Driver

with is not true.

I guess the proper definition would be, instead:

    V4L2 sub-device driver
	A driver for a media component whose bus(es) connects it
	to the hardware controlled via the V4L2 main driver.
	


Thanks,
Mauro
