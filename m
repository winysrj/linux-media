Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:54499 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757478AbdJKOBK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 10:01:10 -0400
Message-ID: <1507730484.18241.17.camel@intel.com>
Subject: Re: [PATCH v2 08/12] intel-ipu3: params: compute and program ccs
From: Tuukka Toivonen <tuukka.toivonen@intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>
Cc: "Zhi, Yong" <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>
Date: Wed, 11 Oct 2017 17:01:24 +0300
In-Reply-To: <CAHp75VfTZ5GhNCgSbD2_d99Yq-32hDy06ZyRpNJTwo3PFKG=Uw@mail.gmail.com>
References: <1497478767-10270-1-git-send-email-yong.zhi@intel.com>
         <1497478767-10270-9-git-send-email-yong.zhi@intel.com>
         <CAHp75Vff3tQE4NdsLJDO=7b7_5O3XW360qxOw4nbeE3i+usvhQ@mail.gmail.com>
         <C193D76D23A22742993887E6D207B54D1AE287D3@ORSMSX106.amr.corp.intel.com>
         <20171011072925.twuc22cqnv5pymed@paasikivi.fi.intel.com>
         <CAHp75VfTZ5GhNCgSbD2_d99Yq-32hDy06ZyRpNJTwo3PFKG=Uw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-10-11 at 16:31 +0300, Andy Shevchenko wrote:
> On Wed, Oct 11, 2017 at 10:29 AM, sakari.ailus@linux.intel.com
> <sakari.ailus@linux.intel.com> wrote:
> > On Wed, Oct 11, 2017 at 04:14:37AM +0000, Zhi, Yong wrote:
> > > > > +static unsigned int ipu3_css_scaler_get_exp(unsigned int
> > > > > counter,
> > > > > +                                           unsigned int
> > > > > divider) {
> > > > > +       unsigned int i = 0;
> > > > > +
> > > > > +       while (counter <= divider / 2) {
> > > > > +               divider /= 2;
> > > > > +               i++;
> > > > > +       }
> > > > > +
> > > > > +       return i;
> >         return (!counter || divider < counter) ?
> >                0 : fls(divider / counter) - 1;
> 
> Extra division is here (I dunno if counter is always power of 2 but
> it
> doesn't matter for compiler).
> 
> Basically above calculates how much bits we need to shift divider to
> get it less than counter.
> 
> I would consider to use something from log2.h.
> 
> Roughly like
> 
> if (!counter || divider < counter)
>  return 0;
> return order_base_2(divider) - order_base_2(counter);

The original loop is typical ran just couple of times, so I think
that fls or division are probably slower than the original loop.
Furthermore, these "optimizations" are also harder to read, so in
my opinion there's no advantage in using them.

- Tuukka
