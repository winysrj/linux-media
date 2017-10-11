Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:44436 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751705AbdJKO12 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 10:27:28 -0400
Received: by mail-qt0-f195.google.com with SMTP id 8so5717998qtv.1
        for <linux-media@vger.kernel.org>; Wed, 11 Oct 2017 07:27:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1507730484.18241.17.camel@intel.com>
References: <1497478767-10270-1-git-send-email-yong.zhi@intel.com>
 <1497478767-10270-9-git-send-email-yong.zhi@intel.com> <CAHp75Vff3tQE4NdsLJDO=7b7_5O3XW360qxOw4nbeE3i+usvhQ@mail.gmail.com>
 <C193D76D23A22742993887E6D207B54D1AE287D3@ORSMSX106.amr.corp.intel.com>
 <20171011072925.twuc22cqnv5pymed@paasikivi.fi.intel.com> <CAHp75VfTZ5GhNCgSbD2_d99Yq-32hDy06ZyRpNJTwo3PFKG=Uw@mail.gmail.com>
 <1507730484.18241.17.camel@intel.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 11 Oct 2017 17:27:27 +0300
Message-ID: <CAHp75VcE11_AZ0UCFxBdMRVnmj+FMUhaBFzEFLxqbK7_0_p9pg@mail.gmail.com>
Subject: Re: [PATCH v2 08/12] intel-ipu3: params: compute and program ccs
To: Tuukka Toivonen <tuukka.toivonen@intel.com>
Cc: "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zhi, Yong" <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 11, 2017 at 5:01 PM, Tuukka Toivonen
<tuukka.toivonen@intel.com> wrote:
> On Wed, 2017-10-11 at 16:31 +0300, Andy Shevchenko wrote:
>> On Wed, Oct 11, 2017 at 10:29 AM, sakari.ailus@linux.intel.com
>> <sakari.ailus@linux.intel.com> wrote:
>> > On Wed, Oct 11, 2017 at 04:14:37AM +0000, Zhi, Yong wrote:

>> > > > > +static unsigned int ipu3_css_scaler_get_exp(unsigned int
>> > > > > counter,
>> > > > > +                                           unsigned int
>> > > > > divider) {
>> > > > > +       unsigned int i = 0;
>> > > > > +
>> > > > > +       while (counter <= divider / 2) {
>> > > > > +               divider /= 2;
>> > > > > +               i++;
>> > > > > +       }
>> > > > > +
>> > > > > +       return i;

>> Roughly like
>>
>> if (!counter || divider < counter)
>>  return 0;
>> return order_base_2(divider) - order_base_2(counter);
>
> The original loop is typical ran just couple of times, so I think
> that fls or division are probably slower than the original loop.
> Furthermore, these "optimizations" are also harder to read, so in
> my opinion there's no advantage in using them.

Honestly I'm opposing that.
It took me about minute to be clear what is going on on that loop
while fls() / ffs() / ilog2() like stuff can be read fast.

Like

int shift = order_base_2(divider) - order_base_2(counter);

return shift > 0 ? shift : 0;

And frankly I don't care about under the hoods of order_base_2(). I
care about this certain piece of code to be simpler.

One may put a comment line:

# Get log2 of how divider bigger than counter

And thinking more while writing this message the use of order_base_2()
actually explains what's going on here.

-- 
With Best Regards,
Andy Shevchenko
