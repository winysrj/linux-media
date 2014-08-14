Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32317 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbaHNNQU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Aug 2014 09:16:20 -0400
Date: Thu, 14 Aug 2014 21:15:57 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [linuxtv-media:devel 489/499]
 drivers/media/usb/as102/as10x_cmd.c:45:40: sparse: incorrect type in
 assignment (different base types)
Message-ID: <53ecb68d.AvEKoHWk+G7h+PnB%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git devel
head:   e5c52c1b504e5620c16b4b87f9c092f719f4706e
commit: af2f93f4f7f45050e042c62041e3dce06d3099c3 [489/499] [media] as102: promote it out of staging
reproduce: make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/usb/as102/as10x_cmd.c:45:40: sparse: incorrect type in assignment (different base types)
   drivers/media/usb/as102/as10x_cmd.c:45:40:    expected unsigned short [unsigned] [usertype] proc_id
   drivers/media/usb/as102/as10x_cmd.c:45:40:    got restricted __le16 [usertype] <noident>
>> drivers/media/usb/as102/as10x_cmd.c:86:41: sparse: incorrect type in assignment (different base types)
   drivers/media/usb/as102/as10x_cmd.c:86:41:    expected unsigned short [unsigned] [usertype] proc_id
   drivers/media/usb/as102/as10x_cmd.c:86:41:    got restricted __le16 [usertype] <noident>
>> drivers/media/usb/as102/as10x_cmd.c:128:41: sparse: incorrect type in assignment (different base types)
   drivers/media/usb/as102/as10x_cmd.c:128:41:    expected unsigned short [unsigned] [usertype] proc_id
   drivers/media/usb/as102/as10x_cmd.c:128:41:    got restricted __le16 [usertype] <noident>
>> drivers/media/usb/as102/as10x_cmd.c:129:43: sparse: incorrect type in assignment (different base types)
   drivers/media/usb/as102/as10x_cmd.c:129:43:    expected unsigned int [unsigned] [usertype] freq
   drivers/media/usb/as102/as10x_cmd.c:129:43:    got restricted __le32 [usertype] <noident>
>> drivers/media/usb/as102/as10x_cmd.c:183:48: sparse: incorrect type in assignment (different base types)
   drivers/media/usb/as102/as10x_cmd.c:183:48:    expected unsigned short [unsigned] [usertype] proc_id
   drivers/media/usb/as102/as10x_cmd.c:183:48:    got restricted __le16 [usertype] <noident>
>> drivers/media/usb/as102/as10x_cmd.c:207:17: sparse: cast to restricted __le16
>> drivers/media/usb/as102/as10x_cmd.c:208:24: sparse: cast to restricted __le16
>> drivers/media/usb/as102/as10x_cmd.c:209:24: sparse: cast to restricted __le16
>> drivers/media/usb/as102/as10x_cmd.c:235:48: sparse: incorrect type in assignment (different base types)
   drivers/media/usb/as102/as10x_cmd.c:235:48:    expected unsigned short [unsigned] [usertype] proc_id
   drivers/media/usb/as102/as10x_cmd.c:235:48:    got restricted __le16 [usertype] <noident>
>> drivers/media/usb/as102/as10x_cmd.c:267:25: sparse: cast to restricted __le16
>> drivers/media/usb/as102/as10x_cmd.c:294:48: sparse: incorrect type in assignment (different base types)
   drivers/media/usb/as102/as10x_cmd.c:294:48:    expected unsigned short [unsigned] [usertype] proc_id
   drivers/media/usb/as102/as10x_cmd.c:294:48:    got restricted __le16 [usertype] <noident>
>> drivers/media/usb/as102/as10x_cmd.c:318:17: sparse: cast to restricted __le32
>> drivers/media/usb/as102/as10x_cmd.c:320:17: sparse: cast to restricted __le32
>> drivers/media/usb/as102/as10x_cmd.c:322:17: sparse: cast to restricted __le32
>> drivers/media/usb/as102/as10x_cmd.c:324:17: sparse: cast to restricted __le16
>> drivers/media/usb/as102/as10x_cmd.c:354:48: sparse: incorrect type in assignment (different base types)
   drivers/media/usb/as102/as10x_cmd.c:354:48:    expected unsigned short [unsigned] [usertype] proc_id
   drivers/media/usb/as102/as10x_cmd.c:354:48:    got restricted __le16 [usertype] <noident>
