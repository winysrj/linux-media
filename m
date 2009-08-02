Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:16359 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbZHBR4V (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Aug 2009 13:56:21 -0400
Received: by fg-out-1718.google.com with SMTP id e21so895406fga.17
        for <linux-media@vger.kernel.org>; Sun, 02 Aug 2009 10:56:21 -0700 (PDT)
Date: Sun, 2 Aug 2009 20:56:22 +0300
From: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: correct implementation of FE_READ_UNCORRECTED_BLOCKS
Message-ID: <20090802175622.GB19034@moon>
References: <20090802174836.GA19034@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090802174836.GA19034@moon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Oops, sent it way too fast. Anyway.

DVB API documentation says:
"This ioctl call returns the number of uncorrected blocks detected by
the device driver during its lifetime.... Note that the counter will
wrap to zero after its maximum count has been reached."

Does it mean that correct implementation of frontend driver should
keep its own counter of UNC blocks and increment it every time hardware
reports such block?

>From what I see, a lot of current frontend drivers simply dump a value
from some hardware register. For example zl10353 I got here reports 
some N unc blocks and then gets back to reporting zero.
