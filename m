Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:36863 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757132AbZE2OZw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 May 2009 10:25:52 -0400
Received: by ewy24 with SMTP id 24so6303860ewy.37
        for <linux-media@vger.kernel.org>; Fri, 29 May 2009 07:25:52 -0700 (PDT)
Message-ID: <4A1FF06E.8060804@gmail.com>
Date: Fri, 29 May 2009 15:25:50 +0100
From: pbflyingdutchman@googlemail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Why are there key mapping tables in the kernel for remote controls?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

Just been trying to get my remote to work for tevii S460 and found it 
needed some patchwork in the cx88-input.c file
and adding a key mapping table in one of the files.
Now for vdr I use lircd to get the keys fed into vdr from 
/dev/input/event<n>

So this feels like things are done twice, as lircd uses a mapping table 
too.

To me it makes sense to keep the mapping tables out of the kernel. You 
already see a whole bunch of remotes in the kernel.
You don't really want to make kernel updates for each new type of remote 
vendors come out with. Lircd seems to be able to do this too and has a 
quick recording tool to setup a new remote.

So what is the history behind having these key mapping tables in the 
kernel?

regards
Peter
