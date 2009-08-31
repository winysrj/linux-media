Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:60767 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbZHaQMT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 12:12:19 -0400
Received: by bwz19 with SMTP id 19so2871030bwz.37
        for <linux-media@vger.kernel.org>; Mon, 31 Aug 2009 09:12:21 -0700 (PDT)
Message-ID: <4A9BF658.1000200@gmail.com>
Date: Mon, 31 Aug 2009 21:42:08 +0530
From: Sudipto Sarkar <xtremethegreat1@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Jean-Francois Moine <moinejf@free.fr>
Subject: HP VGA webcam details correction
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Turns out the memory allocation failure was due to the trackerd, that 
was running. After killing trackerd, I don't get the memory allocation 
failure, but the image still won't show up (probably because the URBs 
are different). dmesg shows several isoc irqs.
