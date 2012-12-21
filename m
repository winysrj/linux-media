Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab2LUSml (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Dec 2012 13:42:41 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qBLIgfev025894
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 21 Dec 2012 13:42:41 -0500
Date: Fri, 21 Dec 2012 16:42:18 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT-PULL fixes for 3.8] Various USB webcam fixes
Message-ID: <20121221164218.0a535bfc@redhat.com>
In-Reply-To: <50D47243.6070107@redhat.com>
References: <50D47243.6070107@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 21 Dec 2012 15:29:23 +0100
Hans de Goede <hdegoede@redhat.com> escreveu:

> Hi Mauro,
> 
> Note this pullreq superceeds my previous pullreq.

Please, next time, be sure to reply to your old email or send a:
	Nacked-by: 
(as patchwork catches this special meta-tag)

tag to the previous one, otherwise I'll be handling your new pull
request only after handling the previous one, just like what I did
today.

Regards,
Mauro
Cheers,
Mauro
