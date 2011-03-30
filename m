Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:49313 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932300Ab1C3L17 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Mar 2011 07:27:59 -0400
References: <201103301244.25272.hverkuil@xs4all.nl>
In-Reply-To: <201103301244.25272.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: RFC: polling for events triggers read() in videobuf2-core: how to resolve?
From: Andy Walls <awalls@md.metrocast.net>
Date: Wed, 30 Mar 2011 07:28:10 -0400
To: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Message-ID: <49c817fb-b644-4404-a34c-f703742871f1@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hans Verkuil <hverkuil@xs4all.nl> wrote:

>I've been working on control events and while doing that I encountered
>a
>V4L2 API problem.
>
>Currently calling select() without REQBUFS having been called first
>will
>assume that you want to read (or write for output devices) and it will
>start the DMA accordingly if supported by the driver.
>
>This is very nice for applications that want to use read (usually for
>MPEG
>encoders), since they don't need to do an intial read() to kickstart
>the
>DMA. It is also pretty much what you expect to happen.
>
>Unfortunately, this clashes with applications that just select on
>exceptions
>(like a control panel type application that just wants to get events
>when
>controls change value). Now a select() on an exception will cause the
>driver
>to start the DMA. Obviously not what you want.
>
>Ideally the driver's poll() implementation should check whether the
>user
>wanted to wait for input, output or exceptions. Unfortunately, that
>information
>is not in general passed to the driver (see the code in fs/select.c).
>
>I am not certain what to do. One option is that poll no longer can kick
>off
>a DMA action. Instead apps need to call read() or write() at least
>once. In
>that case a read/write count of 0 should be allowed: that way you can
>start
>the DMA without actually needing to read or write data.
>
>So apps can do a read(fd, buf, 0), then use poll afterwards to wait for
>data
>to arrive.
>
>I'm not sure whether this is OK or not.
>
>Another alternative would be to try and change the poll() op so that
>this
>information is actually passed to the driver. That's a rather painful
>alternative, though.
>
>Regards,
>
>	Hans
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Off the cuff:

When the stream is not started, just have the poll() method return ready for reading and/or writing.  For blocking fd's it is technically true, depending on how one defines "ready". 

If the fd is opened nonblocking, the first read() of DQBUF could return -EWOULDBLOCK, and schedule the stream to be started with a one-off work item.

Regards,
Andy 
