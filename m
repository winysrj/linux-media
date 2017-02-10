Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57060 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752174AbdBJOA6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 09:00:58 -0500
Date: Fri, 10 Feb 2017 15:00:45 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Ran Algawi <ran.algawi@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [Patch] Staging: media: bcm2048: fixed errors and warnings
Message-ID: <20170210140045.GA28966@kroah.com>
References: <20170210094141.GA24612@LestatChateau>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170210094141.GA24612@LestatChateau>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 10, 2017 at 11:41:41AM +0200, Ran Algawi wrote:
> 

<snip>

Never attach patches, and always test-build them yourself to ensure they
do not break the build :(

greg k-h
