Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx05.lb01.inode.at ([62.99.145.5] helo=mx.inode.at)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <philipp@kolmann.at>) id 1Jvc4r-0003bb-IX
	for linux-dvb@linuxtv.org; Mon, 12 May 2008 19:44:46 +0200
Date: Mon, 12 May 2008 19:44:41 +0200
From: Philipp Kolmann <philipp@kolmann.at>
To: Igor <goga777@bk.ru>
Message-ID: <20080512174441.GB23724@kolmann.at>
References: <20080510085803.GA30598@kolmann.at>
	<E1JulAl-0001Ho-00.goga777-bk-ru@f53.mail.ru>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <E1JulAl-0001Ho-00.goga777-bk-ru@f53.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Mantis-08f27ef99d74: Compile error with 2.6.25
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Sat, May 10, 2008 at 01:15:19PM +0400, Igor wrote:
> could you try with the latest mantis version
> http://jusst.de/hg/mantis/rev/b7b8a2a81f3e

Manits head got fixed (regarding to the hg log). So I tried it. Still the same
error. Same with v4l tree.

Now I found a little patch which brought me over this compile error:

http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc4/2.6.24-rc4-mm1/broken-out/fix-jdelvare-i2c-i2c-constify-client-address-data.patch

From: Andrew Morton <akpm@linux-foundation.org>

drivers/media/video/tvaudio.c:147: error: conflicting type qualifiers for 'addr_data'
include/media/v4l2-i2c-drv-legacy.h:37: error: previous declaration of 'addr_data' was here

Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/media/v4l2-i2c-drv-legacy.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/media/v4l2-i2c-drv-legacy.h~fix-jdelvare-i2c-i2c-constify-client-address-data include/media/v4l2-i2c-drv-legacy.h
--- a/include/media/v4l2-i2c-drv-legacy.h~fix-jdelvare-i2c-i2c-constify-client-address-data
+++ a/include/media/v4l2-i2c-drv-legacy.h
@@ -34,7 +34,7 @@ struct v4l2_i2c_driver_data {
 };
 
 static struct v4l2_i2c_driver_data v4l2_i2c_data;
-static struct i2c_client_address_data addr_data;
+static const struct i2c_client_address_data addr_data;
 static struct i2c_driver v4l2_i2c_driver_legacy;
 static char v4l2_i2c_drv_name_legacy[32];


Now I'm a step further.

Thanks
Philipp
-- 
The more I learn about people, the more I like my dog!

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
