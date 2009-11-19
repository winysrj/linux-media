Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:45372 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147AbZKSQQC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2009 11:16:02 -0500
Date: Thu, 19 Nov 2009 17:16:02 +0100 (CET)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Pedro Andres Aranda Gutierrez <paaguti@gmail.com>
cc: linux-media@vger.kernel.org
Subject: Re: PATCH: better support for INTUIX DVB stick boot
In-Reply-To: <f85a7aa40909300017m217cbb03p433dbd2e715f001b@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.0911191715330.12734@pub2.ifh.de>
References: <f85a7aa40909300017m217cbb03p433dbd2e715f001b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wed, 30 Sep 2009, Pedro Andres Aranda Gutierrez wrote:
> I have a INTUIX/LITEON DVB USB adapter. It boots correctly, but no
> frontend is attached.
> The following patch corrects this behaviour:
> [..]
>
>
> Since a couple of years ago, when I bought the stick, I have been
> using this alternative patch,
> which has not made it to the kernel, apparently because it introduced
> this 1 second delay

Applied, thanks.

--

Patrick
http://www.kernellabs.com/
