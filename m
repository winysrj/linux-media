Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:49766 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752384AbeD2ASk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 20:18:40 -0400
Received: from alans-desktop (82-70-14-226.dsl.in-addr.zen.co.uk [82.70.14.226])
        by fuzix.org (8.15.2/8.15.2) with ESMTP id w3T0IcuW013346
        for <linux-media@vger.kernel.org>; Sun, 29 Apr 2018 01:18:38 +0100
Date: Sun, 29 Apr 2018 01:18:37 +0100
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
To: linux-media@vger.kernel.org
Subject: atomisp: drop from staging ?
Message-ID: <20180429011837.68859797@alans-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I think this is going to be the best option. When I started cleaning up
the atomisp code I had time to work on it. Then spectre/meltdown
happened (which btw is why the updating suddenly and mysteriously stopped
last summer).

I no longer have time to work on it and it's becoming evident that the
world of speculative side channel is going to be mean that I am
not going to get time in the forseeable future despite me trying to find
space to get back into atomisp cleaning up. It sucks because we made some
good initial progress but shit happens.

There are at this point (unsurprisngly ;)) no other volunteers I can
find crazy enough to take this on.

Alan