>> drivers/media/usb/as102/as10x_cmd.c:392:29: sparse: incorrect type in assignment (different base types)
   drivers/media/usb/as102/as10x_cmd.c:392:29:    expected unsigned short [unsigned] [usertype] req_id
   drivers/media/usb/as102/as10x_cmd.c:392:29:    got restricted __le16 [usertype] <noident>
>> drivers/media/usb/as102/as10x_cmd.c:393:27: sparse: incorrect type in assignment (different base types)
   drivers/media/usb/as102/as10x_cmd.c:393:27:    expected unsigned short [unsigned] [usertype] prog
   drivers/media/usb/as102/as10x_cmd.c:393:27:    got restricted __le16 [usertype] <noident>
>> drivers/media/usb/as102/as10x_cmd.c:394:30: sparse: incorrect type in assignment (different base types)
   drivers/media/usb/as102/as10x_cmd.c:394:30:    expected unsigned short [unsigned] [usertype] version
   drivers/media/usb/as102/as10x_cmd.c:394:30:    got restricted __le16 [usertype] <noident>
>> drivers/media/usb/as102/as10x_cmd.c:395:31: sparse: incorrect type in assignment (different base types)
   drivers/media/usb/as102/as10x_cmd.c:395:31:    expected unsigned short [unsigned] [usertype] data_len
   drivers/media/usb/as102/as10x_cmd.c:395:31:    got restricted __le16 [usertype] <noident>
>> drivers/media/usb/as102/as10x_cmd.c:413:14: sparse: cast to restricted __le16
--
>> drivers/media/usb/as102/as10x_cmd_stream.c:45:47: sparse: incorrect type in assignment (different base types)
   drivers/media/usb/as102/as10x_cmd_stream.c:45:47:    expected unsigned short [unsigned] [usertype] proc_id
   drivers/media/usb/as102/as10x_cmd_stream.c:45:47:    got restricted __le16 [usertype] <noident>
>> drivers/media/usb/as102/as10x_cmd_stream.c:47:43: sparse: incorrect type in assignment (different base types)
   drivers/media/usb/as102/as10x_cmd_stream.c:47:43:    expected unsigned short [unsigned] [usertype] pid
   drivers/media/usb/as102/as10x_cmd_stream.c:47:43:    got restricted __le16 [usertype] <noident>
>> drivers/media/usb/as102/as10x_cmd_stream.c:102:47: sparse: incorrect type in assignment (different base types)
   drivers/media/usb/as102/as10x_cmd_stream.c:102:47:    expected unsigned short [unsigned] [usertype] proc_id
   drivers/media/usb/as102/as10x_cmd_stream.c:102:47:    got restricted __le16 [usertype] <noident>
>> drivers/media/usb/as102/as10x_cmd_stream.c:104:43: sparse: incorrect type in assignment (different base types)
   drivers/media/usb/as102/as10x_cmd_stream.c:104:43:    expected unsigned short [unsigned] [usertype] pid
   drivers/media/usb/as102/as10x_cmd_stream.c:104:43:    got restricted __le16 [usertype] <noident>
>> drivers/media/usb/as102/as10x_cmd_stream.c:146:48: sparse: incorrect type in assignment (different base types)
   drivers/media/usb/as102/as10x_cmd_stream.c:146:48:    expected unsigned short [unsigned] [usertype] proc_id
   drivers/media/usb/as102/as10x_cmd_stream.c:146:48:    got restricted __le16 [usertype] <noident>
>> drivers/media/usb/as102/as10x_cmd_stream.c:189:47: sparse: incorrect type in assignment (different base types)
   drivers/media/usb/as102/as10x_cmd_stream.c:189:47:    expected unsigned short [unsigned] [usertype] proc_id
   drivers/media/usb/as102/as10x_cmd_stream.c:189:47:    got restricted __le16 [usertype] <noident>
--
>> drivers/media/usb/as102/as10x_cmd_cfg.c:51:40: sparse: incorrect type in assignment (different base types)
   drivers/media/usb/as102/as10x_cmd_cfg.c:51:40:    expected unsigned short [unsigned] [usertype] proc_id
   drivers/media/usb/as102/as10x_cmd_cfg.c:51:40:    got restricted __le16 [usertype] <noident>
>> drivers/media/usb/as102/as10x_cmd_cfg.c:52:36: sparse: incorrect type in assignment (different base types)
   drivers/media/usb/as102/as10x_cmd_cfg.c:52:36:    expected unsigned short [unsigned] [usertype] tag
   drivers/media/usb/as102/as10x_cmd_cfg.c:52:36:    got restricted __le16 [usertype] <noident>
