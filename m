Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421Ab1L2Ufm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Dec 2011 15:35:42 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Jean-Francois Moine <moinejf@free.fr>
Subject: [PATCH for 3.2 URGENT 0/1] Fix major regression in gspca
Date: Thu, 29 Dec 2011 21:36:41 +0100
Message-Id: <1325191002-25074-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Unfortunately the new iso bandwidth calculation code in gspca has
accidentally broken support for bulk mode cameras, breaking support
for a wide range of chipsets (see the patch for a full list).

Mauro, please send this patch to Linus asap, so that 3.2 won't ship with
this regression.

Thanks,

Hans
