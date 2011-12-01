Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:43434 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755746Ab1LARlv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Dec 2011 12:41:51 -0500
MIME-Version: 1.0
In-Reply-To: <20111201161407.GK29805@valkosipuli.localdomain>
References: <1322698500-29924-1-git-send-email-saaguirre@ti.com> <20111201161407.GK29805@valkosipuli.localdomain>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Thu, 1 Dec 2011 11:41:29 -0600
Message-ID: <CAKnK67RiuuFDutRT-BWGOhCy8aQtfk=RGRdqdt6kGg63qeYyew@mail.gmail.com>
Subject: Re: [PATCH v2 00/11] v4l2: OMAP4 ISS driver + Sensor + Board support
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thu, Dec 1, 2011 at 10:14 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Sergio,
>
> Thanks for the patchset!!

And thanks for your attention :)

>
> On Wed, Nov 30, 2011 at 06:14:49PM -0600, Sergio Aguirre wrote:
>> Hi everyone,
>>
>> This is the second version of the OMAP4 ISS driver,
>> now ported to the Media Controller framework AND supporting
>> videobuf2 framework.
>>
>> This patchset should apply cleanly on top of v3.2-rc3 kernel tag.
>>
>> This driver attempts to provide an fully open source solution to
>> control the OMAP4 Imaging SubSystem (a.k.a. ISS).
>>
>> Starts with just CSI2-A interface support, and pretends to be
>> ready for expansion to add support to the many ISS block modules
>> as possible.
>>
>> Please see newly added documentation for more details:
>>
>> Documentation/video4linux/omap4_camera.txt
>
> I propose s/omap4_camera/omap4iss/, according to the path name in the
> drivers/media/video directory.

Makes sense. Will fix.

>
>> Any comments/complaints are welcome. :)
>>
>> Changes since v1:
>> - Simplification of auxclk handling in board files. (Pointed out by: Roger Quadros)
>> - Cleanup of Camera support enablement for 4430sdp & panda. (Pointed out by: Roger Quadros)
>> - Use of HWMOD declaration for assisted platform_device creation. (Pointed out by: Felipe Balbi)
>> - Videobuf2 migration (Removal of custom iss_queue buffer handling driver)
>
> I'm happy to see it's using videobuf2!

Yeah, I'll definitely need it for multi-planar buffer handling for
NV12 buffer capturing.

Resizer can color convert from YUV422->YUV420 NV12 now, and expects 2 pointers
(1 for Y, and 1 for UV 2x2 sampled) to be programmed in HW.

>
> I have no other comments quite yet. :-)

Ok, let me know if you find something eye-popping ugly in there. I'll
be happy to fix it. :)

Thanks and Regards,
Sergio

>
> Cheers,
>
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     jabber/XMPP/Gmail: sailus@retiisi.org.uk
