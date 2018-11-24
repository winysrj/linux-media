Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:48061 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725738AbeKYFzq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Nov 2018 00:55:46 -0500
Subject: Re: [ragnatech:media-tree 32/140]
 drivers/media/platform/seco-cec/seco-cec.c:237:4: error: implicit declaration
 of function 'cec_transmit_attempt_done'
To: Ettore Chimenti <ek5.chimenti@gmail.com>, lkp@intel.com
Cc: kbuild-all@01.org, m.chehab@samsung.com,
        linux-media@vger.kernel.org, jacopo mondi <jacopo@jmondi.org>
References: <201811250141.qRnpJzhL%fengguang.wu@intel.com>
 <CACcgvi22p-PNv8SuvQcbY7yYyYaUSowL==cMMo3pisMUVqadjA@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <901773a8-9d02-0603-7dc2-7247aa635e9c@xs4all.nl>
Date: Sat, 24 Nov 2018 20:06:34 +0100
MIME-Version: 1.0
In-Reply-To: <CACcgvi22p-PNv8SuvQcbY7yYyYaUSowL==cMMo3pisMUVqadjA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/24/2018 07:14 PM, Ettore Chimenti wrote:
> Hi all,
> Is this error relevant?
> I tried compiling on 'ragnatech/media-tree' (708d75fe1c7c6e9abc5381b6fcc32b49830383d0) without getting errors.

This was fixed by this patch:

https://patchwork.linuxtv.org/patch/53117/

Which is why it now works.

Regards,

	Hans

