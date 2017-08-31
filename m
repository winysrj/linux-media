Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:43122
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751086AbdHaN4e (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 09:56:34 -0400
Date: Thu, 31 Aug 2017 10:56:26 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] docs: kernel-doc comments are ASCII
Message-ID: <20170831105602.5607fe52@vento.lan>
In-Reply-To: <87h8wn98bv.fsf@intel.com>
References: <54c23e8e-89c0-5cea-0dcc-e938952c5642@infradead.org>
        <20170830152314.0486fafb@lwn.net>
        <3390facf-69ae-ba18-8abe-09b5695a6b31@infradead.org>
        <20170831064941.1fb18d20@vento.lan>
        <87h8wn98bv.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 31 Aug 2017 16:26:44 +0300
Jani Nikula <jani.nikula@linux.intel.com> escreveu:

> On Thu, 31 Aug 2017, Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> > As Documentation/conf.py has:
> >
> > 	# -*- coding: utf-8 -*-
> >
> > on its first line, I suspect that the error you're getting is likely
> > due to the usage of a python version that doesn't recognize this.  
> 
> AFAIK that has nothing to do with python I/O, and everything to do with
> the encoding of that specific python source file.

Jani,

It should have something to do with python version and/or to some
locale info at the system, as neither I or Jon can reproduce it.

Can you reproduce it on your system?

Thanks,
Mauro
