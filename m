Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57524 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab2ACSjT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2012 13:39:19 -0500
Received: by vcbfk14 with SMTP id fk14so12578901vcb.19
        for <linux-media@vger.kernel.org>; Tue, 03 Jan 2012 10:39:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <loom.20120103T181436-85@post.gmane.org>
References: <518438.15436.qm@web63402.mail.re1.yahoo.com>
	<loom.20120103T181436-85@post.gmane.org>
Date: Tue, 3 Jan 2012 13:39:18 -0500
Message-ID: <CAGoCfiyuQTg+yLSJ4zdvB_s+x1xFfk+ueKQsh2XBwA+dLGj=Uw@mail.gmail.com>
Subject: Re: Working on Avermedia Duet A188 (saa716x and lgdt3304)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Tim <richardh68@hotmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 3, 2012 at 1:05 PM, Tim <richardh68@hotmail.com> wrote:
> Currently I I am trying to attach the lgdt3304 at i2c address 0x0e  on bus A
> then try to attach the tda1827hdc2.. but the lgdt3304 never attaches

Just a suggestion:  These sorts of problems are usually either you're
trying to talk to the device on the wrong i2c bus, or the chip is
being held in reset by a GPIO.  Also possible that it's bound to a
different i2c address (most demods let you pick between a couple of
addresses based on a pullup resistor on a particular pin.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
