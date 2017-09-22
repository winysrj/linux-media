Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:56769 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752622AbdIVVco (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 17:32:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Marek <mmarek@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, kasan-dev@googlegroups.com,
        linux-kbuild@vger.kernel.org, Jakub Jelinek <jakub@gcc.gnu.org>,
        =?UTF-8?q?Martin=20Li=C5=A1ka?= <marxin@gcc.gnu.org>,
        stable@vger.kernel.org
Subject: [PATCH v4 8/9] netlink: fix nla_put_{u8,u16,u32} for KASAN
Date: Fri, 22 Sep 2017 23:29:19 +0200
Message-Id: <20170922212930.620249-9-arnd@arndb.de>
In-Reply-To: <20170922212930.620249-1-arnd@arndb.de>
References: <20170922212930.620249-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When CONFIG_KASAN is enabled, the "--param asan-stack=1" causes rather large
stack frames in some functions. This goes unnoticed normally because
CONFIG_FRAME_WARN is disabled with CONFIG_KASAN by default as of commit
3f181b4d8652 ("lib/Kconfig.debug: disable -Wframe-larger-than warnings with
KASAN=y").

The kernelci.org build bot however has the warning enabled and that led
me to investigate it a little further, as every build produces these warnings:

net/wireless/nl80211.c:4389:1: warning: the frame size of 2240 bytes is larger than 2048 bytes [-Wframe-larger-than=]
net/wireless/nl80211.c:1895:1: warning: the frame size of 3776 bytes is larger than 2048 bytes [-Wframe-larger-than=]
net/wireless/nl80211.c:1410:1: warning: the frame size of 2208 bytes is larger than 2048 bytes [-Wframe-larger-than=]
net/bridge/br_netlink.c:1282:1: warning: the frame size of 2544 bytes is larger than 2048 bytes [-Wframe-larger-than=]

Most of this problem is now solved in gcc-8, which can consolidate
the stack slots for the inline function arguments. On older compilers
we can add a workaround by declaring a local variable in each function
to pass the inline function argument.

Cc: stable@vger.kernel.org
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=81715
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/net/netlink.h | 73 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 55 insertions(+), 18 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index e51cf5f81597..14c289393071 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -773,7 +773,10 @@ static inline int nla_parse_nested(struct nlattr *tb[], int maxtype,
  */
 static inline int nla_put_u8(struct sk_buff *skb, int attrtype, u8 value)
 {
-	return nla_put(skb, attrtype, sizeof(u8), &value);
+	/* temporary variables to work around GCC PR81715 with asan-stack=1 */
+	u8 tmp = value;
+
+	return nla_put(skb, attrtype, sizeof(u8), &tmp);
 }
 
 /**
@@ -784,7 +787,9 @@ static inline int nla_put_u8(struct sk_buff *skb, int attrtype, u8 value)
  */
 static inline int nla_put_u16(struct sk_buff *skb, int attrtype, u16 value)
 {
-	return nla_put(skb, attrtype, sizeof(u16), &value);
+	u16 tmp = value;
+
+	return nla_put(skb, attrtype, sizeof(u16), &tmp);
 }
 
 /**
@@ -795,7 +800,9 @@ static inline int nla_put_u16(struct sk_buff *skb, int attrtype, u16 value)
  */
 static inline int nla_put_be16(struct sk_buff *skb, int attrtype, __be16 value)
 {
-	return nla_put(skb, attrtype, sizeof(__be16), &value);
+	__be16 tmp = value;
+
+	return nla_put(skb, attrtype, sizeof(__be16), &tmp);
 }
 
 /**
@@ -806,7 +813,9 @@ static inline int nla_put_be16(struct sk_buff *skb, int attrtype, __be16 value)
  */
 static inline int nla_put_net16(struct sk_buff *skb, int attrtype, __be16 value)
 {
-	return nla_put_be16(skb, attrtype | NLA_F_NET_BYTEORDER, value);
+	__be16 tmp = value;
+
+	return nla_put_be16(skb, attrtype | NLA_F_NET_BYTEORDER, tmp);
 }
 
 /**
@@ -817,7 +826,9 @@ static inline int nla_put_net16(struct sk_buff *skb, int attrtype, __be16 value)
  */
 static inline int nla_put_le16(struct sk_buff *skb, int attrtype, __le16 value)
 {
-	return nla_put(skb, attrtype, sizeof(__le16), &value);
+	__le16 tmp = value;
+
+	return nla_put(skb, attrtype, sizeof(__le16), &tmp);
 }
 
 /**
@@ -828,7 +839,9 @@ static inline int nla_put_le16(struct sk_buff *skb, int attrtype, __le16 value)
  */
 static inline int nla_put_u32(struct sk_buff *skb, int attrtype, u32 value)
 {
-	return nla_put(skb, attrtype, sizeof(u32), &value);
+	u32 tmp = value;
+
+	return nla_put(skb, attrtype, sizeof(u32), &tmp);
 }
 
 /**
@@ -839,7 +852,9 @@ static inline int nla_put_u32(struct sk_buff *skb, int attrtype, u32 value)
  */
 static inline int nla_put_be32(struct sk_buff *skb, int attrtype, __be32 value)
 {
-	return nla_put(skb, attrtype, sizeof(__be32), &value);
+	__be32 tmp = value;
+
+	return nla_put(skb, attrtype, sizeof(__be32), &tmp);
 }
 
 /**
@@ -850,7 +865,9 @@ static inline int nla_put_be32(struct sk_buff *skb, int attrtype, __be32 value)
  */
 static inline int nla_put_net32(struct sk_buff *skb, int attrtype, __be32 value)
 {
-	return nla_put_be32(skb, attrtype | NLA_F_NET_BYTEORDER, value);
+	__be32 tmp = value;
+
+	return nla_put_be32(skb, attrtype | NLA_F_NET_BYTEORDER, tmp);
 }
 
 /**
@@ -861,7 +878,9 @@ static inline int nla_put_net32(struct sk_buff *skb, int attrtype, __be32 value)
  */
 static inline int nla_put_le32(struct sk_buff *skb, int attrtype, __le32 value)
 {
-	return nla_put(skb, attrtype, sizeof(__le32), &value);
+	__le32 tmp = value;
+
+	return nla_put(skb, attrtype, sizeof(__le32), &tmp);
 }
 
 /**
@@ -874,7 +893,9 @@ static inline int nla_put_le32(struct sk_buff *skb, int attrtype, __le32 value)
 static inline int nla_put_u64_64bit(struct sk_buff *skb, int attrtype,
 				    u64 value, int padattr)
 {
-	return nla_put_64bit(skb, attrtype, sizeof(u64), &value, padattr);
+	u64 tmp = value;
+
+	return nla_put_64bit(skb, attrtype, sizeof(u64), &tmp, padattr);
 }
 
 /**
@@ -887,7 +908,9 @@ static inline int nla_put_u64_64bit(struct sk_buff *skb, int attrtype,
 static inline int nla_put_be64(struct sk_buff *skb, int attrtype, __be64 value,
 			       int padattr)
 {
-	return nla_put_64bit(skb, attrtype, sizeof(__be64), &value, padattr);
+	__be64 tmp = value;
+
+	return nla_put_64bit(skb, attrtype, sizeof(__be64), &tmp, padattr);
 }
 
 /**
@@ -900,7 +923,9 @@ static inline int nla_put_be64(struct sk_buff *skb, int attrtype, __be64 value,
 static inline int nla_put_net64(struct sk_buff *skb, int attrtype, __be64 value,
 				int padattr)
 {
-	return nla_put_be64(skb, attrtype | NLA_F_NET_BYTEORDER, value,
+	__be64 tmp = value;
+
+	return nla_put_be64(skb, attrtype | NLA_F_NET_BYTEORDER, tmp,
 			    padattr);
 }
 
@@ -914,7 +939,9 @@ static inline int nla_put_net64(struct sk_buff *skb, int attrtype, __be64 value,
 static inline int nla_put_le64(struct sk_buff *skb, int attrtype, __le64 value,
 			       int padattr)
 {
-	return nla_put_64bit(skb, attrtype, sizeof(__le64), &value, padattr);
+	__le64 tmp = value;
+
+	return nla_put_64bit(skb, attrtype, sizeof(__le64), &tmp, padattr);
 }
 
 /**
@@ -925,7 +952,9 @@ static inline int nla_put_le64(struct sk_buff *skb, int attrtype, __le64 value,
  */
 static inline int nla_put_s8(struct sk_buff *skb, int attrtype, s8 value)
 {
-	return nla_put(skb, attrtype, sizeof(s8), &value);
+	s8 tmp = value;
+
+	return nla_put(skb, attrtype, sizeof(s8), &tmp);
 }
 
 /**
@@ -936,7 +965,9 @@ static inline int nla_put_s8(struct sk_buff *skb, int attrtype, s8 value)
  */
 static inline int nla_put_s16(struct sk_buff *skb, int attrtype, s16 value)
 {
-	return nla_put(skb, attrtype, sizeof(s16), &value);
+	s16 tmp = value;
+
+	return nla_put(skb, attrtype, sizeof(s16), &tmp);
 }
 
 /**
@@ -947,7 +978,9 @@ static inline int nla_put_s16(struct sk_buff *skb, int attrtype, s16 value)
  */
 static inline int nla_put_s32(struct sk_buff *skb, int attrtype, s32 value)
 {
-	return nla_put(skb, attrtype, sizeof(s32), &value);
+	s32 tmp = value;
+
+	return nla_put(skb, attrtype, sizeof(s32), &tmp);
 }
 
 /**
@@ -960,7 +993,9 @@ static inline int nla_put_s32(struct sk_buff *skb, int attrtype, s32 value)
 static inline int nla_put_s64(struct sk_buff *skb, int attrtype, s64 value,
 			      int padattr)
 {
-	return nla_put_64bit(skb, attrtype, sizeof(s64), &value, padattr);
+	s64 tmp = value;
+
+	return nla_put_64bit(skb, attrtype, sizeof(s64), &tmp, padattr);
 }
 
 /**
@@ -1010,7 +1045,9 @@ static inline int nla_put_msecs(struct sk_buff *skb, int attrtype,
 static inline int nla_put_in_addr(struct sk_buff *skb, int attrtype,
 				  __be32 addr)
 {
-	return nla_put_be32(skb, attrtype, addr);
+	__be32 tmp = addr;
+
+	return nla_put_be32(skb, attrtype, tmp);
 }
 
 /**
-- 
2.9.0
