Return-path: <linux-media-owner@vger.kernel.org>
Received: from or-71-0-52-80.sta.embarqhsd.net ([71.0.52.80]:35430 "EHLO
        asgard.dharty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753399AbcIVE0C (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Sep 2016 00:26:02 -0400
Received: from [192.168.0.4] (buri.dharty.com [192.168.0.4])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dwh@dharty.com)
        by asgard.dharty.com (Postfix) with ESMTPSA id 3EEB422806
        for <linux-media@vger.kernel.org>; Wed, 21 Sep 2016 21:19:41 -0700 (PDT)
To: Linux-Media <linux-media@vger.kernel.org>
Reply-To: v4l@dharty.com
From: catchall <catchall@dharty.com>
Subject: WinTV-HVR-2255 saa7164 and linux kernel 4.1.27
Message-ID: <b2095112-932c-afc0-ac61-e4f03376bf1c@dharty.com>
Date: Wed, 21 Sep 2016 21:19:39 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I recently replaced a broken WinTV-HVR-2250 with an WinTV-HVR-2255.

I knew that the 2255 was supported in kernel 4.2, what I didn't know was 
that the latest stable version of my distro (opensuse) only used 4.1.

I was on 13.2 with kernel 3.16 at the time of the upgrade.

Anyway, is it possible to patch the saa7164 driver in 4.1?

I had to perform a similar patch in  3.16 for the 2250 to address a PCI 
interupt issue.


Regards,

David


