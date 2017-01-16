Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41868 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750880AbdAPKgh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jan 2017 05:36:37 -0500
Date: Mon, 16 Jan 2017 11:36:50 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Derek Robson <robsonde@gmail.com>
Cc: Scott Matheina <scott@matheina.com>, mchehab@kernel.org,
        jb@abbadie.fr, aquannie@gmail.com, bankarsandhya512@gmail.com,
        bhumirks@gmail.com, claudiu.beznea@gmail.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: media: bcm2048: style fix - bare use of unsigned
Message-ID: <20170116103650.GA2037@kroah.com>
References: <20170116043030.29366-1-robsonde@gmail.com>
 <6FFD25BD-70E3-4BE5-896E-793F4A47F30E@matheina.com>
 <20170116050625.GA26815@bigbird>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170116050625.GA26815@bigbird>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 16, 2017 at 06:06:25PM +1300, Derek Robson wrote:
> On Sun, Jan 15, 2017 at 10:40:02PM -0600, Scott Matheina wrote:
> > 
> > 
> > > On Jan 15, 2017, at 10:30 PM, Derek Robson <robsonde@gmail.com> wrote:
> > > 
> > > Changed bare use of 'unsigned' to the prefered us of 'unsigned int'
> > > found using checkpatch
> > 
> > Just wondering if you compiled? This patch looks exactly like a patch I tried, but it didn't compile. 
> > 
> 
> It complied for me, I am on an X86 system.

I don't believe you, and kbuild backs that up  :)
