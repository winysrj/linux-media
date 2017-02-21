Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33938 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751018AbdBUEtq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 23:49:46 -0500
Date: Tue, 21 Feb 2017 05:49:42 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: David Cako <dc@cako.io>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org
Subject: Re: [PATCH] media: staging: bcm2048: use unsigned int instead of
 unsigned
Message-ID: <20170221044942.GA29799@kroah.com>
References: <1487635736-161650-1-git-send-email-dc@cako.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1487635736-161650-1-git-send-email-dc@cako.io>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 20, 2017 at 05:08:56PM -0700, David Cako wrote:
> Signed-off-by: David Cako <dc@cako.io>
> ---
>  drivers/staging/media/bcm2048/radio-bcm2048.c | 44 +++++++++++++--------------
>  1 file changed, 22 insertions(+), 22 deletions(-)

We can't take patches without any changelog text, sorry.  And always
test-build your patches, this is a known tricky one, you have to ignore
checkpatch, it is wrong.

sorry,

greg k-h
