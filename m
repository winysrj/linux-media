Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:55042 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbZIMWMf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 18:12:35 -0400
Date: Mon, 14 Sep 2009 00:13:15 +0200
From: Janne Grunau <j@jannau.net>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Brandon Jenkins <bcjenkins@tvwhere.com>,
	Andy Walls <awalls@radix.net>, Jarod Wilson <jarod@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] hdpvr: i2c fixups for fully functional IR support
Message-ID: <20090913221314.GA11178@aniel.lan>
References: <200909011019.35798.jarod@redhat.com>
 <1251855051.3926.34.camel@palomino.walls.org>
 <de8cad4d0909131023t7103b446sf6b20889567556ee@mail.gmail.com>
 <6EBCDFA3-FAAA-4757-97B6-9CF3442FE920@wilsonet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6EBCDFA3-FAAA-4757-97B6-9CF3442FE920@wilsonet.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Sep 13, 2009 at 05:04:16PM -0400, Jarod Wilson wrote:
> On Sep 13, 2009, at 1:23 PM, Brandon Jenkins wrote:
> 
> > I don't mind testing. Currently I am running ArchLinux 64-bit,
> > kernel26-2.6.30.6-1. Please tell me where to build the driver from.
> 
> Hrm... It *was* in Janne's hdpvr tree, but it seems to have gone  
> missing...

It's in http://hg.jannau.net/hdpvr. I just merged several weeks of
v4l-dvb changes after the last commit. So it's not at the top of the
log.

Janne
