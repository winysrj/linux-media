Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35439 "EHLO
	mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbbLTW2v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Dec 2015 17:28:51 -0500
Received: by mail-io0-f193.google.com with SMTP id o67so12619052iof.2
        for <linux-media@vger.kernel.org>; Sun, 20 Dec 2015 14:28:51 -0800 (PST)
Received: from [10.0.1.175] (dhcp-108-168-93-48.cable.user.start.ca. [108.168.93.48])
        by smtp.gmail.com with ESMTPSA id z6sm6915517ign.1.2015.12.20.14.28.48
        for <linux-media@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Sun, 20 Dec 2015 14:28:48 -0800 (PST)
From: Maury Markowitz <maury.markowitz@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Some build questions
Message-Id: <4E98CF25-E122-473E-9B4F-BC75920C2E70@gmail.com>
Date: Sun, 20 Dec 2015 17:28:48 -0500
To: linux-media <linux-media@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I’m looking over the page here:

http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers

There are a number of passages on this page which could use a little clarification. But before I jump in, I want to be sure I really understand them.

1) "This seems to be fixed on a fully updated systtem (5 July 2011)"

Given that this warning appears to be talking about a problem that was fixed almost five years ago, would anyone object if this was moved to a note section at the bottom of the page? And is the second note still an issue or is that long gone too?

2) "Note: The build script will clone the entire media-tree.git, which will take some time”

We should be precise with our terminology here. I believe this is trying to say:

"This build script will copy the entire linux source code tree from our git repository into the 'media' directory."

Is that correct? Or do some of you actually have something called "media_tree"?

3) "make tar DIR=<some dir with media -git tree>”

Am I correct this passage is referring to the same thing as (2)? That is, "media -git tree” is the same thing as "media-tree.git"? If so, would it not be proper to use the same terminology here?

And am I correct in understanding that this step, the tar/untar, is replacing the original "media" directory I got from v4l with the new one in the external/custom/other kernel?