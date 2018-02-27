Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57008 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752260AbeB0Nmt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 08:42:49 -0500
Date: Tue, 27 Feb 2018 14:42:50 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Quytelda Kahja <quytelda@tamalin.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, hans.verkuil@cisco.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v2] Staging: bcm2048: Fix function argument alignment in
 radio-bcm2048.c.
Message-ID: <20180227134250.GB6881@kroah.com>
References: <20180219072550.hz4vpomsaz2ajrnm@mwanda>
 <20180220065304.8943-1-quytelda@tamalin.org>
 <cb62e915-eb9c-9252-1f0a-cc85c8ea3530@xs4all.nl>
 <CAFLvi2357U3HAt3mXDdNdZs4QA9mqWntTny4XyvtSfV2hu1dmA@mail.gmail.com>
 <7c9787b2-bad3-21d9-f726-e171d9af940d@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c9787b2-bad3-21d9-f726-e171d9af940d@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 27, 2018 at 08:32:30AM +0100, Hans Verkuil wrote:
> On 02/27/2018 02:53 AM, Quytelda Kahja wrote:
> > Hans,
> > 
> > Thank you very much for your input on the patch; however this patch
> > has already been applied to the staging tree.  Additionally:
> 
> I have no record of this being applied through linux-media. Did someone
> else pick this up? Greg perhaps?

Did I pick this up?  Oops, sorry, didn't mean to, I'll go revert it now,
sorry...

greg k-h
