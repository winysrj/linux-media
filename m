Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59414 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752473AbdBJOZx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 09:25:53 -0500
Date: Fri, 10 Feb 2017 15:01:16 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Ran Algawi <ran.algawi@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] Staging: media: bcm2048: fixed 20+ warings/errors
Message-ID: <20170210140116.GB28966@kroah.com>
References: <1486719425-24546-1-git-send-email-ran.algawi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1486719425-24546-1-git-send-email-ran.algawi@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 10, 2017 at 11:37:04AM +0200, Ran Algawi wrote:
> Fixed a coding style issues, and two major erros about complex macros
> and an error where the driver used a decimal number insted of an octal
> number when using a warning.

Only do one thing-per-patch please.

thanks,

gre gk-h
