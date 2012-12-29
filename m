Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.univ-tours.fr ([193.52.209.50]:29599 "EHLO
	hermes.univ-tours.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab2L2NLh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Dec 2012 08:11:37 -0500
Message-ID: <50DEE9C5.7020407@lissyx.dyndns.org>
Date: Sat, 29 Dec 2012 14:01:57 +0100
From: Alexandre Lissy <lissyx+mozfr@lissyx.dyndns.org>
MIME-Version: 1.0
To: Alexey Klimov <klimov.linux@gmail.com>,
	Alexandre LISSY <alexandrelissy@free.fr>
CC: linux-media@vger.kernel.org
Subject: Re: iMon Knob driver issue
References: <5081109E.7060809@free.fr> <50DEDD43.3080300@free.fr> <CALW4P+++ZZXAGkn+jRVi2D4iz_UpUVUQLFDoQGGfAUMmgUhntg@mail.gmail.com>
In-Reply-To: <CALW4P+++ZZXAGkn+jRVi2D4iz_UpUVUQLFDoQGGfAUMmgUhntg@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040504060504020709040501"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040504060504020709040501
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Le 29/12/2012 13:31, Alexey Klimov a écrit :
> Hello Alexandre,
> 
> On Sat, Dec 29, 2012 at 4:08 PM, Alexandre LISSY <alexandrelissy@free.fr> wrote:
>> Hello,
>>
>> Please find attached a small patch for the iMon Knob driver. I've been
> 
> Could you please also add your Signed-off-by to the patch? It looks
> like it's missed.
> 

Sure, sorry for forgetting this, here it is !

--------------040504060504020709040501
Content-Type: text/x-diff;
 name="0001-fix-iMon-Knob-event-interpretation-issues.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-fix-iMon-Knob-event-interpretation-issues.patch"

>From cca7718a9902a4d5cffbf158b5853980a08ef930 Mon Sep 17 00:00:00 2001
From: Alexandre Lissy <alexandrelissy@free.fr>
Date: Sun, 2 Sep 2012 20:35:20 +0200
Subject: [PATCH] fix: iMon Knob event interpretation issues

Events for the iMon Knob pad where not correctly interpreted, resulting
in buggy mouse movements (cursor going straight out of the screen), key
pad only generating KEY_RIGHT and KEY_DOWN events. A reproducer is:

int main(int argc, char ** argv)
{
        char rel_x = 0x00; printf("rel_x:%d @%s:%d\n", rel_x, __FILE__, __LINE__);
        rel_x = 0x0f; printf("rel_x:%d @%s:%d\n", rel_x, __FILE__, __LINE__);
        rel_x |= ~0x0f; printf("rel_x:%d @%s:%d\n", rel_x, __FILE__, __LINE__);

        return 0;
}

(running on x86 or amd64)
$ ./test
rel_x:0 @test.c:6
rel_x:15 @test.c:7
rel_x:-1 @test.c:8

(running on armv6)
rel_x:0 @test.c:6
rel_x:15 @test.c:7
rel_x:255 @test.c:8

Forcing the rel_x and rel_y variables as signed char fixes the issue.

Signed-off-by: Alexandre Lissy <alexandrelissy@free.fr>
---
 drivers/media/rc/imon.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 5dd0386..9d30ca9 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1225,7 +1225,7 @@ static u32 imon_panel_key_lookup(u64 code)
 static bool imon_mouse_event(struct imon_context *ictx,
 			     unsigned char *buf, int len)
 {
-	char rel_x = 0x00, rel_y = 0x00;
+	signed char rel_x = 0x00, rel_y = 0x00;
 	u8 right_shift = 1;
 	bool mouse_input = true;
 	int dir = 0;
@@ -1301,7 +1301,7 @@ static void imon_touch_event(struct imon_context *ictx, unsigned char *buf)
 static void imon_pad_to_keys(struct imon_context *ictx, unsigned char *buf)
 {
 	int dir = 0;
-	char rel_x = 0x00, rel_y = 0x00;
+	signed char rel_x = 0x00, rel_y = 0x00;
 	u16 timeout, threshold;
 	u32 scancode = KEY_RESERVED;
 	unsigned long flags;
-- 
1.7.10.4


--------------040504060504020709040501--
