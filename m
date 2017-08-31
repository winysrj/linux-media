Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:59941 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751359AbdHaN0v (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 09:26:51 -0400
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] docs: kernel-doc comments are ASCII
In-Reply-To: <20170831064941.1fb18d20@vento.lan>
References: <54c23e8e-89c0-5cea-0dcc-e938952c5642@infradead.org> <20170830152314.0486fafb@lwn.net> <3390facf-69ae-ba18-8abe-09b5695a6b31@infradead.org> <20170831064941.1fb18d20@vento.lan>
Date: Thu, 31 Aug 2017 16:26:44 +0300
Message-ID: <87h8wn98bv.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 31 Aug 2017, Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> As Documentation/conf.py has:
>
> 	# -*- coding: utf-8 -*-
>
> on its first line, I suspect that the error you're getting is likely
> due to the usage of a python version that doesn't recognize this.

AFAIK that has nothing to do with python I/O, and everything to do with
the encoding of that specific python source file.

BR,
Jani.

-- 
Jani Nikula, Intel Open Source Technology Center
