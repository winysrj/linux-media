Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2335 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaAYIpJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jan 2014 03:45:09 -0500
Message-ID: <52E3798C.6090407@xs4all.nl>
Date: Sat, 25 Jan 2014 09:45:00 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Detlev Casanova <detlev.casanova@gmail.com>,
	linux-media@vger.kernel.org, hyun.kwon@xilinx.com
Subject: Re: qv4l2 and media controller support
References: <2270106.dN7Lhra68Q@avalon> <52E0507D.1060103@xs4all.nl> <3336553.LUKAjLBShm@avalon>
In-Reply-To: <3336553.LUKAjLBShm@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 01/24/2014 02:08 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Thursday 23 January 2014 00:13:01 Hans Verkuil wrote:
>> Hi Laurent,
>>
>> First, regarding the inheritance of subdev controls: I found it annoying as
>> well that there is no way to do this. If you have a simple video pipeline,
>> then having to create subdev nodes just to set a few controls is unnecessary
>> complex. I've been thinking of adding a flag to the control handler that,
>> when set, will 'import' the private controls. The bridge driver is the one
>> that sets this as that is the only one that knows whether or not it is in
>> fact a simple pipeline.
> 
> In my case the pipeline is potentially complex, given that it's implemented in 
> an FPGA. The bridge driver just parses the DT pipeline representation and 
> binds subdevs together. It has no concept of simple or complex pipelines. I've 
> thus decided to go for an MC model, even for simple pipelines.

That makes a lot of sense. I was talking about e.g. PCI cards with a simple
video capture pipeline where this would actually be useful.

>> Secondly, I'd love to add MC support to qv4l2. But I'm waiting for you to
>> merge the MC library into v4l-utils.git. It's basically the reason why I
>> haven't looked at this at all.
> 
> I assume that's a hint :-)

A big one :-)

> 
> I've just posted a series of patches for libmediactl. Let's take it from 
> there.

Thanks!

	Hans
