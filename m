Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38670 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab1KUVFD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Nov 2011 16:05:03 -0500
Received: by wwe5 with SMTP id 5so11143604wwe.1
        for <linux-media@vger.kernel.org>; Mon, 21 Nov 2011 13:05:02 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 22 Nov 2011 02:35:02 +0530
Message-ID: <CAHFNz9KAi=XRZt=qM=KKnSKmmf_mn18JJAiUmd_5gXG71VBELA@mail.gmail.com>
Subject: PATCH 00/13: Enumerate DVB frontend Delivery System capabilities to
 identify devices correctly.
From: Manu Abraham <abraham.manu@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andreas Oberritter <obi@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

As discussed prior, the following changes help to advertise a
frontend's delivery system capabilities.

Sending out the patches as they are being worked out.

The following patch series are applied against media_tree.git
after the following commit

commit e9eb0dadba932940f721f9d27544a7818b2fa1c5
Author: Hans Verkuil <hans.verkuil@cisco.com>
Date:   Tue Nov 8 11:02:34 2011 -0300

    [media] V4L menu: add submenu for platform devices


Regards,
Manu
