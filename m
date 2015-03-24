Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42358 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbbCXHXe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 03:23:34 -0400
Date: Tue, 24 Mar 2015 10:23:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: kbuild@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	linux-media@vger.kernel.org
Subject: [linuxtv-media:master 348/454]
 drivers/media/dvb-core/dvb_frontend.c:861 dvb_frontend_thread() warn:
 inconsistent returns 'sem:&fepriv->sem'.
Message-ID: <20150324072340.GX16501@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   8a56b6b5fd6ff92b7e27d870b803b11b751660c2
commit: 135f9be9194cf7778eb73594aa55791b229cf27c [348/454] [media] dvb_frontend: start media pipeline while thread is running

New smatch warnings:
drivers/media/dvb-core/dvb_frontend.c:861 dvb_frontend_thread() warn: inconsistent returns 'sem:&fepriv->sem'.
  Locked on:   line 719
  Unlocked on: line 861

git remote add linuxtv-media git://linuxtv.org/media_tree.git
git remote update linuxtv-media
git checkout 135f9be9194cf7778eb73594aa55791b229cf27c
vim +861 drivers/media/dvb-core/dvb_frontend.c

dea74869 drivers/media/dvb/dvb-core/dvb_frontend.c Patrick Boettcher   2006-05-14  845  				fe->ops.i2c_gate_ctrl(fe, 0);
7eef5dd6 drivers/media/dvb/dvb-core/dvb_frontend.c Andrew de Quincey   2006-04-18  846  		}
dea74869 drivers/media/dvb/dvb-core/dvb_frontend.c Patrick Boettcher   2006-05-14  847  		if (fe->ops.sleep)
dea74869 drivers/media/dvb/dvb-core/dvb_frontend.c Patrick Boettcher   2006-05-14  848  			fe->ops.sleep(fe);
^1da177e drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds      2005-04-16  849  	}
^1da177e drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds      2005-04-16  850  
8eec1429 drivers/media/dvb/dvb-core/dvb_frontend.c Herbert Poetzl      2007-02-08  851  	fepriv->thread = NULL;
e36309f5 drivers/media/dvb/dvb-core/dvb_frontend.c Matthieu CASTET     2010-05-05  852  	if (kthread_should_stop())
18ed2860 drivers/media/dvb-core/dvb_frontend.c     Shuah Khan          2014-07-12  853  		fe->exit = DVB_FE_DEVICE_REMOVED;
e36309f5 drivers/media/dvb/dvb-core/dvb_frontend.c Matthieu CASTET     2010-05-05  854  	else
18ed2860 drivers/media/dvb-core/dvb_frontend.c     Shuah Khan          2014-07-12  855  		fe->exit = DVB_FE_NO_EXIT;
^1da177e drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds      2005-04-16  856  	mb();
^1da177e drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds      2005-04-16  857  
6ae23224 drivers/media/dvb-core/dvb_frontend.c     Juergen Lock        2012-12-23  858  	if (semheld)
6ae23224 drivers/media/dvb-core/dvb_frontend.c     Juergen Lock        2012-12-23  859  		up(&fepriv->sem);
^1da177e drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds      2005-04-16  860  	dvb_frontend_wakeup(fe);
^1da177e drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds      2005-04-16 @861  	return 0;
^1da177e drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds      2005-04-16  862  }
^1da177e drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds      2005-04-16  863  
^1da177e drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds      2005-04-16  864  static void dvb_frontend_stop(struct dvb_frontend *fe)
^1da177e drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds      2005-04-16  865  {
0c53c70f drivers/media/dvb/dvb-core/dvb_frontend.c Johannes Stezenbach 2005-05-16  866  	struct dvb_frontend_private *fepriv = fe->frontend_priv;
^1da177e drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds      2005-04-16  867  
36bdbc3f drivers/media/dvb-core/dvb_frontend.c     Antti Palosaari     2012-08-15  868  	dev_dbg(fe->dvb->device, "%s:\n", __func__);
^1da177e drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds      2005-04-16  869  

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
