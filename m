Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:39395 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751022AbeEMHtw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 May 2018 03:49:52 -0400
Subject: Re: [PATCH 5/7] Header location fix for 3.5.0 to 3.11.x
To: Brad Love <brad@nextdimension.cc>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>
References: <1524763162-4865-1-git-send-email-brad@nextdimension.cc>
 <1524763162-4865-6-git-send-email-brad@nextdimension.cc>
 <4ae5be5c-167e-bf3b-4849-8958552f8d05@anw.at>
 <16264dca-f0c2-a699-c7ff-f392ce8751f4@nextdimension.cc>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <2c7fab30-8a79-2fc7-b29b-1db2bb4bfbbb@anw.at>
Date: Sun, 13 May 2018 09:49:47 +0200
MIME-Version: 1.0
In-Reply-To: <16264dca-f0c2-a699-c7ff-f392ce8751f4@nextdimension.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Brad!

> Are the build logs public?
Look for the eMail
   cron job: media_tree daily build: ?????

The ????? is OK, WARNINGS or ERRORS
In this eMail there are links to the short and long logfile.


Hans uses a complete build system which can download the Kernel sources, build
media-build against all of them and does also Sparse and Smatch tests. It even
builds gcc 7.x and all of the required tools for you. You can find it here:
   https://git.linuxtv.org/hverkuil/build-scripts.git

BR,
   Jasmin
