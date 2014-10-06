Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:61722 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaJFVI1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Oct 2014 17:08:27 -0400
Received: by mail-pd0-f174.google.com with SMTP id y13so3829095pdi.5
        for <linux-media@vger.kernel.org>; Mon, 06 Oct 2014 14:08:27 -0700 (PDT)
Message-ID: <54330499.50905@gmail.com>
Date: Tue, 07 Oct 2014 02:37:37 +0530
From: Alaganraj Sandhanam <alaganraj.sandhanam@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
CC: laurent.pinchart@ideasonboard.com
Subject: Re: omap3isp Device Tree support status
References: <20140928221341.GQ2939@valkosipuli.retiisi.org.uk>
In-Reply-To: <20140928221341.GQ2939@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patches.
On Monday 29 September 2014 03:43 AM, Sakari Ailus wrote:
> Hi,
> 
> I managed to find some time for debugging my original omap3isp DT support
> patchset (which includes smiapp DT support as well), and found a few small
> but important bugs.
> 
> The status is now that images can be captured using the Nokia N9 camera, in
> which the sensor is connected to the CSI-2 interface. Laurent confirmed that
> the parallel interface worked for him (Beagleboard, mt9p031 sensor on
> Leopard imaging's li-5m03 board).
Good news!
> 
> These patches (on top of the smiapp patches I recently sent for review which
> are in much better shape) are still experimental and not ready for review. I
> continue to clean them up and post them to the list when that is done. For
> now they can be found here:
> 
> <URL:http://git.linuxtv.org/cgit.cgi/sailus/media_tree.git/log/?h=rm696-043-dt>
> 
I couldn't clone the repo, getting "remote corrupt" error.

$ git remote -v
media-sakari	git://linuxtv.org/sailus/media_tree.git (fetch)
media-sakari	git://linuxtv.org/sailus/media_tree.git (push)
origin	git://linuxtv.org/media_tree.git (fetch)
origin	git://linuxtv.org/media_tree.git (push)
sakari	git://vihersipuli.retiisi.org.uk/~sailus/linux.git (fetch)
sakari	git://vihersipuli.retiisi.org.uk/~sailus/linux.git (push)

$ git fetch media-sakari
warning: cannot parse SRV response: Message too long
remote: error: Could not read 5ea878796f0a1d9649fe43a6a09df53d3915c0ef
remote: fatal: revision walk setup failed
remote: aborting due to possible repository corruption on the remote side.
fatal: protocol error: bad pack header

Can you please guide me?

Thanks&Regards,
Alaganraj
