Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:51705 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760022AbZLQVer convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2009 16:34:47 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
	"Nori, Sekhar" <nsekhar@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Thu, 17 Dec 2009 15:34:44 -0600
Subject: RE: [PATCH - v1 2/6] V4L - vpfe capture - Adding DM365 ISIF driver
 - header files
Message-ID: <A69FA2915331DC488A831521EAE36FE401625D150C@dlee06.ent.ti.com>
References: <1260464429-10537-1-git-send-email-m-karicheri2@ti.com>
 <1260464429-10537-2-git-send-email-m-karicheri2@ti.com>
 <200912150846.23593.hverkuil@xs4all.nl>
In-Reply-To: <200912150846.23593.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

Thanks for reviewing this.

>
>> +/* isif float type S8Q8/U8Q8 */
>> +struct isif_float_8 {
>> +	/* 8 bit integer part */
>> +	__u8 integer;
>> +	/* 8 bit decimal part */
>> +	__u8 decimal;
>
>Why __u8 instead of u8? This is a kernel-internal file, so it does not need
>to use the '__' variants.
>
This is a public header available for configuring the isif ip blocks such
as black clamp, defect correction, linearization etc. In future once
sub devices have its own node, application will direct the ioctls to
the sub device node. But as of now, it is going through video node.
I can think of splitting this into 2 files, isif.h that contains the
kernel part and isif-ioctl.h that will have structure and types for ioctls.
But for DM355 & DM644x ccdc, this is how it is done.

>If this needs to be publicly available, then it should be in include/linux.
Currently all of dm355 and dm644x header files for user space use are
under include/media/davinci. To me it makes sense since only davinci
specific applications will ever need to include them. I know you have
ivtv.h under linux/. So also several user space header files under
include/media and include/video. So not sure if there is a strict
rule that is followed. 

To a different note, Vaibhav had sent a patch for re-arranging the
driver files in a different folder to allow re-use of drivers
across DaVinci/OMAP devices. The proposal was to move all of TI
driver source files to

drivers/media/video/ti-media

and include files to
include/media/ti-media

What you think about this proposal? So at this point, shall we keep
it in it's current location?

>The comment before each shift define seems rather pointless.
>
>> +	/* Data shift applied before storing to SDRAM */
>> +	__u8 data_shift;
>> +	/* enable input test pattern generation */
>> +	__u8 test_pat_gen;
>> +};
>> +
>> +#ifdef __KERNEL__
>
>Hmm. Is this header supposed to be public or private to the kernel?
>

Actually it has both as is the case with dm355 & dm644x ccdc headers.
Do you want me to split the headers as suggested earlier?

Thanks

Murali
