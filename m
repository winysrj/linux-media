Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47109 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751952AbcKVJGa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 04:06:30 -0500
Received: from [82.128.187.197] (helo=localhost.localdomain)
        by mail.kapsi.fi with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.80)
        (envelope-from <crope@iki.fi>)
        id 1c9723-0004Ag-Cx
        for linux-media@vger.kernel.org; Tue, 22 Nov 2016 11:06:27 +0200
To: LMML <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL] mn88473 statistics
Message-ID: <02a5fdf0-3309-bfa5-17d1-0f9f08423ac4@iki.fi>
Date: Tue, 22 Nov 2016 11:06:26 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit c60b4088108c44529e6f679d9e991e3d3c945950:

   [media] serial_ir: fix reference to 8250 serial code (2016-11-22 
06:17:44 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git mn88473

for you to fetch changes up to 5d575830372914df634d4ed7e6eb6a4b7ac7c9cb:

   mn88473: refactor and fix statistics (2016-11-22 11:02:20 +0200)

----------------------------------------------------------------
Antti Palosaari (1):
       mn88473: refactor and fix statistics

Martin Blumenstingl (1):
       mn88473: add DVBv5 statistics support

  drivers/media/dvb-frontends/mn88473.c      | 201 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------
  drivers/media/dvb-frontends/mn88473_priv.h |   2 ++
  2 files changed, 184 insertions(+), 19 deletions(-)


-- 
http://palosaari.fi/
