Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45013 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab0EEH1s (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 May 2010 03:27:48 -0400
Received: by fxm10 with SMTP id 10so3943607fxm.19
        for <linux-media@vger.kernel.org>; Wed, 05 May 2010 00:27:47 -0700 (PDT)
Date: Wed, 5 May 2010 09:27:38 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-media@vger.kernel.org
Subject: -next: staging/cx25821: please revert 7a02f549fcc
Message-ID: <20100505072738.GH27064@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This was my patch:  "cx25821: fix double unlock in medusa_video_init()"

It accidentally got merged two times.  The version from the staging tree
is not correct.  Please can you revert it:
7a02f549fcc30fe6be0c0024beae9a3db22e1af6 "Staging: cx25821: fix double
unlock in medusa_video_init()"

I guess this is going through the V4L/DVB so it needs to be reverted
there as well as in the -staging tree.

Sorry for the inconvenience.

regards,
dan carpenter

PS. The correct version is:  423f5c0d016 "V4L/DVB (13955): cx25821: fix 
double unlock in medusa_video_init()".  That one is needed and fixes a bug

