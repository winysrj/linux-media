Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46829 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752798AbeBSNwO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 08:52:14 -0500
Subject: Re: Bug: Two device nodes created in /dev for a single UVC webcam
To: =?UTF-8?Q?Alexandre-Xavier_Labont=c3=a9-Lamoureux?=
        <axdoomer@gmail.com>, linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <CAKTMqxtRQvZqZGQ0oWSf79b3ZGs6Stpctx9yqi8X1Myq-CY2JA@mail.gmail.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <dd70c226-e7db-e55e-e467-a6b0d1e7849d@ideasonboard.com>
Date: Mon, 19 Feb 2018 13:52:04 +0000
MIME-Version: 1.0
In-Reply-To: <CAKTMqxtRQvZqZGQ0oWSf79b3ZGs6Stpctx9yqi8X1Myq-CY2JA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alexandre,

Thankyou for your bug report,

On 17/02/18 20:47, Alexandre-Xavier Labonté-Lamoureux wrote:
> Hi,
> 
> I'm running Linux 4.9.0-5-amd64 on Debian. I built the drivers from
> the latest git and installed the modules.

Could you please be specific here?

Are you referring to linux-media/master branch or such? The latest from Linus' tree?

Please also detail the steps you have taken to reproduce this issue - and of
course - if you have made any code changes to make the latest UVC module compile
against a v4.9 kernel...

Building the latest git tree and installing as a module on a v4.9 kernel is
quite a leap... I wouldn't have expected that to work.

The code would have to be compiled against a v4.9 kernel directly, and I didn't
think compiling the UVC driver against older kernels worked.

(at least it didn't work cleanly when I tried to compile v4.15 against a v4.14
kernel last month)

> Now, two device nodes are
> created for my webcam. This is not normal as it has never happened to
> me before. If I connect another webcam to my laptop, two more device
> nodes will be created for this webcam. So two new device nodes are
> created for a single webcam.

I believe Guennadi's latest work for handling meta-data (in the latest v4.16-rc1
I think) will create two device nodes.


> The name of my webcam appears twice in the device comobox in Guvcview
> because of this. One of them will not work if I select it.

It would be expected that only the device with video functions as a streaming
camera device, while the other would not.


> My webcam has completely stopped working with Cheese and VLC.

This part is of particular concern however.

Guennadi - Have you tested Cheese/VLC with your series?

Are there any known issues that need looking at ?

>> v4l2-ctl --list-devices
> Laptop_Integrated_Webcam_E4HD:  (usb-0000:00:1a.0-1.5):
>     /dev/video0
>     /dev/video1
> 
>> ls /dev/video*
> /dev/video0  /dev/video1
>
> Have a nice day,
> Alexandre-Xavier

Regards

Kieran Bingham
