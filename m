Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55352 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751263AbdJ0OrO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Oct 2017 10:47:14 -0400
Date: Fri, 27 Oct 2017 17:47:11 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL for 4.15 v2] Atomisp cleanups, fixes
Message-ID: <20171027144711.p4xaezaoyijucdav@valkosipuli.retiisi.org.uk>
References: <20171019152120.j44duddzs665d7vj@valkosipuli.retiisi.org.uk>
 <20171027162508.131723b2@vela.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171027162508.131723b2@vela.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Fri, Oct 27, 2017 at 04:25:08PM +0200, Mauro Carvalho Chehab wrote:
> Em Thu, 19 Oct 2017 18:21:20 +0300
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> > Hi Mauro,
> > 
> > Here's the second version of the atomisp pull request. Since v1, I've added
> > more patches, including an oops fix from Hans de Goede and move to
> > timer_setup from Kees Cook. Also Andy's patches to clean up the driver are
> > in, as well as my patches to rename the atomisp specific drivers (modules
> > as well as Kconfig options).
> > 
> > Please pull.
> 
> Could you please rebase it on the top of the master branch? This series
> conflicts with another series you sent renaming atomisp files.

Ack, I will. Could you first pull this, so we get the fixes in? Then I can
proceed with more cleanups.

<URL:https://patchwork.linuxtv.org/patch/45157/>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
