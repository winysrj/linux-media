Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50990 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbcA1Olr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2016 09:41:47 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u0SEfkx3021551
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 28 Jan 2016 14:41:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by userv0021.oracle.com (8.13.8/8.13.8) with ESMTP id u0SEfkoB004410
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Thu, 28 Jan 2016 14:41:46 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
	by userv0122.oracle.com (8.14.4/8.13.8) with ESMTP id u0SEfkmF000348
	for <linux-media@vger.kernel.org>; Thu, 28 Jan 2016 14:41:46 GMT
Date: Thu, 28 Jan 2016 17:41:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: linux-media@vger.kernel.org
Subject: [bug report] ttusb-dec: read overflow in ttusb_dec_process_pva()
Message-ID: <20160128144138.GA31320@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi linux media devs,

I am getting the following static checker warning:

	drivers/media/usb/ttusb-dec/ttusb_dec.c:474 ttusb_dec_process_pva()
	error: __memcpy() '&pva[8]' too small (6140 vs 6144)

drivers/media/usb/ttusb-dec/ttusb_dec.c
   419  static void ttusb_dec_process_pva(struct ttusb_dec *dec, u8 *pva, int length)
   420  {
   421          if (length < 8) {
   422                  printk("%s: packet too short - discarding\n", __func__);
   423                  return;
   424          }
   425  
   426          if (length > 8 + MAX_PVA_LENGTH) {

length is capped here.

   427                  printk("%s: packet too long - discarding\n", __func__);
   428                  return;
   429          }
   430  
   431          switch (pva[2]) {
   432  
   433          case 0x01: {            /* VideoStream */
   434                  int prebytes = pva[5] & 0x03;
   435                  int postbytes = (pva[5] & 0x0c) >> 2;
   436                  __be16 v_pes_payload_length;
   437  
   438                  if (output_pva) {
   439                          dec->video_filter->feed->cb.ts(pva, length, NULL, 0,
   440                                  &dec->video_filter->feed->feed.ts);
   441                          return;
   442                  }
   443  
   444                  if (dec->v_pes_postbytes > 0 &&
   445                      dec->v_pes_postbytes == prebytes) {
   446                          memcpy(&dec->v_pes[dec->v_pes_length],
   447                                 &pva[12], prebytes);
   448  
   449                          dvb_filter_pes2ts(&dec->v_pes2ts, dec->v_pes,
   450                                            dec->v_pes_length + prebytes, 1);
   451                  }
   452  
   453                  if (pva[5] & 0x10) {
   454                          dec->v_pes[7] = 0x80;
   455                          dec->v_pes[8] = 0x05;
   456  
   457                          dec->v_pes[9] = 0x21 | ((pva[8] & 0xc0) >> 5);
   458                          dec->v_pes[10] = ((pva[8] & 0x3f) << 2) |
   459                                           ((pva[9] & 0xc0) >> 6);
   460                          dec->v_pes[11] = 0x01 |
   461                                           ((pva[9] & 0x3f) << 2) |
   462                                           ((pva[10] & 0x80) >> 6);
   463                          dec->v_pes[12] = ((pva[10] & 0x7f) << 1) |
   464                                           ((pva[11] & 0xc0) >> 7);
   465                          dec->v_pes[13] = 0x01 | ((pva[11] & 0x7f) << 1);
   466  
   467                          memcpy(&dec->v_pes[14], &pva[12 + prebytes],
   468                                 length - 12 - prebytes);
   469                          dec->v_pes_length = 14 + length - 12 - prebytes;
   470                  } else {
   471                          dec->v_pes[7] = 0x00;
   472                          dec->v_pes[8] = 0x00;
   473  
   474                          memcpy(&dec->v_pes[9], &pva[8], length - 8);

The problem is that pva[] comes from (struct ttusb_dec)->packet which
has MAX_PVA_LENGTH + 4 bytes and not + 8 bytes.  I am not sure how to
fix this.

   475                          dec->v_pes_length = 9 + length - 8;
   476                  }
   477  

regards,
dan carpenter
