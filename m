Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756348Ab2B2W65 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Feb 2012 17:58:57 -0500
Date: Wed, 29 Feb 2012 17:58:52 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, kernel-team@fedoraproject.org
Subject: 3.1/3.2 uvcvideo and Creative Live! Cam Optia AF
Message-ID: <20120229225851.GB14135@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Laurent,

We've had a bug report [1] in Fedora for a while now that the uvcvideo
driver no longer works on the Creative Live! Cam Optia AF (ID 041e:4058)
in the 3.1 and 3.2 kernels.  The bug has all the various output from
dmesg, lsusb, etc.

I'm wondering if there is anything further we can do to help diagnose
what might be going wrong here.

josh

[1] https://bugzilla.redhat.com/show_bug.cgi?id=739448