> 
> Thanks,
> Ettore
> 
> Il giorno sab 24 nov 2018 alle ore 18:07 kbuild test robot <lkp@intel.com <mailto:lkp@intel.com>> ha scritto:
> 
>     tree:   git://git.ragnatech.se/linux <http://git.ragnatech.se/linux> media-tree
>     head:   708d75fe1c7c6e9abc5381b6fcc32b49830383d0
>     commit: b03c2fb97adcc65d3c4098c4aa41fbaa6623ebf2 [32/140] media: add SECO cec driver
>     config: i386-randconfig-x006-201847 (attached as .config)
>     compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
>     reproduce:
>             git checkout b03c2fb97adcc65d3c4098c4aa41fbaa6623ebf2
>             # save the attached .config to linux build tree
>             make ARCH=i386
> 
>     Note: the ragnatech/media-tree HEAD 708d75fe1c7c6e9abc5381b6fcc32b49830383d0 builds fine.
>           It only hurts bisectibility.
> 
>     All error/warnings (new ones prefixed by >>):
> 
>        drivers/media/platform/seco-cec/seco-cec.c: In function 'secocec_tx_done':
>     >> drivers/media/platform/seco-cec/seco-cec.c:237:4: error: implicit declaration of function 'cec_transmit_attempt_done'
>     [-Werror=implicit-function-declaration]
>            cec_transmit_attempt_done(adap, CEC_TX_STATUS_NACK);
>            ^~~~~~~~~~~~~~~~~~~~~~~~~
>        drivers/media/platform/seco-cec/seco-cec.c: In function 'secocec_rx_done':
>     >> drivers/media/platform/seco-cec/seco-cec.c:316:2: error: implicit declaration of function 'cec_received_msg'; did you mean
>     'free_reserved_page'? [-Werror=implicit-function-declaration]
>          cec_received_msg(cec->cec_adap, &msg);
>          ^~~~~~~~~~~~~~~~
>          free_reserved_page
>        drivers/media/platform/seco-cec/seco-cec.c: In function 'secocec_probe':
>     >> drivers/media/platform/seco-cec/seco-cec.c:527:22: error: implicit declaration of function 'cec_allocate_adapter'; did you mean
>     'cec_delete_adapter'? [-Werror=implicit-function-declaration]
>          secocec->cec_adap = cec_allocate_adapter(&secocec_cec_adap_ops,
>                              ^~~~~~~~~~~~~~~~~~~~
>                              cec_delete_adapter
>     >> drivers/media/platform/seco-cec/seco-cec.c:527:20: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
>          secocec->cec_adap = cec_allocate_adapter(&secocec_cec_adap_ops,
>                            ^
>        cc1: some warnings being treated as errors
> 
>     vim +/cec_transmit_attempt_done +237 drivers/media/platform/seco-cec/seco-cec.c
> 
>        232 
>        233  static void secocec_tx_done(struct cec_adapter *adap, u16 status_val)
>        234  {
>        235          if (status_val & SECOCEC_STATUS_TX_ERROR_MASK) {
>        236                  if (status_val & SECOCEC_STATUS_TX_NACK_ERROR)
>      > 237                          cec_transmit_attempt_done(adap, CEC_TX_STATUS_NACK);
>        238                  else
>        239                          cec_transmit_attempt_done(adap, CEC_TX_STATUS_ERROR);
>        240          } else {
>        241                  cec_transmit_attempt_done(adap, CEC_TX_STATUS_OK);
>        242          }
>        243 
>        244          /* Reset status reg */
>        245          status_val = SECOCEC_STATUS_TX_ERROR_MASK |
>        246                  SECOCEC_STATUS_MSG_SENT_MASK |
>        247                  SECOCEC_STATUS_TX_NACK_ERROR;
>        248          smb_wr16(SECOCEC_STATUS, status_val);
>        249  }
>        250 
>        251  static void secocec_rx_done(struct cec_adapter *adap, u16 status_val)
>        252  {
>        253          struct secocec_data *cec = cec_get_drvdata(adap);
>        254          struct device *dev = cec->dev;
>        255          struct cec_msg msg = { };
>        256          bool flag_overflow = false;
>        257          u8 payload_len, i = 0;
>        258          u8 *payload_msg;
>        259          u16 val = 0;
>        260          int status;
>        261 
>        262          if (status_val & SECOCEC_STATUS_RX_OVERFLOW_MASK) {
>        263                  /* NOTE: Untested, it also might not be necessary */
>        264                  dev_warn(dev, "Received more than 16 bytes. Discarding");
>        265                  flag_overflow = true;
>        266          }
>        267 
>        268          if (status_val & SECOCEC_STATUS_RX_ERROR_MASK) {
>        269                  dev_warn(dev, "Message received with errors. Discarding");
>        270                  status = -EIO;
>        271                  goto rxerr;
>        272          }
>        273 
>        274          /* Read message length */
>        275          status = smb_rd16(SECOCEC_READ_DATA_LENGTH, &val);
>        276          if (status)
>        277                  return;
>        278 
>        279          /* Device msg len already accounts for the header */
>        280          msg.len = min(val + 1, CEC_MAX_MSG_SIZE);
>        281 
>        282          /* Read logical address */
>        283          status = smb_rd16(SECOCEC_READ_BYTE0, &val);
>        284          if (status)
>        285                  return;
>        286 
>        287          /* device stores source LA and destination */
>        288          msg.msg[0] = val;
>        289 
>        290          /* Read operation ID */
>        291          status = smb_rd16(SECOCEC_READ_OPERATION_ID, &val);
>        292          if (status)
>        293                  return;
>        294 
>        295          msg.msg[1] = val;
>        296 
>        297          /* Read data if present */
>        298          if (msg.len > 1) {
>        299                  payload_len = msg.len - 2;
>        300                  payload_msg = &msg.msg[2];
>        301 
>        302                  /* device stores 2 bytes in every 16-bit val */
>        303                  for (i = 0; i < payload_len; i += 2) {
>        304                          status = smb_rd16(SECOCEC_READ_DATA_00 + i / 2, &val);
>        305                          if (status)
>        306                                  return;
>        307 
>        308                          /* low byte, skipping header */
>        309                          payload_msg[i] = val & 0x00ff;
>        310 
>        311                          /* hi byte */
>        312                          payload_msg[i + 1] = (val & 0xff00) >> 8;
>        313                  }
>        314          }
>        315 
>      > 316          cec_received_msg(cec->cec_adap, &msg);
>        317 
>        318          /* Reset status reg */
>        319          status_val = SECOCEC_STATUS_MSG_RECEIVED_MASK;
>        320          if (flag_overflow)
>        321                  status_val |= SECOCEC_STATUS_RX_OVERFLOW_MASK;
>        322 
>        323          status = smb_wr16(SECOCEC_STATUS, status_val);
>        324 
>        325          return;
>        326 
>        327  rxerr:
>        328          /* Reset error reg */
>        329          status_val = SECOCEC_STATUS_MSG_RECEIVED_MASK |
>        330                  SECOCEC_STATUS_RX_ERROR_MASK;
>        331          if (flag_overflow)
>        332                  status_val |= SECOCEC_STATUS_RX_OVERFLOW_MASK;
>        333          smb_wr16(SECOCEC_STATUS, status_val);
>        334  }
>        335 
> 
>     ---
>     0-DAY kernel test infrastructure                Open Source Technology Center
>     https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 
> 
> 
> -- 
> Ettore Chimenti
> 
> Cell: 333-1754004
> Skype: ektor-5
> TG/Tw/FB: @ektor5
