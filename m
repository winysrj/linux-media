Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:41756 "EHLO smtp3-1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753439AbcIWAGn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Sep 2016 20:06:43 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: kernel-lintdoc parser - was: Re: [PATCH v2 0/3] doc-rst:c-domain: fix some issues in the c-domain
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160922093516.3f28323e@vento.lan>
Date: Fri, 23 Sep 2016 01:58:43 +0200
Cc: Jonathan Corbet <corbet@lwn.net>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-doc@vger.kernel.org Mailing List" <linux-doc@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <674F0B88-DDA1-4D75-B3F3-97BBC950FA97@darmarit.de>
References: <1473232378-11869-1-git-send-email-markus.heiser@darmarit.de> <20160909090832.35c2d982@vento.lan> <73B0403A-272C-4058-A0D9-493C685EE332@darmarit.de> <1089B8C0-6296-4CC4-84B9-A1F62FA565AD@darmarit.de> <20160919120030.4e390e9a@vento.lan> <35B447A7-6C12-4560-8D06-110B8B33CB56@darmarit.de> <20160922090850.56e3ebb1@vento.lan> <20160922093516.3f28323e@vento.lan>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 22.09.2016 um 14:35 schrieb Mauro Carvalho Chehab <mchehab@infradead.org>:

> Hi Markus,
> 3) this is actually a more complex problem: how to represent returned values
> from the function callbacks. Maybe we'll need to patch kernel-doc.

This might be a solution for dense kernel-doc comments where you
want to have paragraph and lists in parameter descriptions:

https://github.com/return42/linuxdoc/commit/9bfb8a59326677a819f62cb16f3ffacc8b244af1

--M--


