Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bcode.com ([150.101.204.108]:27610 "EHLO mail.bcode.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751484AbZFCE3X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jun 2009 00:29:23 -0400
Date: Wed, 3 Jun 2009 14:13:50 +1000
From: Erik de Castro Lopo <erik@bcode.com>
To: linux-media@vger.kernel.org
Subject: Creating a V4L driver for a USB camera
Message-Id: <20090603141350.04cde59b.erik@bcode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I'm a senior software engineer [0] with a small startup. Our product
is Linux based and makes use of a 3M pixel camera. Unfortunately, the
camera we have been using for the last 3 years is no longer being
produced.

We have found two candidate replacement cameras, one with a binary
only driver and user space library and one with a windows driver
but no Linux driver.

My questions:

 - How difficult is it to create a GPL V4L driver for a USB camera
   by snooping the USB traffic of the device when connected to
   a windows machine? The intention is to merge this work into
   the V4L mainline and ultimately the kernel.

 - How much work is involved in the above for someone experienced
   in writing V4L drivers?

 - Are there people involved with the V4L project that would be
   willing to undertake this project under contract?

Obviously, answers to the last question can be send directly to
me :-). The others are probably best sent to the list.

Cheers,
Erik

[0] I am also a FOSS developer. My main two projects are
       http://www.mega-nerd.com/libsndfile/
       http://www.mega-nerd.com/libsamplerate/
    I am also involved with Xiph.org and the Debian project.
-- 
=======================
erik de castro lopo
senior design engineer

bCODE
level 2, 2a glen street
milsons point
sydney nsw 2061
australia

tel +61 (0)2 9954 4411
fax +61 (0)2 9954 4422
www.bcode.com
