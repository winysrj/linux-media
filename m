Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab3FNHPG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jun 2013 03:15:06 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r5E7F4s3006514
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 14 Jun 2013 03:15:05 -0400
Received: from shalem.localdomain (vpn1-4-110.ams2.redhat.com [10.36.4.110])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r5E7F2o3014705
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 14 Jun 2013 03:15:03 -0400
Message-ID: <51BAC2F6.40708@redhat.com>
Date: Fri, 14 Jun 2013 09:15:02 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Doing a v4l-utils-1.0.0 release
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

IIRC the 0.9.x series were meant as development releases leading up to a new
stable 1.0.0 release. Lately there have been no maintenance 0.8.x releases
and a lot of interesting development going on in the 0.9.x, while at the
same time there have been no issues reported against 0.9.x (iow it seems
stable).

So how about taking current master and releasing that as a 1.0.0 release ?

Regards,

Hans
