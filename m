Return-Path: <SRS0=4gUs=QT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=BIGNUM_EMAILS,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9096CC282C4
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 12:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 552172084E
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 12:48:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bGhF/T7e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbfBLMs6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Feb 2019 07:48:58 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55722 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfBLMs6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Feb 2019 07:48:58 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1CCmuqj119009;
        Tue, 12 Feb 2019 12:48:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=3JJzCTXinBco2WLD25+8KZK/QsA/9DHZ5ZsZEZDyuzY=;
 b=bGhF/T7e9ZSgdAbceKag3pghk5IdxIq3QmO64PrbltCR5b7l6S6eeoydKf6ysIPldxII
 LsCAkXoiCmL/+eLfhjYsTAl2t1mtvAByjQwWm4I+9ERwjXQNG4FngFBXxd3qOdH7jDT5
 2ocJznpAPwayUoVuuv5HFapSM2jXph3SHED+xY7auh2Yg+JXqHc+x+V9aNjhoOMFGYqZ
 iWgvNY9iXoMl2hPJkpGmvpxJFI9DxI1kW1nXz+lYMoKuGM6i0FdSgHTOE/C+xICl4sO/
 tRcbHmnfenb4CPWQ3IkIZNu72wIlxImpm8S0x+ca6wJFUHiYIX4DJ7O8o6+awG3ywlho 2A== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2qhrekbmk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Feb 2019 12:48:56 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1CCmtQQ008049
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Feb 2019 12:48:55 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1CCmsHI002862;
        Tue, 12 Feb 2019 12:48:55 GMT
Received: from kadam (/41.202.241.35)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Feb 2019 04:48:54 -0800
Date:   Tue, 12 Feb 2019 15:48:47 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     pboettcher@kernellabs.com
Cc:     linux-media@vger.kernel.org
Subject: [bug report] [media] dib8000: potential off by one
Message-ID: <20190212124847.GA11184@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9164 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=963 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902120094
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello Patrick Boettcher,

The patch 173a64cb3fcf: "[media] dib8000: enhancement" from Apr 22,
2013, leads to the following static checker warning:

	drivers/media/dvb-frontends/dib8000.c:2132 dib8000_get_init_prbs()
	error: buffer overflow 'lut_prbs_2k' 14 <= 14

drivers/media/dvb-frontends/dib8000.c
    2123 static u16 dib8000_get_init_prbs(struct dib8000_state *state, u16 subchannel)
    2124 {
    2125 	int sub_channel_prbs_group = 0;
    2126 
    2127 	sub_channel_prbs_group = (subchannel / 3) + 1;
    2128 	dprintk("sub_channel_prbs_group = %d , subchannel =%d prbs = 0x%04x\n", sub_channel_prbs_group, subchannel, lut_prbs_8k[sub_channel_prbs_group]);
    2129 
    2130 	switch (state->fe[0]->dtv_property_cache.transmission_mode) {
    2131 	case TRANSMISSION_MODE_2K:
--> 2132 			return lut_prbs_2k[sub_channel_prbs_group];
    2133 	case TRANSMISSION_MODE_4K:
    2134 			return lut_prbs_4k[sub_channel_prbs_group];
    2135 	default:
    2136 	case TRANSMISSION_MODE_8K:
    2137 			return lut_prbs_8k[sub_channel_prbs_group];
    2138 	}
    2139 }

[ snip ]

  3305                  break;
  3306  
  3307          case CT_DEMOD_STEP_11:  /* 41 : init prbs autosearch */
  3308                  if (state->subchannel <= 41) {
                            ^^^^^^^^^^^^^^^^^^^^^^^
The problem is here.  If ->subchannel is 41 then we are off by one.
In the original code this was something like state->subchannel % 41 so
I suspect the fix is to change <= to just < but I'm not totally sure.

  3309                          dib8000_set_subchannel_prbs(state, dib8000_get_init_prbs(state, state->subchannel));
  3310                          *tune_state = CT_DEMOD_STEP_9;
  3311                  } else {
  3312                          *tune_state = CT_DEMOD_STOP;
  3313                          state->status = FE_STATUS_TUNE_FAILED;
  3314                  }
  3315                  break;
  3316  
  3317          default:
  3318                  break;
  3319          }

regards,
dan carpenter
