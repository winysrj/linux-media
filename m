Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:64245 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbZEMVxV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2009 17:53:21 -0400
Received: by bwz22 with SMTP id 22so924149bwz.37
        for <linux-media@vger.kernel.org>; Wed, 13 May 2009 14:53:21 -0700 (PDT)
Message-ID: <4A0B414D.5000106@googlemail.com>
Date: Wed, 13 May 2009 23:53:17 +0200
From: e9hack <e9hack@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Oliver Endriss <o.endriss@gmx.de>
Subject: BUG in av7110_vbi_write()
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

it seems there is a bug in av7110_vbi_write() (av7110_v4l.c). If an user mode application
tries to write more bytes than the size of the structure v4l2_slices_vbi_data,
copy_from_user() will overwrite parts of the kernel stack.

Regards,
Hartmut
