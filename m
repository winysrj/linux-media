Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:52399 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757244AbcKBVF4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Nov 2016 17:05:56 -0400
Date: Wed, 2 Nov 2016 21:05:54 +0000
From: Sean Young <sean@mess.org>
To: VDR User <user.vdr@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        "mailing list: linux-media" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] [media] lirc: remove lirc_serial driver
Message-ID: <20161102210554.GA13653@gofer.mess.org>
References: <1478108285-12046-1-git-send-email-sean@mess.org>
 <1478108285-12046-2-git-send-email-sean@mess.org>
 <CAA7C2qiQyn8eAnoJ6Caq2EwO0+4oqga2FoPmFdBrYxgooQz6=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA7C2qiQyn8eAnoJ6Caq2EwO0+4oqga2FoPmFdBrYxgooQz6=g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 02, 2016 at 02:00:16PM -0700, VDR User wrote:
> > serial_ir driver in rc-core
> 
> Which kernel did this happen in? I don't see a sign of it in 4.8.5 and
> I want to make sure that homebrew serial devices still work with lirc
> after this. Are you sure the serial_ir driver you refer to isn't about
> a usb-based serial ir?

See patch 1/2. That introduces the serial_ir rc-core driver. 

http://www.spinics.net/lists/linux-media/msg107352.html


Sean
