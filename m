Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:11836 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab2HTLdQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Aug 2012 07:33:16 -0400
Received: from eusync1.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M9100ABWXGBJO70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 20 Aug 2012 12:33:47 +0100 (BST)
Received: from [106.116.147.32] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M91001WAXFDAB40@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 20 Aug 2012 12:33:14 +0100 (BST)
Message-id: <50322079.4080409@samsung.com>
Date: Mon, 20 Aug 2012 13:33:13 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sangwook Lee <sangwook.lee@linaro.org>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, suapapa@insignal.co.kr,
	quartz.jang@samsung.com, linaro-dev@lists.linaro.org,
	patches@linaro.org, usman.ahmad@linaro.org
Subject: Re: [PATH v3 0/2] Add v4l2 subdev driver for S5K4ECGX sensor with
 embedded SoC ISP
References: <1343914971-23007-1-git-send-email-sangwook.lee@linaro.org>
 <501ADEF6.1080901@gmail.com>
 <CADPsn1b6TxhmWVzzH1u-wr0UZs6D3cif4+r1S9OOROx1iXCXUQ@mail.gmail.com>
 <50315AC8.5060100@gmail.com>
 <CADPsn1YyOO=wS5eh3H0MJTgwga=j49eE+rn=xcVUaq+ES7CK+A@mail.gmail.com>
 <CADPsn1ZnqxRYd2kTWcOatZVgdcWWbNCA9kwMaWs4O_tk2gYEPQ@mail.gmail.com>
In-reply-to: <CADPsn1ZnqxRYd2kTWcOatZVgdcWWbNCA9kwMaWs4O_tk2gYEPQ@mail.gmail.com>
Content-type: multipart/mixed; boundary=------------020201040601070303000803
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020201040601070303000803
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Sangwook,

On 08/20/2012 12:43 PM, Sangwook Lee wrote:
> On 20 August 2012 09:12, Sangwook Lee <sangwook.lee@linaro.org> wrote:
>> On 19 August 2012 22:29, Sylwester Nawrocki
>> <sylvester.nawrocki@gmail.com> wrote:
>>> On 08/03/2012 04:24 PM, Sangwook Lee wrote:
>>>> I was thinking about this, but this seems to be is a bit time-consuming because
>>>> I have to do this just due to lack of s5k4ecgx hardware information.
>>>> let me try it later once
>>>> this patch is accepted.
>>>
>>> I've converted this driver to use function calls instead of the register
>>> arrays. It can be pulled, along with a couple of minor fixes/improvements,
>>> from following git tree:
>>>
>>>         git://linuxtv.org/snawrocki/media.git s5k4ecgx
>>>         (gitweb: http://git.linuxtv.org/snawrocki/media.git/s5k4ecgx)
>>>
>>> I don't own any Origen board thus it's untested. Could you give it a try ?
> 
> Sorry, It doesn't work. I will send pictures to you by another mail thread.
> Previously, I tested preview array and found out that
> +	/*
> +	 * FIXME: according to the datasheet,
> +	 * 0x70000496~ 0x7000049c seems to be only for capture mode,
> +	 * but without these value, it doesn't work with preview mode.
> +	 */
> 
> Do we need to set those values ?

Yes, after my changes it should be set too. But there is a bug in the
registers definitions. Attached patch should correct this, sorry about
this oversight. Let me know if there are still any issues.
To make sure the I2C write sequences are correct it might be useful to
log all calls to s5k4ecgx_write() and compare the logs with original
tables.

--

Regards,
Sylwester

--------------020201040601070303000803
Content-Type: text/x-patch;
 name="0001-s5k4ecgx-fix-register-definitions.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-s5k4ecgx-fix-register-definitions.patch"

>From b53f1279a32808d696676b905d167bcd33c6e2dc Mon Sep 17 00:00:00 2001
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Date: Mon, 20 Aug 2012 13:27:03 +0200
Subject: [PATCH] s5k4ecgx: fix register definitions

---
 drivers/media/video/s5k4ecgx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/s5k4ecgx.c b/drivers/media/video/s5k4ecgx.c
index 8ad0fb1..836db2f 100644
--- a/drivers/media/video/s5k4ecgx.c
+++ b/drivers/media/video/s5k4ecgx.c
@@ -69,7 +69,7 @@ module_param(debug, int, 0644);
 #define REG_G_PREV_OPEN_AFTER_CH	0x7000026a
 
 /* Preview context register sets. n = 0...4. */
-#define PREG(n, x)			((n) * 0x26 + (x))
+#define PREG(n, x)			((n) * 0x30 + (x))
 #define REG_P_OUT_WIDTH(n)		PREG(n, 0x700002a6)
 #define REG_P_OUT_HEIGHT(n)		PREG(n, 0x700002a8)
 #define REG_P_FMT(n)			PREG(n, 0x700002aa)
@@ -93,10 +93,10 @@ module_param(debug, int, 0644);
 #define REG_G_PREVZOOM_IN_HEIGHT	0x70000496
 #define REG_G_PREVZOOM_IN_XOFFS		0x70000498
 #define REG_G_PREVZOOM_IN_YOFFS		0x7000049a
-#define REG_G_CAPZOOM_IN_WIDTH		0x70000494
-#define REG_G_CAPZOOM_IN_HEIGHT		0x70000496
-#define REG_G_CAPZOOM_IN_XOFFS		0x70000498
-#define REG_G_CAPZOOM_IN_YOFFS		0x7000049a
+#define REG_G_CAPZOOM_IN_WIDTH		0x7000049c
+#define REG_G_CAPZOOM_IN_HEIGHT		0x7000049e
+#define REG_G_CAPZOOM_IN_XOFFS		0x700004a0
+#define REG_G_CAPZOOM_IN_YOFFS		0x700004a2
 
 /* n = 0...4 */
 #define REG_USER_SHARPNESS(n)		(0x70000a28 + (n) * 0xb6)
-- 
1.7.11.3


--------------020201040601070303000803--

