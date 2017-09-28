Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:34321
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752520AbdI1BJk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 21:09:40 -0400
Date: Wed, 27 Sep 2017 22:09:29 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v7 4/7] media: open.rst: document devnode-centric and
 mc-centric types
Message-ID: <20170927220929.4e335455@vento.lan>
In-Reply-To: <d940932c-17ef-0c5f-dcbe-6fac81eae3ae@infradead.org>
References: <cover.1506550930.git.mchehab@s-opensource.com>
        <f3435f2eb6417a4b16e036a492fc5044915892d1.1506550930.git.mchehab@s-opensource.com>
        <d940932c-17ef-0c5f-dcbe-6fac81eae3ae@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Randy,

Em Wed, 27 Sep 2017 15:32:12 -0700
Randy Dunlap <rdunlap@infradead.org> escreveu:

> > +Types of V4L2 media hardware control
> > +====================================
> > +
> > +V4L2 hardware periferal is usually complex: support for it is  
> 
>                  peripheral (in several places...)

Thanks for noticing! My brain is hardwired to automatically replace
ph -> f, as "ph" only exists on archaic Brazilian Portuguese ;-)

Just fixed everything with:

	$ git filter-branch -f --tree-filter 'for i in $(git grep -l periferal Documentation/media); do sed s,periferal,peripheral,g -i $i; done' v4.14-rc1..

And pushed to my development's tree:
	https://git.linuxtv.org/mchehab/experimental.git/log/?h=mc-centric-flag-v7

Thanks,
Mauro
