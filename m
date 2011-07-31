Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494Ab1GaKiz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jul 2011 06:38:55 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6VActJs022932
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 31 Jul 2011 06:38:55 -0400
Message-ID: <4E3530BC.9050108@redhat.com>
Date: Sun, 31 Jul 2011 07:38:52 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL for v3.0] media updates for v3.1
References: <4E32EE71.4030908@redhat.com> <4E350B04.6050209@redhat.com>
In-Reply-To: <4E350B04.6050209@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 31-07-2011 04:57, Hans de Goede escreveu:
> Hi,
> 
> I notice that Hans Verkuil's patches to make poll
> report what is being polled to drivers, and my corresponding
> patches for adding event support to pwc are not included,
> what is the plan with these?

The changes for the vfs code need vfs maintainer's ack, or to go
via their tree. So, we need to wait for them to merge/send it
upstream, before being able to merge the patches that depend on it.

Regards,
Mauro.
