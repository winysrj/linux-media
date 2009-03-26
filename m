Return-path: <linux-media-owner@vger.kernel.org>
Received: from bane.moelleritberatung.de ([77.37.2.25]:34743 "EHLO
	bane.moelleritberatung.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbZCZJ4r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 05:56:47 -0400
Date: Thu, 26 Mar 2009 10:45:53 +0100
From: Artem Makhutov <artem@makhutov.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] Remove debug output from stb6100_cfg.h
Message-ID: <20090326094553.GA12847@titan.makhutov-it.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This patch removes the debug output from stb6100_cfg.h as it is flooding
the syslog with tuning data during normal operation.

Signed-off-by: Artem Makhutov <artem@makhutov.org>

--ibTvN161/egqYuK8
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="dvb-stb6100-removedebug.patch"

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

--ibTvN161/egqYuK8--
