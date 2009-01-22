Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:35847 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbZAVJi6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2009 04:38:58 -0500
Message-ID: <49783E77.7070303@nokia.com>
Date: Thu, 22 Jan 2009 11:37:59 +0200
From: Sakari Ailus <sakari.ailus@nokia.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	"Nagalla, Hari" <hnagalla@ti.com>
Subject: Re: [REVIEW PATCH 01/14] V4L: Int if: Dummy slave
References: <A24693684029E5489D1D202277BE894416429F97@dlee02.ent.ti.com> <20090113183330.066d75e4@pedra.chehab.org>
In-Reply-To: <20090113183330.066d75e4@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> On Mon, 12 Jan 2009 20:03:08 -0600
> "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com> wrote:
> 
>> +static struct v4l2_int_slave dummy_slave = {
>> +	/* Dummy pointer to avoid underflow in find_ioctl. */
>> +	.ioctls = (void *)0x80000000,
> 
> Why are you using here a magic number?

Not really a reason. It could be or actually perhaps anything equal to
or bigger than sizeof(struct v4l2_int_ioctl_desc) so that last doesn't
underflow:

         const struct v4l2_int_ioctl_desc *first = slave->ioctls;
         const struct v4l2_int_ioctl_desc *last =
                 first + slave->num_ioctls - 1;

num_ioctls is zero. See find_ioctl in drivers/media/video/v4l2-int-device.c.

I guess that should be changed to sizeof(struct v4l2_int_ioctl_desc).

-- 
Sakari Ailus
sakari.ailus@nokia.com

