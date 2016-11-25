Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43382 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752264AbcKYHso (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Nov 2016 02:48:44 -0500
Date: Fri, 25 Nov 2016 09:48:38 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/1] smiapp: Implement power-on and power-off sequences
 without runtime PM
Message-ID: <20161125074838.GA16630@valkosipuli.retiisi.org.uk>
References: <2929151.g7xCm3YOsX@avalon>
 <Pine.LNX.4.44L0.1611242112030.20545-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1611242112030.20545-100000@netrider.rowland.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alan and others,

On Thu, Nov 24, 2016 at 09:15:39PM -0500, Alan Stern wrote:
> On Fri, 25 Nov 2016, Laurent Pinchart wrote:
> 
> > Dear linux-pm developers, what's the suggested way to ensure that a runtime-
> > pm-enabled driver can run fine on a system with CONFIG_PM disabled ?
> 
> The exact point of your question isn't entirely clear.  In the most 
> literal sense, the best ways to ensure this are (1) audit the code, and 
> (2) actually try it.
> 
> I have a feeling this doesn't quite answer your question, however.  :-)

The question is related to devices that require certain power-up and
power-down sequences that are now implemented as PM runtime hooks that,
without CONFIG_PM defined, will not be executed. Is there a better way than
to handle this than have an implementation in the driver for the PM runtime
and non-PM runtime case separately?

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