>> drivers/media/usb/as102/as10x_cmd_cfg.c:53:37: sparse: incorrect type in assignment (different base types)
   drivers/media/usb/as102/as10x_cmd_cfg.c:53:37:    expected unsigned short [unsigned] [usertype] type
   drivers/media/usb/as102/as10x_cmd_cfg.c:53:37:    got restricted __le16 [usertype] <noident>
>> drivers/media/usb/as102/as10x_cmd_cfg.c:77:27: sparse: cast to restricted __le32
>> drivers/media/usb/as102/as10x_cmd_cfg.c:107:40: sparse: incorrect type in assignment (different base types)
   drivers/media/usb/as102/as10x_cmd_cfg.c:107:40:    expected unsigned short [unsigned] [usertype] proc_id
   drivers/media/usb/as102/as10x_cmd_cfg.c:107:40:    got restricted __le16 [usertype] <noident>
>> drivers/media/usb/as102/as10x_cmd_cfg.c:109:50: sparse: incorrect type in assignment (different base types)
   drivers/media/usb/as102/as10x_cmd_cfg.c:109:50:    expected unsigned int [unsigned] [usertype] value32
   drivers/media/usb/as102/as10x_cmd_cfg.c:109:50:    got restricted __le32 [usertype] <noident>
>> drivers/media/usb/as102/as10x_cmd_cfg.c:110:36: sparse: incorrect type in assignment (different base types)
   drivers/media/usb/as102/as10x_cmd_cfg.c:110:36:    expected unsigned short [unsigned] [usertype] tag
   drivers/media/usb/as102/as10x_cmd_cfg.c:110:36:    got restricted __le16 [usertype] <noident>
>> drivers/media/usb/as102/as10x_cmd_cfg.c:111:37: sparse: incorrect type in assignment (different base types)
   drivers/media/usb/as102/as10x_cmd_cfg.c:111:37:    expected unsigned short [unsigned] [usertype] type
   drivers/media/usb/as102/as10x_cmd_cfg.c:111:37:    got restricted __le16 [usertype] <noident>
>> drivers/media/usb/as102/as10x_cmd_cfg.c:161:48: sparse: incorrect type in assignment (different base types)
   drivers/media/usb/as102/as10x_cmd_cfg.c:161:48:    expected unsigned short [unsigned] [usertype] proc_id
   drivers/media/usb/as102/as10x_cmd_cfg.c:161:48:    got restricted __le16 [usertype] <noident>
>> drivers/media/usb/as102/as10x_cmd_cfg.c:202:14: sparse: cast to restricted __le16

vim +45 drivers/media/usb/as102/as10x_cmd.c

