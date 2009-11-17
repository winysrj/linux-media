Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:57559 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbZKQP5i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 10:57:38 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 17 Nov 2009 09:57:37 -0600
Subject: Help in adding documentation
Message-ID: <A69FA2915331DC488A831521EAE36FE401559C599E@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Is there some instructions on adding new sections in the v4l2 documentation. I had been struggling yesterday to add my documentation for video timing API. It is easy to make minor documentation changes. But since I am adding new ioctls, Looks like I need to create vidioc-<xxx>.xml under DoCBook/v4l/ directory since media-specs/Makefile is generating videodev2.h.xml automatically (I learned it in the hard way). I have added the IOCTL name in media-specs/Makefile and also added the structure name. But somehow, the videodev2.h.xml file doesn't show my structure types documented in vidioc-<xxx>.xml. Any idea what could be wrong?

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

