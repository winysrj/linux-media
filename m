Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45301 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750807AbdI2KxW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Sep 2017 06:53:22 -0400
Date: Fri, 29 Sep 2017 13:53:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: abraham.manu@gmail.com
Cc: linux-media@vger.kernel.org
Subject: [bug report] V4L/DVB (13717): [MB86A16] Statistics Updates
Message-ID: <20170929105313.f7yhbplrqonmk2kg@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Manu Abraham,

The patch 77557abef0de: "V4L/DVB (13717): [MB86A16] Statistics
Updates" from Dec 3, 2009, leads to the following static checker
warning:

	drivers/media/dvb-frontends/mb86a16.c:1690 mb86a16_read_ber()
	error: uninitialized symbol 'timer'.

	drivers/media/dvb-frontends/mb86a16.c:1706 mb86a16_read_ber()
	error: uninitialized symbol 'timer'.

drivers/media/dvb-frontends/mb86a16.c
  1649  static int mb86a16_read_ber(struct dvb_frontend *fe, u32 *ber)
  1650  {
  1651          u8 ber_mon, ber_tab, ber_lsb, ber_mid, ber_msb, ber_tim, ber_rst;
  1652          u32 timer;
                ^^^^^^^^^
  1653  
  1654          struct mb86a16_state *state = fe->demodulator_priv;
  1655  
  1656          *ber = 0;
  1657          if (mb86a16_read(state, MB86A16_BERMON, &ber_mon) != 2)
  1658                  goto err;
  1659          if (mb86a16_read(state, MB86A16_BERTAB, &ber_tab) != 2)
  1660                  goto err;
  1661          if (mb86a16_read(state, MB86A16_BERLSB, &ber_lsb) != 2)
  1662                  goto err;
  1663          if (mb86a16_read(state, MB86A16_BERMID, &ber_mid) != 2)
  1664                  goto err;
  1665          if (mb86a16_read(state, MB86A16_BERMSB, &ber_msb) != 2)
  1666                  goto err;
  1667          /* BER monitor invalid when BER_EN = 0  */
  1668          if (ber_mon & 0x04) {
  1669                  /* coarse, fast calculation     */
  1670                  *ber = ber_tab & 0x1f;
  1671                  dprintk(verbose, MB86A16_DEBUG, 1, "BER coarse=[0x%02x]", *ber);
  1672                  if (ber_mon & 0x01) {
  1673                          /*
  1674                           * BER_SEL = 1, The monitored BER is the estimated
  1675                           * value with a Reed-Solomon decoder error amount at
  1676                           * the deinterleaver output.
  1677                           * monitored BER is expressed as a 20 bit output in total
  1678                           */
  1679                          ber_rst = ber_mon >> 3;
                                ^^^^^^^
How do we know ber_rst is in the 0-3 range?

  1680                          *ber = (((ber_msb << 8) | ber_mid) << 8) | ber_lsb;
  1681                          if (ber_rst == 0)
  1682                                  timer =  12500000;
  1683                          if (ber_rst == 1)
  1684                                  timer =  25000000;
  1685                          if (ber_rst == 2)
  1686                                  timer =  50000000;
  1687                          if (ber_rst == 3)
  1688                                  timer = 100000000;
  1689  
  1690                          *ber /= timer;
  1691                          dprintk(verbose, MB86A16_DEBUG, 1, "BER fine=[0x%02x]", *ber);
  1692                  } else {

regards,
dan carpenter