41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31   39  
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31   40  	/* prepare command */
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06   41  	as10x_cmd_build(pcmd, (++adap->cmd_xid),
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31   42  			sizeof(pcmd->body.turn_on.req));
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31   43  
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31   44  	/* fill command */
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  @45  	pcmd->body.turn_on.req.proc_id = cpu_to_le16(CONTROL_PROC_TURNON);
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31   46  
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31   47  	/* send command */
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06   48  	if (adap->ops->xfer_cmd) {
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06   49  		error = adap->ops->xfer_cmd(adap, (uint8_t *) pcmd,
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06   50  					    sizeof(pcmd->body.turn_on.req) +
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06   51  					    HEADER_SIZE,
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06   52  					    (uint8_t *) prsp,
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06   53  					    sizeof(prsp->body.turn_on.rsp) +
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06   54  					    HEADER_SIZE);
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31   55  	}
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31   56  
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31   57  	if (error < 0)
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31   58  		goto out;
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31   59  
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31   60  	/* parse response */
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31   61  	error = as10x_rsp_parse(prsp, CONTROL_PROC_TURNON_RSP);
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31   62  
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31   63  out:
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31   64  	return error;
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31   65  }
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31   66  
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31   67  /**
3b4544a3 drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-10-31   68   * as10x_cmd_turn_off - send turn off command to AS10x
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06   69   * @adap:   pointer to AS10x bus adapter
3b4544a3 drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-10-31   70   *
3b4544a3 drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-10-31   71   * Return 0 on success or negative value in case of error.
3b4544a3 drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-10-31   72   */
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06   73  int as10x_cmd_turn_off(struct as10x_bus_adapter_t *adap)
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31   74  {
0550b294 drivers/staging/media/as102/as10x_cmd.c joseph daniel         2012-05-06   75  	int error = AS10X_CMD_ERROR;
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31   76  	struct as10x_cmd_t *pcmd, *prsp;
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31   77  
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06   78  	pcmd = adap->cmd;
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06   79  	prsp = adap->rsp;
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31   80  
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31   81  	/* prepare command */
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06   82  	as10x_cmd_build(pcmd, (++adap->cmd_xid),
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31   83  			sizeof(pcmd->body.turn_off.req));
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31   84  
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31   85  	/* fill command */
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  @86  	pcmd->body.turn_off.req.proc_id = cpu_to_le16(CONTROL_PROC_TURNOFF);
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31   87  
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31   88  	/* send command */
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06   89  	if (adap->ops->xfer_cmd) {
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06   90  		error = adap->ops->xfer_cmd(
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06   91  			adap, (uint8_t *) pcmd,
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31   92  			sizeof(pcmd->body.turn_off.req) + HEADER_SIZE,
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31   93  			(uint8_t *) prsp,
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31   94  			sizeof(prsp->body.turn_off.rsp) + HEADER_SIZE);
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31   95  	}
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31   96  
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31   97  	if (error < 0)
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31   98  		goto out;
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31   99  
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  100  	/* parse response */
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  101  	error = as10x_rsp_parse(prsp, CONTROL_PROC_TURNOFF_RSP);
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31  102  
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31  103  out:
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  104  	return error;
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31  105  }
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31  106  
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31  107  /**
3b4544a3 drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-10-31  108   * as10x_cmd_set_tune - send set tune command to AS10x
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06  109   * @adap:    pointer to AS10x bus adapter
3b4544a3 drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-10-31  110   * @ptune:   tune parameters
3b4544a3 drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-10-31  111   *
3b4544a3 drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-10-31  112   * Return 0 on success or negative value in case of error.
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31  113   */
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06  114  int as10x_cmd_set_tune(struct as10x_bus_adapter_t *adap,
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06  115  		       struct as10x_tune_args *ptune)
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31  116  {
0550b294 drivers/staging/media/as102/as10x_cmd.c joseph daniel         2012-05-06  117  	int error = AS10X_CMD_ERROR;
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  118  	struct as10x_cmd_t *preq, *prsp;
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  119  
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06  120  	preq = adap->cmd;
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06  121  	prsp = adap->rsp;
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  122  
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  123  	/* prepare command */
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06  124  	as10x_cmd_build(preq, (++adap->cmd_xid),
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  125  			sizeof(preq->body.set_tune.req));
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  126  
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  127  	/* fill command */
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31 @128  	preq->body.set_tune.req.proc_id = cpu_to_le16(CONTROL_PROC_SETTUNE);
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31 @129  	preq->body.set_tune.req.args.freq = cpu_to_le32(ptune->freq);
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  130  	preq->body.set_tune.req.args.bandwidth = ptune->bandwidth;
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  131  	preq->body.set_tune.req.args.hier_select = ptune->hier_select;
dfc64384 drivers/staging/media/as102/as10x_cmd.c Mauro Carvalho Chehab 2011-12-26  132  	preq->body.set_tune.req.args.modulation = ptune->modulation;
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  133  	preq->body.set_tune.req.args.hierarchy = ptune->hierarchy;
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  134  	preq->body.set_tune.req.args.interleaving_mode  =
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  135  		ptune->interleaving_mode;
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  136  	preq->body.set_tune.req.args.code_rate  = ptune->code_rate;
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  137  	preq->body.set_tune.req.args.guard_interval = ptune->guard_interval;
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  138  	preq->body.set_tune.req.args.transmission_mode  =
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  139  		ptune->transmission_mode;
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  140  
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  141  	/* send command */
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06  142  	if (adap->ops->xfer_cmd) {
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06  143  		error = adap->ops->xfer_cmd(adap,
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06  144  					    (uint8_t *) preq,
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06  145  					    sizeof(preq->body.set_tune.req)
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06  146  					    + HEADER_SIZE,
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06  147  					    (uint8_t *) prsp,
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06  148  					    sizeof(prsp->body.set_tune.rsp)
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06  149  					    + HEADER_SIZE);
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  150  	}
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  151  
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  152  	if (error < 0)
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  153  		goto out;
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  154  
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  155  	/* parse response */
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  156  	error = as10x_rsp_parse(prsp, CONTROL_PROC_SETTUNE_RSP);
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31  157  
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31  158  out:
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  159  	return error;
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31  160  }
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31  161  
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31  162  /**
3b4544a3 drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-10-31  163   * as10x_cmd_get_tune_status - send get tune status command to AS10x
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06  164   * @adap: pointer to AS10x bus adapter
3b4544a3 drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-10-31  165   * @pstatus: pointer to updated status structure of the current tune
3b4544a3 drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-10-31  166   *
3b4544a3 drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-10-31  167   * Return 0 on success or negative value in case of error.
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31  168   */
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06  169  int as10x_cmd_get_tune_status(struct as10x_bus_adapter_t *adap,
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  170  			      struct as10x_tune_status *pstatus)
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31  171  {
0550b294 drivers/staging/media/as102/as10x_cmd.c joseph daniel         2012-05-06  172  	int error = AS10X_CMD_ERROR;
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  173  	struct as10x_cmd_t  *preq, *prsp;
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31  174  
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06  175  	preq = adap->cmd;
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06  176  	prsp = adap->rsp;
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31  177  
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  178  	/* prepare command */
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06  179  	as10x_cmd_build(preq, (++adap->cmd_xid),
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  180  			sizeof(preq->body.get_tune_status.req));
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31  181  
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  182  	/* fill command */
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31 @183  	preq->body.get_tune_status.req.proc_id =
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  184  		cpu_to_le16(CONTROL_PROC_GETTUNESTAT);
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31  185  
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  186  	/* send command */
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06  187  	if (adap->ops->xfer_cmd) {
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06  188  		error = adap->ops->xfer_cmd(
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06  189  			adap,
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31  190  			(uint8_t *) preq,
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31  191  			sizeof(preq->body.get_tune_status.req) + HEADER_SIZE,
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31  192  			(uint8_t *) prsp,
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31  193  			sizeof(prsp->body.get_tune_status.rsp) + HEADER_SIZE);
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  194  	}
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  195  
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  196  	if (error < 0)
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  197  		goto out;
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  198  
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  199  	/* parse response */
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  200  	error = as10x_rsp_parse(prsp, CONTROL_PROC_GETTUNESTAT_RSP);
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  201  	if (error < 0)
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  202  		goto out;
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  203  
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  204  	/* Response OK -> get response data */
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  205  	pstatus->tune_state = prsp->body.get_tune_status.rsp.sts.tune_state;
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  206  	pstatus->signal_strength  =
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31 @207  		le16_to_cpu(prsp->body.get_tune_status.rsp.sts.signal_strength);
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31 @208  	pstatus->PER = le16_to_cpu(prsp->body.get_tune_status.rsp.sts.PER);
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31 @209  	pstatus->BER = le16_to_cpu(prsp->body.get_tune_status.rsp.sts.BER);
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31  210  
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31  211  out:
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  212  	return error;
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31  213  }
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31  214  
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31  215  /**
14e0e4bf drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06  216   * as10x_cmd_get_tps - send get TPS command to AS10x
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06  217   * @adap:      pointer to AS10x handle
3b4544a3 drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-10-31  218   * @ptps:      pointer to TPS parameters structure
3b4544a3 drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-10-31  219   *
3b4544a3 drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-10-31  220   * Return 0 on success or negative value in case of error.
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31  221   */
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06  222  int as10x_cmd_get_tps(struct as10x_bus_adapter_t *adap, struct as10x_tps *ptps)
41b44e04 drivers/staging/media/as102/as10x_cmd.c Pierrick Hascoet      2011-10-31  223  {
0550b294 drivers/staging/media/as102/as10x_cmd.c joseph daniel         2012-05-06  224  	int error = AS10X_CMD_ERROR;
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  225  	struct as10x_cmd_t *pcmd, *prsp;
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  226  
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06  227  	pcmd = adap->cmd;
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06  228  	prsp = adap->rsp;
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  229  
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  230  	/* prepare command */
34490a0a drivers/staging/media/as102/as10x_cmd.c Sylwester Nawrocki    2011-11-06  231  	as10x_cmd_build(pcmd, (++adap->cmd_xid),
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  232  			sizeof(pcmd->body.get_tps.req));
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  233  
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  234  	/* fill command */
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31 @235  	pcmd->body.get_tune_status.req.proc_id =
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  236  		cpu_to_le16(CONTROL_PROC_GETTPS);
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  237  
9cc08121 drivers/staging/media/as102/as10x_cmd.c Devin Heitmueller     2011-10-31  238  	/* send command */

:::::: The code at line 45 was first introduced by commit
:::::: 9cc08121f177e9618fe9108b0f5e2fb690d4df33 [media] staging: as102: Fix CodingStyle errors in file as10x_cmd.c

:::::: TO: Devin Heitmueller <dheitmueller@kernellabs.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@redhat.com>

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
