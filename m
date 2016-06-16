Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:35515 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbcFPJ33 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 05:29:29 -0400
Date: Thu, 16 Jun 2016 11:29:26 +0200
From: Max Kellermann <max@duempel.org>
To: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] drivers/media/media-device: fix double free bug in
 _unregister()
Message-ID: <20160616092926.GA1333@swift.blarg.de>
References: <146602170216.9818.6967531646383934202.stgit@woodpecker.blarg.de>
 <146602171226.9818.8828702464432665144.stgit@woodpecker.blarg.de>
 <5761BB4A.9040309@osg.samsung.com>
 <20160615203753.GA30666@swift.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160615203753.GA30666@swift.blarg.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(Shuah, I did not receive your second reply; I only found it in an
email archive.)

> Yes media_devnode_create() creates the interfaces links and these
> links are deleted by media_devnode_remove().
> media_device_unregister() still needs to delete the interfaces
> links. The reason for that is the API dynalic use-case.
> 
> Drivers (other than dvb-core and v4l2-core) can create and delete
> media devnode interfaces during run-time

My point was that they do not.  There are no other
media_devnode_create() callers.

> So removing kfree() from media_device_unregister() isn't the correct
> fix.

Then what is?  I don't know anything other than the (mostly
undocumented) code I read, and my patch implements the design that I
interpreted from the code.  Apparently my interpretation of the design
is wrong after all.

> I don't see the stack trace for the double free error you are
> seeing?

Actually, it didn't crash at the double free; it hung forever because
it tried to lock a mutex which was already stale.  I don't have a
stack trace of that; would it help to produce one?

> Could it be that there is a driver problem in the order in which it
> is calling media_device_unregister()?

Maybe it's due to my patch 1/3 which adds a kref, and it only occurs
if one process still has a file handle.

In any case, the kernel must decide who's responsible for freeing the
object, and how the dvbdev.c library gets to know that its pointer has
been invalidated.

Please explain how it should be done, and I'll try to adapt my patches
to the "grand design".
