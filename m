Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57296 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab1KWW02 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Nov 2011 17:26:28 -0500
Received: by bke11 with SMTP id 11so2133593bke.19
        for <linux-media@vger.kernel.org>; Wed, 23 Nov 2011 14:26:26 -0800 (PST)
Message-ID: <4ECD730E.3080808@gmail.com>
Date: Wed, 23 Nov 2011 23:26:22 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [Query] V4L2 Integer (?) menu control
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I was wondering how to implement in v4l2 a standard menu control having integer 
values as the menu items. The menu item values would be irregular, e.g. ascending
logarithmically and thus the step value would not be a constant.
I'm not interested in private control and symbolic enumeration for each value at
the series. It should be a standard control where drivers could define an array 
of integers reflecting the control menu items. And then the applications could
enumerate what integer values are valid and can be happily applied to a device.  

I don't seem to find a way to implement this in current v4l2 control framework. 
Such functionality isn't there, or is it ?

-- 
Regards,
Sylwester Nawrocki
