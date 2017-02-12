Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47638 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751275AbdBLV2Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Feb 2017 16:28:16 -0500
Date: Sun, 12 Feb 2017 13:28:14 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ran Algawi <ran.algawi@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] Staging: media: bcm2048: Fixed an error
Message-ID: <20170212212814.GA14955@kroah.com>
References: <1486766489-8279-1-git-send-email-ran.algawi@gmail.com>
 <20170212121737.GA19670@kroah.com>
 <CAKg+OeRBUVwixkiWnS07=vYG3QHRUkuKxtRmZn5dGWQ0SZVRzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKg+OeRBUVwixkiWnS07=vYG3QHRUkuKxtRmZn5dGWQ0SZVRzA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Feb 12, 2017 at 11:12:42PM +0200, Ran Algawi wrote:
> Hello Greg,
> First, I appreciate you taking the time to educate me. I used the checkpatch
> script on the file I fixed and he reported the line as an error. Do you
> consider all checkpatch warnings/error/checks as coding style fixes?

The ones that refer to coding style issues, yes, that is what they are.
Sometimes the script points out other things that should be changed,
like octal values which is not an error in this case, but rather a
clarification.

And please turn html off in your email client, it gets rejected by the
mailing lists :)

thanks,

greg k-h
