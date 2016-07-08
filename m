Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41338 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179AbcGHNEC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:02 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 14/54] doc-rst: fix intro_files/dvbstb.png image
Date: Fri,  8 Jul 2016 10:03:06 -0300
Message-Id: <e9b72b2744ebff6492fc024c24879706d6413d7c.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The png image was not base64 decoded correctly.
Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../linux_tv/media/dvb/intro_files/dvbstb.png       | Bin 22703 -> 22655 bytes
 1 file changed, 0 insertions(+), 0 deletions(-)

diff --git a/Documentation/linux_tv/media/dvb/intro_files/dvbstb.png b/Documentation/linux_tv/media/dvb/intro_files/dvbstb.png
index 5836ea94eba4ec4fd13a83e89ef86b312cc04c02..9b8f372e7afd9d016854973ba705dcdfbd1bbf13 100644
GIT binary patch
delta 116
zcmZ3#k@5cq#tjYZ%&xwHo7>q}ax=MxZ8j4=%*x{G=H|AUQBs<j#nr{dWwVM*HzS0#
zUAB&&87RBiM)w#KlWX{94uf}0tRO`poBtbq0SX0e{%N{}naMSD@@C6POs;;Ly{#&M
NT3lT>pYnXl2LO%FCVBt>

delta 164
zcmeyrfpPst#tjYZ><J03zJUn|o158Ja<c(BVL-N?@L^UCAluE&4aoZ{A<YcpxwyCh
zc_K31j0oOh**boZ5nzQXy2qG6MuY>Ez0rTi#0k+90_5H|`T~{;0<y1~Zea!~3r$Fv
a+-*4t#PkCS%Ue}|jdFDba%Oox<pTgz-8pao

-- 
2.7.4

