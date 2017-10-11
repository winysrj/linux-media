Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:52196 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757046AbdJKH37 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 03:29:59 -0400
Date: Wed, 11 Oct 2017 10:29:25 +0300
From: "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>
To: "Zhi, Yong" <yong.zhi@intel.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>
Subject: Re: [PATCH v2 08/12] intel-ipu3: params: compute and program ccs
Message-ID: <20171011072925.twuc22cqnv5pymed@paasikivi.fi.intel.com>
References: <1497478767-10270-1-git-send-email-yong.zhi@intel.com>
 <1497478767-10270-9-git-send-email-yong.zhi@intel.com>
 <CAHp75Vff3tQE4NdsLJDO=7b7_5O3XW360qxOw4nbeE3i+usvhQ@mail.gmail.com>
 <C193D76D23A22742993887E6D207B54D1AE287D3@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C193D76D23A22742993887E6D207B54D1AE287D3@ORSMSX106.amr.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 11, 2017 at 04:14:37AM +0000, Zhi, Yong wrote:
> Hi, Andy,
> 
> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > owner@vger.kernel.org] On Behalf Of Andy Shevchenko
> > Sent: Friday, June 16, 2017 3:53 PM
> > To: Zhi, Yong <yong.zhi@intel.com>
> > Cc: Linux Media Mailing List <linux-media@vger.kernel.org>;
> > sakari.ailus@linux.intel.com; Zheng, Jian Xu <jian.xu.zheng@intel.com>;
> > tfiga@chromium.org; Mani, Rajmohan <rajmohan.mani@intel.com>;
> > Toivonen, Tuukka <tuukka.toivonen@intel.com>
> > Subject: Re: [PATCH v2 08/12] intel-ipu3: params: compute and program ccs
> > 
> > On Thu, Jun 15, 2017 at 1:19 AM, Yong Zhi <yong.zhi@intel.com> wrote:
> > > A collection of routines that are mainly responsible to calculate the
> > > acc parameters.
> > 
> > > +static unsigned int ipu3_css_scaler_get_exp(unsigned int counter,
> > > +                                           unsigned int divider) {
> > > +       unsigned int i = 0;
> > > +
> > > +       while (counter <= divider / 2) {
> > > +               divider /= 2;
> > > +               i++;
> > > +       }
> > > +
> > > +       return i;
> > 
> > We have a lot of different helpers including one you may use instead of this
> > function.
> > 
> > It's *highly* recommended you learn what we have under lib/ (and not only
> > there) in kernel bewfore submitting a new version.
> > 
> 
> Tried to identify more places that could be re-implemented with lib
> helpers or more generic method, but we failed to spot any obvious
> candidate thus far.

How about:

	return (!counter || divider < counter) ?
	       0 : fls(divider / counter) - 1;

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
