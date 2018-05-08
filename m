Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51620 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932234AbeEHK0X (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2018 06:26:23 -0400
Date: Tue, 8 May 2018 07:26:17 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCHv13 00/28] Request API
Message-ID: <20180508072617.66906dcc@vento.lan>
In-Reply-To: <20180503145318.128315-1-hverkuil@xs4all.nl>
References: <20180503145318.128315-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu,  3 May 2018 16:52:50 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>

> Regarding locking:
> 
> There are two request locks used: req_queue_mutex (part of media_device)
> ensures high-level serialization of queueing/reiniting and canceling
> requests. It serializes STREAMON/OFF, TRY/S_EXT_CTRLS, close() and
> MEDIA_REQUEST_IOC_QUEUE. This is the top-level lock and should be taken
> before any others.

Why it doesn't serialize poll()? 

> The lock spin_lock in struct media_request protects that structure and
> should be held for a short time only.
> 
> Note that VIDIOC_QBUF does not take this mutex: when
> a buffer is queued for a request it will add it to the
> request by calling media_request_object_bind(), and that returns an
> error if the request is in the wrong state. It is serialized via the
> spin_lock which in this specific case is sufficient.

It looks weird that some syscalls are not serialized. By not having
poll() and VIDIOC_QBUF serialized, I'm wandering if playing with
them and close() on separate threads won't cause bad locking. 

Thanks,
Mauro
