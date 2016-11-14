Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:54927 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932462AbcKNVGF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 16:06:05 -0500
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Olliver Schinagl <oliver@schinagl.nl>, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: [PATCH dtv-scan-tables] Rename pl-Krosno_Sucha_Gora with only ASCII characters
Date: Mon, 14 Nov 2016 22:05:50 +0100
Message-Id: <1479157550-983-1-git-send-email-thomas.petazzoni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The pl-Krosno_Sucha_Gora file, added in commit
4cb113fd15e562f0629000fcad9f41405595198d, is the only file that
contains non-ASCII characters in the tree. This causes a number of
build issues with other packages that don't necessarily handle very
well non-ASCII file name encodings.

Since no other file in the tree contain non-ASCII characters in their
name, this commit renames pl-Krosno_Sucha_Gora similarly.

Examples of files that are named with only ASCII characters even if
the city name really contains non-ASCII characters:

  - pl-Wroclaw should be written pl-Wrocław
  - se-Laxsjo should be written se-Laxsjö
  - de-Dusseldorf should be written de-Düsseldorf
  - vn-Thaibinh should be written vn-Thái_Bình

Since there is no real standardization on the encoding of file names,
we'd better be safe and use only ASCII characters.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 "dvb-t/pl-Krosno_Sucha_G\303\263ra" => dvb-t/pl-Krosno_Sucha_Gora | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename "dvb-t/pl-Krosno_Sucha_G\303\263ra" => dvb-t/pl-Krosno_Sucha_Gora (100%)

diff --git "a/dvb-t/pl-Krosno_Sucha_G\303\263ra" b/dvb-t/pl-Krosno_Sucha_Gora
similarity index 100%
rename from "dvb-t/pl-Krosno_Sucha_G\303\263ra"
rename to dvb-t/pl-Krosno_Sucha_Gora
-- 
2.7.4

