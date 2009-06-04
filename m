Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:47426 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320AbZFDVai convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Jun 2009 17:30:38 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Laurent Pinchart <laurent.pinchart@skynet.be>,
	Kevin Hilman <khilman@deeprootsystems.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Date: Thu, 4 Jun 2009 16:30:16 -0500
Subject: RE: [PATCH 3/9] dm355 ccdc module for vpfe capture driver
Message-ID: <A69FA2915331DC488A831521EAE36FE4013557B51B@dlee06.ent.ti.com>
References: <1242412603-11390-1-git-send-email-m-karicheri2@ti.com>
 <A69FA2915331DC488A831521EAE36FE401354ECDB2@dlee06.ent.ti.com>
 <87y6sbo5mu.fsf@deeprootsystems.com>
 <200906041141.38255.laurent.pinchart@skynet.be>
In-Reply-To: <200906041141.38255.laurent.pinchart@skynet.be>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>
>> My first reaction to this is... no.  I'm reluctant to have a bunch of
>> driver specific hooks in the core davinci SoC specific code.  I'd much
>> rather see this stuff kept along with the driver in drivers/media/*
>> and abstracted as necessary there.
>
>I agree with Kevin on this. arch/* is mostly meant for platform-specific
>infrastructure code. Device drivers should go in drivers/*. The
>VPSS/VPFE/CCDC/... abstraction should live in drivers/media/video/*. SoC-
>specific code that can be shared between multiple drivers (I remember we
>discussed IRQ routing for instance) can go in arch/*.
>
[MK] yes. As per your definition vpss module registers are shared across all video drivers. So it appears it has to go in arch/*. But I am now more inclined to write a platform driver for vpss that live inside media/video/davinci/ and shall export a bunch of library functions shared across drivers. I will make this change and will send it as part of v2 version of the patch series...

