Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:49690 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab2DQKdl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 06:33:41 -0400
Date: Tue, 17 Apr 2012 13:33:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: crope@iki.fi
Cc: linux-media@vger.kernel.org
Subject: re: [media] tda10071: NXP TDA10071 DVB-S/S2 driver
Message-ID: <20120417103330.GA13569@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

Smatch complains about a potential information leak.  I was hoping you
could take a look.

The patch de8e42035014: "[media] tda10071: NXP TDA10071 DVB-S/S2 
driver" from Aug 1, 2011, leads to the following warning:
drivers/media/dvb/frontends/tda10071.c:322 
tda10071_diseqc_send_master_cmd()
	 error: memcpy() 'diseqc_cmd->msg' too small (6 vs 16)


drivers/media/dvb/frontends/tda10071.c
   290          if (diseqc_cmd->msg_len < 3 || diseqc_cmd->msg_len > 16) {
                                               ^^^^^^^^^^^^^^^^^^^^^^^^
We cap ->msg_len at 16 here.  I wasn't able to figure out where the 16
came from.  Or the 3 for that matter.

   291                  ret = -EINVAL;
   292                  goto error;
   293          }
   294  
   295          /* wait LNB TX */
   296          for (i = 500, tmp = 0; i && !tmp; i--) {
   297                  ret = tda10071_rd_reg_mask(priv, 0x47, &tmp, 0x01);
   298                  if (ret)
   299                          goto error;
   300  
   301                  usleep_range(10000, 20000);
   302          }
   303  
   304          dbg("%s: loop=%d", __func__, i);
   305  
   306          if (i == 0) {
   307                  ret = -ETIMEDOUT;
   308                  goto error;
   309          }
   310  
   311          ret = tda10071_wr_reg_mask(priv, 0x47, 0x00, 0x01);
   312          if (ret)
   313                  goto error;
   314  
   315          cmd.args[0x00] = CMD_LNB_SEND_DISEQC;
   316          cmd.args[0x01] = 0;
   317          cmd.args[0x02] = 0;
   318          cmd.args[0x03] = 0;
   319          cmd.args[0x04] = 2;
   320          cmd.args[0x05] = 0;
   321          cmd.args[0x06] = diseqc_cmd->msg_len;
   322          memcpy(&cmd.args[0x07], diseqc_cmd->msg, diseqc_cmd->msg_len);
                                        ^^^^^^^^^^^^^^^
->msg is only 6 bytes long so we're copying past the end of the array.

Also cmd.arg is 0x1e (30) bytes long and we only copy 0x07 + 16 bytes
into it so it leaves the last 7 bytes of cmd.args unitialized.  Btw,
why are the sizes specified in hex instead of decimal here?

   323          cmd.len = 0x07 + diseqc_cmd->msg_len;

regards,
dan carpenter

