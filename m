Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.abilis.ch ([195.70.19.74]:45763 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbaEZOnj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 10:43:39 -0400
Date: Mon, 26 May 2014 16:17:48 +0200 (CEST)
From: Romain Baeriswyl <Romain.Baeriswyl@abilis.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Christian Ruppert <chrisr@abilis.com>,
	Ole Ernst <olebowle@gmx.com>, linux-media@vger.kernel.org
Message-ID: <1586019348.6279.1401113868322.JavaMail.root@abilis.com>
In-Reply-To: <832879218.6141.1401112530064.JavaMail.root@abilis.com>
Subject: Linux DVB frontend issue
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Mauro,

We are using the Linux DVB frontend module on our platform and 
we are facing an issue when having concurrent calls with FE_SET_FRONTEND
and FE_GET_FRONTEND ioctl.

Issue is that both ioctls are using the same dtv_property_cache buffer.
If a FE_SET_FRONTEND ioctl is interrupted by a FE_GET_FRONTEND then the 
dtv_property_cache is overwritten with the result of the FE_GET_FRONTEND. 
When the FE_SET_FRONTEND operation resumes, the dtv_property_cache may
not be accurate anymore.

Did you already face this issue?

Up to now I tried, without success, to think on a fix that does not impact
too much the existing code.

One solution could be to have one cache for reading properties and one other 
cache for writing properties, but this will impact all the drivers below 
the DVB frontend.

Do you see another less impacting solution?

Best regards,

Romain Baeriswyl

Abilis Systems 
3, chemin Pré Fleuri
CH-1228 Plan-Les-Ouates
Geneva




