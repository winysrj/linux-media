Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757878Ab2I1NZj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Sep 2012 09:25:39 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8SDPdd0022067
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 28 Sep 2012 09:25:39 -0400
Received: from [10.97.7.102] (vpn1-7-102.gru2.redhat.com [10.97.7.102])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id q8SDPbi2006619
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 28 Sep 2012 09:25:38 -0400
Message-ID: <5065A550.3090909@redhat.com>
Date: Fri, 28 Sep 2012 10:25:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: account got bounced at vger that might affect patch reviews
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear developers,

Due to some temporary trouble, I was unable to receive emails from
linux-media, since 10 hours ago. As I use my IMAP box to check for
review e-mails, if you replied to an existing patch during that period
of time, and didn't answered it with a Nacked-by/Acked-by tag[1],
please ping me, as otherwise I might be applying a patch
without noticing to your comments.

Thank you!
Mauro

[1] patchwork properly handles those tags (and a few others, like tested-by
and reviewed-by), and joins those when patches are downloaded. As my main
resource when applying patches is patchwork, you don't need to worry if you
use those tags, as I'll see it, even if I loose your email.
