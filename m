Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.aswsp.com ([193.34.35.150]:16827 "EHLO mail.aswsp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932239AbaGaIxq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jul 2014 04:53:46 -0400
Message-ID: <53DA0419.2090405@parrot.com>
Date: Thu, 31 Jul 2014 10:53:45 +0200
From: Julien BERAUD <julien.beraud@parrot.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: <linux-media@vger.kernel.org>
Subject: Re: Configurable Video Controller Driver
References: <53BEA0DA.9000706@parrot.com> <20140721111432.GQ16460@valkosipuli.retiisi.org.uk>
In-Reply-To: <20140721111432.GQ16460@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,
Thank you for your answer.
Le 21/07/2014 13:14, Sakari Ailus a écrit :
> Hi Julien,
>
> On Thu, Jul 10, 2014 at 04:19:06PM +0200, Julien BERAUD wrote:
>> We are developing a driver for our video controller which has the
>> particularity of being very reconfigurable.
>>
>> We have reached a point at which the complexity and variety of the
>> applications we need to implement forces us to
>> design an api/library that allows us to configure the
>> interconnection of the different video processing units(Camera
>> interfaces,
>> LCD interfaces, scalers, rotators, demosaicing, dead pixel
>> correction, etc...) from userland.
>>
>> The media controller api has the limitation of not being able to
>> create links but just browsing and activating/deactivating them.
>> If we just allowed a user to activate/deactivate links, then we
>> would have to declare all the possible connections between
>> the different blocks, which would make it very confusing from a
>> userland point of view. Moreover, the interconnection constraints
>> would have to be dealt with very generically, which would make it
>> very difficult in the kernel too.
> How many different blocks do you have? Can they be connected in arbitrary
> ways? If not, what kind of limitations do you have?
>
> The Media controller is originally intended for modelling complex devices
> with hardware data paths between the sub-blocks. The question is: does your
> device fit into that group, even if could be a little more complex than the
> devices that are currently supported?
We have 44 different hardware blocks that can be connected in arbitrary 
ways but with some constraints. Some of the blocks have several 
inputs(blenders) and some(one type only) have 2 outputs(the block is a 
fork).
There are some limitations. Some blocks only accept Raw Bayer as 
input(ISP). There are some small limitations here and there, like if you 
use a scaler with a high scaling factor, you need to go to memory 
because the internal memory is not sufficient.
Some of the blocks are FIFOs to write/read to memory.
In the end, there are 6 camera inputs and 2 lcd outputs, all of them 
parallel, 2 ISPs with 2 blocks each(bayer/yuv), and 2 stat calculators, 
12 Fifos, 4 color converters, 2 blenders with 4 inputs each, 2 
scalers/rotators, 4 forks, 2 sat, 2 I3D, 2 gamma converters.

Our device might be a little more complex than the devices that are 
currently supported, though I am not aware of all the currently 
supported devices.

Something else, the Media controller doesn't allow to create links from 
userland, which is what I think we would need in order to avoid to 
declare all the possible combinations because that would be hard to 
understand in userland and complicated to handle in the kernel.

We have come from a totally rigid interconnection declared in the BSP to 
become more and more generic but it is probable that becoming too 
generic wouldn't make things any better.


>
>> The conclusion we have reached yet is that we have to design an API
>> that allows us to create v4l2 subdevices that have certain
>> capabilities(scaling,rotating, demosaicing, etc...) and then to
>> create links between them from a userland library.
> Can you create arbitrary devices at will, or do these devices exist on
> hardware all the time?
>
The devices exist on hardware at all time. What I would like to do is to 
create "virtual" subdevices that have some of the capabilities provided 
by the blocks in order to benefit from all the features the hardware 
provides in order to have a media controller tree that is clear and that 
fits the needs of the current application. We are currently thinking 
about designing a kernel driver along with a userland library that 
allows us to reconfigure our hardware paths in order to create those 
virtual subdevices and then expose them with the Media Controller/V4L2 
subdev api.

I have tried to bring the topic up on the  v4l irc because it is a 
complicated matter. I will try again.

There may be a better way to handle such a complicated video controller, 
but I haven't found it yet. If you have any idea, I am totally open to 
reconsider the path we are taking.

In the end, it would be possible to handle each hardware block as an 
independant subdev or input/output as long as we would be able to create 
links with the media api but 2 considerations make it easier to do what 
we are currently doing :
-> In our applications, most of the hardware paths between the blocks 
won't move at runtime, just a few links would have to be reconfigured at 
runtime which could be exposed with the media api.
-> We already have a low level api that allows us to handle the creation 
of a hardware block that provide a list of capabilities.

Thank you,
Julien
