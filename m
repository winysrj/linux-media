Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB1CZ6YC018226
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 07:35:06 -0500
Received: from smtp-vbr4.xs4all.nl (smtp-vbr4.xs4all.nl [194.109.24.24])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB1CYkMR031520
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 07:34:46 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Trilok Soni" <soni.trilok@gmail.com>
Date: Mon, 1 Dec 2008 13:34:41 +0100
References: <5d5443650811280216r450c6f02v3fb0db2e1580594a@mail.gmail.com>
In-Reply-To: <5d5443650811280216r450c6f02v3fb0db2e1580594a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011334.41306.hverkuil@xs4all.nl>
Cc: v4l <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org Mailing List" <linux-omap@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@nokia.com>
Subject: Re: [PATCH] Add Omnivision OV9640 sensor support.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Friday 28 November 2008 11:16:20 Trilok Soni wrote:
> --
> ---Trilok Soni
> http://triloksoni.wordpress.com
> http://www.linkedin.com/in/triloksoni

Hi Trilok,

I reviewed this sensor driver and it's fine except for one thing: 
setting the default registers from outside the driver. This is a really 
bad idea. I2C drivers should be self-contained. I've made the same 
comment in the tvp514x driver review which I'm copying below (with some 
small edits):

This driver relies on an outside source to do the initialization of the 
registers. This is very much the wrong approach. It would require all 
platforms/master drivers that are going to use this chip to program the 
chip's registers. That's not the way to do it. The ov9640 driver should 
do this and the bridge driver should only pass high-level config data 
(such as with input/output pins are being used, signalling setup, 
whatever). This is how for example the Micron sensor mt* drivers do it. 
This approach means that all the relevant programming is inside the 
chip's driver and that bridge drivers can easily replace one chip for 
another since except for a little bit of initialization (usually 
routing, signalling setup) there is otherwise no difference between 
using one chip or another.

Remember that this is not a driver for use with omap, this is a generic 
i2c driver for this chip. omap just happens to be the only one using it 
right now, but that can easily change.

Yes, it makes it harder to write an i2c driver, but experience has shown 
us that the advantages regarding reuse far outweigh this initial cost.

I noticed that the tcm825x.c driver takes exactly the same wrong 
approach, BTW.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
