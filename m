Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59777 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbZC0RY3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 13:24:29 -0400
Date: Fri, 27 Mar 2009 14:24:17 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Artem Makhutov <artem@makhutov.org>, linux-media@vger.kernel.org,
	Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [PATCH] Remove debug output from stb6100_cfg.h
Message-ID: <20090327142417.4d80f166@pedra.chehab.org>
In-Reply-To: <20090326094553.GA12847@titan.makhutov-it.de>
References: <20090326094553.GA12847@titan.makhutov-it.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manu,

If ok to you, please ack.

On Thu, 26 Mar 2009 10:45:53 +0100
Artem Makhutov <artem@makhutov.org> wrote:

This patch removes the debug output from stb6100_cfg.h as it is flooding
the syslog with tuning data during normal operation.

Signed-off-by: Artem Makhutov <artem@makhutov.org>

--- linux.old/drivers/media/dvb/frontends/stb6100_cfg.h	2009-03-26 10:28:57.000000000 +0100
+++ linux/drivers/media/dvb/frontends/stb6100_cfg.h	2009-03-26 10:29:52.000000000 +0100
@@ -36,7 +36,6 @@
 			return err;
 		}
 		*frequency = t_state.frequency;
-		printk("%s: Frequency=%d\n", __func__, t_state.frequency);
 	}
 	return 0;
 }
@@ -59,7 +58,6 @@
 			return err;
 		}
 	}
-	printk("%s: Frequency=%d\n", __func__, t_state.frequency);
 	return 0;
 }
 
@@ -81,7 +79,6 @@
 		}
 		*bandwidth = t_state.bandwidth;
 	}
-	printk("%s: Bandwidth=%d\n", __func__, t_state.bandwidth);
 	return 0;
 }
 
@@ -103,6 +100,5 @@
 			return err;
 		}
 	}
-	printk("%s: Bandwidth=%d\n", __func__, t_state.bandwidth);
 	return 0;
 }


Cheers,
Mauro
