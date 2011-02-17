Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx12.extmail.prod.ext.phx2.redhat.com
	[10.5.110.17])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id p1HJV2Ok031266
	for <video4linux-list@redhat.com>; Thu, 17 Feb 2011 14:31:02 -0500
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.171])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1HJUqgD010023
	for <video4linux-list@redhat.com>; Thu, 17 Feb 2011 14:30:52 -0500
Date: Thu, 17 Feb 2011 20:30:17 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Paolo Santinelli <paolo.santinelli@unimore.it>
Subject: Re: Kernel configuration for ov9655 on the PXA27x Quick Capture
	Interface
In-Reply-To: <AANLkTika03k=cppbejCHkuOT+Uq9ptVHZwYa80ubwLqT@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1102172029220.30692@axis700.grange>
References: <AANLkTika03k=cppbejCHkuOT+Uq9ptVHZwYa80ubwLqT@mail.gmail.com>
MIME-Version: 1.0
Cc: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: video4linux-list-bounces@redhat.com
Sender: <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

On Wed, 16 Feb 2011, Paolo Santinelli wrote:

> Hi all,
> 
> I have an embedded smart camera equipped with an XScal-PXA270
> processor running Linux 2.6.37 and the OV9655 Image sensor connected
> on the PXA27x Quick Capture Interface.
> 
> Please, what kernel module I have to select in order to use the Image sensor ?

You need to write a new or adapt an existing driver for your ov9655 
sensor, currently, there's no driver available to work with your pxa270.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
