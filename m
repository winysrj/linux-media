Return-path: <linux-media-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:60072 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556AbZHTOcD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2009 10:32:03 -0400
Date: Thu, 20 Aug 2009 16:32:00 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [linux-dvb] au0828: experimental support for Syntek Teledongle
 [05e1:0400]
Message-ID: <20090820143200.GA29984@linuxtv.org>
References: <bc18792f0908171325s391d9e36nb0ce20f40017678@mail.gmail.com>
 <37219a840908171359m152363a2ub377abe6e27ff237@mail.gmail.com>
 <20090818110041.GA14710@linuxtv.org>
 <829197380908180707r3aba262fie192090c653c42be@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <829197380908180707r3aba262fie192090c653c42be@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 18, 2009 at 10:07:04AM -0400, Devin Heitmueller wrote:
>                                                      The risk of
> trusting some random Linux developer's driver work is a reason why
> some vendors don't want to support Linux.  If I were a vendor, and I
> endorsed a Linux driver written by someone without the appropriate
> knowledge of the hardware, I could end up with large number of product
> returns, and I would incur the cost of those losses.

This is an interesting statement.  Let me rephrase it:

If I were a vendor selling ill-designed hardware which can
be permanently damaged by buggy software, I'd make sure
as hell that I get the information about how to avoid the
damage out to every Open Source developer.  Otherwise
I would have to live with the risk of seeing an increased
rate of product returns.


BTW, there is a big difference of "after I plugged the device
in under Linux it was dead" and "it runs hot under Linux, that might
shorten the life span".  I hope there is no hardware of the first
kind.  For the second kind you can fairly safely experiment until
you solved the problem.


Thanks,
Johannes
