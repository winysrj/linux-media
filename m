Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:47977 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbZFDBOK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Jun 2009 21:14:10 -0400
Date: Wed, 3 Jun 2009 20:28:38 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Erik de Castro Lopo <erik@bcode.com>
cc: linux-media@vger.kernel.org,
	=?ISO-8859-15?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
Subject: Re: Creating a V4L driver for a USB camera
In-Reply-To: <20090604100110.c837c3df.erik@bcode.com>
Message-ID: <alpine.LNX.2.00.0906032014530.17538@banach.math.auburn.edu>
References: <20090603141350.04cde59b.erik@bcode.com> <62e5edd40906022318l230992b7n34e5178b7e1a7d46@mail.gmail.com> <20090604100110.c837c3df.erik@bcode.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-863829203-948493903-1244078919=:17538"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---863829203-948493903-1244078919=:17538
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT



On Thu, 4 Jun 2009, Erik de Castro Lopo wrote:

> On Wed, 3 Jun 2009 16:18:33 +1000
> Erik Andrén <erik.andren@gmail.com> wrote:
>
>> Do you have any datasheet available on what usb bridge / sensor that is used?
>
> The USB device itself comes up as :
>
>    Bus 001 Device 011: ID 0547:8031 Anchor Chips, Inc
>
> The sensor is a Micron MT9T001P12STC and I have the data sheet for it.
>
> I've asked the manufacturer for source code to the windows driver
> and docs/source/whatever for the USB interface.
>
>> If the chipsets are undocumented and some proprietary image
>> compression technique is used, the time to reverse-engineer them can
>> be quite lengthy.
>
> I happen to know that the sensor/camera (via the windows driver) can
> provide raw bayer data which is what I'm after (our application is
> machine vision and bayer works best).
>
> Cheers,
> Erik

If this is the case, then it ought not to be terribly difficult to write a 
basic driver. If you wanted still camera support, with which I have a bit 
more experience than with streaming support, I would say it would take me 
about a week or so. The real obstacle is proprietary data compression 
which is usually totally undocumented, as others have already said.

Of course, I said above "basic" driver. That does not include things like 
color balance, contrast, or brightness controls. Such would probably take 
a little bit longer.

>From what I read here, I think you will have good luck if you follow 
through with this project.


Theodore Kilgore

(Greetings from the monthly meeting of the East Alabama LUG)
---863829203-948493903-1244078919=:17538--
