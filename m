Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:46953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab0JHA2B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Oct 2010 20:28:01 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o980S0C7011090
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 7 Oct 2010 20:28:00 -0400
Received: from pedra (vpn-225-63.phx2.redhat.com [10.3.225.63])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id o980PriS021715
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 7 Oct 2010 20:27:59 -0400
Date: Thu, 7 Oct 2010 21:25:47 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/2] cx231xx: fix some compilation issues
Message-ID: <20101007212547.34742711@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

cx231xx compilation were broken with allmodconfig, due to some duplicated
symbols with cx23885 driver. This small patch series fix it.

Mauro Carvalho Chehab (2):
  V4L/DVB: cx231xx: declare static functions as such
  V4L/DVB: cx231xx: remove some unused functions

 drivers/media/video/cx231xx/cx231xx-417.c |   57 +++++++----------------------
 1 files changed, 13 insertions(+), 44 deletions(-)

