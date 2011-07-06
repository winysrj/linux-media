Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:2044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab1GFQE1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Jul 2011 12:04:27 -0400
Message-ID: <4E14877F.6060208@redhat.com>
Date: Wed, 06 Jul 2011 13:04:15 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: -EFAULT error code at firedtv driver
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hi Stefan,

I'm validating if all drivers are behaving equally with respect to the
error codes returned to userspace, and double-checking with the API.

On almost all places, -EFAULT code is used only to indicate when
copy_from_user/copy_to_user fails. However, firedtv uses a lot of
-EFAULT, where it seems to me that other error codes should be used
instead (like -EIO for bus transfer errors and -EINVAL/-ERANGE for 
invalid/out of range parameters).

I'll be posting soon a series of patches fixing the error codes on the
other places, but, as I don't know how do you use -EFAULT inside the
firewire core, I prefer to not touch at firedtv.

Could you please take a look on it?

Thanks!
Mauro
