Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35251 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750939AbdAaXlh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 18:41:37 -0500
Subject: Re: [PATCH v3 20/24] media: imx: Add Camera Interface subdev driver
To: Russell King - ARM Linux <linux@armlinux.org.uk>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-21-git-send-email-steve_longerbeam@mentor.com>
 <b7456d40-040d-41b7-45bc-ef6709ab7933@xs4all.nl>
 <20170131134252.GX27312@n2100.armlinux.org.uk>
 <b0517394-7717-3e1d-b850-e2b69a9c19e9@gmail.com>
 <20170131203340.GC27312@n2100.armlinux.org.uk>
 <2297c62c-ae9b-3942-4700-ce268a61a6d5@gmail.com>
 <20170131220452.GE27312@n2100.armlinux.org.uk>
 <d5ede043-3b02-37f6-bd4a-db805e6b36d7@mentor.com>
 <20170131233042.GF27312@n2100.armlinux.org.uk>
Cc: Ian Arkver <ian.arkver.dev@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, nick@shmanahar.org,
        markus.heiser@darmarIT.de, p.zabel@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <bb05d5b0-7842-989c-55a5-4867a19a1883@gmail.com>
Date: Tue, 31 Jan 2017 15:41:14 -0800
MIME-Version: 1.0
In-Reply-To: <20170131233042.GF27312@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/31/2017 03:30 PM, Russell King - ARM Linux wrote:
> On Tue, Jan 31, 2017 at 02:36:53PM -0800, Steve Longerbeam wrote:
>> On 01/31/2017 02:04 PM, Russell King - ARM Linux wrote:
>>> I don't want master though, I want v4.10-rc1, and if I ask for that
>>> it tells me it knows nothing about v4.10-rc1, despite the fact that's
>>> a tag in the mainline kernel repository which was merged into the
>>> linux-media tree that this tree is based upon.
>> Hi Russell, yes git@github.com:slongerbeam/mediatree.git is a fork
>> of the linux-media tree, and the imx-media-staging-md-wip branch
>> is up-to-date with master, currently at 4.10-rc1.
> "up to date" is different from "contains other stuff other than is in
> 4.10-rc1".
>
> What I see in your tree is that your code is based off a merge commit
> between something called "patchwork" (which I assume is a branch in
> the media tree containing stuff commited from patch work) and v4.10-rc1.
>
> Now, you don't get a commit when merging unless there's changes that
> aren't in the commit you're merging - if "patchwork" was up to date
> with v4.10-rc1, then git would have done a "fast forward" to v4.10-rc1.
>
> Therefore, while it may be "up to date" with v4.10-rc1 in so far that
> it's had v4.10-rc1 merged into it, that's not what I've been saying.
> There are other changes below that merge commit which aren't in
> v4.10-rc1.  It's those other changes that I'm talking about, and it's
> those other changes I do not want without knowing what they are.
>
> It may be that those other changes have since been merged into
> v4.10-rc6 - but github's web interface can't show me that.  In fact,
> github's web interface is pretty damned useless as far as this stuff
> goes.
>
> So, what I'll get if I clone or pull your imx-media-staging-md-wip
> branch is, yes, a copy of all your changes, but _also_ all the
> changes that are in the media tree that _aren't_ in mainline at the
> point that v4.10-rc1 was merged.
>
>> You don't need to use the web interface, just git clone the repo.
> You're assuming I want to work off the top of your commits.  I don't.
> I've got other dependencies.

Well, I was suggesting cloning it just to have a look at the new
code, but I understand you don't want to attempt to bring in your
SMIA/bayer format changes and run from this branch, due to the
other changes in the mediatree.

I suppose I should post the next version then.

Trouble is, I see issues in the current driver that prevents working
with your SMIA pipeline. But I guess that will have to be worked out
in another version.

Steve

>
> Then there's yet another problem - lets say that I get a copy of your
> patches that haven't been on the mailing list, and I then want to make
> a comment about it.  I can't reply to a patch that hasn't been on the
> mailing list.  So, the long established mechanism by which the Linux
> community does patch review breaks down.
>
> So no, sorry, I'm not fetching your tree, and I will persist with your
> v3 patch set for the time being.
>

