Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44089 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab1LaLy6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 06:54:58 -0500
Received: by eaad14 with SMTP id d14so7064045eaa.19
        for <linux-media@vger.kernel.org>; Sat, 31 Dec 2011 03:54:57 -0800 (PST)
Message-ID: <4EFEF806.8030602@gmail.com>
Date: Sat, 31 Dec 2011 12:54:46 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Luca Risolia <luca.risolia@studio.unibo.it>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 1/4] V4L: Add JPEG compression control class
References: <4EBECD11.8090709@gmail.com> <1325015011-11904-1-git-send-email-snjw23@gmail.com> <1325015011-11904-2-git-send-email-snjw23@gmail.com> <20111230214225.GB3677@valkosipuli.localdomain>
In-Reply-To: <20111230214225.GB3677@valkosipuli.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 12/30/2011 10:42 PM, Sakari Ailus wrote:
> Hi Sylwester,
> 
> On Tue, Dec 27, 2011 at 08:43:28PM +0100, Sylwester Nawrocki wrote:
> ...
>> +#define	V4L2_CID_JPEG_ACTIVE_MARKERS		(V4L2_CID_JPEG_CLASS_BASE + 4)
> 
> Just a few comments. I like the approach, and I'd just remove the 'S' from
> the CID name.

Thanks for your review. Ok, I'll make it singular form. I was going back and forth
with that, and in last minute even forgot to make it consistent in the DocBook
patches.

I think we need to also redesign VIDIOC_S/G_JPEGCOMP ioctls, to support
quantization
and Huffman tables setup. My idea was to firstly add the controls support in
drivers,
let some time for application to start using them (1 year or so), then remove
VIDIOC_S/G_JPEGCOMP support from drivers in question. Finally having very few
drivers
and applications using VIDIOC_S/G_JPEGCOMP we could deprecate those ioctls and add
new ones.
As of now only two drivers are using S/G_JPEGCOMP for anything else than image
quality
and the markers, with gspca being main user.

-- 

Thanks,
Sylwester
