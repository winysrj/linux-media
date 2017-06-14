Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:12320 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751829AbdFNPVM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 11:21:12 -0400
From: "Zhi, Yong" <yong.zhi@intel.com>
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>,
        "Mohandass, Divagar" <divagar.mohandass@intel.com>
Subject: RE: [PATCH v3 1/3] videodev2.h, v4l2-ioctl: add IPU3 raw10 color
 format
Date: Wed, 14 Jun 2017 15:21:10 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D0799EF06@ORSMSX106.amr.corp.intel.com>
References: <1497385036-1002-1-git-send-email-yong.zhi@intel.com>
        <1497385036-1002-2-git-send-email-yong.zhi@intel.com>
 <20170614144840.4260501d@alans-desktop>
In-Reply-To: <20170614144840.4260501d@alans-desktop>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Alan Cox [mailto:gnomes@lxorguk.ukuu.org.uk]
> Sent: Wednesday, June 14, 2017 6:49 AM
> To: Zhi, Yong <yong.zhi@intel.com>
> Cc: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com; Zheng, Jian
> Xu <jian.xu.zheng@intel.com>; tfiga@chromium.org; Mani, Rajmohan
> <rajmohan.mani@intel.com>; Toivonen, Tuukka
> <tuukka.toivonen@intel.com>; Yang, Hyungwoo
> <hyungwoo.yang@intel.com>; Mohandass, Divagar
> <divagar.mohandass@intel.com>
> Subject: Re: [PATCH v3 1/3] videodev2.h, v4l2-ioctl: add IPU3 raw10 color
> format
> 
> On Tue, 13 Jun 2017 15:17:14 -0500
> Yong Zhi <yong.zhi@intel.com> wrote:
> 
> > Add IPU3 specific formats:
> >
> > 	V4L2_PIX_FMT_IPU3_SBGGR10
> > 	V4L2_PIX_FMT_IPU3_SGBRG10
> > 	V4L2_PIX_FMT_IPU3_SGRBG10
> > 	V4L2_PIX_FMT_IPU3_SRGGB10
> 
> As I said before these are just more bitpacked bayer formats with no reason
> to encode them as IPUv3 specific names.
> 
> Alan

Ack, will update for next version.
