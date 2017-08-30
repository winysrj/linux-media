Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:35836 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750860AbdH3VYb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 17:24:31 -0400
Date: Wed, 30 Aug 2017 15:24:30 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 2/2] media: dvb-core: fix demux.h non-ASCII characters
Message-ID: <20170830152430.068b13ce@lwn.net>
In-Reply-To: <5fb15c64-e376-f461-8a7c-d0c6776870c9@infradead.org>
References: <5fb15c64-e376-f461-8a7c-d0c6776870c9@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 28 Aug 2017 16:10:16 -0700
Randy Dunlap <rdunlap@infradead.org> wrote:

> Fix non-ASCII charactes in kernel-doc comment to prevent the kernel-doc
> build warning below.
> 
> WARNING: kernel-doc '../scripts/kernel-doc -rst -enable-lineno ../drivers/media/dvb-core/demux.h' processing failed with: 'ascii' codec can't decode byte 0xe2 in position 6368: ordinal not in range(128)

I'll leave this one for Mauro to decide on.  My inclination would be to
apply it, though, my previous comments on handling non-ASCII text
notwithstanding.  The weird quotes don't buy us anything here.

Thanks,

jon
