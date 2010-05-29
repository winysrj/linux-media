Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40863 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab0E2RR2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 May 2010 13:17:28 -0400
Received: by vws11 with SMTP id 11so327254vws.19
        for <linux-media@vger.kernel.org>; Sat, 29 May 2010 10:17:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100528195945.GA7305@redhat.com>
References: <20100528195945.GA7305@redhat.com>
Date: Sat, 29 May 2010 13:17:27 -0400
Message-ID: <AANLkTill8ngzhHf-1D09UQ8TSfpI_2fyzyh1CyiqRNJy@mail.gmail.com>
Subject: [PATCH v2] IR: let all protocol decoders have a go at raw data
From: Jarod Wilson <jarod@wilsonet.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 28, 2010 at 3:59 PM, Jarod Wilson <jarod@redhat.com> wrote:
> The mceusb driver I'm about to submit handles just about any raw IR you
> can throw at it. The ir-core loads up all protocol decoders, starting
> with NEC, then RC5, then RC6. RUN_DECODER() was trying them in the same
> order, and exiting if any of the decoders didn't like the data. The
> default mceusb remote talks RC6(6A). Well, the RC6 decoder never gets a
> chance to run unless you move the RC6 decoder to the front of the list.
>
> What I believe to be correct is to have RUN_DECODER keep trying all of
> the decoders, even when one triggers an error. I don't think the errors
> matter so much as it matters that at least one was successful -- i.e.,
> that _sumrc is > 0. The following works for me w/my mceusb driver and
> the default decoder ordering -- NEC and RC5 still fail, but RC6 still
> gets a crack at it, and successfully does its job.
>
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
>
> ---
>  drivers/media/IR/ir-raw-event.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
> index ea68a3f..44162db 100644
> --- a/drivers/media/IR/ir-raw-event.c
> +++ b/drivers/media/IR/ir-raw-event.c
> @@ -36,14 +36,15 @@ static DEFINE_SPINLOCK(ir_raw_handler_lock);
>  */
>  #define RUN_DECODER(ops, ...) ({                                           \
>        struct ir_raw_handler           *_ir_raw_handler;                   \
> -       int _sumrc = 0, _rc;                                                \
> +       int _sumrc = 0, _rc, _fail;                                         \
>        spin_lock(&ir_raw_handler_lock);                                    \
>        list_for_each_entry(_ir_raw_handler, &ir_raw_handler_list, list) {  \
>                if (_ir_raw_handler->ops) {                                 \
>                        _rc = _ir_raw_handler->ops(__VA_ARGS__);            \
>                        if (_rc < 0)                                        \
> -                               break;                                      \
> -                       _sumrc += _rc;                                      \
> +                               _fail++;                                    \
> +                       else                                                \
> +                               _sumrc += _rc;                              \


Self-NAK. The only place we actually *care* about the retval from a
RUN_DECODER() call is in __ir_input_register(), and currently, its
looking for retval < 0, which is currently never possible. When we're
running the decoders, either they fail and return -EINVAL or they
succeed and return 0, and in the register case, we get either a
negative error (ex: -ENOMEM from rc6) or 0, so with the above, _sumrc
will *always* be 0 in the two cases I'm looking at. The third place
where RUN_DECODER gets called (decoder unregister) doesn't care about
the retval either. New patch below, including updated comments about
the macro.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/ir-raw-event.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
index ea68a3f..b832717 100644
--- a/drivers/media/IR/ir-raw-event.c
+++ b/drivers/media/IR/ir-raw-event.c
@@ -31,8 +31,9 @@ static DEFINE_SPINLOCK(ir_raw_handler_lock);
  *
  * Calls ir_raw_handler::ops for all registered IR handlers. It prevents
  * new decode addition/removal while running, by locking ir_raw_handler_lock
- * mutex. If an error occurs, it stops the ops. Otherwise, it returns a sum
- * of the return codes.
+ * mutex. If an error occurs, we keep going, as in the decode case, each
+ * decoder must have a crack at decoding the data. We return a sum of the
+ * return codes, which will be either 0 or negative for current callers.
  */
 #define RUN_DECODER(ops, ...) ({					    \
 	struct ir_raw_handler		*_ir_raw_handler;		    \
@@ -41,8 +42,6 @@ static DEFINE_SPINLOCK(ir_raw_handler_lock);
 	list_for_each_entry(_ir_raw_handler, &ir_raw_handler_list, list) {  \
 		if (_ir_raw_handler->ops) {				    \
 			_rc = _ir_raw_handler->ops(__VA_ARGS__);	    \
-			if (_rc < 0)					    \
-				break;					    \
 			_sumrc += _rc;					    \
 		}							    \
 	}								    \


-- 
Jarod Wilson
jarod@wilsonet.com
