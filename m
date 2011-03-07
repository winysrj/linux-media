Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60568 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab1CGMGQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2011 07:06:16 -0500
Received: by wyg36 with SMTP id 36so4047038wyg.19
        for <linux-media@vger.kernel.org>; Mon, 07 Mar 2011 04:06:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D74C82A.9050406@redhat.com>
References: <201102171606.58540.laurent.pinchart@ideasonboard.com>
	<201103051402.34416.laurent.pinchart@ideasonboard.com>
	<4D727F64.7040805@redhat.com>
	<201103052148.06603.laurent.pinchart@ideasonboard.com>
	<4D74C82A.9050406@redhat.com>
Date: Mon, 7 Mar 2011 14:06:13 +0200
Message-ID: <AANLkTikYvi64V3bmYx=jn3JwvznQ6WT6YM4EmQjzO4ym@mail.gmail.com>
Subject: Re: [GIT PULL FOR 2.6.39] Media controller and OMAP3 ISP driver
From: David Cohen <dacohen@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org,
	Sakari Ailus <sakari.ailus@retiisi.org.uk>,
	Pawel Osciak <pawel@osciak.com>
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Mar 7, 2011 at 1:57 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 05-03-2011 17:48, Laurent Pinchart escreveu:
>> Hi Mauro,

Hi Mauro,

>>
>> On Saturday 05 March 2011 19:22:28 Mauro Carvalho Chehab wrote:
>>> Em 05-03-2011 10:02, Laurent Pinchart escreveu:
>>>> Hi Mauro,
>>>>
>>>> Thanks for the review. Let me address all your concerns in a single mail.
>>>>
>>>> - ioctl numbers
>>>>
>>>> I'll send you a patch that reserves a range in Documentation/ioctl/ioctl-
>>>> number.txt and update include/linux/media.h accordingly.
>>>
>>> Ok, thanks.
>>
>> "media: Pick a free ioctls range" at the top of the
>> http://git.linuxtv.org/pinchartl/media.git?a=shortlog;h=refs/heads/media-2.6.39-0005-
>> omap3isp branch
>
> Added in the end of my quilt series.
>>
>>>> - private ioctls
>>>>
>>>> As already explained by David, the private ioctls are used to control
>>>> advanced device features that can't be handled by V4L2 controls at the
>>>> moment (such as setting a gamma correction table). Using those ioctls is
>>>> not mandatory, and the device will work correctly without them (albeit
>>>> with a non optimal image quality).
>>>>
>>>> David said he will submit a patch to document the ioctls.
>>>
>>> Ok.
>>
>> Working on that.
>
> Laurent/David, any news on that?

Yes. Sakari has written a first documentation and I'm complementing
with statistic's specific usage information.

Regards,

David
