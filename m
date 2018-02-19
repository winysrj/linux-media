Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:43321 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750978AbeBSN6o (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 08:58:44 -0500
Date: Mon, 19 Feb 2018 14:58:40 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
cc: =?ISO-8859-15?Q?Alexandre-Xavier_Labont=E9-Lamoureux?=
        <axdoomer@gmail.com>, linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Bug: Two device nodes created in /dev for a single UVC webcam
In-Reply-To: <dd70c226-e7db-e55e-e467-a6b0d1e7849d@ideasonboard.com>
Message-ID: <alpine.DEB.2.20.1802191456110.8694@axis700.grange>
References: <CAKTMqxtRQvZqZGQ0oWSf79b3ZGs6Stpctx9yqi8X1Myq-CY2JA@mail.gmail.com> <dd70c226-e7db-e55e-e467-a6b0d1e7849d@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Mon, 19 Feb 2018, Kieran Bingham wrote:

> Hi Alexandre,
> 
> Thankyou for your bug report,
> 
> On 17/02/18 20:47, Alexandre-Xavier Labonté-Lamoureux wrote:
> > Hi,
> > 
> > I'm running Linux 4.9.0-5-amd64 on Debian. I built the drivers from
> > the latest git and installed the modules.
> 
> Could you please be specific here?
> 
> Are you referring to linux-media/master branch or such? The latest from Linus' tree?
> 
> Please also detail the steps you have taken to reproduce this issue - and of
> course - if you have made any code changes to make the latest UVC module compile
> against a v4.9 kernel...
> 
> Building the latest git tree and installing as a module on a v4.9 kernel is
> quite a leap... I wouldn't have expected that to work.
> 
> The code would have to be compiled against a v4.9 kernel directly, and I didn't
> think compiling the UVC driver against older kernels worked.
> 
> (at least it didn't work cleanly when I tried to compile v4.15 against a v4.14
> kernel last month)
> 
> > Now, two device nodes are
> > created for my webcam. This is not normal as it has never happened to
> > me before. If I connect another webcam to my laptop, two more device
> > nodes will be created for this webcam. So two new device nodes are
> > created for a single webcam.
> 
> I believe Guennadi's latest work for handling meta-data (in the latest v4.16-rc1
> I think) will create two device nodes.

That's correct. The lower index node (/dev/video0) is a video node, the 
higher videoo node (/dev/video1) is a metadata node.

> > The name of my webcam appears twice in the device comobox in Guvcview
> > because of this. One of them will not work if I select it.
> 
> It would be expected that only the device with video functions as a streaming
> camera device, while the other would not.

Exactly.

> > My webcam has completely stopped working with Cheese and VLC.
> 
> This part is of particular concern however.
> 
> Guennadi - Have you tested Cheese/VLC with your series?

Sure, with cheese you can specify which camera you need by using its 
--device= parameter. Eventually it's expected, that those programs will be 
updated to recognise metadata nodes and not attempt to use them.

Thanks
Guennadi

> Are there any known issues that need looking at ?
> 
> >> v4l2-ctl --list-devices
> > Laptop_Integrated_Webcam_E4HD:  (usb-0000:00:1a.0-1.5):
> >     /dev/video0
> >     /dev/video1
> > 
> >> ls /dev/video*
> > /dev/video0  /dev/video1
> >
> > Have a nice day,
> > Alexandre-Xavier
> 
> Regards
> 
> Kieran Bingham
> 
> 
