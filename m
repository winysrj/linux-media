Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35878 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751391AbdJMXI2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 19:08:28 -0400
Date: Sat, 14 Oct 2017 02:08:25 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Tuukka Toivonen <tuukka.toivonen@intel.com>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zhi, Yong" <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>
Subject: Re: [PATCH v2 08/12] intel-ipu3: params: compute and program ccs
Message-ID: <20171013230824.mihk6ztq4vctvoqf@valkosipuli.retiisi.org.uk>
References: <1497478767-10270-1-git-send-email-yong.zhi@intel.com>
 <1497478767-10270-9-git-send-email-yong.zhi@intel.com>
 <CAHp75Vff3tQE4NdsLJDO=7b7_5O3XW360qxOw4nbeE3i+usvhQ@mail.gmail.com>
 <C193D76D23A22742993887E6D207B54D1AE287D3@ORSMSX106.amr.corp.intel.com>
 <20171011072925.twuc22cqnv5pymed@paasikivi.fi.intel.com>
 <CAHp75VfTZ5GhNCgSbD2_d99Yq-32hDy06ZyRpNJTwo3PFKG=Uw@mail.gmail.com>
 <1507730484.18241.17.camel@intel.com>
 <CAHp75VcE11_AZ0UCFxBdMRVnmj+FMUhaBFzEFLxqbK7_0_p9pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VcE11_AZ0UCFxBdMRVnmj+FMUhaBFzEFLxqbK7_0_p9pg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tuukka, Andy, others,

On Wed, Oct 11, 2017 at 05:27:27PM +0300, Andy Shevchenko wrote:
> On Wed, Oct 11, 2017 at 5:01 PM, Tuukka Toivonen
> <tuukka.toivonen@intel.com> wrote:
> > On Wed, 2017-10-11 at 16:31 +0300, Andy Shevchenko wrote:
> >> On Wed, Oct 11, 2017 at 10:29 AM, sakari.ailus@linux.intel.com
> >> <sakari.ailus@linux.intel.com> wrote:
> >> > On Wed, Oct 11, 2017 at 04:14:37AM +0000, Zhi, Yong wrote:
> 
> >> > > > > +static unsigned int ipu3_css_scaler_get_exp(unsigned int
> >> > > > > counter,
> >> > > > > +                                           unsigned int
> >> > > > > divider) {
> >> > > > > +       unsigned int i = 0;
> >> > > > > +
> >> > > > > +       while (counter <= divider / 2) {
> >> > > > > +               divider /= 2;
> >> > > > > +               i++;
> >> > > > > +       }
> >> > > > > +
> >> > > > > +       return i;
> 
> >> Roughly like
> >>
> >> if (!counter || divider < counter)
> >>  return 0;
> >> return order_base_2(divider) - order_base_2(counter);
> >
> > The original loop is typical ran just couple of times, so I think
> > that fls or division are probably slower than the original loop.
> > Furthermore, these "optimizations" are also harder to read, so in
> > my opinion there's no advantage in using them.
> 
> Honestly I'm opposing that.
> It took me about minute to be clear what is going on on that loop
> while fls() / ffs() / ilog2() like stuff can be read fast.
> 
> Like
> 
> int shift = order_base_2(divider) - order_base_2(counter);
> 
> return shift > 0 ? shift : 0;
> 
> And frankly I don't care about under the hoods of order_base_2(). I
> care about this certain piece of code to be simpler.
> 
> One may put a comment line:
> 
> # Get log2 of how divider bigger than counter
> 
> And thinking more while writing this message the use of order_base_2()
> actually explains what's going on here.

I guess this isn't really worth spending much time on; either way, please
at least fix the current implementation so it won't end up in an infinite
loop. This happens now if counter is zero.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
