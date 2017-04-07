Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out4.electric.net ([192.162.216.186]:59024 "EHLO
        smtp-out4.electric.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933892AbdDGOFG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Apr 2017 10:05:06 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: 'Mauro Carvalho Chehab' <mchehab@s-opensource.com>,
        "Linux Media Mailing List" <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David Mosberger" <davidm@egauge.net>,
        Jaejoong Kim <climbbb.kim@gmail.com>,
        "Oliver Neukum" <oneukum@suse.com>, Roger Quadros <rogerq@ti.com>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH v3] usb: document that URB transfer_buffer should be
 aligned
Date: Fri, 7 Apr 2017 14:04:39 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6DCFFC88A1@AcuExch.aculab.com>
References: <2ed1abe0e72e0e19ea8b1478f5438f2e24480731.1491399808.git.mchehab@s-opensource.com>
In-Reply-To: <2ed1abe0e72e0e19ea8b1478f5438f2e24480731.1491399808.git.mchehab@s-opensource.com>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab
> Sent: 05 April 2017 14:53
> Several host controllers, commonly found on ARM, like dwc2,
> require buffers that are CPU-word aligned for they to work.
> 
> Failing to do that will cause buffer overflows at the caller
> drivers, with could cause data corruption.
> 
> Such data corruption was found, in practice, with the uvcdriver.
> 
> Document it.

How does this in any way solve the problem.

Ethernet frames will be misaligned, however hard it may be
the usb drivers will have to handle it.

	David
