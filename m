Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35626 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423066Ab2CPP6t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 11:58:49 -0400
Received: by ghrr11 with SMTP id r11so4329357ghr.19
        for <linux-media@vger.kernel.org>; Fri, 16 Mar 2012 08:58:49 -0700 (PDT)
Date: Fri, 16 Mar 2012 08:58:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	marauder@tiscali.it
Subject: Re: [PATCH V2]NEXT:drivers:staging:media Fix comments and some typos
 in staging/media/*
Message-ID: <20120316155845.GA975@kroah.com>
References: <1331045709-19309-1-git-send-email-justinmattock@gmail.com>
 <4F635DBF.7000603@gmail.com>
 <alpine.LNX.2.00.1203161644190.18356@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1203161644190.18356@pobox.suse.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 16, 2012 at 04:45:03PM +0100, Jiri Kosina wrote:
> On Fri, 16 Mar 2012, Justin P. Mattock wrote:
> 
> > before I forget about this patch, what was the status of this one?
> 
> As previously announced multiple times, I am ignoring patches that go to 
> drivers/staging and letting Greg pick them up if he wants to.
> 
> Greg, if you want to have this changed, just let me know.

No, no objection from me, but patches to drivers/staging/media/ do not
go through me, please see the MAINTAINERS file for the owner of those
(hint, it's Mauro...)

thanks,

greg k-h
