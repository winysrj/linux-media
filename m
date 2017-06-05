Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:53204 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752625AbdFEQq6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Jun 2017 12:46:58 -0400
Date: Mon, 5 Jun 2017 17:46:34 +0100
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: Firmware for staging atomisp driver
Message-ID: <20170605174634.440e9bdb@lxorguk.ukuu.org.uk>
In-Reply-To: <0bcc3d9d-b16f-49e1-2069-8798894bdf8b@redhat.com>
References: <e4933669-faf4-a721-cce0-117ba3d0f1eb@redhat.com>
        <0bcc3d9d-b16f-49e1-2069-8798894bdf8b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I'm asking  because that is hard to believe given e.g. the recursion bug
> I've just fixed.

It was kind of working yes (with libxcam and a simple test tool). The
recursion one was my fault. I didn't mean that one to go upstream as I
was still debugging it. The older code handled it right until I moved the
test.

> Can someone provide step-by-step instructions for how to get this
> driver working?

Need to restore my backup to get the set up I had (I broke my memopad
somewhat with one of my tests and it ate it's disk).

But basically I was using

https://github.com/01org/libxcam/wiki/Tests

Alan
