Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:38432 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbZKQQAK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 11:00:10 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 17 Nov 2009 10:00:07 -0600
Subject: RE: Help in adding documentation
Message-ID: <A69FA2915331DC488A831521EAE36FE401559C59A2@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After compilation I get the following error

Error: no ID for contstraint linkend: v4l2-dv-enum-presets.

v4l2-dv-enum-presets is the new structure type added. 


Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Karicheri, Muralidharan
>Sent: Tuesday, November 17, 2009 10:58 AM
>To: 'Mauro Carvalho Chehab'
>Cc: 'Hans Verkuil'; linux-media@vger.kernel.org
>Subject: Help in adding documentation
>
>Hi Mauro,
>
>Is there some instructions on adding new sections in the v4l2 documentation.
>I had been struggling yesterday to add my documentation for video timing
>API. It is easy to make minor documentation changes. But since I am adding
>new ioctls, Looks like I need to create vidioc-<xxx>.xml under DoCBook/v4l/
>directory since media-specs/Makefile is generating videodev2.h.xml
>automatically (I learned it in the hard way). I have added the IOCTL name
>in media-specs/Makefile and also added the structure name. But somehow, the
>videodev2.h.xml file doesn't show my structure types documented in vidioc-
><xxx>.xml. Any idea what could be wrong?
>
>Murali Karicheri
>Software Design Engineer
>Texas Instruments Inc.
>Germantown, MD 20874
>phone: 301-407-9583
>email: m-karicheri2@ti.com

