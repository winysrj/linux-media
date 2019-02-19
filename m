Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A80C2C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 17:02:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B5EC2183F
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 17:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729679AbfBSRCs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 12:02:48 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:37909 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbfBSRCr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 12:02:47 -0500
Received: from wuerfel.lan ([109.192.41.194]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1N8GhM-1h9Uhq43Oq-014DH7; Tue, 19 Feb 2019 18:02:39 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Mark Brown <broonie@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] media: go7007: avoid clang frame overflow warning with KASAN
Date:   Tue, 19 Feb 2019 18:01:58 +0100
Message-Id: <20190219170209.4180739-3-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190219170209.4180739-1-arnd@arndb.de>
References: <20190219170209.4180739-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:t3/mjdv6wD7/tRWMcKiA8p4QjJ/EUzxVvcV1M/rdrL5rgjq1TlX
 KfM4Vr+jOGWw+vH4oZ7k1IcyafTsF90+y1m/tMfUKBnkDiaa/2yMXP2B9gOm5Fbkd31+KGT
 qyguvIHRu6rqgEIjRJTeXaNL6r+iLIEEEOHgb9HyZi4zPeAOuusvzc+Ph7yE9LUOJ5oFRfG
 FLaHWGwMZkWJgJVrylW8w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:/iscvYMUj2s=:D6jkiQZZlLvU2DbWwLGRka
 s/wTwku8APxSue3R5LdgNBEeW9OYL6Y4YYeXdUUrv01//8VCHSopg3kmQ5VbaPXW6R1VsFk30
 yaxuWQ/zaR4FmTqAtBJvGVgtxiHg6+eBDilyn6p1hHEbwK//Hyj0/fL0Ti+Qh/SR3xf+nqRT5
 qgfmtJ/E7L2OwVyacTkuf+bLU08lZq7dD66X5SX9H5KJzhWnswOhRLCiPwZ2chD6+Jd3HFqJl
 aHWB0GycawCgV+pUkgxAAy5zKfMZEG4saQZfIgYV9AaD5Lgw50A6RkbtCTI+opV/vjcsR4D44
 IEUZoSARl8wUa2+FMGYsb8GJ0jQsrhpJIWJQnt1OIQTtTEiOYR0875WhFWlknhdxYKGBOHFqz
 kAkkUKgiPjtMcZ9SpZg2yhvZBJx2iniRcjoj1v5oGPfXk+RwGuqzjrC6OLwT7pU50fxtGRCE0
 5fkekKDcFknmCld9FDO9QXfiEgYyJenKRGW/8rpdwUM4bWkAsVqd5my1SiPEP/iNHRbNz/ITB
 TF9IdZHxRKrsrhsASfAZrOB8H8XnLqIrcYeoigkPxNAqwovIft3bVpoCDXbyApuThpQspL4/6
 eKQ3pARJo1MvLbBG4tuHrOjExNiN56U4z15p8iA6YeM/0ZqzH5hoYiWpWwf8ZDyoYjov8+PXR
 4unNRFjTQpOewaT5x0jWXyPju9yeyirwnzdgpC1/o7ctQ+YYduPIkbiR1peY/OuxC15J9xhjD
 7JOWeeO02EijN58g1iXmhgBAjGCkQutNxzVTkw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

clang-8 warns about one function here when KASAN is enabled, even
without the 'asan-stack' option:

drivers/media/usb/go7007/go7007-fw.c:1551:5: warning: stack frame size of 2656 bytes in function

I have reported this issue in the llvm bugzilla, but to make
it work with the clang-8 release, a small annotation is still
needed.

Link: https://bugs.llvm.org/show_bug.cgi?id=38809
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/usb/go7007/go7007-fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/go7007/go7007-fw.c b/drivers/media/usb/go7007/go7007-fw.c
index 24f5b615dc7a..c7201e93c331 100644
--- a/drivers/media/usb/go7007/go7007-fw.c
+++ b/drivers/media/usb/go7007/go7007-fw.c
@@ -1499,7 +1499,7 @@ static int modet_to_package(struct go7007 *go, __le16 *code, int space)
 	return cnt;
 }
 
-static int do_special(struct go7007 *go, u16 type, __le16 *code, int space,
+static noinline_for_stack int do_special(struct go7007 *go, u16 type, __le16 *code, int space,
 			int *framelen)
 {
 	switch (type) {
-- 
2.20.0

