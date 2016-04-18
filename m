Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:38645 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751382AbcDRHY0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2016 03:24:26 -0400
Subject: Re: [PATCH 1/2] [media] atmel-isc: add the Image Sensor Controller
 code
To: Songjun Wu <songjun.wu@atmel.com>, g.liakhovetski@gmx.de,
	nicolas.ferre@atmel.com
References: <1460533460-32336-1-git-send-email-songjun.wu@atmel.com>
 <1460533460-32336-2-git-send-email-songjun.wu@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Benoit Parrot <bparrot@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	=?UTF-8?Q?Richard_R=c3=b6jfors?= <richard@puffinpack.se>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <57148B9E.2000609@xs4all.nl>
Date: Mon, 18 Apr 2016 09:24:14 +0200
MIME-Version: 1.0
In-Reply-To: <1460533460-32336-2-git-send-email-songjun.wu@atmel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/13/2016 09:44 AM, Songjun Wu wrote:
> Add driver for the Image Sensor Controller. It manages
> incoming data from a parallel based CMOS/CCD sensor.
> It has an internal image processor, also integrates a
> triple channel direct memory access controller master
> interface.
> 
> Signed-off-by: Songjun Wu <songjun.wu@atmel.com>

Hi Songjun,

Before this driver can be accepted it has to pass the v4l2-compliance test.
The v4l2-compliance utility is here:

git://linuxtv.org/v4l-utils.git

Compile the utility straight from this repository so you're up to date.

First fix any failures you get when running 'v4l2-compliance', then do the
same when running 'v4l2-compliance -s' (now it is streaming as well) and
finally when running 'v4l2-compliance -f' (streaming and testing all available
formats).

I would like to see the output of 'v4l2-compliance -f' as part of the cover
letter of the next patch series.

Looking at the code I see that it will definitely fail a few tests :-)

Certainly the VIDIOC_CREATE_BUFS support in the queue_setup function is missing.
Read the comments for queue_setup in videobuf2-core.h for more information.

Regards,

	Hans
