Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:56271 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752808AbcCMTep (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Mar 2016 15:34:45 -0400
Subject: Re: Fwd: Re: tw68 fails with motion package running more than 4
 cameras on 8 channel card
To: Tony IBM-MAIN <v1i9v6a6@gmail.com>, linux-media@vger.kernel.org
References: <56E57B89.70406@gmail.com> <56E57C01.8070906@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56E5C0CC.3070908@xs4all.nl>
Date: Sun, 13 Mar 2016 20:34:36 +0100
MIME-Version: 1.0
In-Reply-To: <56E57C01.8070906@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/13/2016 03:41 PM, Tony IBM-MAIN wrote:
> Hans,
> 
> Sorry for the long delay in responding. Only just got around to testing
> qv4l2.
> 
> All was well with qv4l2 on 4 camera's each capturing 25fps. Then when I
> activated the 5th camera it all went pear shaped.
> One camera dies, the image on its screen freezes on the last good frame.
> All the other cameras get corrupt screens like line sync is missing.
> Horizontal lines everywhere. See
> http://www.doom.talktalk.net/2016-03-13-124047_1152x864_scrot.png.
> 
> I have seen this effect 4 years ago using zoneminder. I had two camera
> working fine in zoneminder with motion detect recording. Adding two more
> caused the effect in the screen capture. Eventually I put it down to
> Zoneminder being very CPU hungry event at the lowest framerate. I
> switched to motion and it would happily run motion detect on 6 cameras
> using about 15% on one CPU (Dual core AMD Athlon(tm) II X2 270u
> Processor 1600Mhz). Both zoneminder and motion were using the same old
> tw68 module from github.

I think I know what the problem is. The default pixelformat that the driver
choses is RGB24 (3 bytes per pixel). One stream of 720x576p25 then takes
30 MB/s, so 5 streams is 150 MB/s which is more than the max bandwidth of
a PCI device (133 MB/s).

I suspect that the default format of the old driver was probably YUYV, which
is only 20 MB/s, so 120 MB/s for 6 streams.

The solution would be to set the format to YUYV before streaming. I don't
know if that's possible with the software you're using, but you can always
use qv4l2 or v4l2-ctl (v4l2-ctl -d /dev/videoX -v pixelformat=YUYV) for this.

Another option is to scale down the image and reduce the bandwidth that
way.

> I have set up motion to capture at a relative low 2fps, it is all I
> need. Can I set qv4l2 to capture at a lower rate to see if it resolves
> the problem?

No, that's not possible. But changing the format to YUYV should fix the
issue for you.

Regards,

	Hans
