Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:42454 "EHLO
        einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754175AbcJON7L (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Oct 2016 09:59:11 -0400
Date: Sat, 15 Oct 2016 15:46:14 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 00/57] don't break long lines on strings
Message-ID: <20161015154614.67f97a81@kant>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Oct 14 Mauro Carvalho Chehab wrote:
> There are lots of drivers on media that breaks long line strings in order to
> fit into 80 columns. This was an usual practice to make checkpatch happy.

This was practice even before checkpatch existed.
-- 
Stefan Richter
-======----- =-=- -====
http://arcgraph.de/sr/
