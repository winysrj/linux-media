Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63440 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab2HRMHn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Aug 2012 08:07:43 -0400
Received: by wicr5 with SMTP id r5so2430437wic.1
        for <linux-media@vger.kernel.org>; Sat, 18 Aug 2012 05:07:41 -0700 (PDT)
Message-ID: <1345291653.24014.7.camel@router7789>
Subject: media_build duplicate module structures
From: Malcolm Priestley <tvboxspy@gmail.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Sat, 18 Aug 2012 13:07:33 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

Updating older kernels with media_build does not remove the old file
structure.

Running /sbin/depmod will mean the new structure will have two modules
of the same name causing module conflicts.

The entire old structure needs to be removed first.

rm -r /lib/modules/$(uname -r)/kernel/drivers/media

Regards


Malcolm



