Return-path: <mchehab@pedra>
Received: from kroah.org ([198.145.64.141]:58771 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab0JTAm5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 20:42:57 -0400
Date: Tue, 19 Oct 2010 16:52:34 -0700
From: Greg KH <greg@kroah.com>
To: pboettcher@kernellabs.com
Cc: linux-media@vger.kernel.org,
	Olivier Grenie <olivier.grenie@dibcom.fr>, stable@kernel.org,
	Patrick Boettcher <patrick.boettcher@dibcom.fr>
Subject: Re: [stable] [PATCH 1/2] V4L/DVB: dib7770: enable the current
 mirror
Message-ID: <20101019235234.GC22799@kroah.com>
References: <1283874646-20770-1-git-send-email-Patrick.Boettcher@dibcom.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283874646-20770-1-git-send-email-Patrick.Boettcher@dibcom.fr>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Sep 07, 2010 at 05:50:45PM +0200, pboettcher@kernellabs.com wrote:
> From: Olivier Grenie <olivier.grenie@dibcom.fr>
> 
> To improve performance on DiB7770-devices enabling the current mirror
> is needed.
> 
> This patch adds an option to the dib7000p-driver to do that and it
> creates a separate device-entry in dib0700-device to use those changes
> on hardware which is using the DiB7770.
> 
> Cc: stable@kernel.org
> 
> Signed-off-by: Olivier Grenie <olivier.grenie@dibcom.fr>
> Signed-off-by: Patrick Boettcher <patrick.boettcher@dibcom.fr>

This does not seem like -stable material, sorry.

greg k-h
