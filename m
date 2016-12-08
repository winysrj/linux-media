Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55328 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750982AbcLHKo7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Dec 2016 05:44:59 -0500
Date: Thu, 8 Dec 2016 12:44:50 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Enrico Mioso <mrkiko.rs@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [git:media_tree/master] [media] Add Cinergy S2 rev.4 support
Message-ID: <20161208104450.GF16630@valkosipuli.retiisi.org.uk>
References: <E1bymEK-0008OE-70@www.linuxtv.org>
 <alpine.LNX.2.20.1612081037240.19056@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.20.1612081037240.19056@localhost.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enrico,

On Thu, Dec 08, 2016 at 10:40:06AM +0100, Enrico Mioso wrote:
> Hello guys.
> 
> First of all, thank you for your great work.
> 
> I am writing to you to understand if there where problems with a patch I sent something like 17 octobrer to add an USB id.
> Where there any problems?
> I saw it was accepted but can't find it in the kernel. I admit I didn't check in media tree.

The patch first goes to the media tree, and then Mauro (the media tree
maintainer) sends a pull request to Linus on the master branch, typically a
short while after the kernel release. So the usual time for the patch to
reach the mainline kernel release is roughly between one and two kernel
release cycles.

<URL:http://static.lwn.net/kerneldoc/process/2.Process.html>

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
