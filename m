Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52382 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753286AbdC2HIi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 03:08:38 -0400
Date: Wed, 29 Mar 2017 09:08:15 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Daniel Cashman <dan.a.cashman@gmail.com>
Cc: mchehab@kernel.org, alan@linux.intel.com,
        devel@driverdev.osuosl.org, rvarsha016@gmail.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] Remove atomisp/i2c style errors.
Message-ID: <20170329070815.GA11051@kroah.com>
References: <1490758297-26282-1-git-send-email-dan.a.cashman@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1490758297-26282-1-git-send-email-dan.a.cashman@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 28, 2017 at 08:31:37PM -0700, Daniel Cashman wrote:
> From: Dan Cashman <dan.a.cashman@gmail.com>

Please list what the issue you fixed in the subject line.

Also change the subject to match others for this driver, a 'git log'
will show you what to do there.

> 
> Remove two ' , ' issues and change spaces to tabs found by poking around in
> drivers/staging/. Warnings left untouched.
> 
> Test: Run checkpatch script in drivers/staging/media/atomisp/i2c before and
> after change.  Errors go from 3 to 0.

This isn't needed, and really, you didn't test the code, only a random
perl script :)

thanks,

greg k-h
