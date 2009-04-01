Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:42949 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764925AbZDAOHJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Apr 2009 10:07:09 -0400
Received: by bwz17 with SMTP id 17so47335bwz.37
        for <linux-media@vger.kernel.org>; Wed, 01 Apr 2009 07:07:06 -0700 (PDT)
Message-ID: <49D37485.7030805@gmail.com>
Date: Wed, 01 Apr 2009 17:04:53 +0300
From: Darius Augulis <augulis.darius@gmail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: soc_camera_open() not called
Content-Type: text/plain; charset=ISO-8859-13; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm trying to launch mx1_camera based on new v4l and soc-camera tree.
After loading mx1_camera module, I see that .add callback is not called.
In debug log I see that soc_camera_open() is not called too.
What should call this function? Is this my driver problem?
p.s. loading sensor driver does not change situation.
