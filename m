Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:30514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab1AZIQx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jan 2011 03:16:53 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0Q8GqUe031439
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 26 Jan 2011 03:16:53 -0500
Received: from shalem.localdomain (vpn2-8-6.ams2.redhat.com [10.36.8.6])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p0Q8Gpuk018984
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 26 Jan 2011 03:16:52 -0500
Message-ID: <4D3FDAAC.2020303@redhat.com>
Date: Wed, 26 Jan 2011 09:26:20 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: What to do with videodev.h
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi All,

With v4l1 support going completely away, the question is
raised what to do with linux/videodev.h .

Since v4l1 apps can still use the old API through libv4l1,
these apps will still need linux/videodev.h to compile.

So I see 3 options:
1) Keep videodev.h in the kernel tree even after we've dropped
the API support at the kernel level (seems like a bad idea to me)
2) Copy videodev.h over to v4l-utils as is (under a different name)
and modify the #include in libv4l1.h to include it under the
new name
3) Copy the (needed) contents of videodev.h over to libv4l1.h

I'm not sure where I stand wrt 2 versus 3. Comments anyone?

Regards,

Hans
