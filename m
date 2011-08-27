Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818Ab1H0NNS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Aug 2011 09:13:18 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p7RDDItP032262
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Aug 2011 09:13:18 -0400
Message-ID: <4E58ED6C.6050000@redhat.com>
Date: Sat, 27 Aug 2011 10:13:16 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT FIXES FOR 3.1] pwc: various fixes
References: <4E2C388E.30402@redhat.com>
In-Reply-To: <4E2C388E.30402@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 24-07-2011 12:21, Hans de Goede escreveu:
> Hi Mauro,
> 
> Please pull from my tree for 2 bug fixes patches + support for
> control events for the pwc driver. Note that the control events
> patch depends upon the patches from hverkuils poll tree
> (and those patches are thus also in my tree, but not part of this
> pull req).
> 
> The following changes since commit 30178e8623281063c18592a848cdcd71f78f603d:
> 
>   vivi: let vb2_poll handle events. (2011-07-18 13:07:28 +0200)
> 
> are available in the git repository at:
>   git://linuxtv.org/hgoede/gspca.git media-for_v3.1
> 
> Dan Carpenter (1):
>       pwc: precedence bug in pwc_init_controls()

Applied.

> 
> Hans de Goede (2):
>       pwc: Add support for control events
>       pwc: properly mark device_hint as unused in all probe error paths

Those ones depend on hverkuil series, pending Al Viro's review.

So, I'm not applying them for now, until we get Hans V. patches merged.

Thanks
Mauro
