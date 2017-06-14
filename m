Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-dm3nam03on0112.outbound.protection.outlook.com ([104.47.41.112]:8848
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753579AbdFNDCK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 23:02:10 -0400
Subject: Re: [PATCH v2 0/15] [dt-bindings] [media] Add document file and
 driver for Sony CXD2880 DVB-T2/T tuner + demodulator
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <20170414015043.16731-1-Yasunari.Takiguchi@sony.com>
 <5188b958-9a34-4519-5845-a318273592e0@sony.com>
 <d7c70c53-3fb0-a045-5e1a-1a736bdeda1f@sony.com>
 <20170613113814.0094536f@vento.lan>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tbird20d@gmail.com" <tbird20d@gmail.com>,
        "frowand.list@gmail.com" <frowand.list@gmail.com>,
        "Yamamoto, Masayuki" <Masayuki.Yamamoto@sony.com>,
        "Nozawa, Hideki (STWN)" <Hideki.Nozawa@sony.com>,
        "Yonezawa, Kota" <Kota.Yonezawa@sony.com>,
        "Matsumoto, Toshihiko" <Toshihiko.Matsumoto@sony.com>,
        "Watanabe, Satoshi (SSS)" <Satoshi.C.Watanabe@sony.com>,
        <yasunari.takiguchi@sony.com>
From: "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>
Message-ID: <7f6cb6c6-26f0-db46-4b7b-8cc4df586172@sony.com>
Date: Wed, 14 Jun 2017 12:01:55 +0900
MIME-Version: 1.0
In-Reply-To: <20170613113814.0094536f@vento.lan>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Mauro

Thanks for your kind review during your busy schedule.

I will confirm with your findings and discuss about them
(how to change our codes) in our team.

Regards & Thanks
Takiguchi

On 2017/06/13 23:38, Mauro Carvalho Chehab wrote:
> Hi Takiguchi-san,
> 
> Em Thu, 25 May 2017 15:15:39 +0900
> "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com> escreveu:
> 
>> Hi, all
>>
>> I sent the patch series of Sony CXD2880 DVB-T2/T tuner + demodulator driver on Apr/14.
>> Are there any comments, advices and review results for them?
> 
> Usually, reviewing drivers takes more time, as one needs to reserve a
> long period of time for reviewing. Sorry for the delay.
> 
>> I'd like to get better understanding of current review status for our codes.
> 
> Just sent today a review. There are some things that need to be
> changed in order to get it into a better shape and make it easier
> to review. In particular, it should be using some Kernel internal APIs,
> instead of coming with re-implementation of existing core code. That's fine. 
> It is very unusual that the first contributions from a new Kernel
> developer to gets everything the way as it is expected mainstream ;-)
> 
> One thing that come into my mind, besides what was already commented,
> is that it seems you added an abstraction layer. We don't like such
> layers very much, as it makes harder to understand the driver, usually
> for very little benefit.
> 
> On this first review, I didn't actually try to understand what's
> going on there. As the driver doesn't contain any comments inside,
> it makes harder to understand why some things were coded using
> such approach.
> 
> Thanks,
> Mauro
