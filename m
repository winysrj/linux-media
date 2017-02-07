Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38658 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751927AbdBGIM5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2017 03:12:57 -0500
Date: Tue, 7 Feb 2017 09:12:58 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Avraham Shukron <avraham.shukron@gmail.com>
Cc: laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v2] Staging: omap4iss: Fix coding style issues
Message-ID: <20170207081258.GB18271@kroah.com>
References: <99077677.ouMsYN1JNl@avalon>
 <1486403915-9574-1-git-send-email-avraham.shukron@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1486403915-9574-1-git-send-email-avraham.shukron@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 06, 2017 at 07:58:35PM +0200, Avraham Shukron wrote:
> Fixes line-over-80-characters issues as well as multiline comments style.

When you say things like "as well as", that's a hint that this needs to
be broken up into different patches.  Please do so here.

thanks,

greg k-h
