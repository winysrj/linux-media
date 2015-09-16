Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38326 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbbIPP7i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2015 11:59:38 -0400
Date: Wed, 16 Sep 2015 18:59:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org
Subject: re: [media] vivid: add support for radio receivers and transmitters
Message-ID: <20150916155928.GA9735@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans Verkuil,

The patch 55d58e989856: "[media] vivid: add support for radio
receivers and transmitters" from Aug 25, 2014, leads to the following
static checker warning:

	drivers/media/platform/vivid/vivid-rds-gen.c:82 vivid_rds_generate()
	error: buffer overflow 'rds->psname' 9 <= 43

drivers/media/platform/vivid/vivid-rds-gen.c
   63          for (grp = 0; grp < VIVID_RDS_GEN_GROUPS; grp++, data += VIVID_RDS_GEN_BLKS_PER_GRP) {

VIVID_RDS_GEN_GROUPS is 57.

    64                  data[0].lsb = rds->picode & 0xff;
    65                  data[0].msb = rds->picode >> 8;
    66                  data[0].block = V4L2_RDS_BLOCK_A | (V4L2_RDS_BLOCK_A << 3);
    67                  data[1].lsb = rds->pty << 5;
    68                  data[1].msb = (rds->pty >> 3) | (rds->tp << 2);
    69                  data[1].block = V4L2_RDS_BLOCK_B | (V4L2_RDS_BLOCK_B << 3);
    70                  data[3].block = V4L2_RDS_BLOCK_D | (V4L2_RDS_BLOCK_D << 3);
    71  
    72                  switch (grp) {
    73                  case 0 ... 3:
    74                  case 22 ... 25:
    75                  case 44 ... 47: /* Group 0B */
    76                          data[1].lsb |= (rds->ta << 4) | (rds->ms << 3);
    77                          data[1].lsb |= vivid_get_di(rds, grp % 22);
    78                          data[1].msb |= 1 << 3;
    79                          data[2].lsb = rds->picode & 0xff;
    80                          data[2].msb = rds->picode >> 8;
    81                          data[2].block = V4L2_RDS_BLOCK_C_ALT | (V4L2_RDS_BLOCK_C_ALT << 3);
    82                          data[3].lsb = rds->psname[2 * (grp % 22) + 1];
    83                          data[3].msb = rds->psname[2 * (grp % 22)];

These two are maybe cut and paste from ->radiotext[]?

    84                          break;
    85                  case 4 ... 19:
    86                  case 26 ... 41: /* Group 2A */
    87                          data[1].lsb |= (grp - 4) % 22;
    88                          data[1].msb |= 4 << 3;
    89                          data[2].msb = rds->radiotext[4 * ((grp - 4) % 22)];
    90                          data[2].lsb = rds->radiotext[4 * ((grp - 4) % 22) + 1];

It doesn't like these either though...

    91                          data[2].block = V4L2_RDS_BLOCK_C | (V4L2_RDS_BLOCK_C << 3);
    92                          data[3].msb = rds->radiotext[4 * ((grp - 4) % 22) + 2];
    93                          data[3].lsb = rds->radiotext[4 * ((grp - 4) % 22) + 3];
    94                          break;

drivers/media/platform/vivid/vivid-rds-gen.c:82 vivid_rds_generate() error: buffer overflow 'rds->psname' 9 <= 43
drivers/media/platform/vivid/vivid-rds-gen.c:83 vivid_rds_generate() error: buffer overflow 'rds->psname' 9 <= 42
drivers/media/platform/vivid/vivid-rds-gen.c:89 vivid_rds_generate() error: buffer overflow 'rds->radiotext' 65 <= 84
drivers/media/platform/vivid/vivid-rds-gen.c:90 vivid_rds_generate() error: buffer overflow 'rds->radiotext' 65 <= 85
drivers/media/platform/vivid/vivid-rds-gen.c:92 vivid_rds_generate() error: buffer overflow 'rds->radiotext' 65 <= 86
drivers/media/platform/vivid/vivid-rds-gen.c:93 vivid_rds_generate() error: buffer overflow 'rds->radiotext' 65 <= 87

regards,
dan carpenter
