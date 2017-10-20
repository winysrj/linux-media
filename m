Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59442 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751618AbdJTPBm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 11:01:42 -0400
Date: Fri, 20 Oct 2017 18:01:39 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "Zhi, Yong" <yong.zhi@intel.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>
Subject: Re: [PATCH v3 08/12] intel-ipu3: params: compute and program ccs
Message-ID: <20171020150139.wmd5zmxf5zb3llcd@valkosipuli.retiisi.org.uk>
References: <1500434023-2411-1-git-send-email-yong.zhi@intel.com>
 <1500434023-2411-6-git-send-email-yong.zhi@intel.com>
 <20171020095800.iapx2v3uukeohq2f@valkosipuli.retiisi.org.uk>
 <C193D76D23A22742993887E6D207B54D1AE2AF59@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C193D76D23A22742993887E6D207B54D1AE2AF59@ORSMSX106.amr.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 20, 2017 at 02:51:07PM +0000, Zhi, Yong wrote:
> > > +			/* flip table to for convolution reverse indexing */
> > > +			s64 coeff =  coeffs[coeffs_size -
> > > +						((tap * (coeffs_size / taps)) +
> > > +						phase) - 1];
> > > +			coeff *= mantissa;
> > > +			coeff /= input_width;
> > 
> > Please use do_div() so this will compile on 32-bit machines.
> > 
> 
> Thanks, above was implemented in v4.

Yeah, I noticed that later. I accidentally reviewed an older version. ;)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
