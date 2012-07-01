Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56214 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743Ab2GAWVn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Jul 2012 18:21:43 -0400
Received: by vcbf11 with SMTP id f11so3194161vcb.19
        for <linux-media@vger.kernel.org>; Sun, 01 Jul 2012 15:21:42 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 2 Jul 2012 06:21:42 +0800
Message-ID: <CAHPEtt=7Yxz=U1YaJrMAk8GqoiVSkZpJD9vwo2vumpAb27CCCw@mail.gmail.com>
Subject: please add support of dmb-th in xc5000
From: Choi Wing Chan <chanchoiwing@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

i have an error of not supporting dmb-th in xc5000 in the kernel 3.4.
i think it is a missing switch-case in the set-params function :
        case SYS_DVBT:
	case SYS_DVBT2:
	case SYS_DMBTH:
		dprintk(1, "%s() OFDM\n", __func__);
		switch (bw) {
		case 6000000:
			priv->video_standard = DTV6;
			priv->freq_hz = freq - 1750000;
			break;
		case 7000000:
			priv->video_standard = DTV7;
			priv->freq_hz = freq - 2250000;
			break;
		case 8000000:
			priv->video_standard = DTV8;
			priv->freq_hz = freq - 2750000;
			break;
		default:
			printk(KERN_ERR "xc5000 bandwidth not set!\n");
			return -EINVAL;
		}
		priv->rf_mode = XC_RF_MODE_AIR;



-- 
http://chanchoiwing.blogspot.com
