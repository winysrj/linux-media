Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:35786 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750890AbdH3VXQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 17:23:16 -0400
Date: Wed, 30 Aug 2017 15:23:14 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH 1/2] docs: kernel-doc comments are ASCII
Message-ID: <20170830152314.0486fafb@lwn.net>
In-Reply-To: <54c23e8e-89c0-5cea-0dcc-e938952c5642@infradead.org>
References: <54c23e8e-89c0-5cea-0dcc-e938952c5642@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 28 Aug 2017 16:10:09 -0700
Randy Dunlap <rdunlap@infradead.org> wrote:

> kernel-doc parsing uses as ASCII codec, so let people know that
> kernel-doc comments should be in ASCII characters only.
> 
> WARNING: kernel-doc '../scripts/kernel-doc -rst -enable-lineno ../drivers/media/dvb-core/demux.h' processing failed with: 'ascii' codec can't decode byte 0xe2 in position 6368: ordinal not in range(128)

So I don't get this error.  What kind of system are you running the docs
build on?  I would really rather that the docs system could handle modern
text if possible, so it would be better to figure out what's going on
here...

Thanks,

jon
