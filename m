Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38004 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751159AbdBLMRr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Feb 2017 07:17:47 -0500
Date: Sun, 12 Feb 2017 13:17:37 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Ran Algawi <ran.algawi@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] Staging: media: bcm2048: Fixed an error
Message-ID: <20170212121737.GA19670@kroah.com>
References: <1486766489-8279-1-git-send-email-ran.algawi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1486766489-8279-1-git-send-email-ran.algawi@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Feb 11, 2017 at 12:41:29AM +0200, Ran Algawi wrote:
> Fixed an error where the system was given a code in the form of decimal
> instead of octal.

It's not really an "error", right?  Please be more descriptive of
exactly what is going on here (hint, it's a coding style warning...)

thanks,

greg k-h
