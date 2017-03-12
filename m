Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34902 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935105AbdCLR47 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Mar 2017 13:56:59 -0400
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
To: Russell King - ARM Linux <linux@armlinux.org.uk>
References: <a7b8e095-a95c-24bd-b1e9-e983f18061c4@xs4all.nl>
 <20170310120902.1daebc7b@vento.lan>
 <5e1183f4-774f-413a-628a-96e0df321faf@xs4all.nl>
 <20170311101408.272a9187@vento.lan>
 <20170311153229.yrdjmggb3p2suhdw@ihha.localdomain>
 <acfb5eca-ff00-6d57-339a-3322034cbdb3@gmail.com>
 <20170311184551.GD21222@n2100.armlinux.org.uk>
 <1f1b350a-5523-34bc-07b7-f3cd2d1fd4c1@gmail.com>
 <20170311185959.GF21222@n2100.armlinux.org.uk>
 <4917d7fb-2f48-17cd-aa2f-d54b0f19ed6e@gmail.com>
 <20170312073745.GI21222@n2100.armlinux.org.uk>
Cc: mark.rutland@arm.com, andrew-ct.chen@mediatek.com,
        minghsiu.tsai@mediatek.com, nick@shmanahar.org,
        songjun.wu@microchip.com, Hans Verkuil <hverkuil@xs4all.nl>,
        pavel@ucw.cz, shuah@kernel.org, devel@driverdev.osuosl.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, robert.jarzmik@free.fr,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        geert@linux-m68k.org, p.zabel@pengutronix.de,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de, arnd@arndb.de, tiffany.lin@mediatek.com,
        bparrot@ti.com, robh+dt@kernel.org, horms+renesas@verge.net.au,
        mchehab@kernel.org, linux-arm-kernel@lists.infradead.org,
        niklas.soderlund+renesas@ragnatech.se, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
        jean-christophe.trotin@st.com, sakari.ailus@linux.intel.com,
        fabio.estevam@nxp.com, shawnguo@kernel.org,
        sudipm.mukherjee@gmail.com
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <fba73c10-4b95-f0d2-e681-0b14ef1fbc1c@gmail.com>
Date: Sun, 12 Mar 2017 10:56:53 -0700
MIME-Version: 1.0
In-Reply-To: <20170312073745.GI21222@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/11/2017 11:37 PM, Russell King - ARM Linux wrote:
> On Sat, Mar 11, 2017 at 07:31:18PM -0800, Steve Longerbeam wrote:
>>
>>
>> On 03/11/2017 10:59 AM, Russell King - ARM Linux wrote:
>>> On Sat, Mar 11, 2017 at 10:54:55AM -0800, Steve Longerbeam wrote:
>>>>
>>>>
>>>> On 03/11/2017 10:45 AM, Russell King - ARM Linux wrote:
>>>>> I really don't think expecting the user to understand and configure
>>>>> the pipeline is a sane way forward.  Think about it - should the
>>>>> user need to know that, because they have a bayer-only CSI data
>>>>> source, that there is only one path possible, and if they try to
>>>>> configure a different path, then things will just error out?
>>>>>
>>>>> For the case of imx219 connected to iMX6, it really is as simple as
>>>>> "there is only one possible path" and all the complexity of the media
>>>>> interfaces/subdevs is completely unnecessary.  Every other block in
>>>>> the graph is just noise.
>>>>>
>>>>> The fact is that these dot graphs show a complex picture, but reality
>>>>> is somewhat different - there's only relatively few paths available
>>>>> depending on the connected source and the rest of the paths are
>>>>> completely useless.
>>>>>
>>>>
>>>> I totally disagree there. Raw bayer requires passthrough yes, but for
>>>> all other media bus formats on a mipi csi-2 bus, and all other media
>>>> bus formats on 8-bit parallel buses, the conersion pipelines can be
>>>> used for scaling, CSC, rotation, and motion-compensated de-interlacing.
>>>
>>> ... which only makes sense _if_ your source can produce those formats.
>>> We don't actually disagree on that.
>>
>> ...and there are lots of those sources! You should try getting out of
>> your imx219 shell some time, and have a look around! :)
>
> If you think that, you are insulting me.  I've been thinking about this
> from the "big picture" point of view.  If you think I'm only thinking
> about this from only the bayer point of view, you're wrong.

No insult there, you have my utmost respect Russel. Me gives you the
Ali-G "respec!" :)

It was just a light-hearted attempt at suggesting you might be too
entangled with the imx219 (or short on hardware access, which I can
certainly understand).


>
> Given what Mauro has said, I'm convinced that the media controller stuff
> is a complete failure for usability, and adding further drivers using it
> is a mistake.
>

I do agree with you that MC places a lot of burden on the user to
attain a lot of knowledge of the system's architecture. That's really
why I included that control inheritance patch, to ease the burden
somewhat.

On the other hand, I also think this just requires that MC drivers have
very good user documentation.

And my other point is, I think most people who have a need to work with
the media framework on a particular platform will likely already be
quite familiar with that platform.

> I counter your accusation by saying that you are actually so focused on
> the media controller way of doing things that you can't see the bigger
> picture here.
>

Yeah I've been too mired in the details of this driver.


> So, tell me how the user can possibly use iMX6 video capture without
> resorting to opening up a terminal and using media-ctl to manually
> configure the pipeline.  How is the user going to control the source
> device without using media-ctl to find the subdev node, and then using
> v4l2-ctl on it.  How is the user supposed to know which /dev/video*
> node they should be opening with their capture application?

The media graph for imx6 is fairly self-explanatory in my opinion.
Yes that graph has to be generated, but just with a simple 'media-ctl
--print-dot', I don't see how that is difficult for the user.

The graph makes it quite clear which subdev node belongs to which
entity.

As for which /dev/videoX node to use, I hope I made it fairly clear
in the user doc what functions each node performs. But I will review
the doc again and make sure it's been made explicitly clear.


>
> If you can actually respond to the points that I've been raising about
> end user usability, then we can have a discussion.

Right, I haven't added my input to the middle-ware discussions (libv4l,
v4lconvert, and the auto-pipeline-configuration library work). I can
only say at this point that v4lconvert does indeed sound broken w.r.t
bayer formats from your description. But it also sounds like an isolated
problem and it just needs a patch to allow passing bayer through without
software conversion.

I wish I had the IMX219 to help you debug these bayer issues. I don't
have any bayer sources.

In summary, I do like the media framework, it's a good abstraction of
hardware pipelines. It does require a lot of system level knowledge to
configure, but as I said that is a matter of good documentation.

Steve
