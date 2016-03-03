Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39374 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756723AbcCCJfH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 04:35:07 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1abPez-0001dL-15
	for linux-media@vger.kernel.org; Thu, 03 Mar 2016 10:35:05 +0100
Received: from 546A55B7.cm-12-3b.dynamic.ziggo.nl ([84.106.85.183])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 03 Mar 2016 10:35:05 +0100
Received: from hdegoede by 546A55B7.cm-12-3b.dynamic.ziggo.nl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 03 Mar 2016 10:35:05 +0100
To: linux-media@vger.kernel.org
From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 0/1] v4lconvert: Add "PEGATRON CORPORATION" to =?utf-8?b?YXN1c19ib2FyZF92ZW5kb3I=?=
Date: Thu, 3 Mar 2016 09:28:31 +0000 (UTC)
Message-ID: <loom.20160303T102633-883@post.gmane.org>
References: <1456580424-9627-1-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans de Goede <hdegoede <at> redhat.com> writes:

> 
> Hi Gregor,
> 
> Here is a patch to add "PEGATRON CORPORATION" to asus_board_vendor,
> to fix an upside down bug reported to Fedora:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=1311545
> 
> I'm not 100% sure this is a good idea, it might cause a bunch of false
> positives, but looking at the existing static PEGATRON entries in the
> v4l_control_flags list, it seems that it really is just another vendor
> string for Asus and that adding it to asus_board_vendor is best, so
> I'm say 95% sure :)
> 
> Anyways your input on this is much appreciated. In the mean time I'll
> kick of a scratch-build of the Fedora v4l-utils pkg with this patch
> applied for the reporter to test.

After sleeping a few days on this, I've decided that this is indeed
the best way to deal with this, and given that I've not had any comments
on the patch I've just pushed it to v4l-utils master
 
Regards,
 
Hans


