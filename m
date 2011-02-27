Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:59529 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486Ab1B0EHq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Feb 2011 23:07:46 -0500
Subject: Re: Request clarification on videobuf irqlock and vb_lock usage
From: Andy Walls <awalls@md.metrocast.net>
To: Ben Collins <benmcollins13@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <022EECA1-5416-4173-B435-348531BB5049@gmail.com>
References: <022EECA1-5416-4173-B435-348531BB5049@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Feb 2011 23:08:02 -0500
Message-ID: <1298779682.2423.10.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 2011-02-26 at 13:57 -0500, Ben Collins wrote:
> I'm trying to cleanup some deadlocks and random crashed in my v4l2
> driver (solo6x10) and I cannot find definitive documentation on that
> clear usage of irqlock and vb_lock in a driver that uses videobuf.

Here is the best documentation on videobuf(1) that I ever saw:
http://git.linuxtv.org/media_tree.git?a=blob;f=Documentation/video4linux/videobuf;h=17a1f9abf260f39a44dee35bf7b72a0c66fd71fc;hb=df37e8479875c486d668fdf5bf65dba41422dd76

And here is the bad news about videobuf(1):
http://linuxtv.org/downloads/presentations/summit_jun_2010/20100614-v4l2_summit-videobuf.pdf


Since videobuf2 in now in the bleeding edge kernel, you should look at
using it:

http://lwn.net/Articles/420512/

http://linuxtv.org/downloads/presentations/summit_jun_2010/Videobuf_Helsinki_June2010.pdf


Tonight, I've actually been xamining using videobuf2 for cx18 myself.


> When and where should I be using either of these to ensure I work synchronously with the videobuf-core?

Maybe the above briefs, that detail some of the problems with
videobuf(1), can provide some details on the semantics of them.  IIRC,
Pawel's brief highlighted that iolock was really overloaded.

Regards,
Andy

> --
> Bluecherry: http://www.bluecherrydvr.com/
> SwissDisk : http://www.swissdisk.com/
> Ubuntu    : http://www.ubuntu.com/
> My Blog   : http://ben-collins.blogspot.com/


